/**
 *Submitted for verification at BscScan.com on 2022-11-24
*/

/**
 *Submitted for verification at BscScan.com on 2021-10-01
*/

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/swirge-marketing.sol

pragma solidity ^0.8.4;


contract SwirgePartnerships {
  uint public constant duration = 0 days;
  uint public immutable end;
  address payable public immutable owner  = payable(0xc2253Ea33F98034Bc793496340bbE8D5D65e5460);
  uint256 public balance = 0;

  constructor() {
    end = block.timestamp + duration;
  }
  
  function getRemainingTime() external view returns(uint256){
      if(end < block.timestamp){
          return 0;
      }
      return (end - block.timestamp)/(60 * 60 * 24);
  }

  function deposit(address token, uint amount) external {
    //owner required
    require(msg.sender == owner, "only owner can make transactions");
    
    //owner should have allowance
    require(IERC20(token).allowance(msg.sender,address(this))>=amount,"don't have allowance");
    
    //transfer tokens to this smart contract
    IERC20(token).transferFrom(msg.sender, address(this), amount);
    
    balance += amount;
  }

  receive() external payable {}

  function withdraw(address token, uint amount) external {
    require(msg.sender == owner, 'only owner');
    require(block.timestamp >= end, 'too early');
    if(token == address(0)) { 
      owner.transfer(amount);
    } else {
      IERC20(token).transfer(owner, amount);
    }
  }
}