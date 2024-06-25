/**
 *Submitted for verification at BscScan.com on 2022-10-06
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC20 {
    function balanceOf(address owner) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface ISmartSwapRouter02 {
    function WETH() external pure returns (address);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
        
    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
}


contract rigelInstantPancake is Context {
    IERC20 public rigelToken;
    ISmartSwapRouter02 public smartSwap;
    address payable public devWallet;
    address public owner;
    uint256 public fee;
    uint256 public orderCount;
    uint256 public totalFeeCollected;
    
    struct userData {
        uint256 _id;
        uint256 amountIn;
        uint256 time;
        address caller;
        address[] path;
    }
    
    mapping(address => mapping(uint256 => userData)) private Data;
    mapping(uint256 => bool) public orderCancelled;
    mapping(uint256 => bool) public orderFilled;
    mapping (address => bool) public permit;

    event markOrder(
        uint256 id,
        address indexed user,
        address indexed to,
        address swapFromToken,
        address swapToToken,
        uint256 amountToSwap
    );

    event Cancel(
        uint256 id,
        address indexed user,
        address swapFromToken,
        address swapToToken,
        uint256 amountIn,
        uint256 timestamp
    );

    event fulfilOrder(
        address indexed caller,
        address indexed to,
        address swapFromToken,
        address swapToToken,
        uint256 amountToSwap,
        uint256 time
    );

    modifier onlyOwner() {
        require(owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, "Rigel's Protocol: Locked");
        unlocked = 0;
        _;
        unlocked = 1;
    }
    error Denied();
    error invalid();
    error Allowance();
    error Insufficient();

    constructor(address _rigelToken, address _routerContract, address dev, uint256 timeFee)  {
        rigelToken = IERC20(_rigelToken);
        smartSwap = ISmartSwapRouter02(_routerContract);
        fee = timeFee;
        devWallet = payable(dev);
        owner = _msgSender();
    }

    receive() external payable {}

    function grantAccess(address addr, bool status) external onlyOwner {
        permit[addr] = status;
    }

    function updateRigelFee(uint256 _newFee) external onlyOwner {
        fee = _newFee;
    }

    function changeRouterContract(address _newRouter) external onlyOwner {
        smartSwap = ISmartSwapRouter02(_newRouter);
    }

    function swapExactTokens(
        uint256 _orderID,
        address[] calldata path,
        address _user, 
        uint256 _amountIn
        ) external {    
              
        if (_orderID > orderCount) {
            orderCount = orderCount + 1;
        }
        if(!permit[_msgSender()]) revert Denied();
        if (fee != 0) {
            rigelToken.transferFrom(_user, devWallet, fee);
        }
        require(IERC20(path[0]).transferFrom(_user, address(this), _amountIn));
        totalFeeCollected = totalFeeCollected + fee;
        IERC20(path[0]).approve(address(smartSwap), _amountIn);
        uint256[] memory outputAmount = smartSwap.getAmountsOut(
            _amountIn,
            path
        );
        smartSwap.swapExactTokensForTokens(
            _amountIn,
            outputAmount[1],
            path,
            _user,
            block.timestamp + 1200
        );
        
        emit fulfilOrder(
            _msgSender(),
            _user,
            address(path[0]),
            path[1],
            _amountIn,
            block.timestamp
        );
    }

    function swapTokensForETH(
        uint256 _orderID,
        address[] calldata path,
        address _user, 
        uint256 _amountIn
        ) external {
        if (_orderID > orderCount) {
            orderCount = orderCount + 1;
        }
        if(!permit[_msgSender()]) revert Denied();
        if (fee != 0) {
            rigelToken.transferFrom(_user, devWallet, fee);
        }
        totalFeeCollected = totalFeeCollected + fee;
        IERC20(path[0]).approve(address(smartSwap), _amountIn);
        uint256[] memory outputAmount = smartSwap.getAmountsOut(
            _amountIn,
            path
        );
        require(IERC20(path[0]).transferFrom(_user, address(this), _amountIn));
        smartSwap.swapExactTokensForETH(
            _amountIn,
            outputAmount[1],
            path,
            _user,
            block.timestamp + 1200
        );
        
        emit fulfilOrder(
            _msgSender(),
            _user,
            address(path[0]),
            path[1],
            _amountIn,
            block.timestamp
        );
    }

    function cancelOrder(uint256 _id) external lock() {
        require(_id > 0 && _id <= orderCount, "Error: wrong id");
        if(orderCancelled[_id]) revert invalid();
        orderCancelled[_id] = true;
        userData storage _userData = Data[_msgSender()][_id];
        if(_userData.amountIn == 0) revert Insufficient();
        payable(_msgSender()).transfer(_userData.amountIn);
        _userData.amountIn -= _userData.amountIn;
        emit Cancel(
            _id,
            _msgSender(),
            _userData.path[0],
            _userData.path[1],
            _userData.amountIn,
            block.timestamp 
        );
    }

    function setPeriodToSwapETHForTokens(
        address[] calldata path,
        uint256 _timeOf
        ) external payable{
        
        orderCount = orderCount + 1;
        userData storage _userData = Data[_msgSender()][orderCount];  
        _userData._id = orderCount;
        _userData.amountIn = msg.value;
        _userData.path = [path[0], path[1]];
        _userData.time = block.timestamp;
        _userData.time = _timeOf;
        emit markOrder(
            _userData._id,
            _msgSender(),
            _msgSender(),
            path[0],
            path[1],
            msg.value
        );
    }

    function SwapETHForTokens(uint256 _id, address _user, uint256 amount) external {
        if(!permit[_msgSender()]) revert Denied();
        require(_id > 0 && _id <= orderCount, "Error: wrong id");
        if(orderCancelled[_id]) revert invalid();
        userData storage _userData = Data[_user][_id]; 
        rigelToken.transferFrom(_user, devWallet, fee);
        if(amount > _userData.amountIn) revert Insufficient();
        _userData.amountIn -= amount;
        totalFeeCollected = totalFeeCollected + fee;
        IERC20(_userData.path[1]).approve(address(smartSwap), _userData.amountIn);
        uint256[] memory outputAmount = smartSwap.getAmountsOut(
            amount,
            _userData.path
        );
        // update the time this trx occure.
        _userData.time = block.timestamp;
        if(_userData.path[0] == smartSwap.WETH()) {
            smartSwap.swapExactETHForTokens{value: amount}(
                outputAmount[1],
                _userData.path,
                _user,
                block.timestamp + 1200
            );
        }
        emit fulfilOrder(
            _msgSender(),
            _user,
            _userData.path[0],
            _userData.path[1],
            amount,
            block.timestamp
        );
    }

    function withdrawToken(address _token, address _user, uint256 _amount) external onlyOwner {
        IERC20(_token).transfer(_user, _amount);
    }

    function withdrawETH(address _user, uint256 _amount) external onlyOwner {
        payable(_user).transfer(_amount);
    }

    function getUserData(address _user, uint256 _id) external view returns(userData memory _userData) {
        _userData = Data[_user][_id];        
    }
}