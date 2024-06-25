// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./NftMain.sol";

/*
  ____            _   _       _                   _        ___  
 | __ )   _   _  (_) | |   __| |   ___   _ __    / |      / _ \ 
 |  _ \  | | | | | | | |  / _` |  / _ \ | '__|   | |     | | | |
 | |_) | | |_| | | | | | | (_| | |  __/ | |      | |  _  | |_| |
 |____/   \__,_| |_| |_|  \__,_|  \___| |_|      |_| (_)  \___/ 
                                                     Tokenbank
 ______    ____       ______      __  __      __  __     
/\__  _\  /\  _`\    /\  _  \    /\ \/\ \    /\ \/\ \    
\/_/\ \/  \ \ \L\ \  \ \ \L\ \   \ \ `\\ \   \ \ \/'/'   
   \ \ \   \ \  _ <'  \ \  __ \   \ \ , ` \   \ \ , <    
    \ \ \   \ \ \L\ \  \ \ \/\ \   \ \ \`\ \   \ \ \\`\  
     \ \_\   \ \____/   \ \_\ \_\   \ \_\ \_\   \ \_\ \_\
      \/_/    \/___/     \/_/\/_/    \/_/\/_/    \/_/\/_/

   /\   /\   
  //\\_//\\     ____      🦊✅ 
  \_     _/    /   /      🦊✅ 
   / * * \    /^^^]       🦊✅ 
   \_\O/_/    [   ]       🦊✅ 
    /   \_    [   /       🦊✅ 
    \     \_  /  /        🦊✅ 
     [ [ /  \/ _/         🦊✅ 
    _[ [ \  /_/    

*/
contract BuilderNFT is Ownable, Authorized {

  NftMain public tokenNFT;
  uint256 public _price;
  address public _adminWallet;

  //start
  constructor() {
  }
  
  //receiver
  receive() external payable {}

  // Admin
  function getPrice() public view returns (uint256) { return _price; }
  function setPrice(uint256 price) public isAuthorized(0) { 
    _price = price; 
  }
  function setAdminWallet(address adminWallet) public isAuthorized(0) { 
    _adminWallet = adminWallet;
  }

  //Send to constructor queue Builder Token
  function sendToQueue(
      address marketplaceAddress_,
      address propWallet_,
      string memory name_,
      string memory symbol_
      ) payable external returns (address) {

      //require (msg.value == 50000000000000000);
      require (msg.value == _price,"No pay");


      payable(_adminWallet).transfer(address(this).balance);

      // PAYYYY
    //IERC20(_Tbank).transferFrom(msg.sender, address(this), amount);

    // Building contract
    tokenNFT = new NftMain(marketplaceAddress_, propWallet_, name_, symbol_);

    return address(tokenNFT);

  }

  function safeOtherTokens(address token, address payable receiv, uint amount) external isAuthorized(0) {
    if(token == address(0)) { receiv.transfer(amount); } else { IERC20(token).transfer(receiv, amount); }
  }


  

}