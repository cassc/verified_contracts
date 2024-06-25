// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./AccessControl.sol";
import "./Address.sol";
import "./IERC20.sol";

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IPancakeFactory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface INSIFactory{
    function hasRole(bytes32 role, address account) external view returns (bool);
}

contract NSIMidWalletV1 is AccessControl {
    using Address for address;

    bytes32 constant public OWNER_ROLE = keccak256("Owner Role");
    bytes32 constant public ADMIN_ROLE = keccak256("Admin Role");

    IUniswapV2Router02 public uniswapV2Router;

    address public owner;
    address public factoryAddress = msg.sender;
    bool private paused = false;
    bool public Withdrawpaused = true;

    mapping(address => bool) public enabled;
    mapping(address => bool) public disabled;

    event Trade(address indexed user, uint256 amount, address[] path);
    event Withdraw(address indexed user, uint256 amount, address token);
    event Deposit(address indexed user, uint256 amount, address token);
    event Resultant_Token(address indexed user, uint256 amount, address token);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); 

    modifier onlyOwner(){
        require(hasRole(OWNER_ROLE, msg.sender), "Just Owner!");
        _;
    }

    modifier onlyAdmin(){
        require(INSIFactory(factoryAddress).hasRole(ADMIN_ROLE, msg.sender), "Just Admin!");
        _;
    }

    constructor(address _owner) {

        _setupRole(DEFAULT_ADMIN_ROLE, tx.origin);
        _setupRole(OWNER_ROLE, _owner);
        uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Mainnet

        owner = _owner;
    }

    receive() payable external{}

    function enable(address tokenContractAddress) public onlyOwner{
        IERC20 token = IERC20(tokenContractAddress);
        token.approve(address(uniswapV2Router), type(uint256).max);
        enabled[tokenContractAddress] = true;
    }

    function disable(address tokenContractAddress) public onlyOwner{
        enabled[tokenContractAddress] = false;
        disabled[tokenContractAddress] = true;
    }

    modifier checkAllowance( address token , uint amount)  {
        require(IERC20(token).allowance(msg.sender, address(this)) >= amount, "NSI_MidWallet: Transfering more than allowed");
        _;
    }

    function checkAllowanceof( address token ) external view returns(uint) {
        return (IERC20(token).allowance(msg.sender, address(this)));
        
    }

    function depositTokens(address _token , uint _amount) public checkAllowance(_token, _amount) onlyOwner {
        require(paused == false, "You can't depoist while Swaping");
        require(disabled[_token] == false, "This token is disableb by the owner. Enable it again before depositing in mid wallet.");
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        emit Deposit(owner, _amount, _token);
    }    

    function getSmartContractBalance(address token ) external view returns(uint) {
        return IERC20(token).balanceOf(address(this));
    }

    function Trade_Token(address _tokenIn, address _tokenOut, uint256 _amountIn, uint256 _amountOutMin) public onlyAdmin{
        paused ==  true;
        address _to = address(this);
        address  WETH = uniswapV2Router.WETH();
        address[] memory path;
        if(_tokenIn == WETH){
            require(enabled[_tokenOut] == true,"The token you are trying to swap is not enbaled in MidWallet.");
        }else if(_tokenOut == WETH){
            require(enabled[_tokenIn] == true,"The token you are trying to swap is not enbaled in MidWallet.");
        }else{
            require(enabled[_tokenIn] == true && enabled[_tokenOut],"The token you are trying to swap is not enbaled in MidWallet.");
        }        
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
        uint deadline = block.timestamp + 200;
        IUniswapV2Router02(uniswapV2Router).swapExactTokensForTokens(_amountIn, _amountOutMin, path, _to, deadline);
        paused == false;
        
        emit Resultant_Token(owner, _amountOutMin, _tokenOut);
    }

    function Trade_Token_Supporting_Fee(address _tokenIn, address _tokenOut, uint256 _amountIn, uint256 _amountOutMin) public onlyAdmin{
        paused == true;
        address _to = address(this);
        address  WETH = uniswapV2Router.WETH();
        address[] memory path;
        if(_tokenIn == WETH){
            require(enabled[_tokenOut] == true,"The token you are trying to swap is not enbaled in MidWallet.");
        }else if(_tokenOut == WETH){
            require(enabled[_tokenIn] == true,"The token you are trying to swap is not enbaled in MidWallet.");
        }else{
            require(enabled[_tokenIn] == true && enabled[_tokenOut],"The token you are trying to swap is not enbaled in MidWallet.");
        }
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
        uint deadline = block.timestamp + 200;
        IUniswapV2Router02(uniswapV2Router).swapExactTokensForTokensSupportingFeeOnTransferTokens(_amountIn, _amountOutMin, path, _to, deadline);
        paused == false;

        emit Resultant_Token(owner, _amountOutMin, _tokenOut);
    }
        
    function getAmountOutMin(address _tokenIn, address _tokenOut, uint256 _amountIn) external view returns (uint256) {
            
            address[] memory path;
            address  WETH = uniswapV2Router.WETH();
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
            
            uint256[] memory amountOutMins = IUniswapV2Router02(uniswapV2Router).getAmountsOut(_amountIn, path);
            return amountOutMins[path.length -1];  
    }

    function ownerWithdraw(uint256 _amount, address _tokenAddr) public onlyOwner {
        require(paused == false, "You can't withdraw while Swaping");
        require(Withdrawpaused == false, "Admin hasn't allowed you to withdraw tokens yet.");
        require(disabled[_tokenAddr] == false, "This token is disableb by the owner. Enable it again before withdrawing from the mid wallet.");
        
        if(_tokenAddr == address(0)){
          payable(msg.sender).transfer(_amount);
        }else{
          IERC20(_tokenAddr).transfer(msg.sender, _amount);
        }
        emit Withdraw(owner, _amount, _tokenAddr);
    }

     function WithdrawPaused(bool value) public onlyAdmin{ 
        Withdrawpaused = value;

    }

}