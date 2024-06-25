/**
 *Submitted for verification at BscScan.com on 2022-11-30
*/

pragma solidity ^0.5.16;
    
    interface ILitedexFactory {
        event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    
        function feeTo() external view returns (address);
        function feeToSetter() external view returns (address);
    
        function getPair(address tokenA, address tokenB) external view returns (address pair);
        function allPairs(uint) external view returns (address pair);
        function allPairsLength() external view returns (uint);
    
        function createPair(address tokenA, address tokenB) external returns (address pair);
    
        function setFeeTo(address) external;
        function setFeeToSetter(address) external;
        function setWeightFee(address pair, uint8 _devFee, uint8 _liqFee) external;
        function setSwapFee(address pair, uint32 swapFee) external;
    }
    
    interface ILitedexPair {
        event Approval(address indexed owner, address indexed spender, uint value);
        event Transfer(address indexed from, address indexed to, uint value);
    
        function name() external pure returns (string memory);
        function symbol() external pure returns (string memory);
        function decimals() external pure returns (uint8);
        function totalSupply() external view returns (uint);
        function balanceOf(address owner) external view returns (uint);
        function allowance(address owner, address spender) external view returns (uint);
    
        function approve(address spender, uint value) external returns (bool);
        function transfer(address to, uint value) external returns (bool);
        function transferFrom(address from, address to, uint value) external returns (bool);
    
        function DOMAIN_SEPARATOR() external view returns (bytes32);
        function PERMIT_TYPEHASH() external pure returns (bytes32);
        function nonces(address owner) external view returns (uint);
    
        function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    
        event Mint(address indexed sender, uint amount0, uint amount1);
        event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
        event Swap(
            address indexed sender,
            uint amount0In,
            uint amount1In,
            uint amount0Out,
            uint amount1Out,
            address indexed to
        );
        event Sync(uint112 reserve0, uint112 reserve1);
    
        function minLiquidity() external pure returns (uint);
        function factory() external view returns (address);
        function token0() external view returns (address);
        function token1() external view returns (address);
        function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
        function price0CumulativeLast() external view returns (uint);
        function price1CumulativeLast() external view returns (uint);
        function kLast() external view returns (uint);
    
        function mint(address to) external returns (uint liquidity);
        function burn(address to) external returns (uint amount0, uint amount1);
        function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
        function skim(address to) external;
        function sync() external;
    
        function initialize(address, address) external;

        function setSwapFee(uint32 _swapFee) external;
        function setWeightFee(uint32 _devFee, uint32 _liqFee) external;
    }
    
    interface ILitedexERC20 {
        event Approval(address indexed owner, address indexed spender, uint value);
        event Transfer(address indexed from, address indexed to, uint value);
    
        function name() external pure returns (string memory);
        function symbol() external pure returns (string memory);
        function decimals() external pure returns (uint8);
        function totalSupply() external view returns (uint);
        function balanceOf(address owner) external view returns (uint);
        function allowance(address owner, address spender) external view returns (uint);
    
        function approve(address spender, uint value) external returns (bool);
        function transfer(address to, uint value) external returns (bool);
        function transferFrom(address from, address to, uint value) external returns (bool);
    
        function DOMAIN_SEPARATOR() external view returns (bytes32);
        function PERMIT_TYPEHASH() external pure returns (bytes32);
        function nonces(address owner) external view returns (uint);
    
        function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    }
    
    interface IERC20 {
        event Approval(address indexed owner, address indexed spender, uint value);
        event Transfer(address indexed from, address indexed to, uint value);
    
        function name() external view returns (string memory);
        function symbol() external view returns (string memory);
        function decimals() external view returns (uint8);
        function totalSupply() external view returns (uint);
        function balanceOf(address owner) external view returns (uint);
        function allowance(address owner, address spender) external view returns (uint);
    
        function approve(address spender, uint value) external returns (bool);
        function transfer(address to, uint value) external returns (bool);
        function transferFrom(address from, address to, uint value) external returns (bool);
    }
    
    interface ILitedexCallee {
        function LitedexCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
    }
    
    contract LitedexERC20 is ILitedexERC20 {
        using SafeMath for uint;
    
        string public constant name = "Litedex LP";
        string public constant symbol = "Litedex-LP";
        uint8 public constant decimals = 18;
        uint  public totalSupply;
        mapping(address => uint) public balanceOf;
        mapping(address => mapping(address => uint)) public allowance;
    
        bytes32 public DOMAIN_SEPARATOR;
        // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
        bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
        mapping(address => uint) public nonces;
    
        event Approval(address indexed owner, address indexed spender, uint value);
        event Transfer(address indexed from, address indexed to, uint value);
    
        constructor() public {
            uint chainId;
            assembly {
                chainId := chainid
            }
            DOMAIN_SEPARATOR = keccak256(
                abi.encode(
                    keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                    keccak256(bytes(name)),
                    keccak256(bytes('1')),
                    chainId,
                    address(this)
                )
            );
        }
    
        function _mint(address to, uint value) internal {
            totalSupply = totalSupply.add(value);
            balanceOf[to] = balanceOf[to].add(value);
            emit Transfer(address(0), to, value);
        }
    
        function _burn(address from, uint value) internal {
            require(from != address(0), "Msg: from is zero address");
            balanceOf[from] = balanceOf[from].sub(value);
            totalSupply = totalSupply.sub(value);
            emit Transfer(from, address(0), value);
        }
    
        function _approve(address owner, address spender, uint value) private {
            require(owner != address(0), "Msg: owner is zero address");
            require(spender != address(0), "Msg: spender is zero address");
            allowance[owner][spender] = value;
            emit Approval(owner, spender, value);
        }
    
        function _transfer(address from, address to, uint value) private {
            require(from != address(0), "Msg: from is zero address");
            require(to != address(0), "Msg: to is zero address");
            balanceOf[from] = balanceOf[from].sub(value);
            balanceOf[to] = balanceOf[to].add(value);
            emit Transfer(from, to, value);
        }
    
        function approve(address spender, uint value) external returns (bool) {
            _approve(msg.sender, spender, value);
            return true;
        }
    
        function transfer(address to, uint value) external returns (bool) {
            _transfer(msg.sender, to, value);
            return true;
        }
    
        function transferFrom(address from, address to, uint value) external returns (bool) {
            if (allowance[from][msg.sender] != uint(-1)) {
                allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
            }
            _transfer(from, to, value);
            return true;
        }
    
        function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
            require(deadline >= block.timestamp, "Msg: Expired deadline");
            bytes32 digest = keccak256(
                abi.encodePacked(
                    '\x19\x01',
                    DOMAIN_SEPARATOR,
                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
                )
            );
            address recoveredAddress = ecrecover(digest, v, r, s);
            require(recoveredAddress != address(0) && recoveredAddress == owner, "Msg: Invalid Signature");
            _approve(owner, spender, value);
        }
    }
    
    contract LitedexPair is ILitedexPair, LitedexERC20 {
        using SafeMath  for uint;
        using UQ112x112 for uint224;
    
        uint public constant minLiquidity = 10**3;
        bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
    
        address public factory;
        address public token0;
        address public token1;
    
        uint112 private reserve0;           // uses single storage slot, accessible via getReserves
        uint112 private reserve1;           // uses single storage slot, accessible via getReserves
        uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
    
        uint public price0CumulativeLast;
        uint public price1CumulativeLast;
        uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event

        uint32 public swapFee = 25; // default swap fee
        uint32 public devFee = 8; // default weight of protocol fee
        uint32 public liqFee = 17; // default weight of liquidity provider fee
    
        uint private unlocked = 1;
        modifier lock() {
            require(unlocked == 1, "Msg: locked");
            unlocked = 0;
            _;
            unlocked = 1;
        }
    
        function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
            _reserve0 = reserve0;
            _reserve1 = reserve1;
            _blockTimestampLast = blockTimestampLast;
        }
    
        function _safeTransfer(address token, address to, uint value) private {
            (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
            require(success && (data.length == 0 || abi.decode(data, (bool))), "Msg: Tranfer Failed");
        }
    
        event Mint(address indexed sender, uint amount0, uint amount1);
        event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
        event Swap(
            address indexed sender,
            uint amount0In,
            uint amount1In,
            uint amount0Out,
            uint amount1Out,
            address indexed to
        );
        event Sync(uint112 reserve0, uint112 reserve1);
        event SetSwapFee(uint swapFee);
        event SetWeightFee(uint _devFee, uint _liqFee);
    
        constructor() public {
            factory = msg.sender;
        }
    
        // called once by the factory at time of deployment
        function initialize(address _token0, address _token1) external {
            require(msg.sender == factory, "Msg: Forbidden"); // sufficient check
            token0 = _token0;
            token1 = _token1;
        }

        function setSwapFee(uint32 _swapFee) external {
            require(_swapFee > 0, "Msg: lower then 0");
            require(msg.sender == factory, "Msg: FORBIDDEN");
            require(_swapFee <= 1000, "Msg: FORBIDDEN_FEE");
            swapFee = _swapFee;
            emit SetSwapFee(_swapFee);
        }
        
        function setWeightFee(uint32 _devFee, uint32 _liqFee) external {
            require(msg.sender == factory, "Msg: FORBIDDEN");
            require(_devFee > 0 && _liqFee > 0, "Msg: lower then 0");
            devFee = _devFee;
            liqFee = _liqFee;
            emit SetWeightFee(_devFee, _liqFee);
        }
    
        /***
         * This function is updating reserves and, on the first call per block, price accumulators
         */
        function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
            require(balance0 <= uint112(-1) && balance1 <= uint112(-1), "Msg: Overflow");
            uint32 blockTimestamp = uint32(block.timestamp % 2**32);
            uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
            if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
                // * never overflows, and + overflow is desired
                price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
                price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
            }
            reserve0 = uint112(balance0);
            reserve1 = uint112(balance1);
            blockTimestampLast = blockTimestamp;
            emit Sync(reserve0, reserve1);
        }
    
        /***
         * The function for mint liquidity equivalent to devFee / liqFee + devFee of the growth in sqrt(K)
         * Note : the feeOn should be enabled to activate this function
         */
        function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
            address feeTo = ILitedexFactory(factory).feeTo();
            feeOn = feeTo != address(0);
            uint _kLast = kLast; // gas savings
            if (feeOn) {
                if (_kLast != 0) {
                    uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
                    uint rootKLast = Math.sqrt(_kLast);
                    if (rootK > rootKLast) {
                        uint numerator = totalSupply.mul(rootK.sub(rootKLast)).mul(devFee);
                        uint denominator = rootK.mul(liqFee).add(rootKLast.mul(devFee));
                        uint liquidity = numerator / denominator;
                        if (liquidity > 0) _mint(feeTo, liquidity);
                    }
                }
            } else if (_kLast != 0) {
                kLast = 0;
            }
        }
    
        // this low-level function should be called from a contract which performs important safety checks
        function mint(address to) external lock returns (uint liquidity) {
            (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
            uint balance0 = IERC20(token0).balanceOf(address(this));
            uint balance1 = IERC20(token1).balanceOf(address(this));
            uint amount0 = balance0.sub(_reserve0);
            uint amount1 = balance1.sub(_reserve1);
    
            bool feeOn = _mintFee(_reserve0, _reserve1);
            uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
            if (_totalSupply == 0) {
                liquidity = Math.sqrt(amount0.mul(amount1)).sub(minLiquidity);
               _mint(address(0), minLiquidity); // permanently lock the first minLiquidity tokens
            } else {
                liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
            }
            require(liquidity > 0, "Msg: Insufficient Liquidity Minted");
            _mint(to, liquidity);
    
            _update(balance0, balance1, _reserve0, _reserve1);
            if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
            emit Mint(msg.sender, amount0, amount1);
        }
    
        // this low-level function should be called from a contract which performs important safety checks
        function burn(address to) external lock returns (uint amount0, uint amount1) {
            (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
            address _token0 = token0;                                // gas savings
            address _token1 = token1;                                // gas savings
            uint balance0 = IERC20(_token0).balanceOf(address(this));
            uint balance1 = IERC20(_token1).balanceOf(address(this));
            uint liquidity = balanceOf[address(this)];
    
            bool feeOn = _mintFee(_reserve0, _reserve1);
            uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
            require(_totalSupply != 0, "Msg: Total Supply is 0");
            amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
            amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
            require(amount0 > 0 && amount1 > 0, "Msg: Insufficient Liquidity Burned");
            _burn(address(this), liquidity);
            _safeTransfer(_token0, to, amount0);
            _safeTransfer(_token1, to, amount1);
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
    
            _update(balance0, balance1, _reserve0, _reserve1);
            if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
            emit Burn(msg.sender, amount0, amount1, to);
        }
    
        // this low-level function should be called from a contract which performs important safety checks
        function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
            require(amount0Out > 0 || amount1Out > 0, "Msg: Insufficient Output Amount");
            (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
            require(amount0Out < _reserve0 && amount1Out < _reserve1, "Msg: Insufficient Liquidity");
    
            uint balance0;
            uint balance1;
            { // scope for _token{0,1}, avoids stack too deep errors
            address _token0 = token0;
            address _token1 = token1;
            require(to != _token0 && to != _token1, "Msg: Invalid to");
            if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
            if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
            if (data.length > 0) ILitedexCallee(to).LitedexCall(msg.sender, amount0Out, amount1Out, data);
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
            }
            uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
            uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
            require(amount0In > 0 || amount1In > 0, "Msg: Insufficient Input Amount");
            { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
            uint _swapFee = swapFee;
            uint balance0Adjusted = balance0.mul(10000).sub(amount0In.mul(_swapFee));
            uint balance1Adjusted = balance1.mul(10000).sub(amount1In.mul(_swapFee));
            require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(10000**2), "Msg: K");
            }
    
            _update(balance0, balance1, _reserve0, _reserve1);
            emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
        }
    
        // force balances to match reserves
        function skim(address to) external lock {
            address _token0 = token0; // gas savings
            address _token1 = token1; // gas savings
            _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
            _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
        }
    
        // force reserves to match balances
        function sync() external lock {
            _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
        }
    }
    
    contract LitedexFactory is ILitedexFactory {
        bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(LitedexPair).creationCode));
        address public feeTo;
        address public feeToSetter;
    
        mapping(address => mapping(address => address)) public getPair;
        address[] public allPairs;
    
        event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    
        constructor(address _feeToSetter) public {
            feeToSetter = _feeToSetter;
        }
    
        function allPairsLength() external view returns (uint) {
            return allPairs.length;
        }
    
        function createPair(address tokenA, address tokenB) external returns (address pair) {
            require(tokenA != tokenB, "Msg: Identical Addresses");
            (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
            require(token0 != address(0), "Msg: Zero Address");
            require(getPair[token0][token1] == address(0), "Msg: Pair Exists"); // single check is sufficient
            bytes memory bytecode = type(LitedexPair).creationCode;
            bytes32 salt = keccak256(abi.encodePacked(token0, token1));
            assembly {
                pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
            }
            ILitedexPair(pair).initialize(token0, token1);
            getPair[token0][token1] = pair;
            getPair[token1][token0] = pair; // populate mapping in the reverse direction
            allPairs.push(pair);
            emit PairCreated(token0, token1, pair, allPairs.length);
        }
    
        function setFeeTo(address _feeTo) external {
            require(msg.sender == feeToSetter, "Msg: Forbidden");
            feeTo = _feeTo;
        }
    
        function setFeeToSetter(address _feeToSetter) external {
            require(msg.sender == feeToSetter, "Msg: Forbidden");
            feeToSetter = _feeToSetter;
        }

        function setWeightFee(address _pair,uint8 _devFee, uint8 _liqFee) external {
            require(msg.sender == feeToSetter, "Msg: FORBIDDEN");
            require(_devFee > 0 && _liqFee > 0, "Msg: FORBIDDEN_FEE");
            LitedexPair(_pair).setWeightFee(_devFee, _liqFee);
        }
        
        function setSwapFee(address _pair, uint32 _swapFee) external {
            require(msg.sender == feeToSetter, "Msg: FORBIDDEN");
            LitedexPair(_pair).setSwapFee(_swapFee);
        }
    }
    
    // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
    
    library SafeMath {
        function add(uint x, uint y) internal pure returns (uint z) {
            require((z = x + y) >= x, 'ds-math-add-overflow');
        }
    
        function sub(uint x, uint y) internal pure returns (uint z) {
            require((z = x - y) <= x, 'ds-math-sub-underflow');
        }
    
        function mul(uint x, uint y) internal pure returns (uint z) {
            require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
        }
    }
    
    // a library for performing various math operations
    
    library Math {
        function min(uint x, uint y) internal pure returns (uint z) {
            z = x < y ? x : y;
        }
    
        // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
        function sqrt(uint y) internal pure returns (uint z) {
            if (y > 3) {
                z = y;
                uint x = y / 2 + 1;
                while (x < z) {
                    z = x;
                    x = (y / x + x) / 2;
                }
            } else if (y != 0) {
                z = 1;
            }
        }
    }
    
    // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
    
    // range: [0, 2**112 - 1]
    // resolution: 1 / 2**112
    
    library UQ112x112 {
        uint224 constant Q112 = 2**112;
    
        // encode a uint112 as a UQ112x112
        function encode(uint112 y) internal pure returns (uint224 z) {
            z = uint224(y) * Q112; // never overflows
        }
    
        // divide a UQ112x112 by a uint112, returning a UQ112x112
        function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
            z = x / uint224(y);
        }
    }