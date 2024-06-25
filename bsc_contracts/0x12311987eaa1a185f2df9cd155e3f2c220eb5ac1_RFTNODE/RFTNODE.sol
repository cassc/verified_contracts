/**
 *Submitted for verification at BscScan.com on 2022-12-26
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor() {
        _transferOwnership(_msgSender());
    }

   
    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }


    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

 
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

  
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


library SafeMath {
   
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

   
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

  
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
         
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

 
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }


    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    
 
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

   
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }


    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }


    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}


interface IERC20 {
  
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);
  
    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract ReentrancyGuard {

    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {

        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {

        _status = _NOT_ENTERED;
    }
}

contract RFTNODE is ReentrancyGuard, Ownable {

    using SafeMath for uint256;

    IERC20 public BSN;
    uint256 public ROI;
    uint256 private restrictedNodes;
    uint256 private restrictedAmount;
    uint256 private dayCount;

    address public rewardPool;
    address public teamFunds;
    address public maintenanceFunds;
 
    struct NodeEntity {
        uint256 amount;
        uint256 creationTime;
        uint256 lastClaimTime;
        string name;
        uint256 _nodeId;
        uint256 created;
        uint256 isStake;
    }
    mapping (address => NodeEntity[]) public _nodesOfUser;
    mapping (address => uint256) public _nodesCount;
    mapping(address => uint256) public _expiredNodes;
    uint256 public totalNodesCreated;
    uint256 public ActiveNodes;

    constructor(address _BSN,uint _dec, address _rewPool, address _Team, address _Maintaince) {
        rewardPool = _rewPool;
        teamFunds = _Team;
        maintenanceFunds = _Maintaince;
        BSN = IERC20(_BSN);
        ROI = (5)*(10**_dec);
        restrictedNodes = 100;
        restrictedAmount = (500)*(10**_dec);
        dayCount = 86400;
    }

    event NodeCreated(address indexed from, string name, uint256 stamp, uint256 totalNodesCreated);

    function createNode(string memory _name,uint _tokenAmount) public nonReentrant() {

        require(_tokenAmount == restrictedAmount,"Need 500 $BSN to Create Node!!");

        require(_nodesCount[msg.sender] <= restrictedNodes, "Can't create nodes over 100");

        (bool os) = BSN.transferFrom(msg.sender,address(this),_tokenAmount);
        require(os,"Transaction Failed!!");

        if(isNodeOwner(msg.sender)){

            uint256 nodescounter = _nodesCount[msg.sender];
            require(nodescounter > 0,"Invalid Node Count!!");

            NodeEntity[] storage nodes = _nodesOfUser[msg.sender];
            // NodeEntity storage _node;

            for(uint i = 0; i < nodescounter; i++){

                if(
                    keccak256(abi.encodePacked(nodes[i].name)) == keccak256(abi.encodePacked(_name))
                ) {
                    revert("Name Already Registered!! Use Different One..");
                }
            }
        }


        totalNodesCreated++;
        _nodesCount[msg.sender]++;
        ActiveNodes++;

        _nodesOfUser[msg.sender].push(
            NodeEntity({
                amount: _tokenAmount,
                creationTime: block.timestamp,
                lastClaimTime: block.timestamp,
                name: _name,
                _nodeId: totalNodesCreated,
                created: 1,
                isStake: 1
            })
        );

        emit NodeCreated(msg.sender,_name,block.timestamp,totalNodesCreated);

    }

    function claimReward() public nonReentrant() {
        require(isNodeOwner(msg.sender),"CLAIM REWARDS : NO NODE OWNER");
        uint256 nodescounter = _nodesCount[msg.sender];

        NodeEntity[] storage nodes = _nodesOfUser[msg.sender];

        uint multiplier;

        for(uint i = 0; i < nodescounter; i++){

            uint claimTime = nodes[i].lastClaimTime;

            if(nodes[i].isStake == 1){

                uint sec = block.timestamp - claimTime;
                uint factor = ROI * sec;

                if(factor > 0) {
                    multiplier += factor / dayCount;
                    nodes[i].lastClaimTime = block.timestamp;
                }
            }
        }

        uint rewardedValue = multiplier;

        if(rewardedValue > 0) {
            BSN.transfer(msg.sender,rewardedValue);
        }
        else {
            revert("Wait Till Your Reward Get Generated!!");
        }
    }

    function _claimReward(address _account) internal {

        require(isNodeOwner(_account),"CLAIM REWARDS : NO NODE OWNER");
        uint256 nodescounter = _nodesCount[_account];

        NodeEntity[] storage nodes = _nodesOfUser[_account];

        uint multiplier;

        for(uint i = 0; i < nodescounter; i++){

            uint claimTime = nodes[i].lastClaimTime;

            if(nodes[i].isStake == 1){

                uint sec = block.timestamp - claimTime;
                uint factor = ROI * sec;

                if(factor > 0) {
                    multiplier += factor / dayCount;
                    nodes[i].lastClaimTime = block.timestamp;
                }
            }
        }

        uint rewardedValue = multiplier;

        if(rewardedValue > 0) {
            BSN.transfer(_account,rewardedValue);
        }
        else {
            revert("Wait Till Your Reward Get Generated!!");
        }
        
    }

    function breakNode(string calldata _name) public nonReentrant() {

        address account = msg.sender;
        uint currentTime = block.timestamp;

        if (getRewardValue(account) > 0) {
            _claimReward(account);
        }


        uint256 nodescounter = _nodesCount[account];

        require(nodescounter > 0,"Invalid Node Count!!");

        NodeEntity[] storage nodes = _nodesOfUser[account];
        NodeEntity storage _node;

        uint totalDeduction;
        uint AfterDeduction;
        // restrictedAmount

        uint counter;

        for(uint i = 0; i < nodescounter; i++){

            _node = nodes[i];

            if(
                keccak256(abi.encodePacked(nodes[i].name)) == keccak256(abi.encodePacked(_name))
            ) {

                if(nodes[i].isStake == 1) {

                    uint256 overload;

                    if(nodes[i].creationTime + 5 days > currentTime){   //1-5 days (45%}
                        overload += restrictedAmount.mul(45).div(100);
                        totalDeduction += overload;
                        AfterDeduction += restrictedAmount.sub(overload);
                        nodes[i].isStake -= 1;
                        ActiveNodes--;
                        _expiredNodes[account]++;
                        counter++;
                    }

                    else if(_node.creationTime + 9 days > currentTime){   //6-10 days (40%}
                        overload += restrictedAmount.mul(40).div(100);
                        totalDeduction += overload;
                        AfterDeduction += restrictedAmount.sub(overload);
                        _node.isStake = 0;
                        ActiveNodes--;
                        _expiredNodes[account]++;
                        counter++;
                    }

                    else if(_node.creationTime + 12 days > currentTime){   //11-15 days (35%}
                        overload += restrictedAmount.mul(35).div(100);
                        totalDeduction += overload;
                        AfterDeduction += restrictedAmount.sub(overload);
                        _node.isStake = 0;
                        ActiveNodes--;
                        _expiredNodes[account]++;
                        counter++;
                    }

                    else if(_node.creationTime + 16 days > currentTime){   //16-20 days (30%}
                        overload += restrictedAmount.mul(30).div(100);
                        totalDeduction += overload;
                        AfterDeduction += restrictedAmount.sub(overload);
                        _node.isStake = 0;
                        ActiveNodes--;
                        _expiredNodes[account]++;
                        counter++;
                    }

                    else if(_node.creationTime + 19 days > currentTime){   //21-25 days (25%}
                        overload += restrictedAmount.mul(25).div(100);
                        totalDeduction += overload;
                        AfterDeduction += restrictedAmount.sub(overload);
                        _node.isStake = 0;
                        ActiveNodes--;
                        _expiredNodes[account]++;
                        counter++;
                    }

                    else if(_node.creationTime + 21 days > currentTime){   //26-30 days (20%}
                        overload += restrictedAmount.mul(20).div(100);
                        totalDeduction += overload;
                        AfterDeduction += restrictedAmount.sub(overload);
                        _node.isStake = 0;
                        ActiveNodes--;
                        _expiredNodes[account]++;
                        counter++;
                    }

                    else{   //more then 31 days (10%)
                        overload += restrictedAmount.mul(10).div(100);
                        totalDeduction += overload;
                        AfterDeduction += restrictedAmount.sub(overload);
                        _node.isStake = 0;
                        ActiveNodes--;
                        _expiredNodes[account]++;
                        counter++;
                    }
                }

                else {
                    revert("Already Breaked!!");
                }
                
            }

        }

        uint subtotal = (AfterDeduction);

        if(totalDeduction > 0) {
            uint sevPer = totalDeduction.mul(70).div(100);
            uint TenPer = totalDeduction.mul(15).div(100);
            uint TwentyPer = totalDeduction.mul(15).div(100);

            BSN.transfer(rewardPool,sevPer);
            BSN.transfer(teamFunds,TenPer);
            BSN.transfer(maintenanceFunds,TwentyPer);
        }

        if(subtotal > 0){
            BSN.transfer(account,subtotal);
        }
        else {
            revert("There is Some Issue with your nodes!!");
        }
    }

    function getRewardByName(address user,string memory _name) public view returns (uint) {

        uint256 nodescounter = _nodesCount[user];
        require(nodescounter > 0,"Invalid Node Count!!");

        NodeEntity[] storage nodes = _nodesOfUser[user];
        uint multiplier;

        for(uint i = 0; i < nodescounter; i++){

            if(
                keccak256(abi.encodePacked(nodes[i].name)) == keccak256(abi.encodePacked(_name))
            ) {

                if(nodes[i].isStake == 1){
                    uint claimTime = nodes[i].lastClaimTime;
                    uint sec = block.timestamp - claimTime;
                    uint factor = ROI * sec;

                    if(factor > 0) {
                        multiplier += factor / dayCount;
                    }

                    return multiplier;
                }

                else {
                        revert("Node Already Breaked!!");
                }

            }
        }

        return 0;

    }

    function claimRewardByName(string memory _name) public nonReentrant() {

        uint256 nodescounter = _nodesCount[msg.sender];
        require(nodescounter > 0,"Invalid Node Count!!");

        NodeEntity[] storage nodes = _nodesOfUser[msg.sender];
        uint multiplier;

        for(uint i = 0; i < nodescounter; i++){

            if(
                keccak256(abi.encodePacked(nodes[i].name)) == keccak256(abi.encodePacked(_name))
            ) {

                if(nodes[i].isStake == 1){
                    uint claimTime = nodes[i].lastClaimTime;
                    uint sec = block.timestamp - claimTime;
                    uint factor = ROI * sec;

                    if(factor > 0) {
                        multiplier += factor / dayCount;
                    }

                    nodes[i].lastClaimTime = block.timestamp;
                }

                else {
                    revert("Node Already Breaked!!");
                }

            }
        }

        uint rewardedValue = multiplier;

        if(rewardedValue > 0) {
            BSN.transfer(msg.sender,rewardedValue);
        }
        else {
            revert("Wait Till Your Reward Get Generated!!");
        }

    }


  
    function getRewardValue(address account) public view returns (uint) {

        if(isNodeOwner(account))
        {
            uint256 nodescounter = _nodesCount[account];

            NodeEntity[] memory nodes = _nodesOfUser[account];
            NodeEntity memory _node;

            uint multiplier;

            for(uint i = 0; i < nodescounter; i++){

                _node = nodes[i];

                uint claimTime = _node.lastClaimTime;

                if(_node.isStake == 1){

                    uint sec = block.timestamp - claimTime;
                    uint factor = ROI * sec;

                    if(factor > 0) {

                        multiplier += factor / dayCount;
                    }
                }
            }
            return multiplier;
        }
        return 0;
    }

    function _getNodesId(address account)
        external
        view
        returns (string memory)
    {
        if(isNodeOwner(account))
        {
            NodeEntity[] memory nodes = _nodesOfUser[account];
            uint256 nodesCount = _nodesCount[account];
            NodeEntity memory _node;
            string memory _info = uint2str(nodes[0]._nodeId);
            string memory separator = "#";

            for (uint256 i = 1; i < nodesCount; i++) {
                _node = nodes[i];
                _info = string(
                    abi.encodePacked(
                        _info,
                        separator,
                        uint2str(_node._nodeId)
                    )
                );
            }
            return _info;
        }
        return '';
    }


    function _getNodesStakeInfo(address account)
        external
        view
        returns (string memory)
    {
        if(isNodeOwner(account))
        {
            NodeEntity[] memory nodes = _nodesOfUser[account];
            uint256 nodesCount = _nodesCount[account];
            NodeEntity memory _node;
            string memory _info = uint2str(nodes[0].isStake);
            string memory separator = "#";

            for (uint256 i = 1; i < nodesCount; i++) {
                _node = nodes[i];
                _info = string(
                    abi.encodePacked(
                        _info,
                        separator,
                        uint2str(_node.isStake)
                    )
                );
            }
            return _info;
        }
        return '';
    }

    function _getNodesNameInfo(address account)
        external
        view
        returns (string memory)
    {
        if(isNodeOwner(account))
        {
            NodeEntity[] memory nodes = _nodesOfUser[account];
            uint256 nodesCount = _nodesCount[account];
            NodeEntity memory _node;
            string memory _info = nodes[0].name;
            string memory separator = "#";

            for (uint256 i = 1; i < nodesCount; i++) {
                _node = nodes[i];
                _info = string(
                    abi.encodePacked(
                        _info,
                        separator,
                        nodes[i].name
                    )
                );
            }
            return _info;
        }
        return '';
    }


    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function isNodeOwner(address account) private view returns (bool) {
        return _nodesCount[account] > 0;
    }

    function rescueToken(IERC20 _adr,address recipient,uint _amount) public onlyOwner {
        _adr.transfer(recipient,_amount);
    }

    function rescueFunds() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function setSplitWallets(address _rewPool, address _Team, address _Maintaince) public onlyOwner {
        rewardPool = _rewPool;
        teamFunds = _Team;
        maintenanceFunds = _Maintaince;
    }


}