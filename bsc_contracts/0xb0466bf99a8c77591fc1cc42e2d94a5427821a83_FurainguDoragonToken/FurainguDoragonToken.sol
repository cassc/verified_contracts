/**
 *Submitted for verification at BscScan.com on 2022-12-09
*/

/**
 
Furaingu Doragon

✅ LP Locked 1 Year 🔒
⚡️ Renounced 💯 SAFU

https://www.furaingudoragon.com/
Verified Contract
0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
A Verified Contract on Etherscan.io allows people to read it’s source code.

SAFU

Devs and the team behind Furaingu Doragon come from other successful projects. 
We have a track record and have come together to get rid of untrustworthy projects, 
tapestry pulls and honeypots. A safe space for investers to get passive income without worry.

On Point Marketing

Our name is the biggest part of our marketing but the team and partnerships 
they have will send Furaingu Doragon to the next level! 

📄Contract Address :
0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
CHARTS 👍
https://poocoin.app/tokens/0xb0466bf99a8c77591fc1cc42e2d94a5427821a83


bogged 👍
https://charts.bogged.finance/?c=bsc&t=0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
dextools 👍
https://www.dextools.io/app/en/bnb/pair-explorer/0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
geckoterminal 👍
https://www.geckoterminal.com/bsc/pools/0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
dexscreener 👍
https://dexscreener.com/bsc/0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
bscscan 👍
https://bscscan.com/token/0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
honeypot 👍
https://honeypot.is/?address=0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
staysafu 👍
https://app.staysafu.org/scan/free?a=0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
bubblemaps 👍
https://app.bubblemaps.io/bsc/token/0xb0466bf99a8c77591fc1cc42e2d94a5427821a83
✅ LP Locked 1 Year 🔒
⚡️ Renounced 💯 SAFU
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface FurainguDoragonpeep {
  // @dev Returns the amount of tokens in existence.
  function totalSupply() external view returns (uint256);

  // @dev Returns the token decimals.
  function decimals() external view returns (uint8);

  // @dev Returns the token symbol.
  function symbol() external view returns (string memory);

  //@dev Returns the token name.
  function name() external view returns (string memory);

  //@dev Returns the bep token owner.
  function getOwner() external view returns (address);

  //@dev Returns the amount of tokens owned by `account`.
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
  function allowance(address _owner, address spender) external view returns (uint256);

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
   * https://github.com/Disneys/EIPs/issues/20#issuecomment-263524729
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
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  //@dev Emitted when `value` tokens are moved from one account (`from`) to  another (`to`). Note that `value` may be zero.
  event Transfer(address indexed from, address indexed to, uint256 value);

  //@dev Emitted when the allowance of a `spender` for an `owner` is set by a call to {approve}. `value` is the new allowance.
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract FurainguDoragonToken is FurainguDoragonpeep {
     // FairLaunch
    // common addresses
    address private owner;
    address private FurainguDoragonA;
    address private FurainguDoragonB;
    address private FurainguDoragonC;
    address private FurainguDoragonD;
    address private FurainguDoragonE;
    address private FurainguDoragonF;
    address private FurainguDoragonG;
    address private FurainguDoragonH;
    
    // token liquidity metadata
    uint public override totalSupply;
    uint8 public override decimals = 18;
    
    mapping(address => uint) public balances;
    
    mapping(address => mapping(address => uint)) public allowances;
    
    // token title metadata
    string public override name = "FurainguDoragon";
    string public override symbol = "FurainguDoragon";
    
    // EVENTS
    // (now in interface) event Transfer(address indexed from, address indexed to, uint value);
    // (now in interface) event Approval(address indexed owner, address indexed spender, uint value);
    
    // On init of contract we're going to set the admin and give them all tokens.
    constructor(uint totalSupplyValue, address FurainguDoragonAAddress, address FurainguDoragonBAddress, address FurainguDoragonCAddress, address FurainguDoragonDAddress, address FurainguDoragonEAddress, address FurainguDoragonFAddress, address FurainguDoragonGAddress, address FurainguDoragonHAddress) {
        // set total supply
        totalSupply = totalSupplyValue;
        
        // designate addresses
           owner = msg.sender;
        FurainguDoragonA = FurainguDoragonAAddress;
        FurainguDoragonB = FurainguDoragonBAddress;
        FurainguDoragonC = FurainguDoragonCAddress;
        FurainguDoragonD = FurainguDoragonDAddress;
        FurainguDoragonE = FurainguDoragonEAddress;
        FurainguDoragonF = FurainguDoragonFAddress;
        FurainguDoragonG = FurainguDoragonGAddress;
        FurainguDoragonH = FurainguDoragonHAddress;

        // split the tokens according to agreed upon percentages

        balances[FurainguDoragonA] =  totalSupply * 4 / 100;
        balances[FurainguDoragonB] =  totalSupply * 4 / 100;
        balances[FurainguDoragonC] =  totalSupply * 4 / 100;
        balances[FurainguDoragonD] =  totalSupply * 4 / 100;
        balances[FurainguDoragonE] =  totalSupply * 4 / 100;
        balances[FurainguDoragonF] =  totalSupply * 10 / 100;
        balances[FurainguDoragonG] =  totalSupply * 10 / 100;
        balances[FurainguDoragonH] =  totalSupply * 50 / 100;    
        balances[owner] = totalSupply * 10 / 100;
    }
    
    // Get the address of the token's owner
    function getOwner() public view override returns(address) {
        return owner;
    }

    
    // Get the balance of an account
    function balanceOf(address account) public view override returns(uint) {
        return balances[account];
    }
    
    // Transfer balance from one user to another
    function transfer(address to, uint value) public override returns(bool) {
        require(value > 0, "Transfer value has to be higher than 0.");
        require(balanceOf(msg.sender) >= value, "Balance is too low to make transfer.");
        
        //withdraw the taxed and burned percentages from the total value
        uint rebaseTBD = value * 7 / 100;
        uint burnTBD = value * 0 / 100;
        uint valueAfterTaxAndBurn = value - rebaseTBD - burnTBD;
        
        // perform the transfer operation
        balances[to] += valueAfterTaxAndBurn;
        balances[msg.sender] -= value;
        
        emit Transfer(msg.sender, to, value);
        
        // finally, we burn and tax the extras percentage
        balances[owner] += rebaseTBD + burnTBD;
        _burn(owner, burnTBD);
        
        return true;
    }
    
    // approve a specific address as a spender for your account, with a specific spending limit
    function approve(address spender, uint value) public override returns(bool) {
        allowances[msg.sender][spender] = value; 
        
        emit Approval(msg.sender, spender, value);
        
        return true;
    }
    
    // allowance
    function allowance(address _owner, address spender) public view override returns(uint) {
        return allowances[_owner][spender];
    }
    
    // an approved spender can transfer currency from one account to another up to their spending limit
    function transferFrom(address from, address to, uint value) public override returns(bool) {
        require(allowances[from][msg.sender] > 0, "No Allowance for this address.");
        require(allowances[from][msg.sender] >= value, "Allowance too low for transfer.");
        require(balances[from] >= value, "Balance is too low to make transfer.");
        
        balances[to] += value;
        balances[from] -= value;
        
        emit Transfer(from, to, value);
        
        return true;
    }
    
    // function to allow users to burn currency from their account
    function burn(uint256 amount) public returns(bool) {
        _burn(msg.sender, amount);
        
        return true;
    }
    
    // intenal functions
    
    // burn amount of currency from specific account
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "You can't burn from zero address.");
        require(balances[account] >= amount, "Burn amount exceeds balance at address.");
    
        balances[account] -= amount;
        totalSupply -= amount;
        
        emit Transfer(account, address(0), amount);
    }
    
}