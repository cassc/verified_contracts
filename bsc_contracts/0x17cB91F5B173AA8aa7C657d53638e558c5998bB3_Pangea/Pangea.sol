/**
 *Submitted for verification at BscScan.com on 2023-02-10
*/

/*  
 
* SPDX-License-Identifier: None
*/
pragma solidity 0.8.17;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
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

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface ICCVRF {
    function requestRandomness(uint256 requestID, uint256 howManyNumbers) external payable;
}

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IDEXRouter {
   function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(address token,uint amountTokenDesired,uint amountTokenMin,uint amountETHMin,address to,uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;
    
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function getAmountsOut(
            uint256 amountIn,
            address[] calldata path
    ) external view returns (uint256[] memory amounts);
}

interface IDEXPair {
    function sync() external;
}

contract Pangea is IBEP20, Ownable {
    string constant _name = "PanTest";
    string constant _symbol = "$PanTest";
    uint8 constant _decimals = 9;
    uint256 _totalSupply = 1_000_000 * (10**_decimals);
    uint256 circulatingSupplyLimit = 1_000 * (10**_decimals); 

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public addressWithoutLimits;

    bool public enabled = false;
    
    uint256 public tax = 3;
    uint256 public liq = 0;
    uint256 public marketing = 0;
    uint256 public jackpot = 3;

    uint256 public jackpotBalance;   
    uint256 public maxJackpotBalanceBeforeDistribute = 2 ether;
    uint256 public minBuy = 0.001 ether;

    uint256 public launchTime = type(uint256).max;
    
    bool public jackpotWillBeDistributed;
    bool public winnersHaveBeenChosen;

    bool public payJackpotInToken = true;
    uint256 public totalJackpotPayouts;

    bool private isSwapping;
    uint256 public swapTokensAtAmount = 0 * (10**_decimals);
    uint256 public maxWallet = 20_000 * (10**_decimals);
    
    ICCVRF public randomnessSupplier = ICCVRF(0xC0de0aB6E25cc34FB26dE4617313ca559f78C0dE);
    mapping (uint256 => bool) public nonceProcessed;
    uint256 public vrfCost = 0.002 ether;
    uint256 public nonce;

    IDEXRouter public router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    address public marketingWallet = 0x7299336E094dd0f5a74f6bdCbfE7fECc401b81C4;

    address public pair;
    address public constant WETH = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address public constant ZERO = 0x0000000000000000000000000000000000000000;
    
    address[] public allBuysSinceLastJackpot;
    address[] private pathForBuyingJackpot = new address[](2);
    address[] private pathForSelling = new address[](2);
    address[] private pathForBuying = new address[](2);
    address[] private pathFromBNBToBUSD = new address[](2);

    struct Token {
        IBEP20 contractAddress;
        uint256 percentage;
        bool active;
    }    
    
    mapping(address => bool) public permitedTokens;    
    
    Token[] public tokens;

    struct Winners{
        uint256 round;
        address winner;
        uint256 prize;
    }

    Winners[] public winners;
    address[] public winnersOfCurrent;

    modifier contractSelling() {isSwapping = true; _; isSwapping = false;}
    modifier onlyVRF() {if(msg.sender != address(randomnessSupplier)) return; _;}

    event Winner(address winner, uint256 tokensWon);

    constructor() {
        pathForBuyingJackpot[0] = WETH;

        
        pathForSelling[0] = address(this);
        pathForSelling[1] = WETH;
        
        pathForBuying[0] = WETH;
        pathForBuying[1] = address(this);

        pathFromBNBToBUSD[0] = WETH;
        pathFromBNBToBUSD[1] = BUSD;
        
        pair = IDEXFactory(IDEXRouter(router).factory()).createPair(WETH, address(this));
        _allowances[address(this)][address(router)] = type(uint256).max;

        addressWithoutLimits[msg.sender] = true;
        addressWithoutLimits[address(this)] = true;     

        tokens.push(Token({contractAddress: IBEP20(0x68F483B06F1E96B10239e333b598f145Da8571c2), percentage: 50, active: true}));
        tokens.push(Token({contractAddress: IBEP20(0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c), percentage: 50, active: true}));
        permitedTokens[0x68F483B06F1E96B10239e333b598f145Da8571c2] = true;
        permitedTokens[0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c] = true;        
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}
    function name() public pure override returns (string memory) {return _name;}
    function totalSupply() public view override returns (uint256) {return _totalSupply;}
    function decimals() public pure override returns (uint8) {return _decimals;}
    function symbol() public pure override returns (string memory) {return _symbol;}
    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
    function allowance(address holder, address spender) public view override returns (uint256) {return _allowances[holder][spender];}
    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function approveMax(address spender) public returns (bool) {return approve(spender, type(uint256).max);}
    function transfer(address recipient, uint256 amount) external override returns (bool) {return _transferFrom(msg.sender, recipient, amount);}
    function circulatingSupply() public view returns(uint256) {return _totalSupply - _balances[DEAD] - _balances[ZERO];}

    function transferFrom(address sender, address recipient, uint256 amount ) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            require(_allowances[sender][msg.sender] >= amount, "Insufficient Allowance");
            _allowances[sender][msg.sender] -= amount;
        }
        
        return _transferFrom(sender, recipient, amount);
    }

    function conditionsToSwapAreMet(address sender) internal view returns (bool) {
        return sender != pair && _balances[address(this)] > swapTokensAtAmount;
    }
    
    function _transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        if(addressWithoutLimits[sender]|| addressWithoutLimits[recipient]) return _basicTransfer(sender, recipient, amount);

        if(recipient != address(this) &&  recipient != address(router) && recipient != address(pair) && recipient != address(owner())) {
            uint256 balanceReciver = balanceOf(recipient);
            require(balanceReciver + amount <= maxWallet, "Exceeds maximum wallet token amount." );
        }
        
        if(isSwapping == true) return _lowGasTransfer(sender, recipient, amount);
        
        require(enabled, "Trading not live yet");
   
        if(winnersHaveBeenChosen && jackpotWillBeDistributed) distributeJackpot();
        
        if(sender == pair && bigEnoughBuy(amount)){
            allBuysSinceLastJackpot.push(recipient);
        }

        // if we have enough tokens, let's sell them for jackpot, marketing and liquidity
        if (conditionsToSwapAreMet(sender)) letTheContractSell();
       
       
        
        // calculate effective amount that get's transferred
        uint256 finalamount = takeTax(sender, recipient, amount);
            
             

        // do the transfer
        return _basicTransfer(sender, recipient, finalamount);
    }

    function takeTax(address sender, address recipient, uint256 amount) internal returns (uint256) {
        // tax free for wallet to wallet
        if(sender != pair && recipient != pair) return amount;

        
        uint256 taxAmount = amount * tax / 100;


        if (taxAmount > 0) _lowGasTransfer(sender, address(this), taxAmount);
        return amount - taxAmount;
    }

    function _basicTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        if(recipient == DEAD && circulatingSupply() - amount < circulatingSupplyLimit) amount = circulatingSupply() - circulatingSupplyLimit;
        
        return _lowGasTransfer(sender, recipient, amount);
    }

    function _lowGasTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function letTheContractSell() internal {
        uint256 tokensThatTheContractWillSell = _balances[address(this)] * (tax - liq) / tax;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokensThatTheContractWillSell,
            0,
            pathForSelling,
            address(this),
            block.timestamp
        );

        // adding tokens to liquidity pool
        if(_balances[address(this)] > 0){
            _lowGasTransfer(address(this), pair, _balances[address(this)]);
            IDEXPair(pair).sync();
        }
       
        // dividing the BNB between marketing and jackpot
        uint256 contractBalanceWithoutJackpot = address(this).balance - jackpotBalance;
        payable(marketingWallet).transfer(contractBalanceWithoutJackpot * marketing / tax);
        jackpotBalance += contractBalanceWithoutJackpot * jackpot / tax;

        if(jackpotBalanceInBUSD() > maxJackpotBalanceBeforeDistribute) drawWinnersOfJackpotDistribution();
    }

    function bigEnoughBuy(uint256 amount) public view returns (bool) {
        if (minBuy == 0) return true;
        uint256 tokensOut = router.getAmountsOut(minBuy, pathForBuying)[1] * 9975 / 10000; 
        return amount >= tokensOut;
    }

    function jackpotBalanceInBUSD() public view returns (uint256) {
        if(jackpotBalance == 0) return 0;
        return router.getAmountsOut(jackpotBalance, pathFromBNBToBUSD)[1];
    }

    function getTokens() public view returns(Token[] memory) {
        return tokens;
    }

    function getPayoutTokens() public view returns (Token[] memory) {
        uint length = getTokens().length;
        Token[] memory result = new Token[](length);
        for (uint256 index; index < length; index++) {
                result[index] = Token({
                        contractAddress: IBEP20(getTokens()[index].contractAddress), 
                        percentage: getTokens()[index].percentage, 
                        active: getTokens()[index].active
                });
         }
         return result;
    }


/////////////////// ADMIN FUNCTIONS ///////////////////////////////////////////////////////////////////////
    function launch() external onlyOwner {
        require(enabled == false, "Already Live");
        enabled = !enabled;
        launchTime = block.timestamp;
    }

    // set max wallet, can not be lower than 0.1% of supply
    function setmaxWallet(uint256 value) external onlyOwner {
        value = value * (10**9);
        require(value >= _totalSupply / 1000, "max wallet cannot be set to less than 0.1%");
        maxWallet = value;
    }      
    
    function updatePayJackpotInToken(bool value) external onlyOwner {
        payJackpotInToken = value;
    }
    
    function setMinBuy(uint256 value) external onlyOwner {
        minBuy = value * 1 ether;
    }
    
    function setPermitedToken(address _tokenAddress, bool _active) external onlyOwner { 
        permitedTokens[_tokenAddress] = _active;
    }    
    
    function addtokenOptions(address[] memory _contractAddress, uint[] memory _percentage, bool[] memory _active) public onlyOwner {
         uint totalPercentage; 
         uint counter = tokens.length; 
         

         for(uint256 i = 0; i < _contractAddress.length; i++) {
                 tokens.push(Token({
                     contractAddress: IBEP20(_contractAddress[i]),
                     percentage: _percentage[i],
                     active: _active[i]
                 }));
         }
         if(counter > 0) {
             for(uint256 i = 0; i < counter; i++ ){
                totalPercentage = totalPercentage + tokens[i].percentage;
                if(totalPercentage > 100) revert();
             }
         }
    }

    function updateRewardTokenState(uint index, bool _active, uint256 _percentage) public  onlyOwner {
            require(_percentage < 100, "Percentage cannot be grater then 100");
            require(tokens.length > index, "Token: Out of bounds");
            uint totalPercentage = 0; 
            uint counter = tokens.length; 
            if(counter > 0) {
                for(uint256 i = 0; i< counter; i++ ){
                    totalPercentage = totalPercentage + tokens[i].percentage;
                    if(totalPercentage + _percentage > 100) revert();
                }
            }
            tokens[index].active = _active;
            tokens[index].percentage = _percentage;
    }

    function removeTokenOptions(uint index) public onlyOwner  {
            require(tokens.length > index, "BEP20: Out of bounds");
            for (uint256 i = index; i < tokens.length - 1; i++) {
                tokens[i] = tokens[i+1];
            }
            tokens.pop();
    }    
    
    function makeContractSell() external onlyOwner {
        letTheContractSell();
    }

    function addBNBToJackpotManually() external payable {
        if (msg.value > 0) jackpotBalance += msg.value;
    }

    function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner {
        for (uint256 i = 0; i < airdropWallets.length; i++) {
            _basicTransfer(msg.sender, airdropWallets[i], amount[i] * (10**_decimals));
        }
    }

    function setJackpotSettings(

        uint256 _maxJackpotBalanceBeforeDistribute
    ) external onlyOwner {
        maxJackpotBalanceBeforeDistribute = _maxJackpotBalanceBeforeDistribute * 1 ether;

    }

    function setContractSells(uint256 minAmountOfTokensToSell) external onlyOwner{
        swapTokensAtAmount = minAmountOfTokensToSell * (10 ** _decimals);
    }

    function setWallets(address marketingAddress) external onlyOwner {
        marketingWallet = marketingAddress;
    }

    function setTax(uint256 newLiq, uint256 newMarketing, uint256 newJackpot) external onlyOwner {
        liq = newLiq;
        marketing = newMarketing;
        jackpot = newJackpot;
        tax = liq + marketing + jackpot;
        require(tax <= 5, "Tax limited to max 5%");
    }

    function setAddressWithoutLimits(address unlimitedAddress, bool status) external onlyOwner {
        addressWithoutLimits[unlimitedAddress] = status;
    }

    function rescueAnyToken(address token) external onlyOwner {
        require(token != address(this), "Can't rescue Pangea");
        IBEP20(token).transfer(msg.sender, IBEP20(token).balanceOf(address(this)));
    }

    function drawWinnersOfJackpotDistribution() internal {
        jackpotWillBeDistributed = true;
        randomnessSupplier.requestRandomness{value: vrfCost}(nonce, 1);
        jackpotBalance -= vrfCost;
    }

    function supplyRandomness(uint256 _nonce, uint256[] memory randomNumbers) external onlyVRF {
        if(nonceProcessed[_nonce]) {
            if(winnersOfCurrent[0] == address(0)) winnersOfCurrent[0] = allBuysSinceLastJackpot[(randomNumbers[0] % allBuysSinceLastJackpot.length)];
        } else{
            nonceProcessed[_nonce] = true;
            winnersOfCurrent.push(allBuysSinceLastJackpot[(randomNumbers[0] % allBuysSinceLastJackpot.length)]);
        }

        if(!bigEnoughBuy(_balances[winnersOfCurrent[0]])) winnersOfCurrent[0] = address(0);
        
        if(winnersOfCurrent[0] == address(0)) {
            randomnessSupplier.requestRandomness{value: vrfCost}(_nonce, 1);
            jackpotBalance -= vrfCost;
        } else {
            winnersHaveBeenChosen = true;
            delete allBuysSinceLastJackpot;
        }
    }

    function distributeJackpot() internal {
        uint256 carryOver = jackpotBalance / 100;
        jackpotBalance = jackpotBalance - carryOver;

        if(!payJackpotInToken) {
            payable(winnersOfCurrent[0]).transfer(jackpotBalance);
            jackpotBalance = 0;
            jackpotWillBeDistributed = false;
            winnersHaveBeenChosen = false;
        } else {
            buyBacks();
            totalJackpotPayouts++;
        }
        delete winnersOfCurrent;
        jackpotBalance = carryOver;
        jackpotWillBeDistributed = false;
        winnersHaveBeenChosen = false;
        nonce++;
    }

    function buyBacks() internal {
             address[] memory path = new address[](2);
             uint deadline = block.timestamp;
             for(uint256 i = 0; i < tokens.length; i++) {
                  path[0] = WETH;
                  path[1] = address(tokens[i].contractAddress);
                  uint buyAmount = jackpotBalance * tokens[i].percentage / 100;
                  if(tokens[i].active == true)  try router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: buyAmount}(0, path, winnersOfCurrent[0], deadline) { continue; } catch { revert(); }
            }
    }

}