/**
 *Submitted for verification at BscScan.com on 2022-12-12
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

address constant USDT = 0x55d398326f99059fF775485246999027B3197955;
address constant ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

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

abstract contract ERC20 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /*//////////////////////////////////////////////////////////////
                            METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    string public name;

    string public symbol;

    uint8 public immutable decimals;

    /*//////////////////////////////////////////////////////////////
                              ERC20 STORAGE
    //////////////////////////////////////////////////////////////*/

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

    /*//////////////////////////////////////////////////////////////
                               ERC20 LOGIC
    //////////////////////////////////////////////////////////////*/

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

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

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

contract Distributor is Owned {
    function transferUSDT(address to, uint256 amount) external onlyOwner {
        IERC20(USDT).transfer(to, amount);
    }
}

abstract contract DexBaseUSDT {
    bool public inSwapAndLiquify;
    IUniswapV2Router constant uniswapV2Router = IUniswapV2Router(ROUTER);
    address public immutable uniswapV2Pair;
    Distributor public distributor;
    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() {
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
                address(this),
                USDT
            );
        distributor = new Distributor();
    }
}

abstract contract LiquidityFeeUSDT is Owned, DexBaseUSDT, ERC20 {
    bool public swapAndLiquifyEnabled = true;
    uint256 public numTokensSellToAddToLiquidity = 1e18;

    address public donateAddr = 0xE739df4D8560Cbe1915E4e2635A11E71a5e35F0a;
    address constant buyMarketAddr904 =
        0x51B5EB30E9edF8c93d61c84661a8eD386376F904;
    address constant buyMarketAddr354 =
        0x04392412bB876352EA9E417caA1Ea04D9AAA5354;
    address constant sellMarketAddr5aF =
        0xe67AF8aa47faFd5644a11c4212DD6575761865aF;

    uint256 constant liquidityFee = 2;
    uint256 constant burnFee = 2;
    uint256 constant donateFee = 2;
    uint256 constant m1Fee = 1;
    uint256 constant m2Fee = 1;
    uint256 constant sellMarketFee = 2;

    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    constructor(
        uint256 _numTokensSellToAddToLiquidity,
        bool _swapAndLiquifyEnabled
    ) {
        numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity;
        swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
        allowance[address(this)][address(uniswapV2Router)] = type(uint256).max;
    }

    function _takeMarketing(
        address sender,
        uint256 amount,
        address uniswapV2Pair
    ) internal returns (uint256) {
        //buy
        if (sender == uniswapV2Pair) {
            uint256 burnAmount = (amount * burnFee) / 100;
            super._transfer(sender, address(0xdead), burnAmount);

            uint256 liquidityAmount = (amount *
                (liquidityFee + donateFee + m1Fee + m2Fee)) / 100;
            super._transfer(sender, address(this), liquidityAmount);

            return burnAmount + liquidityAmount;
        } else {
            uint256 burnAmount = (amount * burnFee) / 100;
            super._transfer(sender, address(0xdead), burnAmount);

            uint256 liquidityAmount = (amount *
                (liquidityFee + donateFee + sellMarketFee)) / 100;
            super._transfer(sender, address(this), liquidityAmount);

            return burnAmount + liquidityAmount;
        }
    }

    function setNumTokensSellToAddToLiquidity(uint256 _num) external onlyOwner {
        numTokensSellToAddToLiquidity = _num;
    }

    function setDonateAddr(address _donateAddr) external onlyOwner {
        donateAddr = _donateAddr;
    }

    function shouldSwapAndLiquify(address sender) internal view returns (bool) {
        uint256 contractTokenBalance = balanceOf[address(this)];
        bool overMinTokenBalance = contractTokenBalance >=
            numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            sender != uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            return true;
        } else {
            return false;
        }
    }

    function swapAndLiquify(uint256 _tokenBalance) internal lockTheSwap {
        uint256 totalFee = (liquidityFee +
            liquidityFee +
            donateFee +
            donateFee +
            m1Fee +
            m2Fee +
            sellMarketFee);

        uint256 toMarket = (_tokenBalance *
            (totalFee - liquidityFee - liquidityFee)) / totalFee;
        uint256 contractTokenBalance = _tokenBalance - toMarket;
        // split the contract balance into halves
        uint256 half = contractTokenBalance / 2;
        uint256 otherHalf = contractTokenBalance - half;

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = IERC20(USDT).balanceOf(address(this));

        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = address(USDT);
        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            half + toMarket,
            0, // accept any amount of ETH
            path,
            address(distributor),
            block.timestamp
        );
        uint256 amount = IERC20(USDT).balanceOf(address(distributor));
        uint256 toLiqUsdt = (amount * half) / (half + toMarket);
        uint256 tomarket = amount - toLiqUsdt;

        distributor.transferUSDT(address(this), toLiqUsdt);

        uint256 totalMfee = totalFee - liquidityFee - liquidityFee;

        uint256 toDonate = (tomarket * (donateFee + donateFee)) / totalMfee;
        uint256 toM1 = (tomarket * m1Fee) / totalMfee;
        uint256 toM2 = (tomarket * m2Fee) / totalMfee;
        uint256 toMsell = (tomarket * sellMarketFee) / totalMfee;

        distributor.transferUSDT(donateAddr, toDonate);
        distributor.transferUSDT(buyMarketAddr904, toM1);
        distributor.transferUSDT(buyMarketAddr354, toM2);
        distributor.transferUSDT(sellMarketAddr5aF, toMsell);

        // how much ETH did we just swap into?
        uint256 newBalance = IERC20(USDT).balanceOf(address(this)) -
            initialBalance;

        // add liquidity to uniswap
        addLiquidity(otherHalf, newBalance);
    }

    function addLiquidity(uint256 tokenAmount, uint256 usdtAmount) public {
        // add the liquidity
        IERC20(USDT).approve(address(uniswapV2Router), usdtAmount);
        uniswapV2Router.addLiquidity(
            address(this),
            address(USDT),
            tokenAmount,
            usdtAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner,
            block.timestamp
        );
    }
}

contract DDDSToken is ExcludedFromFeeList, LiquidityFeeUSDT {
    uint256 private constant _totalSupply = 10_0000_0000 * 1e18;
    uint256 public launchedAt;
    uint256 public launchedAtTimestamp;
    mapping(address => bool) public onceBuy;

    constructor()
        ERC20("Da Da deep state", "DDDS", 18)
        LiquidityFeeUSDT(_totalSupply / 100_0000, true)
    {
        _mint(msg.sender, _totalSupply);
        excludeFromFee(msg.sender);
        excludeFromFee(address(this));
    }

    function launch() internal {
        require(launchedAt == 0, "Already launched");
        launchedAt = block.number;
        launchedAtTimestamp = block.timestamp;
    }

    function launched() internal view returns (bool) {
        return launchedAt != 0;
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

    function takeFee(address sender, uint256 amount)
        internal
        returns (uint256)
    {
        uint256 marketAmount = _takeMarketing(sender, amount, uniswapV2Pair);
        return amount - marketAmount;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        if (inSwapAndLiquify) {
            super._transfer(sender, recipient, amount);
            return;
        }

        if (shouldSwapAndLiquify(sender)) {
            swapAndLiquify(numTokensSellToAddToLiquidity);
        }
        if (!launched() && recipient == uniswapV2Pair) {
            require(balanceOf[sender] > 0);
            launch();
        }
        if (shouldTakeFee(sender, recipient)) {
            if (launchedAtTimestamp + 24 hours > block.timestamp) {
                if (sender == uniswapV2Pair) {
                    require(onceBuy[recipient] == false);
                    require(amount == 1000 ether);
                    onceBuy[recipient] = true;
                }
            }

            uint256 transferAmount = takeFee(sender, amount);
            super._transfer(sender, recipient, transferAmount);
        } else {
            super._transfer(sender, recipient, amount);
        }
    }
}