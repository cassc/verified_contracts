/**
 *Submitted for verification at BscScan.com on 2022-12-07
*/

pragma solidity ^0.4.18;
 contract Delegate {

   address public owner;

   function Delegate(address _owner) public {
     owner = _owner;
   }

   function pwn() public {
     owner = msg.sender;
   }
 }

 contract Delegation {

   address public owner;
   Delegate delegate;

   function Delegation(address _delegateAddress) public {
     delegate = Delegate(_delegateAddress);
     owner = msg.sender;
   }

   function() public {
     if(delegate.delegatecall(msg.data)) {
       this;
     }
   }
 }