// SPDX-License-Identifier: MIT

/*
If your here for pee jokes, urine luck

https://t.me/PepePadETH

http://www.pepepisspad.com/

@PepePissPad

*/

pragma solidity =0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PepePad is ERC20, Ownable {

    address public devWallet;
    uint256 public swapTokensAtAmount;
    uint256 public maxBuyAmount;
    uint256 public maxSellAmount;
    uint256 public maxWallet;
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) private _isExcludedFromMaxWallet;
    mapping(address => bool) public automatedMarketMakerPairs;
    bool private swapping;
    bool public swapEnabled = true;
    bool public tradingEnabled;
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    IRouter public router;
    address public pair;

    struct Taxes {
        uint256 burn;
        uint256 dev;
    }

    Taxes public buyTaxes = Taxes(2, 2);
    Taxes public sellTaxes = Taxes(2, 2);
    uint256 public totalBuyTax = 4;
    uint256 public totalSellTax = 4;

    constructor(address _dev) ERC20("Pepe Pad", "PP") {
        setSwapTokensAtAmount(200000);
        updateMaxWalletAmount(2000000);
        setDevWallet(_dev);
        setMaxBuyAndSell(2000000, 2000000);
        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        address _pair = IFactory(_router.factory()).createPair(
            address(this),
            _router.WETH()
        );

        router = _router;
        pair = _pair;

        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromMaxWallet(_pair, true);
        excludeFromMaxWallet(address(this), true);
        excludeFromMaxWallet(address(_router), true);
        _setAutomatedMarketMakerPair(_pair, true);

        _mint(owner(), 100000000 * (10**18));
    }

    receive() external payable {}

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        require(
            _isExcludedFromFees[account] != excluded,
            " Account is already'excluded'"
        );
        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);
    }

    function excludeFromMaxWallet(address account, bool excluded)
        public
        onlyOwner
    {
        _isExcludedFromMaxWallet[account] = excluded;
    }

    function excludeMultipleAccountsFromFees(
        address[] calldata accounts,
        bool excluded
    ) public onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            _isExcludedFromFees[accounts[i]] = excluded;
        }
        emit ExcludeMultipleAccountsFromFees(accounts, excluded);
    }

    function setDevWallet(address wallet) public onlyOwner {
        devWallet = wallet;
    }

    function updateMaxWalletAmount(uint256 newNum) public onlyOwner {
        require(newNum > (1000000 * 1), "Cannot set maxWallet lower than 1%");
        maxWallet = newNum * (10**18);
    }

    function setMaxBuyAndSell(uint256 maxbuy, uint256 maxsell)
        public
        onlyOwner
    {
        require(maxbuy >= 1000000, "Cannot set maxbuy lower than 1% ");
        require(maxsell >= 500000, "Cannot set maxsell lower than 0.5% ");
        maxBuyAmount = maxbuy * 10**18;
        maxSellAmount = maxsell * 10**18;
    }


    /// @notice Update the threshold to swap tokens for liquidity,
    ///   treasury and dividends.
    function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
        require(
            amount < 1000000,
            "Cannot set higher then than 10% "
        );
        swapTokensAtAmount = amount * 10**18;
    }

    /// @notice Enable or disable internal swaps
    /// @dev Set "true" to enable internal swaps for liquidity, treasury and dividends
    function setSwapEnabled(bool _enabled) external onlyOwner {
        swapEnabled = _enabled;
    }

    /// @notice Withdraw tokens sent by mistake.
    /// @param tokenAddress The address of the token to withdraw
    function rescueETH20Tokens(address tokenAddress) external onlyOwner {
        IERC20(tokenAddress).transfer(
            owner(),
            IERC20(tokenAddress).balanceOf(address(this))
        );
    }

    /// @notice Send remaining ETH to treasuryWallet
    /// @dev It will send all ETH to treasuryWallet
    function forceSend() external onlyOwner {
        (bool success, ) = payable(devWallet).call{
            value: address(this).balance
        }("");
        require(success);
    }

    function setBuyTaxes(uint256 _burn, uint256 _dev) external onlyOwner {
        require(_burn + _dev <= 20, "Fee must be <= 20%");
        buyTaxes = Taxes(_burn, _dev);
        totalBuyTax = _burn + _dev;
    }

    function setSellTaxes(uint256 _burn, uint256 _dev) external onlyOwner {
        require(_burn + _dev <= 20, "Fee must be <= 20%");
        sellTaxes = Taxes(_burn, _dev);
        totalSellTax = _burn + _dev;
    }

    function updateRouter(address newRouter) external onlyOwner {
        router = IRouter(newRouter);
    }

    function activateTrading() external onlyOwner {
        require(!tradingEnabled, "Trading enabled");
        tradingEnabled = true;
    }

    /// @dev Set new pairs created due to listing in new DEX
    function setAutomatedMarketMakerPair(address newPair, bool value)
        external
        onlyOwner
    {
        _setAutomatedMarketMakerPair(newPair, value);
    }

    function _setAutomatedMarketMakerPair(address newPair, bool value) private {
        require(
            automatedMarketMakerPairs[newPair] != value
        );
        automatedMarketMakerPairs[newPair] = value;

        emit SetAutomatedMarketMakerPair(newPair, value);
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if (
            !_isExcludedFromFees[from] && !_isExcludedFromFees[to] && !swapping
        ) {
            require(tradingEnabled, "Trading not active");
            if (automatedMarketMakerPairs[to]) {
                require(
                    amount <= maxSellAmount,
                    "You are exceeding maxSellAmount"
                );
            } else if (automatedMarketMakerPairs[from])
                require(
                    amount <= maxBuyAmount,
                    "You are exceeding maxBuyAmount"
                );
            if (!_isExcludedFromMaxWallet[to]) {
                require(
                    amount + balanceOf(to) <= maxWallet,
                    "Unable to exceed Max Wallet"
                );
            }
        }

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            canSwap &&
            !swapping &&
            swapEnabled &&
            automatedMarketMakerPairs[to] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            swapping = true;

            if (totalSellTax > 0) {
                swapAndLiquify(swapTokensAtAmount);
            }

            swapping = false;
        }

        bool takeFee = !swapping;

        // if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        if (!automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from])
            takeFee = false;

        if (takeFee) {
            uint256 feeAmt;
            if (automatedMarketMakerPairs[to])
                feeAmt = (amount * totalSellTax) / 100;
            else if (automatedMarketMakerPairs[from])
                feeAmt = (amount * totalBuyTax) / 100;

            amount = amount - feeAmt;
            super._transfer(from, address(this), feeAmt);
        }
        super._transfer(from, to, amount);
    }

    function swapAndLiquify(uint256 tokens) private {
        uint256 toSwap = tokens; 

        uint256 totalTax = (totalSellTax);

        uint256 burnamnt = (toSwap * sellTaxes.burn) / totalTax;
        if (burnamnt > 0) {
            burn(burnamnt);
        }

        toSwap -= burnamnt;

        swapTokensForETH(toSwap);

        uint256 contractrewardbalance = address(this).balance;

        uint256 devAmt = (contractrewardbalance * sellTaxes.dev) / totalTax;
        if (devAmt > 0) {
            (bool success, ) = payable(devWallet).call{value: devAmt}("");
            require(success, "Failed to send Ether to dev wallet");
        }
    }

    function burn(uint256 burnAmount) private {
        _burn(address(this), burnAmount);
    }

    function PublicBurn(uint256 amount) public {
        address sender = msg.sender;
        require(
            balanceOf(sender) >= amount,
            "ERC20: Burn Amount exceeds account balance"
        );
        require(sender != address(0), "ERC20: Invalid sender address");
        require(amount > 0, "ERC20: Enter some amount to burn");
        _burn(sender, amount);
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        _approve(address(this), address(router), tokenAmount);
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, 
            path,
            address(this),
            block.timestamp
        );
    }
}

interface IPair {
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function token0() external view returns (address);
}

interface IFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

interface IRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

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

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}