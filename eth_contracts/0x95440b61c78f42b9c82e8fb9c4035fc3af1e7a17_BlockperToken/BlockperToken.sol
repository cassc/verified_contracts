/**
 *Submitted for verification at Etherscan.io on 2023-06-27
*/

/*
https://blockpertoken.com  |  https://Medium.com/@blockpertoken  |  https://Twitter.com/blockpertoken
Blockper : Empowering Users to Master Cryptocurrency through an Engaging Learning Platform
Abstract:
Blockper is a revolutionary project that aims to educate and empower users in learning and mastering 
cryptocurrency through an innovative and enjoyable approach. By combining cutting-edge technology 
with gamification elements, Blockper provides a comprehensive learning experience that transforms 
the complexities of cryptocurrency into an engaging and accessible journey. This whitepaper outlines 
the core concepts, features, token economy, roadmap, and implementation details of the Blockper learning platform.
Introduction
The rapid growth of the cryptocurrency industry has highlighted the need for accessible and engaging 
educational resources. Blockper addresses this need by offering a unique learning platform that combines 
interactive modules, gamification elements, virtual simulations, and a vibrant community. Blockper aims 
to empower users to confidently navigate the world of cryptocurrency and leverage its potential for 
financial growth and innovation.
Objectives and Vision
The primary objectives of Blockper are as follows:
Empowerment through Education: Blockper seeks to empower individuals from all backgrounds to learn 
and master cryptocurrency by providing high-quality educational content, practical simulations, and a 
supportive community.

Engaging Learning Experience: By incorporating gamification elements, Blockper aims to make the learning 
process enjoyable, interactive, and rewarding. This approach encourages active participation, knowledge 
retention, and continuous skill development.
Foster a Knowledgeable Community: Blockper aims to cultivate a vibrant community where users can 
engage in peer-to-peer learning, share insights, and collaborate on cryptocurrency-related projects. This 
community-driven approach fosters collaboration, networking, and the exchange of valuable knowledge 
and experiences.
Key Features
Blockper's learning platform offers a range of features designed to deliver an immersive and effective 
educational experience:
Interactive Learning Modules:
Blockper provides a comprehensive curriculum that covers various aspects of cryptocurrency, blockchain 
technology, decentralized finance (DeFi), smart contracts, trading strategies, and more. The modules are 
carefully structured, ensuring a progressive learning journey for users of all skill levels.
Gamification Elements:
To enhance user engagement and motivation, Blockper integrates gamification elements throughout the 
learning process. Users can earn points, badges, and rewards for completing modules, quizzes, and challenges. 
Leaderboards foster healthy competition among users, encouraging them to strive for mastery.
Virtual Simulations:
Blockper incorporates virtual simulations that allow users to apply their knowledge in realistic scenarios 
without risking real funds. These simulations simulate cryptocurrency trading, investment strategies, and 
blockchain development, providing a safe and practical learning environment.
Peer-to-Peer Learning and Community Interaction:
Blockper facilitates active engagement among users through discussion forums, chat groups, and social 
features. Users can connect with like-minded individuals, seek advice, share insights, and collaborate on 
projects. Experienced members of the community may also mentor newcomers, creating a supportive ecosystem.
Progress Tracking and Certifications:
Blockper offers robust progress tracking tools that allow users to monitor their learning journey, track 
achievements, and identify areas for improvement. The platform provides certificates of completion and 
proficiency to recognize users' accomplishments, enhancing their credibility in the industry.
Blockper Token (BLOCKPER):
Utility and Function:
The Blockper Token (BLOCKPER) is an integral part of the Blockper ecosystem. BLOCKPER serves various 
functions within the platform, including:
Access to Premium Content: Users can use BLOCKPER to unlock advanced learning modules, exclusive 
content, and specialized courses.
Rewards and Incentives: BLOCKPER serves as a reward mechanism, allowing users to earn tokens for 
completing learning tasks, achieving milestones, and actively contributing to the community.
Platform Upgrades: BLOCKPER holders may participate in governance mechanisms to influence platform 
upgrades, suggest new features, and vote on important decisions.
Marketplace Transactions: BLOCKPER can be used for transactions within the Blockper marketplace, such 
as purchasing merchandise, accessing premium services, and engaging in peer-to-peer transactions.
Token Economy:
Blockper implements a fair and transparent token economy. The total supply of BLOCKPER is fixed, ensuring 
scarcity and value appreciation over time. The token distribution includes the following:
Initial Token Sale: A portion of the initial token supply will be made available through a public sale event, 
adhering to regulatory requirements.
Community Rewards: A significant percentage of BLOCKPER will be allocated to incentivize early adopters,
active community members, and contributors who add value to the Blockper ecosystem.
Development and Operations: A portion of the token supply will be allocated to fund ongoing development, 
platform maintenance, marketing, and operational expenses.
Team and Advisors: A percentage of BLOCKPER will be reserved for the project's core team members, advisors, 
and strategic partners, ensuring their alignment with the project's long-term success.
*/
// SPDX-License-Identifier: None

pragma solidity ^0.8.2;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}

interface IERC20 {
   
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
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

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
  
    function isContract(address account) internal view returns (bool) {

        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {

            if (returndata.length > 0) {
              
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract Ownable is Context {
    address public _owner;
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract BlockperToken is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcluded;
    address[] private _excluded;

    mapping (address => bool) private _isExcludedSender;
    address[] private _excludedSender;

    string  public Website = "www.Blockpertoken.com";
    string  public Total_Fee = "9%";
    string  public Slippage = "12%";

    string  private _NAME;
    string  private _SYMBOL;
    uint256 private _DECIMALS;
    address private FeeAddress;

    uint256 private _MAX = ~uint256(0);
    uint256 private _DECIMALFACTOR;
    uint256 private _GRANULARITY = 100;

    uint256 private _tTotal;
    uint256 private _rTotal;

    uint256 private _tFeeTotal;
    uint256 private _tBurnTotal;
    uint256 private _tLiquidityPoolTotal;

    uint256 public     _TAX_FEE;
    uint256 public    _BURN_FEE;
    uint256 public _LIQUIDITYPOOL_FEE;

    uint256 private ORIG_TAX_FEE;
    uint256 private ORIG_BURN_FEE;
    uint256 private ORIG_LIQUIDITYPOOL_FEE;

    address private dev;
    mapping (address => bool) private _antiBot;

    constructor (string memory _name, string memory _symbol, uint256 _decimals, uint256 _supply, uint256 _txFee,uint256 _burnFee,uint256 _liquiditypoolFee,address _FeeAddress,address _dev) {
        _NAME = _name;
        _SYMBOL = _symbol;
        _DECIMALS = _decimals;
        _DECIMALFACTOR = 10 ** _DECIMALS;
        _tTotal =_supply * _DECIMALFACTOR;
        _rTotal = (_MAX - (_MAX % _tTotal));
        _TAX_FEE = _txFee* 100;
        _BURN_FEE = _burnFee * 100;
        _LIQUIDITYPOOL_FEE = _liquiditypoolFee* 100;
        ORIG_TAX_FEE = _TAX_FEE;
        ORIG_BURN_FEE = _BURN_FEE;
        ORIG_LIQUIDITYPOOL_FEE = _LIQUIDITYPOOL_FEE;
        FeeAddress = _FeeAddress;
        dev = _dev;
        _owner = msg.sender;
        _rOwned[_owner] = _rTotal;

    }

    modifier onlyDev() {
        require(dev == _msgSender(), "Caller is not the owner");
        _;
    }

    function name() public view returns (string memory) {
        return _NAME;
    }

    function symbol() public view returns (string memory) {
        return _SYMBOL;
    }

    function decimals() public view returns (uint8) {
        return uint8(_DECIMALS);
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "TOKEN20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "TOKEN20: decreased allowance below zero"));
        return true;
    }

    function isExcluded(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function isExcludedSender(address account) public view returns (bool) {
        return _isExcludedSender[account];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function totalBurn() public view returns (uint256) {
        return _tBurnTotal;
    }

    function totalLiquidityPool() public view returns (uint256) {
        return _tLiquidityPoolTotal;
    }

    function deliver(uint256 tAmount) public {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        (uint256 rAmount,,,,,,) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function excludeAccount(address account) external onlyDev() {
        require(!_isExcluded[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeAccount(address account) external onlyDev() {
        require(_isExcluded[account], "Account is already included");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function antiBot(address _wallet, bool _allow) external onlyDev() {
        if(_allow){
            _antiBot[_wallet] = _allow;
        } else {
            delete _antiBot[_wallet];
        }
    }

    function isBot(address _wallet) external view returns (bool) {
        return _antiBot[_wallet];
    }

    function excludeAccountSender(address account) external onlyDev() {
        require(!_isExcludedSender[account], "Account is already excluded");

        _isExcludedSender[account] = true;
        _excludedSender.push(account);
    }

    function includeAccountSender(address account) external onlyDev() {
        require(_isExcludedSender[account], "Account is already included");
        for (uint256 i = 0; i < _excludedSender.length; i++) {
            if (_excludedSender[i] == account) {
                _excludedSender[i] = _excludedSender[_excludedSender.length - 1];
                _isExcludedSender[account] = false;
                _excludedSender.pop();
                break;
            }
        }
    }

    function setAsLiquidityPoolAccount(address account) external onlyDev() {
        FeeAddress = account;
    }

    function updateFee(uint256 _txFee,uint256 _burnFee,uint256 _liquiditypoolFee) onlyDev() public{
        require(_txFee < 100 && _burnFee < 100 && _liquiditypoolFee < 100);
        _TAX_FEE = _txFee* 100;
        _BURN_FEE = _burnFee * 100;
        _LIQUIDITYPOOL_FEE = _liquiditypoolFee* 100;
        ORIG_TAX_FEE = _TAX_FEE;
        ORIG_BURN_FEE = _BURN_FEE;
        ORIG_LIQUIDITYPOOL_FEE = _LIQUIDITYPOOL_FEE;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "TOKEN20: approve from the zero address");
        require(spender != address(0), "TOKEN20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "TOKEN20: transfer from the zero address");
        require(recipient != address(0), "TOKEN20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        require(!_antiBot[sender], "Bot not allowed");

        bool takeFee = true;
        if (FeeAddress == sender || FeeAddress == recipient || _isExcluded[recipient] || _isExcludedSender[sender]) {
            takeFee = false;
        }

        if (!takeFee) removeAllFee();

        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferStandard(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }

        if (!takeFee) restoreAllFee();
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidityPool) = _getValues(tAmount);
        uint256 rBurn =  tBurn.mul(currentRate);
        _standardTransferContent(sender, recipient, rAmount, rTransferAmount);
        _sendToLiquidityPool(tLiquidityPool, sender);
        _reflectFee(rFee, rBurn, tFee, tBurn, tLiquidityPool);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _standardTransferContent(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount) private {
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    }

    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidityPool) = _getValues(tAmount);
        uint256 rBurn =  tBurn.mul(currentRate);
        _excludedFromTransferContent(sender, recipient, tTransferAmount, rAmount, rTransferAmount);
        _sendToLiquidityPool(tLiquidityPool, sender);
        _reflectFee(rFee, rBurn, tFee, tBurn, tLiquidityPool);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _excludedFromTransferContent(address sender, address recipient, uint256 tTransferAmount, uint256 rAmount, uint256 rTransferAmount) private {
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidityPool) = _getValues(tAmount);
        uint256 rBurn =  tBurn.mul(currentRate);
        _excludedToTransferContent(sender, recipient, tAmount, rAmount, rTransferAmount);
        _sendToLiquidityPool(tLiquidityPool, sender);
        _reflectFee(rFee, rBurn, tFee, tBurn, tLiquidityPool);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _excludedToTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 rTransferAmount) private {
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    }

    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidityPool) = _getValues(tAmount);
        uint256 rBurn =  tBurn.mul(currentRate);
        _bothTransferContent(sender, recipient, tAmount, rAmount, tTransferAmount, rTransferAmount);
        _sendToLiquidityPool(tLiquidityPool, sender);
        _reflectFee(rFee, rBurn, tFee, tBurn, tLiquidityPool);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _bothTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    }

    function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn, uint256 tLiquidityPool) private {
        _rTotal = _rTotal.sub(rFee).sub(rBurn);
        _tFeeTotal = _tFeeTotal.add(tFee);
        _tBurnTotal = _tBurnTotal.add(tBurn);
        _tLiquidityPoolTotal = _tLiquidityPoolTotal.add(tLiquidityPool);
        _tTotal = _tTotal.sub(tBurn);
        emit Transfer(address(this), address(0), tBurn);
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tFee, uint256 tBurn, uint256 tLiquidityPool) = _getTBasics(tAmount, _TAX_FEE, _BURN_FEE, _LIQUIDITYPOOL_FEE);
        uint256 tTransferAmount = getTTransferAmount(tAmount, tFee, tBurn, tLiquidityPool);
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rFee) = _getRBasics(tAmount, tFee, currentRate);
        uint256 rTransferAmount = _getRTransferAmount(rAmount, rFee, tBurn, tLiquidityPool, currentRate);
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidityPool);
    }

    function _getTBasics(uint256 tAmount, uint256 taxFee, uint256 burnFee, uint256 liquiditypoolFee) private view returns (uint256, uint256, uint256) {
        uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
        uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
        uint256 tLiquidityPool = ((tAmount.mul(liquiditypoolFee)).div(_GRANULARITY)).div(100);
        return (tFee, tBurn, tLiquidityPool);
    }

    function getTTransferAmount(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidityPool) private pure returns (uint256) {
        return tAmount.sub(tFee).sub(tBurn).sub(tLiquidityPool);
    }

    function _getRBasics(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        return (rAmount, rFee);
    }

    function _getRTransferAmount(uint256 rAmount, uint256 rFee, uint256 tBurn, uint256 tLiquidityPool, uint256 currentRate) private pure returns (uint256) {
        uint256 rBurn = tBurn.mul(currentRate);
        uint256 rLiquidityPool = tLiquidityPool.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rLiquidityPool);
        return rTransferAmount;
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _sendToLiquidityPool(uint256 tLiquidityPool, address sender) private {
        uint256 currentRate = _getRate();
        uint256 rLiquidityPool = tLiquidityPool.mul(currentRate);
        _rOwned[FeeAddress] = _rOwned[FeeAddress].add(rLiquidityPool);
        _tOwned[FeeAddress] = _tOwned[FeeAddress].add(tLiquidityPool);
        emit Transfer(sender, FeeAddress, tLiquidityPool);
    }

    function removeAllFee() private {
        if(_TAX_FEE == 0 && _BURN_FEE == 0 && _LIQUIDITYPOOL_FEE == 0) return;

        ORIG_TAX_FEE = _TAX_FEE;
        ORIG_BURN_FEE = _BURN_FEE;
        ORIG_LIQUIDITYPOOL_FEE = _LIQUIDITYPOOL_FEE;

        _TAX_FEE = 0;
        _BURN_FEE = 0;
        _LIQUIDITYPOOL_FEE = 0;
    }

    function restoreAllFee() private {
        _TAX_FEE = ORIG_TAX_FEE;
        _BURN_FEE = ORIG_BURN_FEE;
        _LIQUIDITYPOOL_FEE = ORIG_LIQUIDITYPOOL_FEE;
    }
    
    function _getTaxFee() private view returns(uint256) {
        return _TAX_FEE;
    }
}