// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface Router {
    function exactInputSingle(ExactInputSingleParams calldata params) external returns (uint256 amountOut);
}

interface Pool {
    function slot0()
    external
    view
    returns (
        uint160 sqrtPriceX96,
        int24 tick,
        uint16 observationIndex,
        uint16 observationCardinality,
        uint16 observationCardinalityNext,
        uint32 feeProtocol,
        bool unlocked
    );

    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
    ) external returns (int256 amount0, int256 amount1);

}


contract V3 {
    address public tokenIn = 0x55d398326f99059fF775485246999027B3197955;
    address public tokenOut = 0x9b9e48dFBe6A357D975e64875837aB97ee20a349;
    address public pool = 0x1E204eD3A5BB892Eef050ca247AE6fa8b8210Dea;
    address public router = 0x13f4EA83D0bd40E75C8222255bc855a974568Dd4;
    uint256 public amountIn = 1e15;

    event Log1(string message);
    event Log2(string message);
    event Log3(string message);
    event LogBytes1(bytes data);
    event LogBytes2(bytes data);
    event LogBytes3(bytes data);

    function swap(
        uint24 _fee,
        uint256 _minOut,
        bool _usesqrtPriceX96
    ) external payable returns (uint256 amountOut) {
        try IERC20(tokenIn).approve(router, amountIn) {} catch Error(string memory reason) {
            emit Log2(reason);
        } catch (bytes memory reason) {
            emit LogBytes2(reason);
        }
        (uint160 sqrtPriceX96,,,,,,) = Pool(pool).slot0();
        try Router(router).exactInputSingle(ExactInputSingleParams({
        tokenIn : tokenIn,
        tokenOut : tokenOut,
        fee : _fee,
        recipient : msg.sender,
        amountIn : amountIn,
        amountOutMinimum : _minOut,
        sqrtPriceLimitX96 : _usesqrtPriceX96 ? sqrtPriceX96 : 0
        })) returns (uint256 k) {amountOut = k;} catch Error(string memory reason) {
            emit Log3(reason);
        } catch (bytes memory reason) {
            emit LogBytes3(reason);
        }
    }

    function uniswapV3SwapCallback(uint256 amount0, uint256 amount1, bytes calldata data) external {
        // Handle the Uniswap V3 swap callback
        // ...
    }

    function swap2(
        bool _usesqrtPriceX96
    ) external payable returns (uint256 amountOut) {
        IERC20(tokenIn).transfer(pool, amountIn);
        (uint160 sqrtPriceX96,,,,,,) = Pool(pool).slot0();
        Pool(pool).swap(
            msg.sender,
            true,
            int256(amountIn),
            _usesqrtPriceX96 ? sqrtPriceX96 : 0,
            abi.encodeWithSelector(
                bytes4(keccak256(bytes("uniswapV3SwapCallback(uint256,uint256,bytes))"))),
                0,
                0,
                bytes("")
            )
        );
    }
}