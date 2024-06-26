// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./Owned.sol";
import "./ERC20.sol";

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract GarfieldZelenskyyYodaBot420Inu is ERC20, Owned {
    address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    mapping (address => bool) isFeeExempt;

    uint256 public totalFee = 42;
    uint256 constant feeDenominator = 1000;
    uint256 public whaleDenominator = 100;

    address internal team;

    IDEXRouter public router;
    address public pair;

    uint256 public swapThreshold;
    bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }

    constructor (address _team) Owned(msg.sender) ERC20("GarfieldZelenskyyYodaBot420Inu", "BOT", 18) {
        team = _team;
        router = IDEXRouter(routerAdress);
        pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
        allowance[address(this)][address(router)] = type(uint256).max;

        isFeeExempt[_team] = true;

        uint supply = 42069000000000 * (10**decimals);

        _mint(owner, supply);

        swapThreshold = totalSupply / 1000 * 4; // 0.125%
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 allowed = allowance[sender][msg.sender];

        if (allowed != type(uint256).max) allowance[sender][msg.sender] = allowed - amount;

        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if (amount > totalSupply / whaleDenominator) { revert("Transfer amount exceeds the whale amount"); }
        if(inSwap){ return super.transferFrom(sender, recipient, amount); }

        if(shouldSwapBack()){ swapBack(); } 

        balanceOf[sender] -= amount;

        uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
        balanceOf[recipient] += amountReceived;

        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    function shouldTakeFee(address sender) internal view returns (bool) {
        return !isFeeExempt[sender];
    }

    function takeFee(address sender, uint256 amount) internal returns (uint256) {
        uint256 feeAmount = (amount * totalFee) / feeDenominator;
        balanceOf[address(this)] = balanceOf[address(this)] + feeAmount;
        emit Transfer(sender, address(this), feeAmount);
        return amount - feeAmount;
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !inSwap
        && balanceOf[address(this)] >= swapThreshold;
    }

    function swapBack() internal swapping {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        uint256 balanceBefore = address(this).balance;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            swapThreshold,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 amountETH = address(this).balance - balanceBefore;

        (bool TeamSuccess,) = payable(team).call{value: amountETH, gas: 30000}("");
        require(TeamSuccess, "receiver rejected ETH transfer");
    }

    function clearStuckBalance() external {
        payable(team).transfer(address(this).balance);
    }

    function setWhaleDenominator(uint256 _whaleDenominator) external onlyOwner {
        whaleDenominator = _whaleDenominator;
    }

    receive() external payable {}
}