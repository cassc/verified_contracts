/**
 *Submitted for verification at BscScan.com on 2022-09-25
*/

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

// email: [email protected]

abstract contract Owned {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event OwnerUpdated(address indexed user, address indexed newOwner);

    /*//////////////////////////////////////////////////////////////
                            OWNERSHIP STORAGE
    //////////////////////////////////////////////////////////////*/

    address public owner;

    modifier onlyOwner() virtual {
        require(msg.sender == owner, "UNAUTHORIZED");

        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        owner = msg.sender;
        emit OwnerUpdated(address(0), msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                             OWNERSHIP LOGIC
    //////////////////////////////////////////////////////////////*/

    function setOwner(address newOwner) public virtual onlyOwner {
        owner = newOwner;
        emit OwnerUpdated(msg.sender, newOwner);
    }
}

contract ExcludedFromFeeList is Owned {
    mapping(address => bool) internal _isExcludedFromFee;

    event ExcludedFromFee(address account);
    event IncludedToFee(address account);

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
        emit ExcludedFromFee(account);
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
        emit IncludedToFee(account);
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router {
    function factory() external pure returns (address);
}

abstract contract DexBase {
    address public immutable uniswapV2Pair;
    address public constant USDT = 0x55d398326f99059fF775485246999027B3197955;

    constructor() {
        IUniswapV2Router uniswapV2Router = IUniswapV2Router(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        );
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
                address(this),
                USDT
            );
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}

abstract contract ERC20 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /*//////////////////////////////////////////////////////////////
                            METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    string public name;

    string public symbol;

    uint8 public immutable decimals;

    /*//////////////////////////////////////////////////////////////
                              ERC20 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    /*//////////////////////////////////////////////////////////////
                               ERC20 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 amount)
        public
        virtual
        returns (bool)
    {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        returns (bool)
    {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max)
            allowance[from][msg.sender] = allowed - amount;

        _transfer(from, to, amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        balanceOf[from] -= amount;
        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }
        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}

abstract contract MarketFee is Owned, DexBase, ERC20 {
    address public constant communityAddr =
        0xf1d6Bf21b77371dA72c05B6a8e5D112C5Ec10D10;
    address public constant fundAddr =
        0xf48CCc024335145379D9fCDEBe10C505FF3D70B1;
    address public constant devAddr =
        0xBCCc55d2059Ed457b83153746Cc449996Bd97c1C;
    address constant DEAD = 0x000000000000000000000000000000000000dEaD;

    uint256 constant communityBuyFee = 2;
    uint256 constant fundBuyFee = 2;
    uint256 constant inviterBuyFee = 2;

    uint256 constant communitySellFee = 5;
    uint256 constant fundSellFee = 2;
    uint256 constant burnSellFee = 2;

    mapping(address => address) public inviter;

    function _takeMarketing(
        address sender,
        uint256 amount,
        address recipient
    ) internal returns (uint256) {
        // sell
        if (recipient == uniswapV2Pair) {
            uint256 communityAmount = (amount * communitySellFee) / 100;
            uint256 fundAmount = (amount * fundSellFee) / 100;
            uint256 burnAmount = (amount * burnSellFee) / 100;

            super._transfer(sender, communityAddr, communityAmount);
            super._transfer(sender, fundAddr, fundAmount);
            super._transfer(sender, DEAD, burnAmount);
            return communityAmount + fundAmount + burnAmount;
        } else if (sender == uniswapV2Pair) {
            // buy
            uint256 communityAmount = (amount * communityBuyFee) / 100;
            uint256 fundAmount = (amount * fundBuyFee) / 100;

            uint256 inviterAmount = (amount * inviterBuyFee) / 100;

            super._transfer(sender, devAddr, communityAmount);
            super._transfer(sender, fundAddr, fundAmount);

            address cur = recipient;
            cur = inviter[cur];
            if (cur == address(0)) {
                cur = devAddr;
            }
            super._transfer(sender, cur, inviterAmount);

            return communityAmount + fundAmount + inviterAmount;
        } else {
            uint256 devAmount = (amount * 6) / 100;
            super._transfer(sender, devAddr, devAmount);

            return devAmount;
        }
    }
}

contract WHN_Token is ExcludedFromFeeList, MarketFee {
    constructor() ERC20("WHN", "WHN", 18) MarketFee() {
        _mint(msg.sender, 16 * 1000_0000 * 1e18);
        excludeFromFee(msg.sender);
        excludeFromFee(address(this));
    }

    function shouldTakeFee(address sender, address recipient)
        internal
        view
        returns (bool)
    {
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
            return false;
        }
        return true;
    }

    function takeFee(
        address sender,
        uint256 amount,
        address recipient
    ) internal returns (uint256) {
        uint256 marketingAmount = _takeMarketing(sender, amount, recipient);
        return amount - marketingAmount;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        bool shouldInvite = (balanceOf[recipient] == 0 &&
            inviter[recipient] == address(0) &&
            !isContract(sender) &&
            !isContract(recipient));

        if (shouldTakeFee(sender, recipient)) {
            if (recipient == uniswapV2Pair && amount == balanceOf[sender]) {
                amount = (amount * 9) / 10;
            }
            uint256 transferAmount = takeFee(sender, amount, recipient);
            super._transfer(sender, recipient, transferAmount);
        } else {
            super._transfer(sender, recipient, amount);
        }

        if (shouldInvite) {
            inviter[recipient] = sender;
        }
    }
}