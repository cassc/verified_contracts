// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./interfaces/IERC721.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IERC1155.sol";
import "./interfaces/IPriceConsumerV3.sol";

contract OnChainRewardsManagement {
    enum RewardType { ERC20, ERC721, ERC1155 }

    struct RewardInfo {
        RewardType rewardType;
        address rewardAddress;
        uint amount;
        uint tokenId;
        uint fee;
        uint maxClaims;
        uint maxClaimsPerUser;
        bool isSet;
        bool useReviveRug;

        uint totalClaims;
        mapping (address => uint) allowedUserClaims;
        mapping (address => uint) userClaimed;
    }

    address public owner;
    address public gameMaster;
    address public treasury;
    IPriceConsumerV3 public priceConsumer;

    mapping (uint => RewardInfo) rewards;

    event RewardClaimed(address player, uint id, address reward);
    event OwnershipTransferred(address previousOwner, address newOwner);

    constructor(address _gameMaster, address _treasury, address _priceConsumer) {
        gameMaster = _gameMaster;
        treasury = _treasury;
        priceConsumer = IPriceConsumerV3(_priceConsumer);
        owner = msg.sender;
    }

    function feeInBnb(uint _id) public view returns (uint256) { return priceConsumer.usdToBnb(rewards[_id].fee); }

    function setGameMaster(address _gameMaster) public {
        _requireOwner();
        gameMaster = _gameMaster;
    }

    function setTreasury(address _treasury) public {
        _requireOwner();
        treasury = _treasury;
    }
    
    function setUseReviveRug(uint _id, bool _use) public {
        _requireOwner();
        rewards[_id].useReviveRug = _use;
    }

    function setPriceConsumer(address _priceConsumer) public {
        _requireOwner();
        priceConsumer = IPriceConsumerV3(_priceConsumer);
    }

    function renounceOwnership() public {
        _requireOwner();
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public {
        _requireOwner();
        require(newOwner != address(0), 'Ownable: new owner cannot be zero address - renounce contract instead');
        _transferOwnership(newOwner);
    }

    function checkReward(uint _id, address _wallet) public view returns (bool hasClaimed, bool hasClaims, bool availableClaims) {
        RewardInfo storage reward = rewards[_id];
        require(reward.isSet, 'Reward is not set');
        uint claimed = reward.userClaimed[_wallet];
        hasClaimed = claimed > 0;
        hasClaims = reward.allowedUserClaims[_wallet] > claimed;
        availableClaims = reward.allowedUserClaims[_wallet] < reward.maxClaimsPerUser;
        return (hasClaimed, hasClaims, availableClaims);
    }

    function setReward(
        uint _id, 
        RewardType _type, 
        address _rewardAddress, 
        uint _amount, 
        uint _tokenId,
        uint _fee, 
        uint _maxClaims, 
        uint _maxClaimsPerUser
    ) public {
        _requireOwner();
        require(rewards[_id].totalClaims == 0, 'Reward cannot be changed after being claimed');
        rewards[_id].rewardType = _type;
        rewards[_id].rewardAddress = _rewardAddress;
        rewards[_id].amount = _amount;
        rewards[_id].tokenId = _tokenId;
        rewards[_id].fee = _fee;
        rewards[_id].maxClaims = _maxClaims;
        rewards[_id].maxClaimsPerUser = _maxClaimsPerUser;
        rewards[_id].isSet = true;
    }

    function allowClaim(uint _id, address _wallet, uint _claims) public {
        require(rewards[_id].isSet, 'Reward is not set');
        require(msg.sender == gameMaster, 'Must be called by game master');
        require(rewards[_id].allowedUserClaims[_wallet] + _claims <= rewards[_id].maxClaimsPerUser, 'User has maximum claims');
        rewards[_id].allowedUserClaims[_wallet] += _claims;
    }

    function claim(uint _id) public payable {
        RewardInfo storage reward = rewards[_id];
        require(reward.allowedUserClaims[msg.sender] > reward.userClaimed[msg.sender], 'No claims available');
        require(msg.value >= feeInBnb(_id));
        require(reward.totalClaims < reward.maxClaims || reward.maxClaims == 0, 'Maximum claims for this reward have been issued');
        
        _safeTransfer(treasury, msg.value);

        if (reward.rewardType == RewardType.ERC20) _claimERC20(reward.rewardAddress, reward.amount);
        else if (reward.rewardType == RewardType.ERC721) _claimERC721(reward.rewardAddress, reward.useReviveRug);
        else _claimERC1155(reward.rewardAddress, reward.tokenId, reward.amount);

        reward.totalClaims++;
        reward.userClaimed[msg.sender]++;
    }

    function _claimERC20(address _reward, uint _amount) private {
        IERC20 token = IERC20(_reward);
        require(token.balanceOf(address(this)) >= _amount, 'Insufficient token balance');
        token.approve(msg.sender, _amount);
        token.transferFrom(address(this), msg.sender, _amount);
    }

    function _claimERC721(address _reward, bool _reviveRug) private {
        IERC721 nft = IERC721(_reward);
        if (_reviveRug) nft.reviveRug(msg.sender);
        else nft.mint(msg.sender);
    }

    function _claimERC1155(address _reward, uint _tokenId, uint _amount) private {
        IERC1155 nft = IERC1155(_reward);
        nft.mint(msg.sender, _tokenId, _amount);
    }

    function _safeTransfer(address _recipient, uint _amount) private {
        (bool _success, ) = _recipient.call{value: _amount}("");
        require(_success, "transfer failed");
    }

    function _requireOwner() private view {
        require(msg.sender == owner, 'Ownable: caller is not contract owner');
    }

    function _transferOwnership(address newOwner) private {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, owner);
    }
}