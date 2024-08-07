// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.10 <0.8.0;

interface IControllerBallot {
    function count(uint256 timestamp)
        external
        view
        returns (uint256[] memory ratios, address[] memory funds);
}