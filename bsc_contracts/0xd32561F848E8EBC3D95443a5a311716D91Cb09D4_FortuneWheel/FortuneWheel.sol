/**
 *Submitted for verification at BscScan.com on 2023-02-06
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.16;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address from,address to,uint256 amount) external returns (bool);
}
contract Context {
    function _msgSender() internal view returns (address payable) {return payable(msg.sender);}
    function _msgData() internal view returns (bytes memory) {this; return msg.data;}
}
contract Ownable is Context {
    address public _owner;
    event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
    function owner() public view returns (address) {return _owner;}
    modifier onlyOwner() {require(_owner == _msgSender(), "Ownable: caller is not the owner");_;}
    function renounceOwnership() public virtual onlyOwner {emit OwnershipTransferred(_owner, address(0));_owner = address(0);}
    function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0),"Ownable new owner is the zero address");emit OwnershipTransferred(_owner, newOwner);_owner = newOwner;}
}
contract FortuneWheel is Context, Ownable {

    IERC20 BLUE_ART;
    uint256 WinReward_1;
    uint256 WinReward_2;
    uint256 WinReward_3;
    uint256 TicketPrice;
    uint256 BLA_DECIMALS = 1000000000; // 10^9

    mapping(uint => bytes) private m_game_result;
    mapping(address => uint256) private m_user_turn_count;
    mapping(address => uint256) private m_user_win_balance;
 
    event WheelTurned(address indexed user, uint indexed wheelResult);
    event ClaimReward(address indexed user, uint256 indexed userReward);
    event UserBoughtTicket(address indexed user, uint256 indexed ticketCount);

    constructor() {
        _owner = _msgSender();
        WinReward_1 = 1000; // 1K BLA
        WinReward_2 = 200; // 200 BLA
        WinReward_3 = 100; // 100 BLA

        TicketPrice = 100; // 100 BLA
        BLUE_ART = IERC20(0x81Aa4d3AD2A86E7A2cd44630C36ccAACD6b30568);
    }
// public
    function buyTicket(uint256 _ticket_count) external {
        require(_ticket_count > 0, "Ticket count must be bigger than zero!");
    
        address senderAddress = _msgSender();
        bool success = BLUE_ART.transferFrom(senderAddress, address(this), _ticket_count * TicketPrice * BLA_DECIMALS);
        require(success, "ERROR: BLA staking failed.");

        m_user_turn_count[senderAddress] += _ticket_count ;

        emit UserBoughtTicket(senderAddress, _ticket_count);
    }
    function spinWheel() external {
        require(m_user_turn_count[_msgSender()] > 0, "You don't have any ticket!");
        address senderAddress = msg.sender;

        uint randomNum = _random();
        uint gameResult =  _handleWheelResult(senderAddress, randomNum);

        emit WheelTurned(senderAddress, gameResult);
    }
    function claimReward() external {       
        address senderAddress = _msgSender();
        uint senderBalance = m_user_win_balance[senderAddress];
        require(senderBalance > 1000, "You don't have any rewards.");

        m_user_win_balance[senderAddress] = 0;

        bool success = BLUE_ART.transfer(senderAddress, senderBalance);
        require(success, "ERROR: BLA staking failed.");

        emit ClaimReward(senderAddress, senderBalance);
    }
    function getUserBalance(address user) external view returns(uint256) {
        return m_user_win_balance[user];
    }
    function getUserTicketCount(address user) external view returns(uint256) {
        return m_user_turn_count[user];
    } 
// only owner
    function setWinnerPrize_1(uint256 new_winner_prize) external onlyOwner {
        WinReward_1 = new_winner_prize;
    }
    function setWinnerPrize_2(uint256 new_winner_prize) external onlyOwner {
        WinReward_2 = new_winner_prize;
    }
    function setWinnerPrize_3(uint256 new_winner_prize) external onlyOwner {
        WinReward_3 = new_winner_prize;
    }
    function setTicketPrice(uint256 new_ticket_ptice) external onlyOwner {
        TicketPrice = new_ticket_ptice; 
    }
    function returnBLATokens() external onlyOwner {
        uint256 contractBalance = BLUE_ART.balanceOf(address(this));

        bool success = BLUE_ART.transfer(owner(), contractBalance);
        require(success, "Error: Returning contracts BLA tokens.");
    }
    function destroyContract() external onlyOwner {
        // only for protection purpose
        selfdestruct(payable(owner()));
    }
// private
    function _handleWheelResult(address user, uint256 _wheel_index) private returns(uint256) {
        if(_wheel_index == 1) {
            m_user_win_balance[user] += WinReward_1 * BLA_DECIMALS; // 1K BLA
            m_user_turn_count[user] -= 1;
            return 1;
        } 
        else if(_wheel_index == 7) {
            m_user_win_balance[user] += WinReward_2 * BLA_DECIMALS; // 200 BLA
            m_user_turn_count[user] -= 1;
            return 7;
        }
        else if(_wheel_index == 5) {
            m_user_win_balance[user] += WinReward_3 * BLA_DECIMALS; // 100 BLA
            m_user_turn_count[user] -= 1;
            return 5;
        }
        else if(_wheel_index == 9 || _wheel_index == 2) {
            return 3;
        }
        else {
            m_user_turn_count[user] -= 1;
            return 0;
        }
    }
    function _random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 13;
    }
}