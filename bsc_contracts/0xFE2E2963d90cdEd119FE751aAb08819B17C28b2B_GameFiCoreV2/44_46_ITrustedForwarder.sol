// SPDX-License-Identifier: BUSL-1.1
// GameFi Core™ by CDEVS

pragma solidity 0.8.10;

interface ITrustedForwarder {
    function setTrustedForwarder(address _newTrustedForwarder) external;
}