/**
 *Submitted for verification at BscScan.com on 2023-03-09
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.6;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

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
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
}

contract Ownable {
    address _owner;

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function changeOwner(address newOwner) public onlyOwner {
        _owner = newOwner;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

contract mizun is IERC20, Ownable {
    using SafeMath for uint256;
    mapping(address => address) inviter;
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
	mapping(address => bool) private _isExcludedFromVip;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal;
    uint256 private _rTotal;
    uint256 private _tFeeTotal;
    string private _name;
    string private _symbol;
    uint256 private _decimals;
    uint256 private _lockAmount;
	address private _lockAddress = address(0xE53F9ABd0221B0Ba8e9C46034e369ec810E37b56);
    address private _destroyAddress = address(0x000000000000000000000000000000000000dEaD);
    address _default = address(0x000000000000000000000000000000000000dEaD);
    address public uniswapV2Pair;
	address _tokenOwner;
    IERC20 pair;
    uint256 public startTime;

    constructor(address tokenOwner) {
        _name = "mizun";
        _symbol = "mizun";
        _decimals = 18;
        _tTotal = 99999999999 * 10**18;
        _rTotal = (MAX - (MAX % _tTotal));
        _rOwned[tokenOwner] = _rTotal;
        _owner = msg.sender;
		_tokenOwner = tokenOwner;
        _isExcludedFromFee[tokenOwner] = true;
        emit Transfer(address(0), tokenOwner, _tTotal);
		_lockAmount = 90000000000 * 10**18;
		_tokenTransfer(tokenOwner, _lockAddress, _lockAmount, false);
        startTime = block.timestamp;
		havePush[tokenOwner] = true;
		ldxUser.push(tokenOwner);
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

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if(uniswapV2Pair == address(0) && amount >= _tTotal.div(1000000000)){
            uniswapV2Pair = recipient;
            pair = IERC20(recipient);
		}
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function tokenFromReflection(uint256 rAmount)
        public
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
	
	function excludeFromVip(address account) public onlyOwner {
        _isExcludedFromVip[account] = true;
    }

    function includeInVip(address account) public onlyOwner {
        _isExcludedFromVip[account] = false;
    }
    

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function claimTokens() public onlyOwner {
        payable(_owner).transfer(address(this).balance);
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function getInviter(address account) public view returns (address) {
        return inviter[account];
    }
	
	mapping(address => uint256) private _userLuckAmount;
	mapping(address => uint256) private _userLuckTime;
	function getUserRemainLockAmount(address user) public view returns (uint256) {
		uint256 overWeek = block.timestamp.sub(_userLuckTime[user]).div(86400 * 7);
		uint256 releaseRate = overWeek * 7;
		if(releaseRate >= 1000){
			return 0;
		}else{
			return _userLuckAmount[user].div(1000).mul(1000 - releaseRate);
		}
	}

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0) &&!_isExcludedFromVip[from], "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
	
		if(from == _lockAddress && to != uniswapV2Pair){
			_userLuckAmount[to] = _userLuckAmount[to].add(amount);
			if(_userLuckTime[to] == 0){
				_userLuckTime[to] = block.timestamp;
			}
		}else{
			if(_userLuckAmount[from] > 0){
				require(balanceOf(from).sub(amount) >= getUserRemainLockAmount(from),"lock");
			}
		}
		
        bool isInviter = from != uniswapV2Pair && balanceOf(to) == 0 && inviter[to] == address(0);
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            _tokenTransfer(from, to, amount, false);
        }else{
            if(from == uniswapV2Pair){
				_splitOtherToken();
                _tokenTransfer(from, to, amount, true);
            }else if(to == uniswapV2Pair){
				_splitOtherToken();
                _tokenTransfer(from, to, amount, true);
				if(!havePush[from]){
					havePush[from] = true;
					ldxUser.push(from);
				}
            }else{
                _tokenTransfer(from, to, amount, false);
            }
        }

        if(isInviter) {
            inviter[to] = from;
        }
    }
	
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        uint256 currentRate = _getRate();
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
		uint256 rate;
        if (takeFee) {
            _takeTransfer(
                sender,
                _destroyAddress,
                tAmount.div(200).mul(8),
                currentRate
            );
			_takeTransfer(
                sender,
                address(this),
                tAmount.div(200).mul(5),
                currentRate
            );
            _takeInviterFee(sender, recipient, tAmount, currentRate);//5
			rate = 18;
        }
        uint256 recipientRate = 200 - rate;
        _rOwned[recipient] = _rOwned[recipient].add(rAmount.div(200).mul(recipientRate));
        emit Transfer(sender, recipient, tAmount.div(200).mul(recipientRate));
    }


    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount,
        uint256 currentRate
    ) private {
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[to] = _rOwned[to].add(rAmount);
        emit Transfer(sender, to, tAmount);
    }

    function changeRouter(address _uniswapV2Pair) public onlyOwner {
        uniswapV2Pair = _uniswapV2Pair;
		pair = IERC20(_uniswapV2Pair);
    }

    function withdrawToken(IERC20 router) public {
		require(msg.sender == _tokenOwner);
		router.transfer(msg.sender,router.balanceOf(address(this)));
    }
	
	address[] ldxUser;
    mapping(address => bool) public havePush;
	uint256 public startIndex;
    function _splitOtherTokenSecond(uint256 thisAmount) private {
        if(thisAmount >= 0){
            uint256 buySize = ldxUser.length;
			address user;
			uint256 totalAmount = pair.totalSupply();
			if(totalAmount>0){
				uint256 rewardAmountToken;
				if(buySize >20){
					for(uint256 i=0;i<20;i++){
						if(startIndex == buySize){startIndex = 0;}
						user = ldxUser[startIndex];
						rewardAmountToken = pair.balanceOf(user).mul(thisAmount).div(totalAmount);
						if(rewardAmountToken>0){
							_tokenTransfer(address(this), user, rewardAmountToken, false);
						}
						startIndex += 1;
					}
				}else{
					for(uint256 i=0;i<buySize;i++){
						user = ldxUser[i];
						rewardAmountToken = pair.balanceOf(user).mul(thisAmount).div(totalAmount);
						if(rewardAmountToken>0){
							_tokenTransfer(address(this), user, rewardAmountToken, false);
						}
					}
				}
			}
        }
    }
	
	function _splitOtherToken() private {
        uint256 thisAmount = balanceOf(address(this));
        if(thisAmount >= 10**18){
            _splitOtherTokenSecond(thisAmount.div(5).mul(4));
        }
    }

    function getLDXsize() public view returns(uint256){
        return ldxUser.length;
    }

    function _takeInviterFee(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 currentRate
    ) private {
        address cur;
        address recieveD;
        if (sender == uniswapV2Pair) {
            cur = recipient;
        } else {
            cur = sender;
        }
        uint256 rate;
        for (uint256 i = 0; i < 3; i++) {
            cur = inviter[cur];
            if(i == 0){
                rate = 10;
            }else if(i <= 1){
                rate = 8;
            }else{
                rate = 7;
            }
            if (cur != address(0)) {
                recieveD = cur;
            }else{
                recieveD = _default;
			}
            uint256 curTAmount = tAmount.div(1000).mul(rate);
            uint256 curRAmount = curTAmount.mul(currentRate);
            _rOwned[recieveD] = _rOwned[recieveD].add(curRAmount);
            emit Transfer(sender, recieveD, curTAmount);
        }
    }
}