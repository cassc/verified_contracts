// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: KYP005
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////
//           //
//           //
//    ✦✦✦    //
//           //
//           //
///////////////


contract KYP is ERC1155Creator {
    constructor() ERC1155Creator("KYP005", "KYP") {}
}