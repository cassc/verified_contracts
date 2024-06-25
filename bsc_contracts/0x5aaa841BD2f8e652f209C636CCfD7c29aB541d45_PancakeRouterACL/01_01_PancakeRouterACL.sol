pragma solidity ^0.8.14;

contract PancakeRouterACL {
    address public safeAddress;
    address public safeModule;

    bytes32 private _checkedRole;
    uint256 private _checkedValue;

    address constant btcb = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
    address constant busd = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address constant cake = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;

    mapping(address => bool) _tokenWhitelist;

    constructor(address _safeAddress, address _safeModule) {
        require(_safeAddress != address(0), "invalid safe address");
        require(_safeModule!= address(0), "invalid module address");
        safeAddress = _safeAddress;
        safeModule = _safeModule;
        _tokenWhitelist[btcb] = true;
        _tokenWhitelist[busd] = true;
        _tokenWhitelist[cake] = true;
    }

    modifier onlySelf() {
        require(address(this) == msg.sender, "Caller is not inner");
        _;
    }

    modifier onlyModule() {
        require(safeModule == msg.sender, "Caller is not the module");
        _;
    }

    function check(bytes32 _role, uint256 _value, bytes calldata data) external onlyModule returns (bool) {
        _checkedRole = _role;
        _checkedValue = _value;
        (bool success,) = address(this).staticcall(data);
        return success;
    }

    fallback() external {
        revert("Unauthorized access");
    }

    // ===== ACL Function =====
    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external view onlySelf {
        require(_checkedValue == 0, "invalid value");
        require(path.length == 2, "Invalid Path");
        require(_tokenWhitelist[path[0]], "Token is not allowed");
        require(_tokenWhitelist[path[path.length - 1]], "Token is not allowed");
        require(to == safeAddress, "To address is not allowed");
    }
    function swapTokensForExactTokens(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external view onlySelf {
        require(_checkedValue == 0, "invalid value");
        require(path.length == 2, "Invalid Path");
        require(_tokenWhitelist[path[0]], "Token is not allowed");
        require(_tokenWhitelist[path[path.length - 1]], "Token is not allowed");
        require(to == safeAddress, "To address is not allowed");
    }

    function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external view onlySelf {
        require(_checkedValue == 0, "invalid value");
        require(_tokenWhitelist[tokenA], "Token is not allowed");
        require(_tokenWhitelist[tokenB], "Token is not allowed");
        require(to == safeAddress, "To address is not allowed");
    }

    function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external view onlySelf {
        require(_checkedValue == 0, "invalid value");
        require(_tokenWhitelist[tokenA], "Token is not allowed");
        require(_tokenWhitelist[tokenB], "Token is not allowed");
        require(to == safeAddress, "To address is not allowed");
    }
}