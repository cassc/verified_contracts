/**
 *Submitted for verification at Etherscan.io on 2023-06-06
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(
            value
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeERC20: decreased allowance below zero"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

library SafeMath {
    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
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

contract Marketer is Ownable {
    using SafeMath for uint256;
    using Address for address;
    using SafeERC20 for IERC20;

    mapping(address => uint256) public buyerAmount;
    mapping(address => bool) public whiteList;
    mapping(address => uint256) public totalBuyerAmount;

    mapping(uint8 => uint256) private classes;
    uint256 classesCount;
    mapping(uint8 => uint256) private pricing;
    mapping(uint8 => uint256) private pricingU;
    uint256 pricingCount;
    mapping(uint8 => uint256) public totalAmount;
    uint256 totalAmountCount;

    address public _USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public market = 0x0dAC62360961544132a1283205501f3FcDC9817c;

    function buyBot(address recipient, uint8 _id) external payable {
        require(msg.value > 0, "invalid amount");

        if (msg.value == pricing[_id]) {
            buyerAmount[recipient] = buyerAmount[recipient] <= block.timestamp
                ? block.timestamp.add(classes[_id])
                : buyerAmount[recipient].add(classes[_id]);
            totalBuyerAmount[recipient] = totalAmount[_id];
        } else {
            revert("wrong amount");
        }
    }

    function buyBotU(address recipient, uint8 _id) external payable {
        uint256 price = pricingU[_id];
        IERC20 token = IERC20(_USDT);
        if (token.balanceOf(msg.sender) >= price) {
            token.safeTransferFrom(msg.sender, market, price);
            buyerAmount[recipient] = buyerAmount[recipient] <= block.timestamp
                ? block.timestamp.add(classes[_id])
                : buyerAmount[recipient].add(classes[_id]);
            totalBuyerAmount[recipient] = totalAmount[_id];
        } else {
            revert("not enough balance");
        }
    }

    function checkUsefull(
        address recipient
    ) public view returns (bool success, uint256 time, uint256 amount) {
        time = buyerAmount[recipient];
        amount = totalBuyerAmount[recipient];
        if (block.timestamp <= buyerAmount[recipient]) {
            success = true;
            return (success, time, amount);
        } else {
            success = false;
            return (success, time, amount);
        }
    }

    function getClasses() public view returns (uint256[] memory classArray) {
        classArray = new uint256[](classesCount);
        for (uint8 i = 0; i < classesCount; i++) {
            classArray[i] = classes[i];
        }

        return classArray;
    }

    function getPricing(
        bool u
    ) public view returns (uint256[] memory pricingArray) {
        pricingArray = new uint256[](pricingCount);
        if (u) {
            for (uint8 i = 0; i < pricingCount; i++) {
                pricingArray[i] = pricingU[i];
            }
        } else {
            for (uint8 i = 0; i < pricingCount; i++) {
                pricingArray[i] = pricing[i];
            }
        }

        return pricingArray;
    }

    function getTotalAmount()
        public
        view
        returns (uint256[] memory totalAmountArray)
    {
        totalAmountArray = new uint256[](totalAmountCount);
        for (uint8 i = 0; i < totalAmountCount; i++) {
            totalAmountArray[i] = totalAmount[i];
        }
        return totalAmountArray;
    }

    function setClassess(
        uint8[] calldata _id,
        uint256[] calldata _seconds
    ) public onlyOwner {
        require(
            _id.length == _seconds.length,
            "_id's length is not _seconds's length"
        );
        classesCount = 0;
        for (uint8 i = 0; i < _id.length; i++) {
            classes[i] = _seconds[i];
            classesCount++;
        }
    }

    function setPricings(
        uint8[] calldata _id,
        uint256[] calldata _price,
        bool u
    ) public onlyOwner {
        require(
            _id.length == _price.length,
            "_id's length is not _price's length"
        );
        pricingCount = 0;
        for (uint8 i = 0; i < _id.length; i++) {
            if (u) {
                pricingU[i] = _price[i];
            } else {
                pricing[i] = _price[i];
            }
            pricingCount++;
        }
    }

    function setTotalAmounts(
        uint8[] calldata _id,
        uint256[] calldata _amount
    ) public onlyOwner {
        require(
            _id.length == _amount.length,
            "_id's length is not _amount's length"
        );
        totalAmountCount = 0;
        for (uint8 i = 0; i < _id.length; i++) {
            totalAmount[i] = _amount[i];
            totalAmountCount++;
        }
    }

    function setClasses(uint8 _id, uint256 _second) public onlyOwner {
        require(classes[_id] != _second, "_id's value is _second");
        if (classes[_id] == 0) classesCount++;
        classes[_id] = _second;
    }

    function setPricing(uint8 _id, uint256 _price, bool u) public onlyOwner {
        if (u) {
            require(pricingU[_id] != _price, "_id's value is _price");
            if (pricing[_id] == 0 && pricingU[_id] == 0) pricingCount++;
            pricingU[_id] = _price;
        } else {
            require(pricing[_id] != _price, "_id's value is _price");
            if (pricing[_id] == 0 && pricingU[_id] == 0) pricingCount++;
            pricing[_id] = _price;
        }
    }

    function setTotalAmount(uint8 _id, uint256 _amount) public onlyOwner {
        require(totalAmount[_id] != _amount, "_id's value is _amount");
        if (totalAmount[_id] == 0) totalAmountCount++;
        totalAmount[_id] = _amount;
    }

    function setWhiteList(address token, bool value) public onlyOwner {
        require(whiteList[token] != value, "token is this value");
        if (whiteList[token]) {
            buyerAmount[token] = 0;
        } else {
            buyerAmount[token] = 32503651199;
        }
        whiteList[token] = value;
    }

    function setBuyerList(address token, uint256 t) public onlyOwner {
        require(t != 0, "t must > 0");
        buyerAmount[token] = block.timestamp.add(t);
    }

    function setAddress(address _usdt, address _market) public onlyOwner {
        _USDT = _usdt;
        market = _market;
    }

    function withdrawToken(address recipient, address token) public onlyOwner {
        IERC20(token).transfer(
            recipient,
            IERC20(token).balanceOf(address(this))
        );
    }

    function withdrawETH(address recipient) public onlyOwner {
        payable(recipient).transfer(address(this).balance);
    }

    receive() external payable {}

    fallback() external payable {
        require(msg.data.length == 0);
    }
}