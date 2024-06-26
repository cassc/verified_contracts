// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "../libraries/AllyLibrary.sol";
import "../interfaces/v1/IPoolGuardian.sol";
import "../interfaces/governance/ICommittee.sol";
import "../interfaces/v1/model/IGovRewardModel.sol";
import "../criteria/ChainSchema.sol";
import "../storage/CommitteStorage.sol";
import "../util/BoringMath.sol";

contract CommitteeImpl is ChainSchema, CommitteStorage, ICommittee {
    using BoringMath for uint256;
    using EnumerableSet for EnumerableSet.UintSet;
    using AllyLibrary for IShorterBone;

    constructor(address _SAVIOR) public ChainSchema(_SAVIOR) {}

    function initialize(
        address _shorterBone,
        address _ipistrToken,
        address _stableToken
    ) external isSavior {
        shorterBone = IShorterBone(_shorterBone);
        ipistrToken = IIpistrToken(_ipistrToken);
        stableToken = _stableToken;
        maxVotingDays = 2;
        proposalFee = 1e22;
        rulerThreshold = 1e9;
        committeeProposalThreshold = 50;
        poolProposalThreshold = 10;
    }

    /// @notice User deposit IPISTR into committee pool
    function deposit(uint256 amount) external override whenNotPaused onlyEOA {
        uint256 spendableBalanceOf = ipistrToken.spendableBalanceOf(msg.sender);
        require(amount <= spendableBalanceOf, "Committee: Insufficient amount");

        shorterBone.tillIn(address(ipistrToken), msg.sender, AllyLibrary.COMMITTEE, amount);
        IGovRewardModel(shorterBone.getGovRewardModel()).harvest(msg.sender);

        RulerData storage rulerData = _rulerDataMap[msg.sender];
        rulerData.stakedAmount = rulerData.stakedAmount.add(amount);
        totalIpistrStakedShare = totalIpistrStakedShare.add(amount);

        emit DepositCommittee(msg.sender, amount, rulerData.stakedAmount);
    }

    /// @notice Withdraw IPISTR from committee vault
    function withdraw(uint256 amount) external override whenNotPaused onlyEOA {
        RulerData storage rulerData = _rulerDataMap[msg.sender];
        require(rulerData.stakedAmount >= rulerData.voteShareLocked.add(amount), "Committee: Insufficient amount");

        IGovRewardModel(shorterBone.getGovRewardModel()).harvest(msg.sender);

        rulerData.stakedAmount = rulerData.stakedAmount.sub(amount);
        totalIpistrStakedShare = totalIpistrStakedShare.sub(amount);

        shorterBone.tillOut(address(ipistrToken), AllyLibrary.COMMITTEE, msg.sender, amount);

        emit WithdrawCommittee(msg.sender, amount, rulerData.stakedAmount);
    }

    /// @notice Specified for the proposal of pool type
    function createPoolProposal(
        address _stakedTokenAddr,
        uint256 _leverage,
        uint256 _durationDays
    ) external chainReady whenNotPaused {
        address WrappedEtherAddr = IPoolGuardian(shorterBone.getPoolGuardian()).WrappedEtherAddr();
        require(_stakedTokenAddr != WrappedEtherAddr, "Committee: Invalid stakedToken");
        if (address(_stakedTokenAddr) == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
            _stakedTokenAddr = WrappedEtherAddr;
        }
        (bool inWhiteList, , ) = shorterBone.getTokenInfo(_stakedTokenAddr);
        require(inWhiteList, "Committee: Invalid stakedToken");
        require(_durationDays > 0 && _durationDays <= 1000, "Committee: Invalid duration");
        proposalCount = proposalCount.add(block.timestamp.add(1).sub(block.timestamp.div(30).mul(30)));
        require(proposalGallery[proposalCount].startBlock == 0, "Committee: Existing proposal found");
        proposalIds.push(proposalCount);
        shorterBone.revenue(address(ipistrToken), msg.sender, proposalFee, IShorterBone.IncomeType.PROPOSAL_FEE);
        IPoolGuardian(shorterBone.getPoolGuardian()).addPool(_stakedTokenAddr, stableToken, msg.sender, _leverage, _durationDays, proposalCount);

        proposalGallery[proposalCount] = Proposal({id: uint32(proposalCount), proposer: msg.sender, catagory: 1, startBlock: block.number.to64(), endBlock: block.number.add(blocksPerDay().mul(maxVotingDays)).to64(), forShares: 0, againstShares: 0, status: ProposalStatus.Active, displayable: true});
        poolMetersMap[proposalCount] = PoolMeters({tokenContract: _stakedTokenAddr, leverage: _leverage.to32(), durationDays: _durationDays.to32()});

        emit PoolProposalCreated(proposalCount, msg.sender);
    }

    /// @notice Specified for the proposal of community type
    function createCommunityProposal(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description,
        string memory title
    ) external chainReady whenNotPaused {
        require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "Committee: Parameters mismatch");
        require(targets.length > 0 && targets.length <= 10, "Committee: Invalid actions");
        proposalCount = proposalCount.add(block.timestamp.add(1).sub(block.timestamp.div(30).mul(30)));
        require(proposalGallery[proposalCount].startBlock == 0, "Committee: Existing proposal found");
        proposalIds.push(proposalCount);
        shorterBone.revenue(address(ipistrToken), msg.sender, proposalFee, IShorterBone.IncomeType.PROPOSAL_FEE);

        proposalGallery[proposalCount] = Proposal({id: uint32(proposalCount), proposer: msg.sender, catagory: 2, startBlock: block.number.to64(), endBlock: block.number.add(blocksPerDay().mul(maxVotingDays)).to64(), forShares: 0, againstShares: 0, status: ProposalStatus.Active, displayable: true});
        communityProposalGallery[proposalCount] = CommunityProposal({targets: targets, values: values, signatures: signatures, calldatas: calldatas});

        emit CommunityProposalCreated(proposalCount, msg.sender, description, title);
    }

    function vote(
        uint256 proposalId,
        bool direction,
        uint256 voteShare
    ) external whenNotPaused {
        require(_isRuler(msg.sender), "Committee: Caller is not a ruler");

        Proposal storage proposal = proposalGallery[proposalId];
        require(uint256(proposal.endBlock) > block.number, "Committee: Proposal was closed");

        require(proposal.status == ProposalStatus.Active, "Committee: Not an active proposal");
        require(voteShare > 0, "Committee: Invalid voteShare");

        // Lock the vote power after voting
        RulerData storage rulerData = _rulerDataMap[msg.sender];

        uint256 availableVotePower = rulerData.stakedAmount.sub(rulerData.voteShareLocked);
        require(availableVotePower >= voteShare, "Committee: Insufficient voting power");

        proposalVoters[proposalId].add(msg.sender);

        //Lock user's vote power
        rulerData.voteShareLocked = rulerData.voteShareLocked.add(voteShare);

        VoteShares storage userVoteShare = userLockedShare[proposalId][msg.sender];

        if (direction) {
            proposal.forShares = voteShare.add(proposal.forShares);
            forVoteProposals[msg.sender].add(proposalId);
            userVoteShare.forShares = userVoteShare.forShares.add(voteShare);
            bool _finished = ((uint256(proposal.forShares) >= totalIpistrStakedShare.mul(poolProposalThreshold).div(100)) && uint256(proposal.catagory) == uint256(1)) ||
                ((uint256(proposal.forShares) >= totalIpistrStakedShare.mul(committeeProposalThreshold).div(100)) && uint256(proposal.catagory) == uint256(2));
            if (_finished) {
                _updateProposalStatus(proposalId, ProposalStatus.Passed);
                _makeProposalQueued(proposal);
                _unlockRulerVotingShare(proposal.id);
            }
        } else {
            proposal.againstShares = voteShare.add(proposal.againstShares);
            againstVoteProposals[msg.sender].add(proposalId);
            userVoteShare.againstShares = userVoteShare.againstShares.add(voteShare);
            bool _finished = ((uint256(proposal.againstShares) >= totalIpistrStakedShare.mul(poolProposalThreshold).div(100)) && uint256(proposal.catagory) == uint256(1)) || ((uint256(proposal.againstShares) >= totalIpistrStakedShare.mul(committeeProposalThreshold).div(100)) && uint256(proposal.catagory) == uint256(2));
            if (_finished) {
                _updateProposalStatus(proposalId, ProposalStatus.Failed);
                _unlockRulerVotingShare(proposal.id);
            }
        }

        emit ProposalVoted(proposal.id, msg.sender, direction, voteShare);
    }

    function getQueuedProposals() external view override returns (uint256[] memory _queuedProposals, uint256[] memory _failedProposals) {
        uint256 queueProposalSize = queuedProposals.length();
        _queuedProposals = new uint256[](queueProposalSize);
        for (uint256 i = 0; i < queueProposalSize; i++) {
            _queuedProposals[i] = queuedProposals.at(i);
        }

        uint256 failedProposalIndex;
        uint256 proposalLen = proposalIds.length;
        uint256[] memory failedProposals = new uint256[](proposalLen);
        for (uint256 i = 0; i < proposalLen; i++) {
            if (proposalGallery[proposalIds[i]].status == ProposalStatus.Active && uint256(proposalGallery[proposalIds[i]].endBlock) < block.number) {
                failedProposals[failedProposalIndex++] = proposalIds[i];
            }
        }

        _failedProposals = new uint256[](failedProposalIndex);
        for (uint256 i = 0; i < failedProposalIndex; i++) {
            _failedProposals[i] = failedProposals[i];
        }
    }

    /// @notice Judge Ruler role
    function isRuler(address account) external view override returns (bool) {
        return _isRuler(account);
    }

    function getUserShares(address account) external view override returns (uint256 totalShare, uint256 lockedShare) {
        RulerData storage rulerData = _rulerDataMap[account];
        totalShare = rulerData.stakedAmount;
        lockedShare = rulerData.voteShareLocked;
    }

    function executedProposals(uint256[] calldata _proposalIds, uint256[] calldata _failedProposals) external override {
        shorterBone.assertCaller(msg.sender, AllyLibrary.GRAB_REWARD);
        uint256 sizeToTackle = _proposalIds.length;
        for (uint256 i = 0; i < sizeToTackle; i++) {
            require(queuedProposals.contains(_proposalIds[i]), "Committee: Invalid queuedProposal");
            queuedProposals.remove(_proposalIds[i]);
            IPoolGuardian(shorterBone.getPoolGuardian()).listPool(_proposalIds[i]);
            _updateProposalStatus(_proposalIds[i], ProposalStatus.Executed);
        }
        sizeToTackle = _failedProposals.length;
        for (uint256 i = 0; i < sizeToTackle; i++) {
            Proposal storage failedProposal = proposalGallery[_failedProposals[i]];
            if (failedProposal.status != ProposalStatus.Active) continue;
            require(failedProposal.endBlock < block.number, "Committee: Invalid failedProposals");
            if (failedProposal.forShares > failedProposal.againstShares) {
                _updateProposalStatus(_failedProposals[i], ProposalStatus.Passed);
                _makeProposalQueued(failedProposal);
            } else {
                _updateProposalStatus(_failedProposals[i], ProposalStatus.Failed);
            }
            _unlockRulerVotingShare(_failedProposals[i]);
        }
    }

    function executedCommunityProposal(uint256 proposalId) external override isSavior {
        require(proposalGallery[proposalId].status == ProposalStatus.Queued && proposalGallery[proposalId].catagory == 2, "Committee: Proposal is not in queue");
        CommunityProposal storage communityProposal = communityProposalGallery[proposalId];
        uint256 sizeToTackle = communityProposal.targets.length;
        for (uint256 i = 0; i < sizeToTackle; i++) {
            _executeTransaction(communityProposal.targets[i], communityProposal.values[i], communityProposal.signatures[i], communityProposal.calldatas[i]);
        }
        _updateProposalStatus(proposalId, ProposalStatus.Executed);
    }

    function _executeTransaction(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data
    ) internal returns (bytes memory) {
        bytes memory callData;

        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
        }

        // solium-disable-next-line security/no-call-value
        (bool success, ) = target.call{value: value}(callData);

        require(success, "Committee: Transaction execution reverted");
    }

    function getVoteProposals(address account, uint256 catagory) external view override returns (uint256[] memory _poolForProposals, uint256[] memory _poolAgainstProposals) {
        uint256 poolForProposalsIndex;
        uint256 forProposalSize = forVoteProposals[account].length();
        uint256[] memory _forProposals = new uint256[](forProposalSize);

        for (uint256 i = 0; i < forProposalSize; i++) {
            uint256 proposalId = forVoteProposals[account].at(i);
            if (proposalGallery[proposalId].catagory == catagory) {
                _forProposals[poolForProposalsIndex++] = proposalId;
            }
        }

        uint256 poolAgainstProposalsIndex;
        uint256 againstProposalSize = againstVoteProposals[account].length();
        uint256[] memory _againstProposals = new uint256[](againstProposalSize);

        for (uint256 i = 0; i < againstProposalSize; i++) {
            uint256 proposalId = againstVoteProposals[account].at(i);
            if (proposalGallery[proposalId].catagory == catagory) {
                _againstProposals[poolAgainstProposalsIndex++] = proposalId;
            }
        }

        _poolForProposals = new uint256[](poolForProposalsIndex);
        for (uint256 i = 0; i < poolForProposalsIndex; i++) {
            _poolForProposals[i] = _forProposals[i];
        }

        _poolAgainstProposals = new uint256[](poolAgainstProposalsIndex);
        for (uint256 i = 0; i < poolAgainstProposalsIndex; i++) {
            _poolAgainstProposals[i] = _againstProposals[i];
        }
    }

    function getForShares(address account, uint256 proposalId) external view override returns (uint256 voteShare, uint256 totalShare) {
        if (proposalGallery[proposalId].status == ProposalStatus.Executed) {
            voteShare = userLockedShare[proposalId][account].forShares;
            totalShare = proposalGallery[proposalId].forShares;
        }
    }

    function getAgainstShares(address account, uint256 proposalId) external view override returns (uint256 voteShare, uint256 totalShare) {
        if (proposalGallery[proposalId].status == ProposalStatus.Failed) {
            voteShare = userLockedShare[proposalId][account].againstShares;
            totalShare = proposalGallery[proposalId].againstShares;
        }
    }

    function getCommunityProposalInfo(uint256 proposalId)
        external
        view
        returns (
            address[] memory,
            uint256[] memory,
            string[] memory,
            bytes[] memory
        )
    {
        CommunityProposal storage communityProposal = communityProposalGallery[proposalId];
        return (communityProposal.targets, communityProposal.values, communityProposal.signatures, communityProposal.calldatas);
    }

    /// @notice Set voting period
    /// @param _maxVotingDays new maximum voting days
    function setVotingDays(uint256 _maxVotingDays) external {
        require(msg.sender == address(this), "Committee: Caller is not Committee");
        require(_maxVotingDays > 1, "Committee: Invalid voting days");
        maxVotingDays = _maxVotingDays;

        emit VotingMaxDaysSet(_maxVotingDays);
    }

    /// @notice Tweak the proposal submission fee
    function setProposalFee(uint256 _proposalFee) external {
        require(msg.sender == address(this), "Committee: Caller is not Committee");
        proposalFee = _proposalFee;
    }

    /// @notice Set the ruler threshold
    function setRulerThreshold(uint256 newRulerThreshold) external {
        require(msg.sender == address(this), "Committee: Caller is not Committee");
        require(newRulerThreshold > 0 && newRulerThreshold <= 1e12, "Committee: Invalid ruler threshold");
        uint256 oldRulerThreshold = rulerThreshold;
        rulerThreshold = newRulerThreshold;

        emit RulerThresholdSet(oldRulerThreshold, newRulerThreshold);
    }

    /// @notice Switch proposal's display state
    function changeProposalVisibility(uint256 proposalId, bool displayable) external isManager {
        proposalGallery[proposalId].displayable = displayable;
    }

    function setCommitteeProposalQuorum(uint256 threshold) external {
        require(msg.sender == address(this), "Committee: Caller is not Committee");
        committeeProposalThreshold = threshold;
    }

    function setPoolProposalQuorum(uint256 threshold) external {
        require(msg.sender == address(this), "Committee: Caller is not Committee");
        poolProposalThreshold = threshold;
    }

    function _makeProposalQueued(Proposal storage proposal) internal {
        if (proposal.status != ProposalStatus.Passed) {
            return;
        }

        _updateProposalStatus(proposal.id, ProposalStatus.Queued);

        if (proposal.catagory == 1) {
            queuedProposals.add(proposal.id);
        }
    }

    function _unlockRulerVotingShare(uint256 proposalId) internal {
        uint256 voterCount = proposalVoters[proposalId].length();
        for (uint256 i = 0; i < voterCount; i++) {
            address voter = proposalVoters[proposalId].at(i);
            uint256 lockedShare = userLockedShare[proposalId][voter].forShares.add(userLockedShare[proposalId][voter].againstShares);
            _rulerDataMap[voter].voteShareLocked = _rulerDataMap[voter].voteShareLocked.sub(lockedShare);
        }
    }

    function _isRuler(address account) internal view returns (bool) {
        return _rulerDataMap[account].stakedAmount.mul(1e12).div(rulerThreshold) > totalIpistrStakedShare;
    }

    function _updateProposalStatus(uint256 proposalId, ProposalStatus ps) internal {
        proposalGallery[proposalId].status = ps;
        emit ProposalStatusChanged(proposalId, uint256(ps));
    }
}