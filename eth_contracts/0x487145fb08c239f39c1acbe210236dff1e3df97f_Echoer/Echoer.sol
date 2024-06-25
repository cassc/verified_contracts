/**
 *Submitted for verification at Etherscan.io on 2020-11-30
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract Echoer {
  event Echo(address indexed who, bytes data);

  function echo(bytes calldata _data) external {
    emit Echo(msg.sender, _data);
  }
}