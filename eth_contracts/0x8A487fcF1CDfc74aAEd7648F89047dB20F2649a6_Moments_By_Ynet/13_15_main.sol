// SPDX-License-Identifier: MIT



pragma solidity ^0.8.9;

import "./counters.sol";
import "./IERC721.sol";
import "./IERC1155.sol";
import "./strings.sol";
import "./AbstractERC1155Factory.sol";



/*
* @title ERC1155 ExoticLife
* @author Exotic Technology
*/
contract Moments_By_Ynet is AbstractERC1155Factory {
      
    
    struct cover {
        uint id;
        uint maxToken;
        
    }

    

    cover[] covers;

    bool public saleActive =false;

    bool public ownerMint = true;

    bool public paperMint = true;

    mapping(address => bool) private senders;

    uint public salePrice  =0;

    uint public MAX_PUBLIC_MINT  = 1;

    mapping(address => bool) private paperAddresses;

    mapping(uint256 => bool) private paperMints;

    event minted(uint256 indexed index, address indexed account, uint256 amount);

    constructor(
      
         
    ) ERC1155("ipfs://QmVCgVPjzt8LQ19g98LcvGTH9YMP9TxnBeFqRpinYXTUmB/") {
        name_ = "Moments By Ynet";
        symbol_ = "MBY";


        senders[msg.sender] = true; // add owner

        // add 3 tokens with 1 copy each
        for(uint i=0; i<3; i++){
            addToken(1);
        }

    }

              // onlyPaper modifier 
    modifier onlyPaper() {
       
        require(paperAddresses[_msgSender()], "Failed to verify address");
        _;
    }

    


    function getPaperMint(uint _id)public view returns (bool){
         require(_id <= covers.length ,"out of bounds");
         return paperMints[_id];
    }

    function updateSalePrice(uint _price) external {
        require(senders[_msgSender()]);

        salePrice = _price;
    }

    function updatePaperAddress(address _address, bool _val) external {
        require(senders[_msgSender()]);

        paperAddresses[_address] = _val;
    }


    function updateMaxPublicMint(uint _max) external{
        require(senders[_msgSender()]);

        MAX_PUBLIC_MINT = _max;
    }


    function flipSaleState() external{
        require(senders[_msgSender()]);

        saleActive = !saleActive;
    }

    function flipOwnerMint() external{
        require(senders[_msgSender()]);

        ownerMint = !ownerMint;
    }

    function flipPaperMint() external{
        require(senders[_msgSender()]);

        paperMint = !paperMint;
    }


    function addSender(address _address) external onlyOwner  {
        
        require(_address != address(0));
        senders[_address] = true;
       
    }
    
    function removeSender(address _address) external onlyOwner {
        require(_address != address(0));
        senders[_address] = false;
        
    }

    

   function addToken(uint _max)public  {

       require(senders[_msgSender()]);

       require(_max >0,"cannot be 0");

       uint x = covers.length;
       covers.push(cover(x,_max));

   }

   function updateTokenSupply(uint _id, uint _supply)external {
       require(senders[_msgSender()]);

       require(covers.length > 0,"no tokens");
       require(_id <= covers.length,"out of bounds");
       uint x = totalSupply(_id);
       require(_supply >= x,"already passed");

       covers[_id].maxToken = _supply;
       

   }

   function confirmMint(uint _id, uint _amount)private view returns(bool){
       
       require(_amount>0,"zero");
       require(covers.length > 0,"no tokens");
       require(_id <= covers.length,"out of bounds");
       
       uint ts = totalSupply(_id);
       uint max =  covers[_id].maxToken;
       require(ts + _amount <= max,"max");

       return true;
   }

    function auctionMint(address _to, uint _id, uint _amount) external  payable{
        
        if(ownerMint){
            require(senders[_msgSender()],"only owner");
        }
        else{
            require(saleActive,"closed");
            require(salePrice * (_amount) <= msg.value, "Ether");
        }
        
        
        require(confirmMint(_id, _amount),"confirm");
       
        _mint(_to, _id, _amount, "");


    }

        // paper
    function checkClaimEligibility(uint _token, uint quantity) external view returns (string memory){
             uint ts = totalSupply(_token);
             uint max =  covers[_token].maxToken;
             

        if (!saleActive) {
            return "not live yet";
        } else if (quantity > MAX_PUBLIC_MINT) {
            return "max mint amount per transaction exceeded";
        } else if (ts + quantity > max) {
            return "not enough supply";
        }
        return "";
        }

    // paper mint
    function mintTo(uint _id,address recipient, uint256 quantity) public payable 
    onlyPaper(){
        
        require(paperMint,"closed");
        require(salePrice * (quantity) <= msg.value, "Ether");
        require(confirmMint(_id, quantity),"confirm");

        paperMints[_id]=true;

        _mint(recipient, _id, quantity, "");

        
    
    }


    function withdraw(address _beneficiary) public onlyOwner {
        uint balance = address(this).balance;
        payable(_beneficiary).transfer(balance);
    }

    function getTotalCover()public view returns(uint){
        
        
        return covers.length;
    }

    function getTokenSupply(uint _id)public view returns (uint){
        require(covers.length > 0,"no tokens");
        uint i = covers[_id].maxToken;
        return i;
    }



    /**
    * @notice returns the metadata uri for a given id
    *
    * @param _id the card id to return metadata for
    */
    function uri(uint256 _id) public view override returns (string memory) {
            require(exists(_id), "URI: nonexistent token");

            return string(abi.encodePacked(super.uri(_id), Strings.toString(_id)));
    }
}


/*
                                                                                                                                                     
                                                                                
                               %%%%%*       /%%%%*                              
                         %%%                         %%                         
                     .%%                                 %%                     
                   %%                                       %                   
                 %%                                           %                 
               %%                                               %               
             .%     @@@@@@@@@@@@@@@@@@@@@               @@@@                    
            %%      @@@                @@@             @@@         ,            
            %       @@@                  @@@         @@@                        
           %%       &&&                   &@@@     @@@              %           
           %        &&&                     @@@@ @@@                            
          ,%        &&&&&&&&&&&&&&&&&&&%%(.   @@@@@                             
           %        %%%                      @@@@@@@                            
           %        %%%                    @@@@   @@@@                          
           %%       %%%                  @@@@       @@@             %           
            %%      %%%                 @@@           @@@          %            
             %%     %%%               @@@               @@@       %             
              %%    %%%%%%%%%%%%%%%%@@@                  @@@@    %              
                %%                                             %                
                  %%                                         %                  
                    %%                                     %                    
                       %%%                             %%                       
                            %%%                   %%#                           
                                    #%%%%%%%                 

*/
