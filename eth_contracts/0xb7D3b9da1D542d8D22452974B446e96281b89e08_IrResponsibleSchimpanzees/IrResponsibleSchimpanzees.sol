/**
 *Submitted for verification at Etherscan.io on 2023-05-21
*/

/*
Ape iReSponsibly

irschimp.us
t.me/IRS_ERC20
𓅪 @IRS_ERC20

,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,(@@@@@@@@@@@@@@@@@@@@@@##%&@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,*@@@@@@@@@@#*,,,,,,,@@@@@*,,,,,,,,,,,,,,,,,,,*(@@@@@@@@@@(,,,,,,,,,,,,,,,,
,,,,,,,,,,,,#@@@@@@@%,&@@@,,,,,,,(@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@@@@@@@&,,,,,,,,,,,,
,,,,,,,,*@@@@@@&,,,,,@@@#,,,,,,%@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,,*&@@@@@%@%,&@@@@@@/,,,,,,,,
,,,,,,&@@@@@*,,,,,,,@@@,,,,,,#@@@/,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@&@*,&@*,@@,&@,&@@@@@,,,,,,
,,,,,(@@@@@&,,,,,,*@@@,,,,,*@@@#,,,,,,,,,,,,**,,,,,,,,,,,,,*@@,,,,&@@@@@@@#,,,,*&@@@%,,,,,
,,,,,@@@@@@,,,,,,,@@@,,,,,%@@@,,,,,,,%@@@@@@&&&@@@@@@,,,,,,,,@@@(@%,,,/@@,,,,,,,,@@@@,,,,,
,,,,@@@@@@@,,,,,,@@@,,,,,@@@&,,@@%,@@@,,,,,,,,,,,,,,%@@#(@@/,,*@@,,*@#,,,,,,,,,,,,@@@@,,,,
,,,,@@@@@@%,,,,,@@@*,,,,@@@#,@@@,#@@*,(@@&*,,,,,&@@%,,@@&,&@@,,(@@@&%&&&&&&&/,,,,,%@@@/,,,
,,,&@@@@@@/,,,,&@@%,,,,@@@#*@@/@&,,,,&@,@/,,**,,*@,@@,,,,/@,@@#,,,,,,,,,,,,@@@,,,,,@@@@,,,
,,,@@@@@@@*,,,,@@@,,,,#@@@,@@%(@,,,,@@**(%@@,,%@%/**@@,,,,@&*@@,,,,,,,,,,,,,@@(,,,,@@@@,,,
,,*@@@&@@@*,,,%@@&,,,,@@@,,*@@,*,,,,,,,@@#**,,**(@@*,,,,,,*,@@#,,,,,,,,,,,,,/@@,,,,*@@@%,,
,,%@@@/@@@/,,,@@@,,,,(@@@,,,,&@@@@/,,,,(@,,,,,,,,@%,,,,*@@@@@*,,,,,,,,,,,,,,,@@,,,,,@@@@,,
,,@@@@,%@@%,,,@@@,,,,@@@/,,,,,,,,#@@(,,@#,,,,,,,,*@,,*@@&,,,,,,,,,,,,,,,,,,,,@@,,,,,@@@@,,
,,@@@@,*@@@,,,@@@,,,,@@@*,,,,,,,,,,#@@,@@,*#&&#*,&@,@@&,,,,,,,,,,,,,,,,,,,,,@@%,,,,,@@@@,,
,,@@@@,,@@@*,,%@@%,,,@@@*,,,,,,,,,,,@@(,%@(,,,,*@@,*@@,,,,,,,,,,,,,,,,,,,,@@@,,,,,,,@@@@,,
,,&@@@*,*@@@,,,@@@,,,@@@/,,,,,,,,,,,&@@*,,,/%%/,,,,@@@@@@@@@@@@@&(///#@@@@&,,,,,,,,,@@@@,,
,,/@@@%,,&@@%,,&@@&,,/@@@,,,,,,,,,,,,,#@@@@(,,/@@@@&,,,,,,,,,,,,,//((*,,,,,,,,,,,,,*@@@&,,
,,,@@@@,,*@@@%,,@@@&,,@@@*,,,,,,,,,,,,,,,,,(@@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@*,,
,,,&@@@*,,,@@@&,,@@@&,*@@@,,,,,,,,,,,,,,,,&@@@@&*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@,,,
,,,*@@@@,,,,#@@@,,%@@@,(@@@,,,,,,,,,,,,,,,/@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@@@(,,,
,,,,@@@@*,,,,,@@@@,,@@@#(@@@,,,,,,,,,,,,,,,****,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@,,,,
,,,,,@@@@,,,,,,*@@@@,#@@@/@@@#,,,,,,,,,,,,*@@@@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*,@@@@,,,,,
,,,,,*@@@@@@*,,,,,@@@@/&@@@@@@@*,,,,,,,,,,%@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@@@@@@(,,,,,
,,,,,,,,(@@@@@@@(,,,#@@@@@@@@@@@@(,,,,,,,,@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,#@@@@@@@%,,,,,,,,
,,,,,,,,,,,,*@@@@@@@@@(/@@@@@@@@@@@@*,,,,*@@@@@@#,,,,,,,,,,,,,,,,,,/@@@@@@@@@(,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,*&@@@@@@@@@@@@@@@@@@@@%,&@@@@@@@,,,,,,,,,/&@@@@@@@@@@@@*,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&*,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*(&@@@@@@@@@@@@&#*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,



**/
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


pragma solidity ^0.8.0;

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "You are not Lord Rothschild");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "The void consumes");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


pragma solidity ^0.8.0;


interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);


    function allowance(address owner, address spender) external view returns (uint256);


    function approve(address spender, uint256 amount) external returns (bool);


    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}


pragma solidity ^0.8.0;

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

pragma solidity ^0.8.0;

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }


    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }


    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "increase apeage");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ape is below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "Transfer from dead");
        require(recipient != address(0), "Transfer to dead");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }


    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}


    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

pragma solidity ^0.8.0;

contract IrResponsibleSchimpanzees is Ownable, ERC20 {
    bool public tradingOpen = false;
    // Bot status: DESTROYED, apes SAVED
    uint256 public deadBlocks = 4;
    uint256 public launchedAt = 0;

    bool public limited;
    uint256 public maxHoldingAmount;
    uint256 public minHoldingAmount;
    address public uniswapV2Pair;

    mapping(address => bool) public whitelists;

    constructor(uint256 _totalSupply) ERC20("IrResponsible Schimpanzees", "IRS") {
        _mint(msg.sender, _totalSupply);
    }
    // max ape limits
    function setTradingConfig(bool _status, uint256 _deadBlocks, bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
        tradingOpen = _status;
        if (tradingOpen && launchedAt == 0) {
            launchedAt = block.number;
            deadBlocks = _deadBlocks;
        }
        limited = _limited;
        uniswapV2Pair = _uniswapV2Pair;
        maxHoldingAmount = _maxHoldingAmount;
        minHoldingAmount = _minHoldingAmount;
    }

    function whitelist(address _address, bool _isWhitelisted) external onlyOwner {
        whitelists[_address] = _isWhitelisted;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) override internal virtual {

        if (!whitelists[from]) {
            if (uniswapV2Pair == address(0)) {
                require(from == owner() || to == owner(), "You cannot Ape yet");
                return;
            }

            if (limited && from == uniswapV2Pair) {
                require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Sent to India");
            }
        }
    }

    function burn(uint256 value) external {
        _burn(msg.sender, value);
    }
}