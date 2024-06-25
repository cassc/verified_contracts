/**
 *Submitted for verification at BscScan.com on 2023-01-04
*/

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
abstract contract Ownable{
    address private _owner;
    constructor() {
        _transferOwnership(msg.sender);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }


    function _checkOwner() internal view virtual {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        _owner = newOwner;
    }
}

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

interface IPancakeRouter {
  function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);  
  function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

contract Swap is Ownable{
    address private constant PANCAKE_V2_ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address private constant WETH = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
    function withdrow() external onlyOwner{
        payable(msg.sender).transfer(address(this).balance);
    }
    function buy(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin) external onlyOwner {
      IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);

      IERC20(_tokenIn).approve(PANCAKE_V2_ROUTER, _amountIn);

      address[] memory path;
       if (_tokenIn == WETH || _tokenOut == WETH) {
        path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;
      } else {
        path = new address[](3);
        path[0] = _tokenIn;
        path[1] = WETH;
        path[2] = _tokenOut;
      }
      IPancakeRouter(PANCAKE_V2_ROUTER).swapExactTokensForTokens(_amountIn, _amountOutMin, path, address(this), block.timestamp);
    }
    function sell(address _tokenIn) external onlyOwner {

      uint256 _amountIn = IERC20(_tokenIn).balanceOf(address(this));
    
      IERC20(_tokenIn).approve(PANCAKE_V2_ROUTER, _amountIn);
    
      address[] memory path;
      
      path = new address[](2);
      path[0] = _tokenIn;
      path[1] = WETH;
      IPancakeRouter(PANCAKE_V2_ROUTER).swapExactTokensForTokens(_amountIn, 1, path, address(this), block.timestamp);
    }

}