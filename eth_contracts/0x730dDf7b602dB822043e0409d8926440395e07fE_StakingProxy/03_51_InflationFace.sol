/*

 Copyright 2017-2019 RigoBlock, Rigo Investment Sagl, 2020 Rigo Intl.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

*/

pragma solidity >=0.4.22 <0.8.0;

/// @title Inflation Interface - Allows interaction with the Inflation contract.
/// @author Gabriele Rigo - <[email protected]>
// solhint-disable-next-line
interface InflationFace {

    /*
     * PUBLIC VARIABLES
     */
    // solhint-disable-next-line
    function RIGO_TOKEN_ADDRESS()
        external
        view
        returns (address);

    //solhint-disable-next-line
    function STAKING_PROXY_ADDRESS()
        external
        view
        returns (address);

    function slot()
        external
        view
        returns (uint256);

    function epochLength()
        external
        view
        returns (uint256);

    /*
     * CORE FUNCTIONS
     */
    /// @dev Allows staking proxy to mint rewards.
    /// @return mintedInflation Number of allocated tokens.
    function mintInflation()
        external
        returns (uint256 mintedInflation);

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    /// @dev Returns whether an epoch has ended.
    /// @return Bool the epoch has ended.
    function epochEnded()
        external
        view
        returns (bool);

    /// @dev Returns how long until next claim.
    /// @return Number in seconds.
    function timeUntilNextClaim()
        external
        view
        returns (uint256);

    /// @dev Returns the epoch inflation.
    /// @return Value of units of GRG minted in an epoch.
    function getEpochInflation()
        external
        view
        returns (uint256);
}