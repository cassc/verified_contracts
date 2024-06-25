// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.6;

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
}

pragma solidity >=0.5.0;

interface IBEP20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

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

interface IPancakePair {
    event Transfer(address indexed from, address indexed to, uint256 value);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;
}

library PancakeLibrary {
    using SafeMath for uint256;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB)
        internal
        pure
        returns (address token0, address token1)
    {
        require(tokenA != tokenB, "Library Sort: IDENTICAL_ADDRESSES");
        (token0, token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0), "Library Sort: ZERO_ADDRESS");
    }

    // fetches and sorts the reserves for a pair
    function getReserves(
        address pairAddress,
        address tokenA,
        address tokenB
    ) internal view returns (uint256 reserveA, uint256 reserveB) {
        (address token0, ) = sortTokens(tokenA, tokenB);
        (uint256 reserve0, uint256 reserve1, ) = IPancakePair(pairAddress)
            .getReserves();
        (reserveA, reserveB) = tokenA == token0
            ? (reserve0, reserve1)
            : (reserve1, reserve0);
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 fee
    ) internal pure returns (uint256 amountOut) {
        require(amountIn > 0, "Library: INSUFFICIENT_INPUT_AMOUNT");
        require(
            reserveIn > 0 && reserveOut > 0,
            "Library: INSUFFICIENT_LIQUIDITY"
        );
        uint256 tenThousand = 10000;
        uint256 amountInWithFee = amountIn.mul(tenThousand.sub(fee));
        uint256 numerator = amountInWithFee.mul(reserveOut);
        uint256 denominator = reserveIn.mul(10000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(
        uint256 amountIn,
        address[] memory path,
        address[] memory pairPath,
        uint256[] memory fee
    ) internal view returns (uint256[] memory amounts) {
        require(path.length >= 2, "Library: INVALID_PATH");
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;
        for (uint256 i; i < path.length - 1; i++) {
            (uint256 reserveIn, uint256 reserveOut) = getReserves(
                pairPath[i],
                path[i],
                path[i + 1]
            );
            amounts[i + 1] = getAmountOut(
                amounts[i],
                reserveIn,
                reserveOut,
                fee[i]
            );
        }
    }
}

contract Swapper {
    using SafeMath for uint256;
    address private owner;
    uint256 public calculatedTax;
    mapping(address => bool) public authorizations;

    modifier onlyOwner() {
        require(msg.sender == owner, "Swapper: not authorized: ");
        _;
    }

    modifier authorized() {
        require(authorizations[msg.sender] == true, "Account not authorized.");
        _;
    }

    modifier ensure(uint256 deadline) {
        require(deadline >= block.timestamp, "vSwap: EXPIRED");
        _;
    }

    function authorize(address[] memory accounts, bool status)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < accounts.length; i++) {
            authorizations[accounts[i]] = status;
        }
    }

    constructor() {
        owner = msg.sender;
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) public authorized {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x23b872dd, from, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: TRANSFER_FROM_FAILED"
        );
    }

    function _swap(
        uint256[] memory amounts,
        address[] memory path,
        address[] memory pairPath,
        address _to
    ) internal virtual {
        for (uint256 i; i < pairPath.length; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0, ) = PancakeLibrary.sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOut)
                : (amountOut, uint256(0));
            address to = i < pairPath.length - 1 ? pairPath[i + 1] : _to;
            IPancakePair(pairPath[i]).swap(
                amount0Out,
                amount1Out,
                to,
                new bytes(0)
            );
        }
    }

    function _swapSupportingFeeOnTransferTokens(
        address[] memory path,
        address[] memory pairPath,
        address _to
    ) internal virtual {
        for (uint256 i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0, ) = PancakeLibrary.sortTokens(input, output);
            IPancakePair pair = IPancakePair(pairPath[i]);
            uint256 amountInput;
            uint256 amountOutput;
            {
                // scope to avoid stack too deep errors
                (uint256 reserve0, uint256 reserve1) = PancakeLibrary
                    .getReserves(pairPath[i], path[i], path[i + 1]);
                (uint256 reserveInput, uint256 reserveOutput) = input == token0
                    ? (reserve0, reserve1)
                    : (reserve1, reserve0);
                amountInput = IBEP20(input).balanceOf(address(pair)).sub(
                    reserveInput
                );
                amountOutput = PancakeLibrary.getAmountOut(
                    amountInput,
                    reserveInput,
                    reserveOutput,
                    20
                );
            }
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOutput)
                : (amountOutput, uint256(0));
            address to = i < path.length - 2 ? pairPath[i + 2] : _to;
            pair.swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    function reverseArray(address[] calldata _array)
        public
        pure
        returns (address[] memory)
    {
        uint256 length = _array.length;
        address[] memory reversedArray = new address[](length);
        uint256 j = 0;
        for (uint256 i = length; i >= 1; i--) {
            reversedArray[j] = _array[i - 1];
            j++;
        }
        return reversedArray;
    }

    function safetyCheck(
        address[] calldata path,
        address[] calldata pairPath,
        uint256[] calldata fee,
        address to,
        uint256 deadline
    ) internal virtual ensure(deadline) {
        IBEP20 token = IBEP20(path[path.length - 1]);

        uint256[] memory amounts = PancakeLibrary.getAmountsOut(
            1,
            path,
            pairPath,
            fee
        );
        uint256 balanceBefore = token.balanceOf(to);
        safeTransferFrom(path[0], msg.sender, pairPath[0], amounts[0]);
        _swap(amounts, path, pairPath, to);
        uint256 balanceAfter = token.balanceOf(to).sub(balanceBefore);
        calculatedTax =
            100 -
            ((balanceAfter * 100) / amounts[amounts.length - 1]);
    }

    function PUMP(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address[] calldata pairPath,
        uint256[] calldata fee,
        address[] memory to,
        uint256 deadline,
        uint256 maxTax
    ) external virtual ensure(deadline) authorized {
        safetyCheck(path, pairPath, fee, to[0], deadline);
        require(calculatedTax <= maxTax);
        for (uint256 x = 0; x < to.length; x++) {
            uint256[] memory amounts = PancakeLibrary.getAmountsOut(
                amountIn,
                path,
                pairPath,
                fee
            );

            require(amounts[amounts.length - 1] >= amountOutMin);
            safeTransferFrom(path[0], msg.sender, pairPath[0], amounts[0]);
            _swap(amounts, path, pairPath, to[x]);
        }
    }

    function DUMP(
        uint256 amountIn,
        address[] calldata path,
        address[] calldata pairPath,
        uint256[] calldata fee,
        address[] memory from,
        uint256 deadline
    ) external virtual ensure(deadline) authorized {
        IBEP20 token = IBEP20(path[0]);
        for (uint256 i = 0; i < from.length; i++) {
            uint256 balance = token.balanceOf(from[i]);
            uint256 amount = balance;
            if (amountIn == 50) {
                amount = balance / 2;
            } else if (amountIn == 25) {
                amount = balance / 4;
            }
            uint256[] memory amounts = PancakeLibrary.getAmountsOut(
                amount,
                path,
                pairPath,
                fee
            );

            safeTransferFrom(path[0], from[i], pairPath[0], amounts[0]);
            _swapSupportingFeeOnTransferTokens(path, pairPath, msg.sender);
        }
    }
}