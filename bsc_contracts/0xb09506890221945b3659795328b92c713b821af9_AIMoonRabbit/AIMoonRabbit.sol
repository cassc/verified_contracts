/**
 *Submitted for verification at BscScan.com on 2023-02-05
*/

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
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
    event Approval(address indexed owner, address indexed spender, uint256 value);

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
    function allowance(address owner, address spender) external view returns (uint256);

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

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

  
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

  
   
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

  
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

 
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

  
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

 
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

  
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

  
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

  
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

   
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

   
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;



abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;





interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function factory() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

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


contract AIMoonRabbit is IERC20Metadata, Ownable {
    using SafeMath for uint256;

    
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    
    string constant _name = "AI Moon Rabbit";
    string constant _symbol = "AIMR";
    uint8 constant _decimals = 18;

    uint256 _totalSupply =  10000000000000 * (10 ** 18);

    uint256 public maxTx = _totalSupply.div(50);
    uint256 public maxWallet = _totalSupply.div(50);

    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;

    mapping (address => bool) isFeeExempt;
    mapping (address => bool) isFreezeExempt;
    mapping (address => bool) isTxLimitExempt;
    mapping (address => bool) isMaxWalletExempt;

    uint256 public teamFee = 200;
    uint256 public marketingFee = 200;
    uint256 public liquidityFee = 100;
    uint256 public totalFee = 500;
    uint256 public feeDenominator = 10000;

    address public teamRcvr;
    address public marketingRcvr;
    address public liquidityRcvr;

    IDEXRouter public pcsRouter;
    address bnbPair;

    uint256 public launchedAt;

    bool public liquifyEnabled = false;
    bool public freeze_contract = true;
    bool public swapEnabled = false;

    uint256 public swapThreshold = _totalSupply.div(200);
    bool public inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }
    
    event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
    event Launched(uint256 blockNumber, uint256 timestamp);
    event SwapBackSuccess(uint256 amount);
    event SwapBackFailed(string message);

    constructor () Ownable() {
        
        pcsRouter = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        
        bnbPair = IDEXFactory(pcsRouter.factory()).createPair(WBNB, address(this));
        _allowances[address(this)][address(pcsRouter)] = ~uint256(0);

        address owner_ = msg.sender;

        teamRcvr = owner_;
        marketingRcvr = owner_;
        liquidityRcvr = owner_;

        isFreezeExempt[owner_] = true;

        isMaxWalletExempt[owner_] = true;
        isMaxWalletExempt[address(bnbPair)] = true;
        isMaxWalletExempt[address(this)] = true;

        isFeeExempt[owner_] = true;
        isFeeExempt[address(this)] = true;

        isTxLimitExempt[owner_] = true;
        isTxLimitExempt[address(this)] = true;

        approve(address(pcsRouter), _totalSupply);
        _balances[owner_] = _totalSupply;
        emit Transfer(address(0), owner_, _totalSupply);
    }

    receive() external payable { }

    /*
     * Basic Contract Functions
     */
    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender_, uint256 amount_) public override returns (bool) {
        _allowances[msg.sender][spender_] = amount_;
        emit Approval(msg.sender, spender_, amount_);
        return true;
    }

    function approveMax(address spender_) external returns (bool) {
        return approve(spender_, ~uint256(0));
    }

    function clearStuckBNB(address wallet_) external onlyOwner {
        payable(wallet_).transfer(address(this).balance);
    }

    /*
     * Token Transfer Functions
     */
    function transfer(address recipient_, uint256 amount_) external override returns (bool) {
        return _transferFrom(msg.sender, recipient_, amount_);
    }

    function transferFrom(address sender_, address recipient_, uint256 amount_) external override returns (bool) {
        if(_allowances[sender_][msg.sender] != ~uint256(0)){
            _allowances[sender_][msg.sender] = _allowances[sender_][msg.sender].sub(amount_, "Insufficient Allowance");
        }

        return _transferFrom(sender_, recipient_, amount_);
    }

    function _transferFrom(address sender_, address recipient_, uint256 amount_) internal returns (bool) {
        require(sender_ != address(0) && recipient_ != address(0), "Zero Address Transfer");
        require(!freeze_contract || isFreezeExempt[sender_], "Contract Frozen");
        require(passLimitChecks(sender_, recipient_, amount_), "Over TX or Wallet Limit");

        if(inSwap){ return _basicTransfer(sender_, recipient_, amount_); }
        
        if(shouldSwapBack()){ swapBack(); }

        if(!launched() && recipient_ == bnbPair) { require(_balances[sender_] > 0); launch(); }

        _balances[sender_] = _balances[sender_].sub(amount_, "Insufficient Balance");

        uint256 amountReceived = shouldTakeFee(sender_, recipient_) ? takeFee(sender_, amount_) : amount_;
        _balances[recipient_] = _balances[recipient_].add(amountReceived);
        
        emit Transfer(sender_, recipient_, amountReceived);
        return true;
    }
    
    function _basicTransfer(address sender_, address recipient_, uint256 amount_) internal returns (bool) {
        _balances[sender_] = _balances[sender_].sub(amount_, "Insufficient Balance");
        _balances[recipient_] = _balances[recipient_].add(amount_);
        emit Transfer(sender_, recipient_, amount_);
        return true;
    }

    /*
     * Transfer Support Functions
     */
    function passLimitChecks(address sender_, address recipient_, uint256 amount_) internal view returns (bool) {
        if(amount_ > maxTx && !isTxLimitExempt[sender_]) { return false; }
        if(sender_ == bnbPair && _balances[recipient_].add(amount_) > maxWallet) { return false; }
        return true;
    }

    function shouldTakeFee(address sender_, address recipient_) internal view returns (bool) {
        if (isFeeExempt[sender_] || isFeeExempt[recipient_] || !launched()) return false;
        if (sender_ == bnbPair || recipient_ == bnbPair) return true;
        return false;
    }

    function takeFee(address sender_, uint256 amount_) internal returns (uint256) {
        uint256 feeAmount = amount_.mul(totalFee).div(feeDenominator);
        
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender_, address(this), feeAmount);

        return amount_.sub(feeAmount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != bnbPair
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function swapBack() internal swapping {
        uint256 swapLiquidityFee = liquifyEnabled ? liquidityFee : 0;
        uint256 amountToLiquify = swapThreshold.mul(swapLiquidityFee).div(totalFee).div(2);

        uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
        
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;

        uint256 balanceBefore = address(this).balance;

        try pcsRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        ) {

            uint256 amountBNB = address(this).balance.sub(balanceBefore);

            uint256 totalBNBFee = totalFee.sub(swapLiquidityFee.div(2));

            uint256 amountBNBLiquidity = amountBNB.mul(swapLiquidityFee).div(totalBNBFee).div(2);
            uint256 amountBNBTeam = amountBNB.mul(teamFee).div(totalBNBFee);
            uint256 amountBNBMarketing = amountBNB.mul(marketingFee).div(totalBNBFee);
        

            payable(address(teamRcvr)).transfer(amountBNBTeam);
            payable(address(marketingRcvr)).transfer(amountBNBMarketing);
        
        
            if(amountToLiquify > 0){
                try pcsRouter.addLiquidityETH{ value: amountBNBLiquidity }(
                    address(this),
                    amountToLiquify,
                    0,
                    0,
                    liquidityRcvr,
                    block.timestamp
                ) {
                    emit AutoLiquify(amountToLiquify, amountBNBLiquidity);
                } catch {
                    emit AutoLiquify(0, 0);
                }
            }

            emit SwapBackSuccess(amountToSwap);
        } catch Error(string memory e) {
            emit SwapBackFailed(string(abi.encodePacked("SwapBack failed with error ", e)));
        } catch {
            emit SwapBackFailed("SwapBack failed without an error message from pancakeSwap");
        }
    }


    /*
     * Set Contract Settings
     */
    function launch() internal {
        launchedAt = block.number;
        emit Launched(block.number, block.timestamp);
    }
    
    function freeze(bool freeze_) external onlyOwner {
        freeze_contract = freeze_;
    }
 function setFees(uint256 _liquidityFee, uint256 _teamFee,  uint256 _feeDenominator) external onlyOwner {
        liquidityFee = _liquidityFee;
        teamFee = _teamFee;
        marketingFee =  marketingFee;
         totalFee = _liquidityFee.add(_teamFee);
        feeDenominator = _feeDenominator;
    }
    // Exemptions
    function setIsFeeExempt(address holder_, bool exempt_) external onlyOwner {
        isFeeExempt[holder_] = exempt_;
    }

    function setIsTxLimitExempt(address holder_, bool exempt_) external onlyOwner {
        isTxLimitExempt[holder_] = exempt_;
    }

    function setIsFreezeExempt(address holder_, bool exempt_) external onlyOwner {
        isFreezeExempt[holder_] = exempt_;
    }

    function setIsMaxWalletExempt(address holder_, bool exempt_) external onlyOwner {
        isMaxWalletExempt[holder_] = exempt_;
    }

    // Receivers
    function setTeamReceiver(address teamRcvr_) external onlyOwner {
        teamRcvr = teamRcvr_;
    }

    function setMarketingReceiver(address marketingRcvr_) external onlyOwner {
        marketingRcvr = marketingRcvr_;
    }



    // Swap and Auto-LP
    function setSwapBackSettings(bool enabled_, uint256 amount_) external onlyOwner {
        swapEnabled = enabled_;
        swapThreshold = amount_;
    }
    
    function setLiquifyEnabled(bool enabled_) external onlyOwner {
        liquifyEnabled = enabled_;
    }

    /*
     * Read Contract Settings
     */
    function launched() internal view returns (bool) {
        return launchedAt != 0;
    }
    
    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }

}