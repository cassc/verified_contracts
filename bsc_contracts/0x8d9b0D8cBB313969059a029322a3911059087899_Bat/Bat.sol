/**
 *Submitted for verification at BscScan.com on 2022-12-30
*/

// SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.8.1;

interface PancakeRouter {
    function factory() external pure returns (address);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

interface PancakeFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface BEP20 {
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

interface BatMedium {
    function exchangeUsdt(uint256 amount) external returns (uint256);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
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
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract Bat is Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    address private _usdtAddress;
    address private _pancakeRouterAddress;
    PancakeRouter private _pancakeRouter;
    mapping(address => bool) public isPairAddress;
    address private _pairAddress;
    mapping(address => bool) public systemList;
    uint256 public buySlipPoint;
    uint256 public sellSlipPoint;
    mapping(address => address) private leader;
    mapping(address => address[]) private directPush;
    uint256 public totalDestruction;
    uint256 public endDestruction;
    uint256 public destroyNum;
    uint256 public transferMaxRatio;
    uint8 public serviceCharge;
    address public BatFoundationAddress;
    address public communityAddress;
    uint256 public BatMax;
    address private BatMediumAddress;

    constructor(string memory _name, string memory _symbol,address _address) {
        decimals = 11;

        _usdtAddress = 0x55d398326f99059fF775485246999027B3197955;
        _pancakeRouterAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

        _pancakeRouter = PancakeRouter(_pancakeRouterAddress);

        _pairAddress = PancakeFactory(_pancakeRouter.factory()).createPair(
            address(this),
            address(_usdtAddress)
        );

        isPairAddress[_pairAddress] = true;

        systemList[_pairAddress] = true;
        systemList[msg.sender] = true;
        systemList[address(this)] = true;

        buySlipPoint = 6;
        sellSlipPoint = 10;
        totalDestruction = 720000000 * 10 ** decimals;
        endDestruction = 72000000 * 10 ** decimals;
        transferMaxRatio = 90;
        serviceCharge = 2;
        BatFoundationAddress = 0xEf7A24dF92737c70690a2fAA2d1bc84122845c5D;
        communityAddress = 0xB2671Ec504B20c8AC73E9E10218031357f4b6e4F;
        BatMax = 7200000 * 10 ** decimals;

        systemList[BatFoundationAddress] = true;
        systemList[communityAddress] = true;
        systemList[_address] = true;

        name = _name;
        symbol = _symbol;
        _mint(_address, totalDestruction);
    }

    function setBatMediumAddress(
        address _address
    ) public onlyOwner returns (bool) {
        BatMediumAddress = _address;
        systemList[_address] = true;
        return true;
    }

    function setSystemAddress(
        address[] memory _address,
        bool _state
    ) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < _address.length; i++) {
            systemList[_address[i]] = _state;
        }
        return true;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function contractTransfer(
        address recipient,
        uint256 amount
    ) public onlyOwner returns (bool) {
        _transfer(address(this), recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        unchecked {
            _approve(sender, msg.sender, currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public returns (bool) {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );

        require(amount >= 100, "BEP20: Error");

        if (!systemList[sender]) {
            uint256 now_balance = _balances[sender];
            if (amount > (now_balance * transferMaxRatio) / 100) {
                require(false, "BEP20: sender too many transactions");
            }
        }

        uint256 amounts = amount;

        if (totalDestruction - endDestruction > destroyNum) {
            if (isPairAddress[sender]) {
                if (!systemList[recipient]) {
                    amounts = _takeFee(amount, 2, recipient);
                }
            } else if (isPairAddress[recipient]) {
                if (!systemList[sender]) {
                    amounts = _takeFee(amount, 1, sender);
                }
            } else {
                if (!systemList[sender]) {
                    uint256 foundation_amount = amount.mul(serviceCharge).div(
                        100
                    );
                    _balances[BatFoundationAddress] += foundation_amount;
                    senderBalance = senderBalance - foundation_amount;
                    _balances[sender] = senderBalance;
                    emit Transfer(sender, BatFoundationAddress, foundation_amount);
                }
            }
        }

        if (!systemList[recipient]) {
            uint256 now_balance = _balances[recipient];
            if (now_balance + amounts > BatMax) {
                require(false, "BEP20: recipient too many transactions");
            }
        }

        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amounts;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    function _takeFee(
        uint256 _amount,
        uint256 _types,
        address _address
    ) internal returns (uint256 amounts) {
        uint256 amount = _amount;

        uint256 usdtMobilityNums = BEP20(_usdtAddress).balanceOf(_pairAddress);
        uint256 slip_point = 0;
        if (_types == 1) {
            slip_point = sellSlipPoint;
        } else {
            slip_point = buySlipPoint;
        }
        if (usdtMobilityNums >= 5000000 * 10 ** 18) {
            if (_types == 1) {
                slip_point = 5;
            } else {
                slip_point = 1;
            }
        } else if (usdtMobilityNums >= 3000000 * 10 ** 18) {
            if (_types == 1) {
                slip_point = 6;
            } else {
                slip_point = 2;
            }
        } else if (usdtMobilityNums >= 2000000 * 10 ** 18) {
            if (_types == 1) {
                slip_point = 7;
            } else {
                slip_point = 3;
            }
        } else if (usdtMobilityNums >= 1000000 * 10 ** 18) {
            if (_types == 1) {
                slip_point = 8;
            } else {
                slip_point = 4;
            }
        } else if (usdtMobilityNums >= 600000 * 10 ** 18) {
            if (_types == 1) {
                slip_point = 9;
            } else {
                slip_point = 5;
            }
        }
        uint256 profit_amount = amount.mul(slip_point).div(100);
        amounts = amount.sub(profit_amount);
        _balances[address(this)] += profit_amount;
        if (_types == 1) {
            uint256 destroy_profit = profit_amount.mul(10).div(100);
            uint256 buy_pt_num = profit_amount.sub(destroy_profit);
            _transfer(address(this), BatMediumAddress, buy_pt_num);
            uint256 usdt_profit = BatMedium(BatMediumAddress).exchangeUsdt(
                buy_pt_num
            );
            uint256 push_profit = usdt_profit.mul(77).div(100);
            if (push_profit > 0) {
                uint256 surplus_profit = _profit(
                    getLeader(_address),
                    push_profit,
                    1,
                    1,
                    0
                );
                if (surplus_profit > 0) {
                    BEP20(_usdtAddress).transfer(
                        BatFoundationAddress,
                        surplus_profit
                    );
                }
            }

            uint256 community_profit = usdt_profit.sub(push_profit);
            if (community_profit > 0) {
                BEP20(_usdtAddress).transfer(
                    communityAddress,
                    community_profit
                );
            }

            if (destroy_profit > 0) {
                _burn(address(this), destroy_profit);
                destroyNum += destroy_profit;
            }
        } else if (_types == 2) {
            uint256 push_profit = profit_amount.mul(70).div(100);
            if (push_profit > 0) {
                uint256 surplus_profit = _profit(
                    getLeader(_address),
                    push_profit,
                    1,
                    2,
                    0
                );
                if (surplus_profit > 0) {
                    _transfer(
                        address(this),
                        BatFoundationAddress,
                        surplus_profit
                    );
                }
            }

            uint256 community_profit = profit_amount.mul(20).div(100);
            if (community_profit > 0) {
                _transfer(address(this), communityAddress, community_profit);
            }

            uint256 destroy_profit = profit_amount.sub(push_profit).sub(
                community_profit
            );
            if (destroy_profit > 0) {
                _burn(address(this), destroy_profit);
                destroyNum += destroy_profit;
            }
        }
        return amounts;
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        if (
            getLeader(to) == address(0) &&
            amount >= 1 &&
            from != to &&
            from != address(this) &&
            to != address(this) &&
            from != address(0) &&
            to != address(0)
        ) {
            if (_pairAddress != from && _pairAddress != to) {
                bool verify_leader_valid = _verify_leader_valid(to, from);
                if (verify_leader_valid) {
                    directPush[from].push(to);
                    leader[to] = from;
                }
            }
        }
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal {}

    function getLeader(address account) public view returns (address) {
        return leader[account];
    }

    function _verify_leader_valid(
        address from,
        address to
    ) internal view returns (bool) {
        address to_leader = getLeader(to);
        if (to_leader == address(0)) {
            return true;
        }
        if (to_leader == from) {
            return false;
        }
        return _verify_leader_valid(from, to_leader);
    }

    function get_direct_push(
        address account
    ) public view returns (address[] memory) {
        return directPush[account];
    }

    function _profit(
        address account,
        uint256 num,
        uint256 i,
        uint256 types,
        uint256 rewards
    ) internal returns (uint256) {
        if (i <= 9) {
            if (account != address(0)) {
                if (balanceOf(account) >= 1 * 10 ** 11) {
                    address[] memory address_list = get_direct_push(account);
                    uint256 push_valid = 0;
                    for (uint256 iq = 0; iq < address_list.length; iq++) {
                        if (balanceOf(address_list[iq]) >= 1 * 10 ** 11) {
                            push_valid += 1;
                        }
                    }

                    uint256 _profit_ratio = 0;
                    uint256 _profit_num = 0;
                    if (i == 1 && push_valid >= 1) {
                        _profit_ratio = 20;
                    } else if (i == 2 && push_valid >= 2) {
                        _profit_ratio = 10;
                    } else if (i == 3 && push_valid >= 3) {
                        _profit_ratio = 10;
                    } else if (i == 4 && push_valid >= 4) {
                        _profit_ratio = 10;
                    } else if (i == 5 && push_valid >= 5) {
                        _profit_ratio = 10;
                    } else if (i == 6 && push_valid >= 6) {
                        _profit_ratio = 10;
                    } else if (i == 7 && push_valid >= 7) {
                        _profit_ratio = 10;
                    } else if (i == 8 && push_valid >= 8) {
                        _profit_ratio = 10;
                    } else if (i == 9 && push_valid >= 9) {
                        _profit_ratio = 10;
                    }
                    if (_profit_ratio > 0) {
                        _profit_num = num.mul(_profit_ratio).div(100);
                        if (types == 1) {
                            BEP20(_usdtAddress).transfer(account, _profit_num);
                        } else if (types == 2) {
                            if (!systemList[account]) {
                                if (_balances[account] >= BatMax) {
                                    _transfer(
                                        address(this),
                                        BatFoundationAddress,
                                        _profit_num
                                    );
                                } else {
                                    uint256 revenueable = BatMax
                                        .sub(_balances[account])
                                        .sub(1);
                                    if (_profit_num > revenueable) {
                                        _transfer(
                                            address(this),
                                            account,
                                            revenueable
                                        );
                                        _transfer(
                                            address(this),
                                            BatFoundationAddress,
                                            _profit_num.sub(revenueable)
                                        );
                                    } else {
                                        _transfer(
                                            address(this),
                                            account,
                                            _profit_num
                                        );
                                    }
                                }
                            } else {
                                _transfer(address(this), account, _profit_num);
                            }
                        }
                        rewards += _profit_num;
                    }
                    i++;
                    return _profit(getLeader(account), num, i, types, rewards);
                } else {
                    return _profit(getLeader(account), num, i, types, rewards);
                }
            }
        }
        uint256 surplus = num.sub(rewards);
        return surplus;
    }
}