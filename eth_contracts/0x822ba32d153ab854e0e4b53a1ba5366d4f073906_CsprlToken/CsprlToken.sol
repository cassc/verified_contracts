/**
 *Submitted for verification at Etherscan.io on 2023-08-23
*/

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/utils/introspection/ERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File: @openzeppelin/contracts/utils/math/SignedMath.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard signed math utilities missing in the Solidity language.
 */
library SignedMath {
    /**
     * @dev Returns the largest of two signed numbers.
     */
    function max(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two signed numbers.
     */
    function min(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two signed numbers without overflow.
     * The result is rounded towards zero.
     */
    function average(int256 a, int256 b) internal pure returns (int256) {
        // Formula from the book "Hacker's Delight"
        int256 x = (a & b) + ((a ^ b) >> 1);
        return x + (int256(uint256(x) >> 255) & (a ^ b));
    }

    /**
     * @dev Returns the absolute unsigned value of a signed value.
     */
    function abs(int256 n) internal pure returns (uint256) {
        unchecked {
            // must be unchecked in order to support `n = type(int256).min`
            return uint256(n >= 0 ? n : -n);
        }
    }
}

// File: @openzeppelin/contracts/utils/math/Math.sol


// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1, "Math: mulDiv overflow");

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
        }
    }
}

// File: @openzeppelin/contracts/utils/Strings.sol


// OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)

pragma solidity ^0.8.0;



/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `int256` to its ASCII `string` decimal representation.
     */
    function toString(int256 value) internal pure returns (string memory) {
        return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }

    /**
     * @dev Returns true if the two strings are equal.
     */
    function equal(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

// File: @openzeppelin/contracts/access/IAccessControl.sol


// OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)

pragma solidity ^0.8.0;

/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControl {
    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) external;
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/security/Pausable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: @openzeppelin/contracts/access/AccessControl.sol


// OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)

pragma solidity ^0.8.0;





/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```solidity
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```solidity
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
 * to enforce additional security measures for this role.
 */
abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
    }

    mapping(bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
        return _roles[role].members[account];
    }

    /**
     * @dev Revert with a standard message if `_msgSender()` is missing `role`.
     * Overriding this function changes the behavior of the {onlyRole} modifier.
     *
     * Format of the revert message is described in {_checkRole}.
     *
     * _Available since v4.6._
     */
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }

    /**
     * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        Strings.toHexString(account),
                        " is missing role ",
                        Strings.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleGranted} event.
     */
    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleRevoked} event.
     */
    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     *
     * May emit a {RoleRevoked} event.
     */
    function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * May emit a {RoleGranted} event.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     *
     * NOTE: This function is deprecated in favor of {_grantRole}.
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleGranted} event.
     */
    function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleRevoked} event.
     */
    function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

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
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

// File: contracts/ERC1404/IERC1404Validators.sol



pragma solidity 0.8.20;

/**
 * @title IERC1404Validators
 * @dev Interfaces implemented by the token contract to be called by the TransferRestrictions contract
 */
interface IERC1404Validators {

    /// @notice Returns a boolean indicating the paused state of the contract
    /// @return true if contract is paused, false if unpaused
    function paused() external view returns (bool);

    /// @notice Determine if sender and receiver are whitelisted, return true if both accounts are whitelisted
    /// @param from The address sending tokens
    /// @param to The address receiving tokens
    /// @return true if both accounts are whitelisted, false if not
    function checkWhitelists(address from, address to) external view returns (bool);

    /// @notice Determine if spender, sender and receiver are whitelisted, return true if all accounts are whitelisted
    /// @param spender The address performing the transfer
    /// @param from The address sending tokens
    /// @param to The address receiving tokens
    /// @return true if both accounts are whitelisted, false if not
    function checkWhitelists(address spender, address from, address to) external view returns (bool);

    /// @notice Determine if a users tokens are locked preventing a transfer
    /// @param _address the address to retrieve the data from
    /// @param amount the amount to send
    /// @return true if user has sufficient unlocked token to transfer the requested amount, false if not
    function checkTimelock(address _address, uint256 amount) external view returns (bool);
}


// File: contracts/ERC1404/IERC1404.sol



pragma solidity 0.8.20;

interface IERC1404 {
    /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    /// @dev Overwrite with your custom transfer restriction logic
    function detectTransferRestriction (address from, address to, uint256 value) external view returns (uint8);

    /// @notice Detects if a transferFrom will be reverted and if so returns an appropriate reference code
    /// @param spender Transaction sending address
    /// @param from Source of funds address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    /// @dev Overwrite with your custom transfer restriction logic
    function detectTransferFromRestriction (address spender, address from, address to, uint256 value) external view returns (uint8);

    /// @notice Returns a human-readable message for a given restriction code
    /// @param restrictionCode Identifier for looking up a message
    /// @return Text showing the restriction's reasoning
    /// @dev Overwrite with your custom message and restrictionCode handling
    function messageForTransferRestriction (uint8 restrictionCode) external view returns (string memory);
}


interface IERC1404getSuccessCode {
    /// @notice Return the uint256 that represents the SUCCESS_CODE
    /// @return uint8 SUCCESS_CODE
    function getSuccessCode () external view returns (uint8);
}


/**
 * @title IERC1404Success
 * @dev Combines IERC1404 and IERC1404getSuccessCode interfaces, to be implemented by the TransferRestrictions contract
 */
interface IERC1404Success is IERC1404getSuccessCode, IERC1404 {
}
// File: contracts/CsprlToken.sol



pragma solidity 0.8.20;






/**
 * @title CsprlToken
 * @notice Extended ERC20 contract with additional functionality:
 * 1. Access Control
 * 2. Contract pausability
 * 3. Whitelisting
 * 4. Token timelocking
 * 5. Token minting
 * 6. Token burning
 * 7. Token revoking
 * 8. Transfer restrictions
 * @dev Inherits from OpenZeppelin contracts: ERC20, AccessControl, Pausable.
 * @dev Implements ERC1404 for transfer restrictions
 */
contract CsprlToken is ERC20, AccessControl, Pausable, IERC1404, IERC1404Validators {
    
    // Tracks whether an address is whitelisted
    // data field can track any external field (like a hash of personal details)
    struct WhiteListItem {
        bool status;
        string data;
    }
    
    // Tracks the amount and release time of locked tokens for an address
    struct LockupItem {
        uint256 amount;
        uint256 releaseTime;
    }

    // Token Details
    string constant TOKEN_NAME = "Casper Labs";
    string constant TOKEN_SYMBOL = "CSPRL";

   
    /// @dev Determines whether minting was allowed at construction
    bool public immutable MINT_ALLOWED;

     /// @dev Determines whether burning was allowed at construction
    bool public immutable BURN_ALLOWED;

    /// @dev The only address where tokens can be burned from
    address public burnAddress;

    // Role identifiers for AccessControl
    // bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00; // inherited from AccessControl
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant REVOKER_ROLE = keccak256("REVOKER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant WHITELISTER_ROLE = keccak256("WHITELISTER_ROLE");
    bytes32 public constant TIMELOCKER_ROLE = keccak256("TIMELOCKER_ROLE");

    /// @dev Whitelisting info per address
    mapping (address => WhiteListItem) public whitelists;

    /// @dev Timelocking info per address
    mapping (address => LockupItem) public lockups;

    // tracks the external contract where restriction logic is defined
    IERC1404Success private _transferRestrictions;

    /// Minting was not allowed at construction
    error MintingNotAllowed();
    /// Burning was not allowed at construction
    error BurningNotAllowed();
    /// Burn address is not set
    error BurnAddressNotSet();
    /// Address zero is not allowed for this operation
    error AddressZeroNotAllowed();
    /// Release time must be in the future
    error ReleaseTimeMustBeInFuture();
    /// Amount must be greater than zero
    error AmountMustBeGreaterThanZero();
    /// Transfer restrictions contract must be set
    error TransferRestrictionsContractMustBeSet();
    /// Not enough unlocked tokens to revoke
    error InsufficientUnlockedBalance();

    /// @dev Modifier to make a function callable only when a transfer is not restricted
    modifier notRestricted(address from, address to, uint256 value) {
        IERC1404Success _transferRestrictions_ = _transferRestrictions;
        if (address(_transferRestrictions_) == address(0)) revert TransferRestrictionsContractMustBeSet();
        uint8 restrictionCode = _transferRestrictions_.detectTransferRestriction(from, to, value);
        require(restrictionCode == _transferRestrictions_.getSuccessCode(),
            _transferRestrictions_.messageForTransferRestriction(restrictionCode));
        _;
    }

    /// @dev Modifier to make a function callable only when a transferFrom is not restricted
    modifier notRestrictedTransferFrom(address spender, address from, address to, uint256 value) {
        IERC1404Success _transferRestrictions_ = _transferRestrictions;
        if (address(_transferRestrictions_) == address(0)) revert TransferRestrictionsContractMustBeSet();
        uint8 restrictionCode = _transferRestrictions_.detectTransferFromRestriction(spender, from, to, value);
        require(restrictionCode == _transferRestrictions_.getSuccessCode(),
            _transferRestrictions_.messageForTransferRestriction(restrictionCode));
        _;
    }

    /// @dev Event for logging timelocking of tokens for an address
    event AccountLock(address address_, uint256 amount, uint256 releaseTime);

    /// @dev Event for logging the release of locked tokens for an address
    event AccountRelease(address address_, uint256 amountReleased);

    /// @dev Event for logging the updating of the transfer restrictions contract
    event RestrictionsUpdated(address newRestrictionsAddress, address updatedBy);

    /// @dev Event for logging the revoking of tokens from an address
    event Revoke(address indexed revoker, address indexed from, uint256 amount);

    /// @dev Event for logging the updating of a whitelist entry
    event WhitelistUpdate(address address_, bool status, string data);

    /// @dev Event for logging the updating of the burn address
    event burnAddressUpdated(address newBurnAddress, address updatedBy);

    /**
     * @dev The constructor sets up the basic properties of the token such as its name and symbol. It also assigns the
     * entire initial supply to the owner specified in the parameters. The owner is also set as the administrator with
     * all roles. The mint and burn allowance are set as per the parameters.
     * @param owner The address that will receive the initial supply of tokens, and be granted the default admin role
     * @param isMintAllowed Permission flag for token minting
     * @param isBurnAllowed Permission flag for token burning
     * @param initialSupply The amount of tokens to mint
     */
    constructor(address owner, bool isMintAllowed, bool isBurnAllowed, uint256 initialSupply)
        ERC20(TOKEN_NAME, TOKEN_SYMBOL)
    {
        MINT_ALLOWED = isMintAllowed;
        BURN_ALLOWED = isBurnAllowed;
        _grantRole(DEFAULT_ADMIN_ROLE, owner); // set up the owner as the default admin of all roles
        grantRole(DEFAULT_ADMIN_ROLE, owner); // grant the owner all roles
        _mint(owner, initialSupply);
    }

    /**
     * @dev Overrides the default AccessControl implementation to add whitelisting and granting of all roles to owners
     * of DEFAULT_ADMIN_ROLE
     */
    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        if (role == DEFAULT_ADMIN_ROLE) {
            _grantRole(MINTER_ROLE, account);
            _grantRole(BURNER_ROLE, account);
            _grantRole(REVOKER_ROLE, account);
            _grantRole(PAUSER_ROLE, account);
            _grantRole(WHITELISTER_ROLE, account);
            _grantRole(TIMELOCKER_ROLE, account);
            setWhitelist(account, true, "default admin");
        }
            _grantRole(role, account);
    }

    /**
     * @dev Overrides the default AccessControl implementation to add unwhitelisting and revoking of all roles to
     * owners of DEFAULT_ADMIN_ROLE
     */
    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        if (role == DEFAULT_ADMIN_ROLE) {
            _revokeRole(MINTER_ROLE, account);
            _revokeRole(BURNER_ROLE, account);
            _revokeRole(REVOKER_ROLE, account);
            _revokeRole(PAUSER_ROLE, account);
            _revokeRole(WHITELISTER_ROLE, account);
            _revokeRole(TIMELOCKER_ROLE, account);
            setWhitelist(account, false, "default admin revoked");
        }
            _revokeRole(role, account);
    }

    /**
     * @notice Mints tokens to a specified address, only callable by a minter
     * @param to The address to mint tokens to
     * @param amount The amount of tokens to mint
     */
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        if(!MINT_ALLOWED) revert MintingNotAllowed();
        _mint(to, amount);
    }

    /**
     * @notice Sets the burn address, which is the only address that tokens can be burnt from. Only callable by an admin
     * @param newBurnAddress The new burn address
     */
    function setBurnAddress(address newBurnAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
        burnAddress = newBurnAddress;
        emit burnAddressUpdated(newBurnAddress, msg.sender);
    }

    /**
     * @notice Burns tokens from the burn address. Only callable by a burner
     * @param amount The amount of tokens to burn
     */
    function burn(uint256 amount) external onlyRole(BURNER_ROLE) {
        if (!BURN_ALLOWED) revert BurningNotAllowed();
        _burn(burnAddress, amount);
    }

    /**
     * @notice Revokes tokens from an address and transfers them to the burn address. Only callable by a revoker
     * @param from The address to revoke tokens from
     * @param amount The amount of tokens to revoke
     */
    function revoke(address from, uint256 amount) external onlyRole(REVOKER_ROLE) {
        if (!checkTimelock(from, amount)) revert InsufficientUnlockedBalance();
        ERC20._transfer(from, burnAddress, amount);
        emit Revoke(msg.sender, from, amount);
    }
    
    /**
     * @notice Pauses all token transfers. Only callable by a pauser
     */
    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
     * @notice Unpauses all token transfers. Only callable by a pauser
     */
    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * @notice Set the whitelist status of an address. Only callable by a whitelister
     * @param address_ The address to set the whitelist status for
     * @param status The status to set the whitelist to
     * @param data A string with data about the whitelisted address
     */
    function setWhitelist(address address_, bool status, string memory data) public onlyRole(WHITELISTER_ROLE) {
        if (address_ == address(0)) revert AddressZeroNotAllowed();
        whitelists[address_] = WhiteListItem(status, data);
        emit WhitelistUpdate(address_, status, data);
    }

    /**
     * @notice Get the whitelist status of an address
     * @param address_ The address to check the whitelist status for
     * @return True if the address is whitelisted, false if not
     */
    function getWhitelistStatus(address address_) external view returns(bool){
        return whitelists[address_].status;
    }

    /**
     * @notice Get the whitelist data of an address
     * @param address_ The address to check the whitelist data for
     * @return The whitelist data string for the address
     */
    function getWhitelistData(address address_) external view returns(string memory){
        return whitelists[address_].data;
    }

    /**
     * @notice Determine if sender and receiver are both whitelisted
     * @param from The address sending tokens
     * @param to The address receiving tokens
     * @return True if both addresses are whitelisted, false if not
     */
    function checkWhitelists(address from, address to) external view returns (bool) {
        return whitelists[from].status && whitelists[to].status;
    }

    /**
     * @notice Determine if spender, sender and receiver are all whitelisted
     * @param spender The address performing the transfer
     * @param from The address sending tokens
     * @param to The address receiving tokens
     * @return True if all addresses are whitelisted, false if not
     */
    function checkWhitelists(address spender, address from, address to) external view returns (bool) {
        return whitelists[from].status && whitelists[to].status && whitelists[spender].status;
    }

    /**
     * @notice Lock tokens for a given address until a given time in the future. Only callable by a timelocker
     * @param address_ The address to lock tokens for
     * @param amount The amount of tokens to lock. If this is greater than the balance, the entire balance will be
     * locked
     * @param releaseTime The time in the future when the tokens will be released, in seconds since the epoch
     */
    function lock(address address_, uint256 amount, uint256 releaseTime) public onlyRole(TIMELOCKER_ROLE) {
        if (releaseTime <= block.timestamp) revert ReleaseTimeMustBeInFuture();
        if (address_ == address(0)) revert AddressZeroNotAllowed();
        if (amount == 0) revert AmountMustBeGreaterThanZero();

        // if the amount is greater than the balance, lock the entire balance
        uint256 balance = ERC20.balanceOf(address_);
        amount = amount <=  balance ? amount : balance;
        
        lockups[address_] = LockupItem(amount, releaseTime);
        emit AccountLock(address_, amount, releaseTime);
    }

    /**
     * @notice Release tokens for a given address. Only callable by a timelocker
     * @param address_ The address to release tokens for
     * @param amountToRelease The amount of tokens to release. If this is greater than the locked amount, the entire
     * locked amount will be released
     */
    function release(address address_, uint256 amountToRelease) external onlyRole(TIMELOCKER_ROLE) {
        if (address_ == address(0)) revert AddressZeroNotAllowed();

        uint256 lockedAmount = lockups[address_].amount;

        // nothing to release
        if(lockedAmount == 0 || amountToRelease == 0) {
            emit AccountRelease(address_, 0);
            return;
        }
        
        uint256 newLockedAmount;
        // if the amount to release is greater than the locked amount, release the entire locked amount
        unchecked { // lockedAmount - amountToRelease only in case lockedAmount > amountToRelease
            newLockedAmount = lockedAmount <= amountToRelease ? 0 : lockedAmount - amountToRelease;
        }

        // Update the lockup details (in case all was released, amount will be 0 and hence no lockup)
        lockups[address_].amount = newLockedAmount;

        unchecked { // newLockedAmount is either 0 or less than lockedAmount
          emit AccountRelease(address_, lockedAmount - newLockedAmount);   
        }
    }

    /**
     * @notice Determine if a user has sufficient unlocked tokens to transfer the requested amount
     * @dev This function is used by the transfer and transferFrom functions to determine if the transfer should be
     * allowed. It does not check if the user has sufficient tokens to transfer, only if they have sufficient unlocked
     * tokens. If the user does not have sufficient unlocked tokens, this function will return true but the transfer
     * will fail due to low balance.
     * @param address_ The address to check the timelock for
     * @param amount The amount to check if can be transferred
     * @return True if the user has sufficient unlocked tokens to transfer the requested amount, false if not
     */
    function checkTimelock(address address_, uint256 amount) public view returns (bool) {
        // get the address' token balance
        uint256 balance = balanceOf(address_);

        // if the user does not have enough tokens to send regardless of lock return true here
        // the failure will still fail but this should make it explicit that the transfer failure is not
        // due to locked tokens but because of too low token balance
        if (balance < amount) return true;

        // copy lockup data into memory
        LockupItem memory lockupItem = lockups[address_];

        // return true if the lock is expired
        if (block.timestamp > lockupItem.releaseTime) return true;

        // get the user's token balance that is not locked
        uint256 nonLockedAmount = balance - lockupItem.amount;

        // return true if the user has enough unlocked tokens to send the requested amount, false if not
        return amount <= nonLockedAmount;
    }
    
    /**
     * @notice Retrieve the timelock info for a given address
     * @param address_ The address to retrieve the lockup info for
     * @return The release time and amount of tokens locked
     */
    function getLockUpInfo(address address_) external view returns(uint256, uint256) {
        // copy lockup data into memory
        LockupItem memory lockupItem = lockups[address_];

        return (lockupItem.releaseTime, lockupItem.amount);
    }

    /**
     * @notice Update the transfer restriction contract. Only callable by an admin
     * @param newRestrictionsAddress The new transfer restriction contract address
     */
    function updateTransferRestrictions(address newRestrictionsAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _transferRestrictions = IERC1404Success(newRestrictionsAddress);
        emit RestrictionsUpdated(newRestrictionsAddress, msg.sender);
    }

    /**
     * @notice Return the address of the transfer restrictions contract
     * @return The address of the transfer restrictions contract
     */
    function getRestrictionsAddress() external view returns (address) {
        return address(_transferRestrictions);
    }

    /**
     * @notice Returns the transfer restriction code for a transfer with the given parameters.
     * If the function returns SUCCESS_CODE (0) then it should be allowed, otherwise it should be blocked.
     * @param from The address sending tokens
     * @param to The address receiving tokens
     * @param amount The amount of tokens to transfer
     * @return The restriction code, where 0 means success
     */
    function detectTransferRestriction(address from, address to, uint256 amount) external view returns (uint8) {
        // call detectTransferRestriction on the current transferRestrictions contract
        return _transferRestrictions.detectTransferRestriction(from, to, amount);
    }

    /**
     * @notice Returns the transfer restriction code for a transferFrom with the given parameters.
     * If the function returns SUCCESS_CODE (0) then it should be allowed.
     * @param spender The address initiating the transfer
     * @param from The address sending tokens
     * @param to The address receiving tokens
     * @param amount The amount of tokens to transfer
     * @return The restriction code, where 0 means success
     */
    function detectTransferFromRestriction(address spender, address from, address to, uint256 amount)
        external
        view
        returns (uint8)
    {
        // call detectTransferFromRestriction on the current transferRestrictions contract
        return _transferRestrictions.detectTransferFromRestriction(spender, from, to, amount);
    }

    /**
     * @notice Provides a human readable string for a transfer restriction code
     * @param restrictionCode The restriction code
     * @return The corresponding human readable string
     */
    function messageForTransferRestriction(uint8 restrictionCode) external view returns (string memory) {
        // call messageForTransferRestriction on the current transferRestrictions contract
        return _transferRestrictions.messageForTransferRestriction(restrictionCode);
    }

    /**
     * @notice Overrides the parent class token transfer function to enforce transfer restrictions. See {ERC20-transfer}
     * @param to The address to transfer tokens to
     * @param value The amount of tokens to transfer
     * @return success A boolean indicating whether the operation was successful
     */
    function transfer(address to, uint256 value)
        override public
        notRestricted(msg.sender, to, value)
        returns (bool success)
    {
        success = ERC20.transfer(to, value);
    }

    /**
     * @notice Overrides the parent class token transferFrom function to enforce transfer restrictions.
     * See {ERC20-transferFrom}
     * @param from The address to transfer tokens from
     * @param to The address to transfer tokens to
     * @param value The amount of tokens to transfer
     * @return success A boolean indicating whether the operation was successful
     */
    function transferFrom(address from, address to, uint256 value)
        override public
        notRestrictedTransferFrom(msg.sender, from, to, value)
        returns (bool success)
    {
        success = ERC20.transferFrom(from, to, value);
    }

    /**
     * @notice Indicates whether all transfers are paused. See {Pausable-paused}
     * @return True if transfers are paused, false otherwise
     */
    function paused() public view override(Pausable, IERC1404Validators) returns (bool) {
        return Pausable.paused();
    }

    /**
     * @notice Returns the number of decimals used for the token. See {ERC20-decimals}
     * @return The number of decimals used for the token
     */
    function decimals() public pure override(ERC20) returns (uint8) {
        return 0;
    }
}