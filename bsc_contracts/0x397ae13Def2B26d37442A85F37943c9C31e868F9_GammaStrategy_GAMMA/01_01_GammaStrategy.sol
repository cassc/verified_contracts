pragma solidity 0.8.15;

// SPDX-License-Identifier: MIT


abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
}

interface IERC20 {
   
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

}

library Address {
   
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + (value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    // not been called from anywhere
    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance =
            token.allowance(address(this), spender) - (value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ReentrancyGuard {
   
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
        _;
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

interface IWBNB is IERC20 {
    function deposit() external payable;

    function withdraw(uint256 wad) external;
}

interface IToken {
    function totalSupply() external view returns(uint);
}

interface GammaTroller {
    function claimGamma(address[] memory holders,address[] memory gTokens,bool borrowers,bool suppliers) external ;
}

interface Gtoken {
    function mint(uint mintAmount) external returns (uint);
    function redeem(uint redeemTokens) external returns (uint); 
}

abstract contract StratX2 is Ownable, ReentrancyGuard {

    using SafeERC20 for IERC20;

    address public wantAddress;
    address public rewardsAddress;
    address public feeRewardsUpdater;

    address public wbnbAddress;
    address public gammaFarmAddress;
    address public GAMMAAddress;
    address public iGammaAddress;
    address public gammaTrollerAddress;

    uint256 public feeRewardsAccruedPerWeek;
    uint256 public feeRewardsAccrued;
    
    uint256 public wantLockedTotal;
    uint256 public constant initialExchangeRate = 1e8;
   
    uint256 public entranceFeeFactor; 
    uint256 public constant entranceFeeFactorMax = 50; // 0.5% is the max entrance fee settable. LL = lowerlimit

    uint256 public withdrawFeeFactor = 100;
    uint256 public constant withdrawFeeFactorMax = 200; // 2% is the max entrance fee settable. LL = lowerlimit

    uint256 public performanceFee = 1000; //10%
    uint256 public constant performanceFeeMax = 2500; //25%

    uint256 public instantWithdrawFeeFactor = 500; // 5%;
    uint256 public constant instantWithdrawFeeFactorMax = 1000; //10%

    event SetSettings(
        uint256 _entranceFeeFactor, 
        uint256 _withdrawFeeFactor,
        uint256 _instantWithdrawFeeFactor,
        uint256 _performanceFee
    );

    event SetRewardsAddress(address _rewardsAddress);
    error Unauthorized(address caller);

    function checkForFarmAddressCall() private view  {
        if(msg.sender != gammaFarmAddress) 
        {
            revert Unauthorized(msg.sender);
        }
    }

    /**
    * @notice Calculates the exchange rate from the gToken to the iToken
    * @return (calculated exchange rate scaled by 1e18)
    */
    function iTokenExchangeRate() public view returns (uint) {
        uint256 _totalSupply = IToken(iGammaAddress).totalSupply();
        if (_totalSupply == 0) {
           /**
            * If there are no iTokens minted:
            *  exchangeRate = initialExchangeRate
            */
            return (initialExchangeRate); //1e8
        } else { 
            return ((wantLockedTotal * 1e18) / _totalSupply);
        }
    }

    function getUserGtokenBal(address _user) external view returns (uint256 gGAMMABalance){
        gGAMMABalance = (IERC20(iGammaAddress).balanceOf(_user) * iTokenExchangeRate())/1e18;
    }

    // Executes deposit based on whether or not to charge fee
    function deposit(uint256 _wantAmt, bool _chargeFee) external virtual nonReentrant returns (uint256) {
        checkForFarmAddressCall();
        uint256 balBefore = IERC20(wantAddress).balanceOf(address(this));
        IERC20(GAMMAAddress).safeIncreaseAllowance(wantAddress, _wantAmt);
        Gtoken(wantAddress).mint(_wantAmt);
        uint256 depositAmount = IERC20(wantAddress).balanceOf(address(this)) - balBefore;

        uint256 depositFee;
        if(_chargeFee) {
            depositFee = (depositAmount* entranceFeeFactor)/ 10000;
        }
        
        if(depositFee != 0){
            depositAmount = depositAmount - depositFee;
            IERC20(wantAddress).safeTransfer(rewardsAddress, depositFee);
        }

        uint256 current_exchange_rate = iTokenExchangeRate();
        uint256 mintAmount = (depositAmount * 1e18) / current_exchange_rate;

        wantLockedTotal = wantLockedTotal + depositAmount;
        
        return (mintAmount);
    }

    function unstake(uint256 _wantAmt, bool instantly) public virtual nonReentrant returns (uint256, uint256) {
        checkForFarmAddressCall();

        if (wantLockedTotal < _wantAmt) {
            _wantAmt = wantLockedTotal;
        }

        uint256 balanceOfStrat = IERC20(wantAddress).balanceOf(address(this));
        if (_wantAmt > balanceOfStrat) {
            _wantAmt = balanceOfStrat;
        }
        
        uint256 stratWantTokensRemoved = _wantAmt;
        uint256 withdrawFee;
        uint256 withdrawAmount;
        uint256 feeFactor = withdrawFeeFactor;

        if(instantly) {
            feeFactor = instantWithdrawFeeFactor;
        }
        
        if (_wantAmt != 0) {
            withdrawFee = (_wantAmt * feeFactor)/10000;
            _wantAmt = _wantAmt - withdrawFee;
            withdrawFee = withdrawFee/2;
            wantLockedTotal = wantLockedTotal - _wantAmt - withdrawFee;
            IERC20(wantAddress).safeTransfer(rewardsAddress, withdrawFee);

            feeRewardsAccrued += withdrawFee;

            uint256 balBefore = IERC20(GAMMAAddress).balanceOf(address(this));
            Gtoken(wantAddress).redeem(_wantAmt);
            withdrawAmount = IERC20(GAMMAAddress).balanceOf(address(this)) - balBefore;
            
            IERC20(GAMMAAddress).safeTransfer(gammaFarmAddress, withdrawAmount);
        }
        return (withdrawAmount, stratWantTokensRemoved);
    }

    function getShares() external virtual view returns (uint256, uint256) {
        return (wantLockedTotal, IToken(iGammaAddress).totalSupply());
    }

     function sharesTotal() external virtual view returns (uint256) {
        return IToken(iGammaAddress).totalSupply();
    }

    function setSettings(
        uint256 _entranceFeeFactor, 
        uint256 _withdrawFeeFactor,
        uint256 _instantWithdrawFeeFactor,
        uint256 _performanceFee
    ) external virtual onlyOwner {
    
        require(_entranceFeeFactor <= entranceFeeFactorMax, "_entranceFeeFactor too high");
        entranceFeeFactor = _entranceFeeFactor;

        require(_withdrawFeeFactor <= withdrawFeeFactorMax, "_withdrawFeeFactor too high");
        withdrawFeeFactor = _withdrawFeeFactor;

        require(_instantWithdrawFeeFactor <= instantWithdrawFeeFactorMax, "_instantWithdrawFeeFactor too high");
        instantWithdrawFeeFactor = _instantWithdrawFeeFactor;

        require(_performanceFee <= performanceFeeMax, "_performanceFee too high");
        performanceFee = _performanceFee;

        emit SetSettings(_entranceFeeFactor, _withdrawFeeFactor,_instantWithdrawFeeFactor, _performanceFee);
    }

    function setRewardsAddress(address _rewardsAddress) external virtual onlyOwner {
        rewardsAddress = _rewardsAddress;
        emit SetRewardsAddress(_rewardsAddress);
    }

    /**
    * @notice this will change fee rewards updater address
    *         in the contract it is called by owner address only
    */
    function changeFeeRewardsUpdater(address _newFeeRewardsUpdater) external onlyOwner {
        feeRewardsUpdater = _newFeeRewardsUpdater;
    }

    /**
    * @notice this will update feeRewardsAccruedPerWeek value
    *         in the contract it is called by feeRewardsUpdater address only
    */

    function updateFeeRewards() external {
        require(_msgSender()  == feeRewardsUpdater,"Caller is not fee rewards updater");
        if(feeRewardsAccrued > 0){
            feeRewardsAccruedPerWeek = feeRewardsAccrued;
            feeRewardsAccrued = 0;
        }
    }

    function inCaseTokensGetStuck(address _token) external onlyOwner {
        require(_token != address(wantAddress), "Token cannot be same as deposit token");
        require(_token != GAMMAAddress, "Token cannot be same as gamma token");
        uint256 amount = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(_msgSender(), amount);
    }

    function _wrapBNB() internal virtual {
        // BNB -> WBNB
        uint256 bnbBal = address(this).balance;
        if (bnbBal != 0) {
            IWBNB(wbnbAddress).deposit{value: bnbBal}(); // BNB -> WBNB
        }
    }

    function wrapBNB() external virtual onlyOwner {
        _wrapBNB();
    }

    function claimPendingGamma() internal {
        
        address[] memory holders = new address[](1);
        holders[0] = address(this);

        address[] memory gTokens = new address[](1);
        gTokens[0] = address(wantAddress);

        GammaTroller(gammaTrollerAddress).claimGamma(holders,gTokens, false, true);        

    }

    function earnGammaProfits() external returns (uint256){
        checkForFarmAddressCall();
        claimPendingGamma();
        //invest GAMMA into gTOKEN
        IERC20 gToken = IERC20(wantAddress);
        uint256 bal = IERC20(GAMMAAddress).balanceOf(address(this));
        if (bal != 0) {
            uint256 gTokenBalBefore = gToken.balanceOf(address(this));
            IERC20(GAMMAAddress).safeIncreaseAllowance(wantAddress, bal);
            Gtoken(wantAddress).mint(bal);
            uint256 gTokenBal = gToken.balanceOf(address(this)) - gTokenBalBefore;
            uint256 fee = (gTokenBal * performanceFee) / 10000;
            gTokenBal = gTokenBal - fee;
            gToken.safeTransfer(rewardsAddress,fee);
            wantLockedTotal = wantLockedTotal + gTokenBal;
        }
	return bal;
    }
}

contract GammaStrategy_GAMMA is StratX2 {
    
    constructor(
        address[] memory _addresses,
        uint256 _entranceFeeFactor,
        uint256 _withdrawFeeFactor,
        uint256 _instantWithdrawFeeFactor

    ) {
        wbnbAddress = _addresses[0];
        gammaFarmAddress = _addresses[1];
        GAMMAAddress = _addresses[2];
        wantAddress = _addresses[3];
        iGammaAddress = _addresses[4];
        gammaTrollerAddress = _addresses[5];
        rewardsAddress = _addresses[6];
	feeRewardsUpdater = _addresses[7];

        entranceFeeFactor = _entranceFeeFactor;
        withdrawFeeFactor = _withdrawFeeFactor;
        instantWithdrawFeeFactor =_instantWithdrawFeeFactor;
        //transferOwnership(gammaFarmAddress);
    }

    function changeGammaTrollerAddress(address _gammatrollerAddress) public onlyOwner {
        gammaTrollerAddress = _gammatrollerAddress;
    }
}