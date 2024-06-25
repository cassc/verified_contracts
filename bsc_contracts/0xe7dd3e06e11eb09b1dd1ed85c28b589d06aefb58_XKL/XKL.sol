/**
 *Submitted for verification at BscScan.com on 2022-10-30
*/

// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);
}


library EnumerableSet {
    struct Set {
        bytes32[] _values;
        mapping(bytes32 => uint256) _indexes;
    }

    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function _remove(Set storage set, bytes32 value) private returns (bool) {
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];
                set._values[toDeleteIndex] = lastValue;
                set._indexes[lastValue] = valueIndex;
            }
            set._values.pop();
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    struct Bytes32Set {
        Set _inner;
    }

    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        return _values(set._inner);
    }

    struct AddressSet {
        Set _inner;
    }

    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        assembly {
            result := store
        }

        return result;
    }

    struct UintSet {
        Set _inner;
    }

    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        assembly {
            result := store
        }

        return result;
    }
}

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
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "e003");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "e004");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "e005");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "e006");
        uint256 c = a / b;
        return c;
    }
}


interface swapFactory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface swapRouter {

    function factory() external pure returns (address);

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

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);


    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

}

contract middleContract is Ownable {
    address public caller;
    constructor (address _account)  {
        caller = _account;

    }
    function claimToken(IERC20 _token) external {
        require(msg.sender == caller);
        _token.transfer(msg.sender, _token.balanceOf(address(this)));
    }
}


interface ICoSoPair {
    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

contract XKL is Ownable {
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.AddressSet;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) public buyerSet; //whitelist for buyer
    mapping(address => bool) public sellerSet; //whitelist for seller
    mapping(address => bool) public transferSet; //whitelist for transfer
    mapping(address => bool) public contractList; //whitelist for contract address

    address public marketAddress;
    address public liquifyAddress;
    address public deadAddress = address(0);
    address[] public teamAddressList;
    uint256[] public teamFeeList = [100, 100, 50];

    address[] public nodeList;
    uint256 public nodeFee = 75;
    uint256 public lpFee = 75;
    uint256 public autoPool = 25;

    address public WETH;
    address public swapAndLiquifyToken;
    swapRouter public routerAddress;
    EnumerableSet.AddressSet private pairAddressList;
    uint256 private _totalSupply;
    middleContract public middleContractAddress;


    uint256 public allRate = 10000;

    uint256 public buyFeeForMarket = 75;
    uint256 public buyFeeForBurn = 0;
    uint256 public buyFeeForAddPool = 175;
    uint256 public buyFeeForTeam = 250;

    uint256 public sellFeeForMarket = 75;
    uint256 public sellFeeForBurn = 0;
    uint256 public sellFeeForAddPool = 175;
    uint256 public sellFeeForTeam = 250;

    uint256 public txFeeForMarket = 75;
    uint256 public txFeeForBurn = 0;
    uint256 public txFeeForAddPool = 175;
    uint256 public txFeeForTeam = 250;

    uint256 public minAddPoolAmount = 25 * (10 ** 17);
    uint256 public minHolderAmount = 1 * (10 ** 14);
    string private _name;
    string private _symbol;
    uint256 private _decimals;

    struct buyFeeStruct {
        uint256 buyFeeForMarket;
        uint256 buyFeeForBurn;
        uint256 buyFeeForAddPool;
        uint256 buyFeeForTeam;
    }

    struct sellFeeStruct {
        uint256 sellFeeForMarket;
        uint256 sellFeeForBurn;
        uint256 sellFeeForAddPool;
        uint256 sellFeeForTeam;
    }

    struct txFeeStruct {
        uint256 txFeeForMarket;
        uint256 txFeeForBurn;
        uint256 txFeeForAddPool;
        uint256 txFeeForTeam;
    }

    struct feeAddressListStruct {
        address[] feeListForBuy;
        address[] feeListForSell;
        address[] feeListForTransfer;
    }

    struct swapInfoStruct {
        bool canAddLiquify;
        address marketAddress;
        address routerAddress;
        address swapAndLiquifyToken;
        address WETH;
        uint256 minAddPoolAmount;
    }

    struct tokenStruct {
        uint256 decimals;
        buyFeeStruct buyFee;
        sellFeeStruct sellFee;
        txFeeStruct txFee;
        address[] feeAddressList;
        swapInfoStruct swapInfo;
    }

    struct feeStruct {
        uint256 marketFee;
        uint256 burnFee;
        uint256 liquidityFee;
        uint256 teamFee;
        uint256 txAmount;
        uint256 feeListNum;
        uint256 teamPerFee;
    }

    bool public canAddLiquify = false;

    bool inSwapAndLiquify;
    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    address[] public ldxUser;
    uint256 public ldxindex;
    mapping(address => bool) public havepush;

    event isAddLiquidity(bool isAdd);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event swapAndLiquifyEvent(uint256 amount);
    event addPairEvent(address _pair, uint256 _time);
    event transferType(string _type, address sender, address recipient, uint256 amount);
    event checkIsAddLiquidityEvent(address token0, address token1, uint256 r0, uint256 r1, uint256 bal0, uint256 bal1, bool r0_e, bool r1_e);
    event addUser(address _user, uint256 _time);
    event swapAndLiquifyEvent(string _type, uint256 _UsdtAmount, uint256 _thisAmount);
    event takeFeeEvent(string _type, address _user, uint256 amount);
    event splitLpDividendEvent(address _user, uint256 _amount);

    constructor (address newOwner_, string memory name_, string memory symbol_, uint256 decimals_, uint256 totalSupply_, address _marketAddress, address _liquifyAddress)  {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _totalSupply = totalSupply_.mul(10 ** _decimals);
        _balances[newOwner_] = _totalSupply;
        middleContractAddress = new middleContract(address(this));
        buyerSet[newOwner_] = true;
        sellerSet[newOwner_] = true;
        transferSet[newOwner_] = true;
        buyerSet[address(this)] = true;
        sellerSet[address(this)] = true;
        transferSet[address(this)] = true;
        transferSet[deadAddress] = true;
        transferSet[address(middleContractAddress)] = true;
        contractList[address(this)] = true;
        contractList[address(middleContractAddress)] = true;
        marketAddress = _marketAddress;
        buyerSet[_marketAddress] = true;
        sellerSet[_marketAddress] = true;
        transferSet[_marketAddress] = true;
        liquifyAddress = _liquifyAddress;
        buyerSet[_liquifyAddress] = true;
        sellerSet[_liquifyAddress] = true;
        transferSet[_liquifyAddress] = true;
        emit Transfer(address(0), newOwner_, _totalSupply);
    }

    function setHSwapInfo(bool _canAddLiquify, swapRouter _routerAddress, address _WETH, address _swapAndLiquifyToken, uint256 _amount, uint256 _minAddPoolAmount) external onlyOwner {
        require(address(_routerAddress) != address(0));
        require(_WETH != address(0));
        require(_swapAndLiquifyToken != address(0));
        canAddLiquify = _canAddLiquify;
        routerAddress = _routerAddress;
        WETH = _WETH;
        swapAndLiquifyToken = _swapAndLiquifyToken;
        minAddPoolAmount = _minAddPoolAmount;
        IERC20(address(this)).approve(address(_routerAddress), _amount);
        if (_swapAndLiquifyToken != WETH) {
            IERC20(_swapAndLiquifyToken).approve(address(_routerAddress), _amount);
        }
    }
    
    function setHNodeList(address[] memory _nodeList) external onlyOwner {
        nodeList = _nodeList;
    }

    function setAddLiquifyMode(bool _canAddLiquify) external onlyOwner {
        canAddLiquify = _canAddLiquify;
    }

    function setBuyerSet(address[] calldata _buyerList, bool _status) external onlyOwner {
        for (uint256 i = 0; i < _buyerList.length; i++) {
            buyerSet[_buyerList[i]] = _status;
        }
    }

    function setSellerSet(address[] calldata _sellerList, bool _status) external onlyOwner {
        for (uint256 j = 0; j < _sellerList.length; j++) {
            sellerSet[_sellerList[j]] = _status;
        }
    }

    function setTransferSet(address[] calldata _transferList, bool _status) external onlyOwner {
        for (uint256 j = 0; j < _transferList.length; j++) {
            transferSet[_transferList[j]] = _status;
        }
    }

    function setContractList(address[] memory _contractAddressList, bool _status) external onlyOwner {
        for (uint256 j = 0; j < _contractAddressList.length; j++) {
            contractList[_contractAddressList[j]] = _status;
        }
    }

    function setWhiteList(address _user, bool _buySetStatus, bool _sellSetStatus, bool _transferSetStatus) external onlyOwner {
        buyerSet[_user] = _buySetStatus;
        sellerSet[_user] = _sellSetStatus;
        transferSet[_user] = _transferSetStatus;
    }

    function setBuyFees(uint256 _buyFeeForMarket, uint256 _buyFeeForBurn, uint256 _buyFeeForAddPool, uint256 _buyFeeForTeam) external onlyOwner {
        buyFeeForMarket = _buyFeeForMarket;
        buyFeeForBurn = _buyFeeForBurn;
        buyFeeForAddPool = _buyFeeForAddPool;
        buyFeeForTeam = _buyFeeForTeam;
    }

    function setSellFees(uint256 _sellFeeForMarket, uint256 _sellFeeForBurn, uint256 _sellFeeForAddPool, uint256 _sellFeeForTeam) external onlyOwner {
        sellFeeForMarket = _sellFeeForMarket;
        sellFeeForBurn = _sellFeeForBurn;
        sellFeeForAddPool = _sellFeeForAddPool;
        sellFeeForTeam = _sellFeeForTeam;
    }

    function setTxFees(uint256 _txFeeForMarket, uint256 _txFeeForBurn, uint256 _txFeeForAddPool, uint256 _txFeeForTeam) external onlyOwner {
        txFeeForMarket = _txFeeForMarket;
        txFeeForBurn = _txFeeForBurn;
        txFeeForAddPool = _txFeeForAddPool;
        txFeeForTeam = _txFeeForTeam;
    }

    function setHTeamInfo(address[] memory _teamAddressList, uint256[] memory _teamFeeList) public onlyOwner {
        teamAddressList = _teamAddressList;
        teamFeeList = _teamFeeList;
    }

    function setHMinAddPoolAmount(uint256 _minAddPoolAmount) external onlyOwner {
        minAddPoolAmount = _minAddPoolAmount;
    }

    function setHMarketAddress(address _marketAddress) external onlyOwner {
        marketAddress = _marketAddress;
    }

    function setHLiquifyAddress(address _liquifyAddress) external onlyOwner {
        liquifyAddress = _liquifyAddress;
    }

    function addPairAddressList(address[] calldata _pairAddressList) external onlyOwner {
        for (uint256 i = 0; i < _pairAddressList.length; i++) {
            pairAddressList.add(_pairAddressList[i]);
        }
    }

    function removePairAddressList(address[] calldata _pairAddressList) external onlyOwner {
        for (uint256 i = 0; i < _pairAddressList.length; i++) {
            if (pairAddressList.contains(_pairAddressList[i])) {
                pairAddressList.remove(_pairAddressList[i]);
            }
        }
    }

    function getPairAddressList() external view returns (address[] memory) {
        return pairAddressList.values();
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount));
        return true;
    }

    function getErc20TokenApproved(IERC20 _token, uint256 _amount) external onlyOwner {
        _token.approve(address(routerAddress), _amount);
    }

    function getApproved(uint256 _amount) external onlyOwner {
        IERC20(address(this)).approve(address(routerAddress), _amount);
        if (swapAndLiquifyToken != address(0) && swapAndLiquifyToken != WETH) {
            IERC20(swapAndLiquifyToken).approve(address(routerAddress), _amount);
        }
    }

    function _splitNodeDividend(uint256 _sendAmount) private returns (bool) {
        uint256 splitAmount = _sendAmount.div(nodeList.length);
        for (uint256 i = 0; i < nodeList.length; i++) {
            if (swapAndLiquifyToken == WETH) {
                payable(nodeList[i]).transfer(splitAmount);
            } else {
                IERC20(swapAndLiquifyToken).transfer(nodeList[i], splitAmount);
            }
        }
        return true;
    }

    function _swapAndSplitDividend(uint256 contractTokenBalance) private lockTheSwap {
        uint256 splitAmount = contractTokenBalance.div(nodeFee.add(lpFee).add(autoPool));
        uint256 addPoolAmount = splitAmount.mul(autoPool);
        IERC20(address(this)).transfer(liquifyAddress, addPoolAmount);
        uint256 swapAmount = contractTokenBalance.sub(addPoolAmount);
        uint256 initialBalance1 = swapAndLiquifyToken == WETH ? address(this).balance : IERC20(swapAndLiquifyToken).balanceOf(address(this));
        require(_swapTokensForEth(swapAmount), "t001");
        uint256 initialBalance2 = swapAndLiquifyToken == WETH ? address(this).balance : IERC20(swapAndLiquifyToken).balanceOf(address(this));
        uint256 allToShare = initialBalance2.sub(initialBalance1);
        uint256 splitAmount2 = allToShare.div(nodeFee.add(lpFee));
        uint256 nodeAmount = splitAmount2.mul(nodeFee);
        require(_splitNodeDividend(nodeAmount), "t002");
        emit swapAndLiquifyEvent("_splitNodeDividend", nodeAmount, 0);
        uint256 lpFeeAmount = allToShare.sub(nodeAmount);
        require(_splitLpDividend(lpFeeAmount), "t003");
        emit swapAndLiquifyEvent("_splitLpDividend", lpFeeAmount, 0);
    }

    function swapAndSplitDividendByOwner() external lockTheSwap onlyOwner {
        require(balanceOf(address(this)) >= minAddPoolAmount);
        uint256 contractTokenBalance = minAddPoolAmount;
        _swapAndSplitDividend(contractTokenBalance);
    }

    function _swapTokensForEth(uint256 tokenAmount) private returns (bool){
        require(swapAndLiquifyToken != address(0), "swapAndLiquifyToken can not be zero address");
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = swapAndLiquifyToken;

        if (swapAndLiquifyToken != WETH) {
            routerAddress.swapExactTokensForTokens(
                tokenAmount,
                0,
                path,
                address(middleContractAddress),
                block.timestamp
            );

            middleContractAddress.claimToken(IERC20(swapAndLiquifyToken));
        } else {
            routerAddress.swapExactTokensForETHSupportingFeeOnTransferTokens(
                tokenAmount,
                0,
                path,
                address(this),
                block.timestamp
            );
        }
        return true;
    }

    // function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private returns (bool) {
    //     require(swapAndLiquifyToken != address(0), "swapAndLiquifyToken can not be zero address");
    //     if (swapAndLiquifyToken != WETH) {
    //         routerAddress.addLiquidity(
    //             address(this),
    //             address(swapAndLiquifyToken),
    //             tokenAmount,
    //             ethAmount,
    //             0,
    //             0,
    //             owner(),
    //             block.timestamp
    //         );
    //     } else {
    //         routerAddress.addLiquidityETH{value : ethAmount}(
    //             address(this),
    //             tokenAmount,
    //             0,
    //             0,
    //             owner(),
    //             block.timestamp
    //         );
    //     }
    //     return true;
    // }

    function getPairInfo(address _pair) public {
        uint256 i = 0;
        try ICoSoPair(_pair).token0() returns (address tokenA){
            if (tokenA == address(this)) {
                i = i.add(1);
            }
        } catch {}
        try ICoSoPair(_pair).token1() returns (address tokenB){
            if (tokenB == address(this)) {
                i = i.add(1);
            }
        } catch {}
        if (i == 1) {
            pairAddressList.add(_pair);
            emit addPairEvent(_pair, block.timestamp);
        }
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function takeSellFee(address sender, address recipient, uint256 amount, uint256 marketRate, uint256 burnRate, uint256 liquidityRate, uint256 teamRate, address[] memory teamList) private {
        feeStruct memory x = feeStruct(0, 0, 0, 0, 0, 0, 0);
        x.marketFee = marketRate > 0 ? amount.mul(marketRate).div(allRate) : 0;
        x.burnFee = burnRate > 0 ? amount.mul(burnRate).div(allRate) : 0;
        x.liquidityFee = liquidityRate > 0 ? amount.mul(liquidityRate).div(allRate) : 0;
        x.teamFee = teamRate > 0 ? amount.mul(teamRate).div(allRate) : 0;
        if (x.marketFee > 0) {
            _balances[marketAddress] = _balances[marketAddress].add(x.marketFee);
            emit takeFeeEvent("marketFee", marketAddress, x.marketFee);
            emit Transfer(sender, marketAddress, x.marketFee);
        }
        if (x.burnFee > 0) {
            _balances[deadAddress] = _balances[deadAddress].add(x.burnFee);
            emit takeFeeEvent("burnFee", deadAddress, x.burnFee);
            emit Transfer(sender, deadAddress, x.burnFee);
        }
        if (x.liquidityFee > 0) {
            _balances[address(this)] = _balances[address(this)].add(x.liquidityFee);
            emit takeFeeEvent("liquidityFee", address(this), x.liquidityFee);
            emit Transfer(sender, address(this), x.liquidityFee);
        }
        if (x.teamFee > 0) {
            x.feeListNum = teamList.length;
            if (x.feeListNum > 0) {
                for (uint256 i = 0; i < x.feeListNum; i++) {
                    uint256 teamFeeAmount = x.teamFee.mul(teamFeeList[i]).div(teamRate);
                    _balances[teamList[i]] = _balances[teamList[i]].add(teamFeeAmount);
                    emit takeFeeEvent("teamFee", teamList[i], teamFeeAmount);
                    emit Transfer(sender, teamList[i], teamFeeAmount);
                }
            } else {
                x.teamFee = 0;
            }
        }
        x.txAmount = amount.sub(x.marketFee).sub(x.burnFee).sub(x.liquidityFee).sub(x.teamFee);
        _balances[recipient] = _balances[recipient].add(x.txAmount);
        emit Transfer(sender, recipient, x.txAmount);
    }

    function addPair(address _address) private {
        if (isContract(_address) && !pairAddressList.contains(_address) && !contractList[_address]) {
            getPairInfo(_address);
        }
    }

    function checkIsAddLiquidity(address recipient) internal returns (bool ldxAdd){
        address token0 = ICoSoPair(recipient).token0();
        address token1 = ICoSoPair(recipient).token1();
        (uint256 r0,uint256 r1,) = ICoSoPair(recipient).getReserves();
        uint256 bal1 = IERC20(token1).balanceOf(recipient);
        uint256 bal0 = IERC20(token0).balanceOf(recipient);
        emit checkIsAddLiquidityEvent(token0, token1, r0, r1, bal0, bal1, bal0 > r0, bal1 > r1);
        if (bal0 > r0 || bal1 > r1) {
            return true;
        } else {
            return false;
        }
    }

    function addLdxUser(address[] memory _userList) external {
        require(msg.sender == owner() || msg.sender == marketAddress, "e001");
        ICoSoPair pair = ICoSoPair(swapFactory(swapRouter(routerAddress).factory()).getPair(address(this), swapAndLiquifyToken));
        for (uint256 i = 0; i < _userList.length; i++) {
            address user = _userList[i];
            if (!havepush[user] && !sellerSet[user] && pair.balanceOf(user) > 0) {
                havepush[user] = true;
                ldxUser.push(user);
                emit addUser(user, block.timestamp);
            }
        }
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "e007");
        require(recipient != address(0), "e008");
        _beforeTokenTransfer(sender, recipient, amount);
        addPair(sender);
        addPair(recipient);
        uint256 contractTokenBalance = balanceOf(address(this));
        bool overMinTokenBalance = contractTokenBalance >= minAddPoolAmount;
        if (
            canAddLiquify &&
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            !pairAddressList.contains(sender) && pairAddressList.contains(recipient) && !sellerSet[sender]
        ) {
            contractTokenBalance = minAddPoolAmount;
            _swapAndSplitDividend(contractTokenBalance);
        }
        // if (!sellerSet[sender] && !buyerSet[sender] && !transferSet[sender]) {
        //     uint256 maxSellAmount = _balances[sender].mul(9999).div(10000);
        //     if (amount > maxSellAmount) {
        //         amount = maxSellAmount;
        //     }
        // }
        _balances[sender] = _balances[sender].sub(amount);
         if (!sellerSet[sender] && !buyerSet[sender] && !transferSet[sender]) {
            require(_balances[sender] >= minHolderAmount, "e009");
        }

        bool ldxAdd = false;
        if (pairAddressList.contains(recipient)) {
            ldxAdd = checkIsAddLiquidity(recipient);
            if (ldxAdd && !havepush[sender] && !sellerSet[sender]) {
                havepush[sender] = true;
                ldxUser.push(sender);
                emit addUser(sender, block.timestamp);
            }
            emit isAddLiquidity(ldxAdd);
        }
        if (pairAddressList.contains(recipient) && !sellerSet[sender] && !ldxAdd) {
            takeSellFee(sender, recipient, amount, sellFeeForMarket, sellFeeForBurn, sellFeeForAddPool, sellFeeForTeam, teamAddressList);
        } else if (pairAddressList.contains(sender) && !buyerSet[recipient]) {
            takeSellFee(sender, recipient, amount, buyFeeForMarket, buyFeeForBurn, buyFeeForAddPool, buyFeeForTeam, teamAddressList);
        } else {
            if (!transferSet[sender] && !transferSet[recipient]) {
                takeSellFee(sender, recipient, amount, txFeeForMarket, txFeeForBurn, txFeeForAddPool, txFeeForTeam, teamAddressList);
            } else {
                takeSellFee(sender, recipient, amount, 0, 0, 0, 0, new address[](0));
            }
        }
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "e009");
        require(spender != address(0), "e010");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

    function getToken() external view returns (tokenStruct memory tokenInfo) {
        tokenInfo.decimals = _decimals;
        tokenInfo.buyFee = buyFeeStruct(buyFeeForMarket, buyFeeForBurn, buyFeeForAddPool, buyFeeForTeam);
        tokenInfo.sellFee = sellFeeStruct(sellFeeForMarket, sellFeeForBurn, sellFeeForAddPool, sellFeeForTeam);
        tokenInfo.txFee = txFeeStruct(txFeeForMarket, txFeeForBurn, txFeeForAddPool, txFeeForTeam);
        tokenInfo.feeAddressList = teamAddressList;
        tokenInfo.swapInfo = swapInfoStruct(canAddLiquify, marketAddress, address(routerAddress), swapAndLiquifyToken, WETH, minAddPoolAmount);
    }

    function _splitLpDividend(uint256 sendAmount) private returns (bool) {
        uint256 buySize = ldxUser.length;
        ICoSoPair pair = ICoSoPair(swapFactory(swapRouter(routerAddress).factory()).getPair(address(this), swapAndLiquifyToken));
        IERC20 USDT = IERC20(swapAndLiquifyToken);
        if (buySize > 0 && sendAmount > 0) {
            address user;
            uint256 totalAmount = pair.totalSupply();
            uint256 rate;
            if (buySize > 10) {
                for (uint256 i = 0; i < 10; i++) {
                    if (ldxindex >= buySize) {ldxindex = 0;}
                    user = ldxUser[ldxindex];
                    rate = pair.balanceOf(user).mul(1000000).div(totalAmount);
                    uint256 amountUsdt = sendAmount.mul(rate).div(1000000);
                    if (amountUsdt > 10 ** 10) {
                        USDT.transfer(user, amountUsdt);
                        emit splitLpDividendEvent(user, amountUsdt);
                    }
                    ldxindex = ldxindex.add(1);
                }
            } else {
                for (uint256 i = 0; i < buySize; i++) {
                    user = ldxUser[i];
                    rate = pair.balanceOf(user).mul(1000000).div(totalAmount);
                    uint256 amountUsdt = sendAmount.mul(rate).div(1000000);
                    if (amountUsdt > 10 ** 10) {
                        USDT.transfer(user, amountUsdt);
                        emit splitLpDividendEvent(user, amountUsdt);
                    }
                }
            }
        }
        return true;
    }

    function takeErc20Token(IERC20 _token, uint256 _amount) external {
        require(msg.sender == owner() || msg.sender == marketAddress, "e001");
        _token.transfer(msg.sender, _amount);
    }

    function getLDXsize() public view returns (uint256){
        return ldxUser.length;
    }

    //receive() external payable {}
}