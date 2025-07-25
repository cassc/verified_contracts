// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "./BridgeAccessControl.sol";
import "./interfaces/IERCHandler.sol";
import "./interfaces/IDepositExecute.sol";
import "./interfaces/IDepositNative.sol";
import "./interfaces/IFeeHandler.sol";

/// @notice This contract facilitates the following:
/// - deposits
/// - creation and voting of deposit proposals
/// - deposit executions

contract BridgeBase is Pausable, BridgeAccessControl {
    using SafeCast for *;

    /// @notice Limit relayers number because proposal can fit only so much votes
    uint256 public constant MAX_RELAYERS = 200;

    uint8 public immutable _domainID;
    uint8 public _relayerThreshold;
    uint40 public _expiry;

    IFeeHandler public _feeHandler;

    enum ProposalStatus {
        Inactive,
        Active,
        Passed,
        Executed,
        Cancelled
    }

    struct Proposal {
        ProposalStatus _status;
        uint200 _yesVotes; // bitmap, 200 maximum votes
        uint8 _yesVotesTotal;
        uint40 _proposedBlock; // 1099511627775 maximum block
    }

    // destinationDomainID => number of deposits
    mapping(uint8 => uint64) public _depositCounts;
    // resourceID => handler address
    mapping(bytes32 => address) public _resourceIDToHandlerAddress;
    // forwarder address => is trusted
    mapping(address => bool) public trustedForwarders;
    // destinationDomainID + depositNonce => dataHash => Proposal
    mapping(uint72 => mapping(bytes32 => Proposal)) private _proposals;

    event FeeHandlerChanged(address newFeeHandler);
    event RelayerThresholdChanged(uint256 newThreshold);
    event RelayerAdded(address relayer);
    event RelayerRemoved(address relayer);
    event Deposit(
        uint8 destinationDomainID,
        bytes32 resourceID,
        uint64 depositNonce,
        address indexed user,
        bytes data,
        bytes handlerResponse
    );
    event ProposalEvent(
        uint8 originDomainID,
        bytes32 resourceID,
        uint64 depositNonce,
        ProposalStatus status,
        bytes32 dataHash
    );
    event ProposalVote(
        uint8 originDomainID,
        uint64 depositNonce,
        ProposalStatus status,
        bytes32 dataHash
    );
    event FailedHandlerExecution(bytes lowLevelData);

    bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");

    modifier onlyAdmin() {
        _onlyAdmin();
        _;
    }

    modifier onlyAdminOrRelayer() {
        _onlyAdminOrRelayer();
        _;
    }

    modifier onlyRelayers() {
        _onlyRelayers();
        _;
    }

    /// @notice Initializes Bridge, creates and grants {_msgSender()} the admin role,
    /// creates and grants {initialRelayers} the relayer role.
    ///
    /// @param domainID ID of chain the Bridge contract exists on.
    /// @param initialRelayers Addresses that should be initially granted the relayer role.
    /// @param initialRelayerThreshold Number of votes needed for a deposit proposal to be considered passed.
    constructor(
        uint8 domainID,
        address[] memory initialRelayers,
        uint256 initialRelayerThreshold,
        uint256 expiry
    ) {
        _domainID = domainID;
        _relayerThreshold = initialRelayerThreshold.toUint8();
        _expiry = expiry.toUint40();

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        for (uint256 i = 0; i < initialRelayers.length; i++) {
            grantRole(RELAYER_ROLE, initialRelayers[i]);
        }
    }

    /// @notice Removes admin role from {_msgSender()} and grants it to {newAdmin}.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    ///
    /// @param newAdmin Address that admin role will be granted to.
    function renounceAdmin(address newAdmin) external onlyAdmin {
        require(_msgSender() != newAdmin, "Cannot renounce oneself");
        grantRole(DEFAULT_ADMIN_ROLE, newAdmin);
        renounceRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /// @notice Pauses deposits, proposal creation and voting, and deposit executions.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    function adminPauseTransfers() external onlyAdmin {
        _pause();
    }

    /// @notice Unpauses deposits, proposal creation and voting, and deposit executions.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    function adminUnpauseTransfers() external onlyAdmin {
        _unpause();
    }

    /// @notice Modifies the number of votes required for a proposal to be considered passed.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    ///
    /// @param newThreshold Value {_relayerThreshold} will be changed to.
    ///
    /// @notice Emits {RelayerThresholdChanged} event.
    function adminChangeRelayerThreshold(uint256 newThreshold)
        external
        onlyAdmin
    {
        _relayerThreshold = newThreshold.toUint8();
        emit RelayerThresholdChanged(newThreshold);
    }

    /// @notice Grants {relayerAddress} the relayer role.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    /// - {relayerAddress} must not already has relayer role.
    /// - The number of current relayer must be less than {MAX_RELAYERS}
    ///
    /// @param relayerAddress Address of relayer to be added.
    ///
    /// @notice Emits {RelayerAdded} event.
    ///
    /// @dev admin role is checked in grantRole()
    function adminAddRelayer(address relayerAddress) external {
        require(
            !hasRole(RELAYER_ROLE, relayerAddress),
            "addr already has relayer role!"
        );
        require(_totalRelayers() < MAX_RELAYERS, "relayers limit reached");
        grantRole(RELAYER_ROLE, relayerAddress);
        emit RelayerAdded(relayerAddress);
    }

    /// @notice Removes relayer role for {relayerAddress}.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    /// - {relayerAddress} must has relayer role.
    ///
    /// @param relayerAddress Address of relayer to be removed.
    ///
    /// @notice Emits {RelayerRemoved} event.
    ///
    /// @dev admin role is checked in revokeRole()
    function adminRemoveRelayer(address relayerAddress) external {
        require(
            hasRole(RELAYER_ROLE, relayerAddress),
            "addr doesn't have relayer role!"
        );
        revokeRole(RELAYER_ROLE, relayerAddress);
        emit RelayerRemoved(relayerAddress);
    }

    /// @notice Sets a new resource for handler contracts that use the IERCHandler interface,
    /// and maps the {handlerAddress} to {resourceID} in {_resourceIDToHandlerAddress}.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    ///
    /// @param handlerAddress Address of handler resource will be set for.
    /// @param resourceID ResourceID to be used when making deposits.
    /// @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
    function adminSetResource(
        address handlerAddress,
        bytes32 resourceID,
        address tokenAddress
    ) external onlyAdmin {
        _resourceIDToHandlerAddress[resourceID] = handlerAddress;
        IERCHandler handler = IERCHandler(handlerAddress);
        handler.setResource(resourceID, tokenAddress);
    }

    /// @notice Sets a resource as burnable for handler contracts that use the IERCHandler interface.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    ///
    /// @param handlerAddress Address of handler resource will be set for.
    /// @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
    function adminSetBurnable(address handlerAddress, address tokenAddress)
        external
        onlyAdmin
    {
        IERCHandler handler = IERCHandler(handlerAddress);
        handler.setBurnable(tokenAddress);
    }

    /// @notice Sets the nonce for the specific domainID.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    /// - {nonce} must be greater than the current nonce.
    ///
    /// @param domainID Domain ID for increasing nonce.
    /// @param nonce The nonce value to be set.
    function adminSetDepositNonce(uint8 domainID, uint64 nonce)
        external
        onlyAdmin
    {
        // solhint-disable-next-line reason-string
        require(
            nonce > _depositCounts[domainID],
            "Does not allow decrements of the nonce"
        );
        _depositCounts[domainID] = nonce;
    }

    /// @notice Set a forwarder to be trusted.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    ///
    /// @param forwarder Forwarder address to be added.
    /// @param isTrusted if true, {forwarder} is trusted. Otherwise, it is no longer trusted.
    function adminSetForwarder(address forwarder, bool isTrusted)
        external
        onlyAdmin
    {
        trustedForwarders[forwarder] = isTrusted;
    }

    /// @notice Changes deposit fee handler contract address.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    ///
    /// @param newFeeHandler Address {_feeHandler} will be updated to.
    function adminChangeFeeHandler(address newFeeHandler) external onlyAdmin {
        _feeHandler = IFeeHandler(newFeeHandler);
        emit FeeHandlerChanged(newFeeHandler);
    }

    /// @notice Used to manually withdraw funds from ERC safes.
    ///
    /// @notice Requirements:
    /// - It must be called by only admin.
    ///
    /// @param handlerAddress Address of handler to withdraw from.
    /// @param data ABI-encoded withdrawal params relevant to the specified handler.
    function adminWithdraw(address handlerAddress, bytes memory data)
        external
        onlyAdmin
    {
        IERCHandler handler = IERCHandler(handlerAddress);
        handler.withdraw(data);
    }

    /// @notice Initiates a transfer using a specified handler contract.
    /// @notice Only callable when Bridge is not paused.
    /// @param destinationDomainID ID of chain deposit will be bridged to.
    /// @param resourceID ResourceID used to find address of handler to be used for deposit.
    /// @param depositData Additional data to be passed to specified handler.
    /// @notice Emits {Deposit} event with all necessary parameters and a handler response.
    function depositNative(
        uint8 destinationDomainID,
        bytes32 resourceID,
        bytes calldata depositData
    ) external payable whenNotPaused {
        require(
            destinationDomainID != _domainID,
            "Can't deposit to current domain"
        );

        address sender = _msgSender();
        uint256 fee = 0;

        if (address(_feeHandler) != address(0)) {
            fee = _feeHandler.fee();

            // Reverts on failure
            // slither-disable-next-line arbitrary-send-eth,reentrancy-benign,reentrancy-events
            _feeHandler.collectFee{value: fee}(
                sender,
                _domainID,
                destinationDomainID,
                resourceID
            );
        }

        address handler = _resourceIDToHandlerAddress[resourceID];
        require(handler != address(0), "resourceID not mapped to handler");

        // slither-disable-next-line reentrancy-benign
        uint64 depositNonce = ++_depositCounts[destinationDomainID];

        IDepositNative depositHandler = IDepositNative(handler);
        bytes memory handlerResponse = depositHandler.depositNative{
            value: msg.value - fee
        }(resourceID, sender, depositData);

        emit Deposit(
            destinationDomainID,
            resourceID,
            depositNonce,
            sender,
            depositData,
            handlerResponse
        );
    }

    /// @notice Initiates a transfer using a specified handler contract.
    /// @notice Only callable when Bridge is not paused.
    /// @param destinationDomainID ID of chain deposit will be bridged to.
    /// @param resourceID ResourceID used to find address of handler to be used for deposit.
    /// @param depositData Additional data to be passed to specified handler.
    /// @notice Emits {Deposit} event with all necessary parameters and a handler response.
    /// - ERC20Handler: responds with an empty data.
    /// - ERC721Handler: responds with the deposited token metadata acquired by calling a tokenURI method in the token contract.
    /// - ERC1155Handler: responds with an empty data.
    function deposit(
        uint8 destinationDomainID,
        bytes32 resourceID,
        bytes calldata depositData
    ) external payable whenNotPaused {
        require(
            destinationDomainID != _domainID,
            "Can't deposit to current domain"
        );

        address sender = _msgSender();
        if (address(_feeHandler) == address(0)) {
            require(msg.value == 0, "no FeeHandler, msg.value != 0");
        } else {
            // Reverts on failure
            _feeHandler.collectFee{value: msg.value}(
                sender,
                _domainID,
                destinationDomainID,
                resourceID
            );
        }

        address handler = _resourceIDToHandlerAddress[resourceID];
        require(handler != address(0), "resourceID not mapped to handler");

        // slither-disable-next-line reentrancy-benign
        uint64 depositNonce = ++_depositCounts[destinationDomainID];

        IDepositExecute depositHandler = IDepositExecute(handler);
        bytes memory handlerResponse = depositHandler.deposit(
            resourceID,
            sender,
            depositData
        );

        // slither-disable-next-line reentrancy-events
        emit Deposit(
            destinationDomainID,
            resourceID,
            depositNonce,
            sender,
            depositData,
            handlerResponse
        );
    }

    /// @notice When called, {_msgSender()} will be marked as voting in favor of proposal.
    ///
    /// @notice Requirements:
    /// - It must be called by only relayer.
    /// - Bridge must not be paused.
    /// - Handler must be registered with {resourceID}.
    /// - Proposal must not have already been passed or executed.
    /// - Relayer must vote only once.
    ///
    /// @param domainID ID of chain deposit originated from.
    /// @param depositNonce ID of deposited generated by origin Bridge contract.
    /// @param data Data originally provided when deposit was made.
    ///
    /// @notice Emits {ProposalEvent} event with status indicating the proposal status.
    /// @notice Emits {ProposalVote} event.
    function voteProposal(
        uint8 domainID,
        uint64 depositNonce,
        bytes32 resourceID,
        bytes calldata data
    ) external onlyRelayers whenNotPaused {
        address handler = _resourceIDToHandlerAddress[resourceID];
        uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(domainID);
        bytes32 dataHash = keccak256(abi.encodePacked(handler, data));
        Proposal memory proposal = _proposals[nonceAndID][dataHash];

        require(
            _resourceIDToHandlerAddress[resourceID] != address(0),
            "no handler for resourceID"
        );

        if (proposal._status == ProposalStatus.Passed) {
            executeProposal(domainID, depositNonce, data, resourceID, true);
            return;
        }

        // Passed case is considered already
        // Now we can consider Inactive, Active cases
        // solhint-disable-next-line reason-string
        require(
            uint256(proposal._status) <= 1,
            "proposal already executed/cancelled"
        );
        require(!_hasVoted(proposal, _msgSender()), "relayer already voted");

        if (proposal._status == ProposalStatus.Inactive) {
            proposal = Proposal({
                _status: ProposalStatus.Active,
                _yesVotes: 0,
                _yesVotesTotal: 0,
                _proposedBlock: uint40(block.number) // Overflow is desired.
            });

            emit ProposalEvent(
                domainID,
                resourceID,
                depositNonce,
                ProposalStatus.Active,
                dataHash
            );
        } else if (uint40(block.number - proposal._proposedBlock) > _expiry) {
            // if the number of blocks that has passed since this proposal was
            // submitted exceeds the expiry threshold set, cancel the proposal
            proposal._status = ProposalStatus.Cancelled;

            emit ProposalEvent(
                domainID,
                resourceID,
                depositNonce,
                ProposalStatus.Cancelled,
                dataHash
            );
        }

        if (proposal._status != ProposalStatus.Cancelled) {
            proposal._yesVotes = (proposal._yesVotes |
                _relayerBit(_msgSender())).toUint200();
            proposal._yesVotesTotal++; // TODO: check if bit counting is cheaper.

            emit ProposalVote(
                domainID,
                depositNonce,
                proposal._status,
                dataHash
            );

            // Finalize if _relayerThreshold has been reached
            if (proposal._yesVotesTotal >= _relayerThreshold) {
                proposal._status = ProposalStatus.Passed;
                emit ProposalEvent(
                    domainID,
                    resourceID,
                    depositNonce,
                    ProposalStatus.Passed,
                    dataHash
                );
            }
        }
        _proposals[nonceAndID][dataHash] = proposal;

        // slither-disable-next-line incorrect-equality
        if (proposal._status == ProposalStatus.Passed) {
            executeProposal(domainID, depositNonce, data, resourceID, false);
        }
    }

    /// @notice Cancels a deposit proposal that has not been executed yet.
    ///
    /// @notice Requirements:
    /// - It must be called by only relayer or admin.
    /// - Bridge must not be paused.
    /// - Proposal must be past expiry threshold.
    ///
    /// @param domainID ID of chain deposit originated from.
    /// @param depositNonce ID of deposited generated by origin Bridge contract.
    /// @param dataHash Hash of data originally provided when deposit was made.
    ///
    /// @notice Emits {ProposalEvent} event with status {Cancelled}.
    function cancelProposal(
        uint8 domainID,
        bytes32 resourceID,
        uint64 depositNonce,
        bytes32 dataHash
    ) external onlyAdminOrRelayer {
        uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(domainID);
        Proposal memory proposal = _proposals[nonceAndID][dataHash];
        ProposalStatus currentStatus = proposal._status;

        require(
            currentStatus == ProposalStatus.Active ||
                currentStatus == ProposalStatus.Passed,
            "Proposal cannot be cancelled"
        );
        require(
            uint40(block.number - proposal._proposedBlock) > _expiry,
            "Proposal not at expiry threshold"
        );

        proposal._status = ProposalStatus.Cancelled;
        _proposals[nonceAndID][dataHash] = proposal;

        emit ProposalEvent(
            domainID,
            resourceID,
            depositNonce,
            ProposalStatus.Cancelled,
            dataHash
        );
    }

    /// @notice Returns a proposal.
    ///
    /// @param originDomainID Chain ID deposit originated from.
    /// @param depositNonce ID of proposal generated by proposal's origin Bridge contract.
    /// @param dataHash Hash of data to be provided when deposit proposal is executed.
    /// @return Proposal which consists of:
    /// - _dataHash Hash of data to be provided when deposit proposal is executed.
    /// - _yesVotes Number of votes in favor of proposal.
    /// - _noVotes Number of votes against proposal.
    /// - _status Current status of proposal.
    function getProposal(
        uint8 originDomainID,
        uint64 depositNonce,
        bytes32 dataHash
    ) external view returns (Proposal memory) {
        uint72 nonceAndID = (uint72(depositNonce) << 8) |
            uint72(originDomainID);
        return _proposals[nonceAndID][dataHash];
    }

    /// @notice Returns true if {relayer} has voted on {destNonce} {dataHash} proposal.
    ///
    /// @param destNonce destinationDomainID + depositNonce of the proposal.
    /// @param dataHash Hash of data to be provided when deposit proposal is executed.
    /// @param relayer Address to check.
    ///
    /// @dev Naming left unchanged for backward compatibility.
    function _hasVotedOnProposal(
        uint72 destNonce,
        bytes32 dataHash,
        address relayer
    ) external view returns (bool) {
        return _hasVoted(_proposals[destNonce][dataHash], relayer);
    }

    /// @notice Returns true if {relayer} has the relayer role.
    ///
    /// @param relayer Address to check.
    function isRelayer(address relayer) external view returns (bool) {
        return hasRole(RELAYER_ROLE, relayer);
    }

    /// @notice Executes a deposit proposal that is considered passed using a specified handler contract.
    ///
    /// @notice Requirements:
    /// - It must be called by only relayer.
    /// - Bridge must not be paused.
    /// - Proposal must have Passed status.
    /// - Hash of {data} must equal proposal's {dataHash}.
    ///
    /// @param domainID ID of chain deposit originated from.
    /// @param resourceID ResourceID to be used when making deposits.
    /// @param depositNonce ID of deposited generated by origin Bridge contract.
    /// @param data Data originally provided when deposit was made.
    /// @param revertOnFail Decision if the transaction should be reverted in case of handler's executeProposal is reverted or not.
    ///
    /// @notice Emits {ProposalEvent} event with status {Executed}.
    /// @notice Emits {FailedExecution} event with the failed reason.
    function executeProposal(
        uint8 domainID,
        uint64 depositNonce,
        bytes calldata data,
        bytes32 resourceID,
        bool revertOnFail
    ) public onlyRelayers whenNotPaused {
        address handler = _resourceIDToHandlerAddress[resourceID];
        uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(domainID);
        bytes32 dataHash = keccak256(abi.encodePacked(handler, data));
        Proposal storage proposal = _proposals[nonceAndID][dataHash];

        require(
            proposal._status == ProposalStatus.Passed,
            "Proposal must have Passed status"
        );

        proposal._status = ProposalStatus.Executed;
        IDepositExecute depositHandler = IDepositExecute(handler);

        if (revertOnFail) {
            depositHandler.executeProposal(resourceID, data);
        } else {
            try depositHandler.executeProposal(resourceID, data) {} catch (
                // slither-disable-next-line uninitialized-local,variable-scope
                bytes memory lowLevelData
            ) {
                // slither-disable-next-line reentrancy-no-eth
                proposal._status = ProposalStatus.Passed;
                // slither-disable-next-line reentrancy-events
                emit FailedHandlerExecution(lowLevelData);
                return;
            }
        }

        // slither-disable-next-line reentrancy-events
        emit ProposalEvent(
            domainID,
            resourceID,
            depositNonce,
            ProposalStatus.Executed,
            dataHash
        );
    }

    /// @notice Returns total relayers number.
    ///
    /// @dev Added for backwards compatibility.
    function _totalRelayers() public view returns (uint256) {
        return BridgeAccessControl.getRoleMemberCount(RELAYER_ROLE);
    }

    function _onlyAdminOrRelayer() private view {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()) ||
                hasRole(RELAYER_ROLE, _msgSender()),
            "sender is not relayer or admin"
        );
    }

    function _onlyAdmin() private view {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "sender doesn't have admin role"
        );
    }

    function _onlyRelayers() private view {
        require(
            hasRole(RELAYER_ROLE, _msgSender()),
            "sender doesn't have relayer role"
        );
    }

    function _relayerBit(address relayer) private view returns (uint256) {
        return
            uint256(1) <<
            (BridgeAccessControl.getRoleMemberIndex(RELAYER_ROLE, relayer) - 1);
    }

    function _hasVoted(Proposal memory proposal, address relayer)
        private
        view
        returns (bool)
    {
        return (_relayerBit(relayer) & uint256(proposal._yesVotes)) > 0;
    }

    function _msgSender() internal view override returns (address) {
        address signer = msg.sender;
        if (msg.data.length >= 20 && trustedForwarders[signer]) {
            // slither-disable-next-line assembly
            assembly {
                // Extract the Transaction Signer address from the last 20 bytes of the call data
                // and use that as the original sender of the transaction (instead of _msgSender())
                // Reference: https://eips.ethereum.org/EIPS/eip-2771
                signer := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        }
        return signer;
    }
}