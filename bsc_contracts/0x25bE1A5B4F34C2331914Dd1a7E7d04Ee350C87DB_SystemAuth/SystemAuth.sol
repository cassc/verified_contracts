/**
 *Submitted for verification at BscScan.com on 2022-10-18
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SystemAuth {

    address internal owner;
    address internal root;
    address internal farmToken;
    address internal usdtToken;
    address internal pancakeFactory;
    // bool internal debugMode;
    bool internal bEnable;

    constructor() {
        owner = msg.sender;
        root = msg.sender;
        // debugMode = true;
        bEnable = true;
    }

    // function setDebugMode(bool value) external {
    //     require(msg.sender == owner, "owner only");
    //     debugMode = value;
    // }

    // function getDebugMode() external view returns (bool res) {
    //     res = debugMode;
    // }

    function setEnable(bool _enable) external {
        require(msg.sender == owner, "owner only");
        bEnable = _enable;
    }

    function getEnable() external view returns (bool res) {
        res = bEnable;
    }

    function setOwner(address to) external {
        require(msg.sender == owner, "owner only");
        require(to != owner, "owner already");
        owner = to;
    }

    function getOwner() external view returns (address res) {
        res = owner;
    }

    function setRoot(address to) external {
        require(msg.sender == owner, "owner only");
        require(to != root, "root already");
        root = to;
    }

    function getRoot() external view returns (address res) {
        res = root;
    }

    function setFarmToken(address to) external {
        require(msg.sender == owner, "owner only");
        require(to != farmToken, "farmToken already");
        farmToken = to;
    }

    function getFarmToken() external view returns (address res) {
        res = farmToken;
    }

    function setUSDTToken(address to) external {
        require(msg.sender == owner, "owner only");
        require(to != usdtToken, "usdtToken already");
        usdtToken = to;
    }

    function getUSDTToken() external view returns (address res) {
        res = usdtToken;
    }

    function setPancakeFactory(address to) external {
        require(msg.sender == owner, "owner only");
        require(to != pancakeFactory, "pancakeFactory already");
        pancakeFactory = to;
    }

    function getPancakeFactory() external view returns (address res) {
        res = pancakeFactory;
    }
}