/**
 *Submitted for verification at Etherscan.io on 2022-10-13
*/

// hevm: flattened sources of src/DssSpell.sol
// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity =0.6.12 >=0.6.12 <0.7.0;
// pragma experimental ABIEncoderV2;

////// lib/dss-exec-lib/src/CollateralOpts.sol
/* pragma solidity ^0.6.12; */

struct CollateralOpts {
    bytes32 ilk;
    address gem;
    address join;
    address clip;
    address calc;
    address pip;
    bool    isLiquidatable;
    bool    isOSM;
    bool    whitelistOSM;
    uint256 ilkDebtCeiling;
    uint256 minVaultAmount;
    uint256 maxLiquidationAmount;
    uint256 liquidationPenalty;
    uint256 ilkStabilityFee;
    uint256 startingPriceFactor;
    uint256 breakerTolerance;
    uint256 auctionDuration;
    uint256 permittedDrop;
    uint256 liquidationRatio;
    uint256 kprFlatReward;
    uint256 kprPctReward;
}

////// lib/dss-exec-lib/src/DssExecLib.sol
//
// DssExecLib.sol -- MakerDAO Executive Spellcrafting Library
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
/* pragma solidity ^0.6.12; */
/* // pragma experimental ABIEncoderV2; */

/* import { CollateralOpts } from "./CollateralOpts.sol"; */

interface Initializable {
    function init(bytes32) external;
}

interface Authorizable {
    function rely(address) external;
    function deny(address) external;
    function setAuthority(address) external;
}

interface Fileable {
    function file(bytes32, address) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, bytes32, address) external;
}

interface Drippable {
    function drip() external returns (uint256);
    function drip(bytes32) external returns (uint256);
}

interface Pricing {
    function poke(bytes32) external;
}

interface ERC20 {
    function decimals() external returns (uint8);
}

interface DssVat {
    function hope(address) external;
    function nope(address) external;
    function ilks(bytes32) external returns (uint256 Art, uint256 rate, uint256 spot, uint256 line, uint256 dust);
    function Line() external view returns (uint256);
    function suck(address, address, uint) external;
}

interface ClipLike {
    function vat() external returns (address);
    function dog() external returns (address);
    function spotter() external view returns (address);
    function calc() external view returns (address);
    function ilk() external returns (bytes32);
}

interface DogLike {
    function ilks(bytes32) external returns (address clip, uint256 chop, uint256 hole, uint256 dirt);
}

interface JoinLike {
    function vat() external returns (address);
    function ilk() external returns (bytes32);
    function gem() external returns (address);
    function dec() external returns (uint256);
    function join(address, uint) external;
    function exit(address, uint) external;
}

// Includes Median and OSM functions
interface OracleLike_2 {
    function src() external view returns (address);
    function lift(address[] calldata) external;
    function drop(address[] calldata) external;
    function setBar(uint256) external;
    function kiss(address) external;
    function diss(address) external;
    function kiss(address[] calldata) external;
    function diss(address[] calldata) external;
    function orb0() external view returns (address);
    function orb1() external view returns (address);
}

interface MomLike {
    function setOsm(bytes32, address) external;
    function setPriceTolerance(address, uint256) external;
}

interface RegistryLike {
    function add(address) external;
    function xlip(bytes32) external view returns (address);
}

// https://github.com/makerdao/dss-chain-log
interface ChainlogLike {
    function setVersion(string calldata) external;
    function setIPFS(string calldata) external;
    function setSha256sum(string calldata) external;
    function getAddress(bytes32) external view returns (address);
    function setAddress(bytes32, address) external;
    function removeAddress(bytes32) external;
}

interface IAMLike {
    function ilks(bytes32) external view returns (uint256,uint256,uint48,uint48,uint48);
    function setIlk(bytes32,uint256,uint256,uint256) external;
    function remIlk(bytes32) external;
    function exec(bytes32) external returns (uint256);
}

interface LerpFactoryLike {
    function newLerp(bytes32 name_, address target_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) external returns (address);
    function newIlkLerp(bytes32 name_, address target_, bytes32 ilk_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) external returns (address);
}

interface LerpLike {
    function tick() external returns (uint256);
}


library DssExecLib {

    /* WARNING

The following library code acts as an interface to the actual DssExecLib
library, which can be found in its own deployed contract. Only trust the actual
library's implementation.

    */

    address constant public LOG = 0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F;
    uint256 constant internal WAD      = 10 ** 18;
    uint256 constant internal RAY      = 10 ** 27;
    uint256 constant internal RAD      = 10 ** 45;
    uint256 constant internal THOUSAND = 10 ** 3;
    uint256 constant internal MILLION  = 10 ** 6;
    uint256 constant internal BPS_ONE_PCT             = 100;
    uint256 constant internal BPS_ONE_HUNDRED_PCT     = 100 * BPS_ONE_PCT;
    uint256 constant internal RATES_ONE_HUNDRED_PCT   = 1000000021979553151239153027;
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function dai()        public view returns (address) { return getChangelogAddress("MCD_DAI"); }
    function vat()        public view returns (address) { return getChangelogAddress("MCD_VAT"); }
    function cat()        public view returns (address) { return getChangelogAddress("MCD_CAT"); }
    function dog()        public view returns (address) { return getChangelogAddress("MCD_DOG"); }
    function jug()        public view returns (address) { return getChangelogAddress("MCD_JUG"); }
    function vow()        public view returns (address) { return getChangelogAddress("MCD_VOW"); }
    function end()        public view returns (address) { return getChangelogAddress("MCD_END"); }
    function reg()        public view returns (address) { return getChangelogAddress("ILK_REGISTRY"); }
    function autoLine()   public view returns (address) { return getChangelogAddress("MCD_IAM_AUTO_LINE"); }
    function daiJoin()    public view returns (address) { return getChangelogAddress("MCD_JOIN_DAI"); }
    function lerpFab()    public view returns (address) { return getChangelogAddress("LERP_FAB"); }
    function clip(bytes32 _ilk) public view returns (address _clip) {}
    function flip(bytes32 _ilk) public view returns (address _flip) {}
    function calc(bytes32 _ilk) public view returns (address _calc) {}
    function getChangelogAddress(bytes32 _key) public view returns (address) {}
    function setAuthority(address _base, address _authority) public {}
    function canCast(uint40 _ts, bool _officeHours) public pure returns (bool) {}
    function nextCastTime(uint40 _eta, uint40 _ts, bool _officeHours) public pure returns (uint256 castTime) {}
    function setValue(address _base, bytes32 _what, uint256 _amt) public {}
    function setValue(address _base, bytes32 _ilk, bytes32 _what, uint256 _amt) public {}
    function setMaxTotalDAILiquidationAmount(uint256 _amount) public {}
    function setIlkAutoLineDebtCeiling(bytes32 _ilk, uint256 _amount) public {}
    function setIlkMaxLiquidationAmount(bytes32 _ilk, uint256 _amount) public {}
    function setStartingPriceMultiplicativeFactor(bytes32 _ilk, uint256 _pct_bps) public {}
    function setAuctionTimeBeforeReset(bytes32 _ilk, uint256 _duration) public {}
    function setAuctionPermittedDrop(bytes32 _ilk, uint256 _pct_bps) public {}
    function setKeeperIncentiveFlatRate(bytes32 _ilk, uint256 _amount) public {}
    function setIlkStabilityFee(bytes32 _ilk, uint256 _rate, bool _doDrip) public {}
    function sendPaymentFromSurplusBuffer(address _target, uint256 _amount) public {}
    function linearInterpolation(bytes32 _name, address _target, bytes32 _ilk, bytes32 _what, uint256 _startTime, uint256 _start, uint256 _end, uint256 _duration) public returns (address) {}
}

////// lib/dss-exec-lib/src/DssAction.sol
//
// DssAction.sol -- DSS Executive Spell Actions
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity ^0.6.12; */

/* import { DssExecLib } from "./DssExecLib.sol"; */
/* import { CollateralOpts } from "./CollateralOpts.sol"; */

interface OracleLike_1 {
    function src() external view returns (address);
}

abstract contract DssAction {

    using DssExecLib for *;

    // Modifier used to limit execution time when office hours is enabled
    modifier limited {
        require(DssExecLib.canCast(uint40(block.timestamp), officeHours()), "Outside office hours");
        _;
    }

    // Office Hours defaults to true by default.
    //   To disable office hours, override this function and
    //    return false in the inherited action.
    function officeHours() public virtual returns (bool) {
        return true;
    }

    // DssExec calls execute. We limit this function subject to officeHours modifier.
    function execute() external limited {
        actions();
    }

    // DssAction developer must override `actions()` and place all actions to be called inside.
    //   The DssExec function will call this subject to the officeHours limiter
    //   By keeping this function public we allow simulations of `execute()` on the actions outside of the cast time.
    function actions() public virtual;

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://<executive-vote-canonical-post> -q -O - 2>/dev/null)"
    function description() external virtual view returns (string memory);

    // Returns the next available cast time
    function nextCastTime(uint256 eta) external returns (uint256 castTime) {
        require(eta <= uint40(-1));
        castTime = DssExecLib.nextCastTime(uint40(eta), uint40(block.timestamp), officeHours());
    }
}

////// lib/dss-exec-lib/src/DssExec.sol
//
// DssExec.sol -- MakerDAO Executive Spell Template
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity ^0.6.12; */

interface PauseAbstract {
    function delay() external view returns (uint256);
    function plot(address, bytes32, bytes calldata, uint256) external;
    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);
}

interface Changelog {
    function getAddress(bytes32) external view returns (address);
}

interface SpellAction {
    function officeHours() external view returns (bool);
    function description() external view returns (string memory);
    function nextCastTime(uint256) external view returns (uint256);
}

contract DssExec {

    Changelog      constant public log   = Changelog(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
    uint256                 public eta;
    bytes                   public sig;
    bool                    public done;
    bytes32       immutable public tag;
    address       immutable public action;
    uint256       immutable public expiration;
    PauseAbstract immutable public pause;

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://<executive-vote-canonical-post> -q -O - 2>/dev/null)"
    function description() external view returns (string memory) {
        return SpellAction(action).description();
    }

    function officeHours() external view returns (bool) {
        return SpellAction(action).officeHours();
    }

    function nextCastTime() external view returns (uint256 castTime) {
        return SpellAction(action).nextCastTime(eta);
    }

    // @param _description  A string description of the spell
    // @param _expiration   The timestamp this spell will expire. (Ex. now + 30 days)
    // @param _spellAction  The address of the spell action
    constructor(uint256 _expiration, address _spellAction) public {
        pause       = PauseAbstract(log.getAddress("MCD_PAUSE"));
        expiration  = _expiration;
        action      = _spellAction;

        sig = abi.encodeWithSignature("execute()");
        bytes32 _tag;                    // Required for assembly access
        address _action = _spellAction;  // Required for assembly access
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
    }

    function schedule() public {
        require(now <= expiration, "This contract has expired");
        require(eta == 0, "This spell has already been scheduled");
        eta = now + PauseAbstract(pause).delay();
        pause.plot(action, tag, sig, eta);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}

////// src/DssSpellCollateral.sol
// SPDX-FileCopyrightText: © 2022 Dai Foundation <www.daifoundation.org>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity 0.6.12; */

/* import "dss-exec-lib/DssExecLib.sol"; */

contract DssSpellCollateralAction {

    // --- Rates ---
    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    // A table of rates can be found at
    // https://ipfs.io/ipfs/QmVp4mhhbwWGTfbh2BzwQB9eiBrQBKiqcPRZCaAxNUaar6
    //

    // --- Math ---
    // uint256 constant THOUSAND   = 10 ** 3;
    // uint256 constant MILLION    = 10 ** 6;
    // uint256 constant BILLION    = 10 ** 9;

    // --- DEPLOYED COLLATERAL ADDRESSES ---
    // address constant XXX                  = 0x0000000000000000000000000000000000000000;
    // address constant PIP_XXX              = 0x0000000000000000000000000000000000000000;
    // address constant MCD_JOIN_XXX_A       = 0x0000000000000000000000000000000000000000;
    // address constant MCD_CLIP_XXX_A       = 0x0000000000000000000000000000000000000000;
    // address constant MCD_CLIP_CALC_XXX_A  = 0x0000000000000000000000000000000000000000;

    // --- Offboarding: Current Liquidation Ratio ---
    // uint256 constant CURRENT_XXX_A_MAT              =  XYZ * RAY / 100;

    // --- Offboarding: Target Liquidation Ratio ---
    // uint256 constant TARGET_XXX_A_MAT               =  XYZ * RAY / 100;


    function onboardCollaterals() internal {
        // ----------------------------- Collateral onboarding -----------------------------
        //  Add ______________ as a new Vault Type
        //  Poll Link:

        // DssExecLib.addNewCollateral(
        //     CollateralOpts({
        //         ilk:                   "XXX-A",
        //         gem:                   XXX,
        //         join:                  MCD_JOIN_XXX_A,
        //         clip:                  MCD_CLIP_XXX_A,
        //         calc:                  MCD_CLIP_CALC_XXX_A,
        //         pip:                   PIP_XXX,
        //         isLiquidatable:        BOOL,
        //         isOSM:                 BOOL,
        //         whitelistOSM:          BOOL,
        //         ilkDebtCeiling:        line,
        //         minVaultAmount:        dust,
        //         maxLiquidationAmount:  hole,
        //         liquidationPenalty:    chop,
        //         ilkStabilityFee:       duty,
        //         startingPriceFactor:   buf,
        //         breakerTolerance:      tolerance,
        //         auctionDuration:       tail,
        //         permittedDrop:         cusp,
        //         liquidationRatio:      mat,
        //         kprFlatReward:         tip,
        //         kprPctReward:          chip
        //     })
        // );

        // DssExecLib.setStairstepExponentialDecrease(
        //     CALC_ADDR,
        //     DURATION,
        //     PCT_BPS
        // );

        // DssExecLib.setIlkAutoLineParameters(
        //     "XXX-A",
        //     AMOUNT,
        //     GAP,
        //     TTL
        // );

        // ChainLog Updates
        // DssExecLib.setChangelogAddress("XXX", XXX);
        // DssExecLib.setChangelogAddress("PIP_XXX", PIP_XXX);
        // DssExecLib.setChangelogAddress("MCD_JOIN_XXX_A", MCD_JOIN_XXX_A);
        // DssExecLib.setChangelogAddress("MCD_CLIP_XXX_A", MCD_CLIP_XXX_A);
        // DssExecLib.setChangelogAddress("MCD_CLIP_CALC_XXX_A", MCD_CLIP_CALC_XXX_A);
    }

    function offboardCollaterals() internal {
        // ----------------------------- Collateral offboarding -----------------------------

        // 1st Stage of Collateral Offboarding Process
        // Poll Link:
        // uint256 line;
        // uint256 lineReduction;

        // Set XXX-A Maximum Debt Ceiling to 0
        // (,,,line,) = vat.ilks("XXX-A");
        // lineReduction += line;
        // DssExecLib.removeIlkFromAutoLine("XXX-A");
        // DssExecLib.setIlkDebtCeiling("XXX-A", 0);

        // Set XXX-A Maximum Debt Ceiling to 0
        // (,,,line,) = vat.ilks("XXX-A");
        // lineReduction += line;
        // DssExecLib.removeIlkFromAutoLine("XXX-A");
        // DssExecLib.setIlkDebtCeiling("XXX-A", 0);

        // Decrease Global Debt Ceiling by total amount of offboarded ilks
        // vat.file("Line", _sub(vat.Line(), lineReduction));

        // 2nd Stage of Collateral Offboarding Process
        // address spotter = DssExecLib.spotter();

        // Offboard XXX-A
        // Poll Link:
        // Forum Link:

        // DssExecLib.setIlkLiquidationPenalty("XXX-A", 0);
        // DssExecLib.setKeeperIncentiveFlatRate("XXX-A", 0);
        // DssExecLib.linearInterpolation({
        //     _name:      "XXX-A Offboarding",
        //     _target:    spotter,
        //     _ilk:       "XXX-A",
        //     _what:      "mat",
        //     _startTime: block.timestamp,
        //     _start:     CURRENT_XXX_A_MAT,
        //     _end:       TARGET_XXX_A_MAT,
        //     _duration:  30 days
        // });

        // Offboard XXX-A
        // Poll Link:
        // Forum Link:

        // DssExecLib.setIlkLiquidationPenalty("XXX-A", 0);
        // DssExecLib.setKeeperIncentiveFlatRate("XXX-A", 0);
        // DssExecLib.linearInterpolation({
        //     _name:      "XXX-A Offboarding",
        //     _target:    spotter,
        //     _ilk:       "XXX-A",
        //     _what:      "mat",
        //     _startTime: block.timestamp,
        //     _start:     CURRENT_XXX_A_MAT,
        //     _end:       TARGET_XXX_A_MAT,
        //     _duration:  30 days
        // });

    }
}

////// src/DssSpell.sol
// SPDX-FileCopyrightText: © 2020 Dai Foundation <www.daifoundation.org>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity 0.6.12; */
// Enable ABIEncoderV2 when onboarding collateral through `DssExecLib.addNewCollateral()`
// // pragma experimental ABIEncoderV2;

/* import "dss-exec-lib/DssExec.sol"; */
/* import "dss-exec-lib/DssAction.sol"; */

/* import { DssSpellCollateralAction } from "./DssSpellCollateral.sol"; */

contract DssSpellAction is DssAction, DssSpellCollateralAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash:cast keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/d4081516d55e1da0e45220ec475cc616d9957a7b/governance/votes/Executive%20vote%20-%20October%2012%2C%202022.md -q -O - 2>/dev/null)"

    string public constant override description =
        "2022-10-12 MakerDAO Executive Spell | Hash: 0x0b0d0065dba31f91f6552a87022959dc802e0d902402998cf4717bbdd42471ab";

    // Turn office hours off
    function officeHours() public override returns (bool) {
        return false;
    }
    
    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    // A table of rates can be found at
    //    https://ipfs.io/ipfs/QmVp4mhhbwWGTfbh2BzwQB9eiBrQBKiqcPRZCaAxNUaar6
    //
    // --- Rates ---
    uint256 internal constant ONE_FIVE_PCT_RATE = 1000000000472114805215157978; 
    // --- Math ---
    uint256 internal constant MILLION = 10 ** 6;
    // --- Wallets ---
    address internal constant JUSTIN_CASE_WALLET         = 0xE070c2dCfcf6C6409202A8a210f71D51dbAe9473;
    address internal constant DOO_WALLET                 = 0x3B91eBDfBC4B78d778f62632a4004804AC5d2DB0;
    address internal constant ULTRASCHUPPI_WALLET        = 0xCCffDBc38B1463847509dCD95e0D9AAf54D1c167;
    address internal constant FLIPFLOPFLAP_WALLET        = 0x688d508f3a6B0a377e266405A1583B3316f9A2B3;
    address internal constant FLIPSIDE_WALLET            = 0x62a43123FE71f9764f26554b3F5017627996816a;
    address internal constant FEEDBLACKLOOPS_WALLET      = 0x80882f2A36d49fC46C3c654F7f9cB9a2Bf0423e1;
    address internal constant PENNBLOCKCHAIN_WALLET      = 0x2165D41aF0d8d5034b9c266597c1A415FA0253bd;
    address internal constant GFXLABS_WALLET             = 0xa6e8772af29b29B9202a073f8E36f447689BEef6;
    address internal constant MHONKASALOTEEMULAU_WALLET  = 0x97Fb39171ACd7C82c439b6158EA2F71D26ba383d;
    address internal constant CHRISBLEC_WALLET           = 0xa3f0AbB4Ba74512b5a736C5759446e9B50FDA170;
    address internal constant ACREINVEST_WALLET          = 0x5b9C98e8A3D9Db6cd4B4B4C1F92D0A551D06F00D;
    address internal constant BLOCKCHAINCOLUMBIA_WALLET  = 0xdC1F98682F4F8a5c6d54F345F448437b83f5E432;
    address internal constant FRONTIERRESEARCH_WALLET    = 0xA2d55b89654079987CF3985aEff5A7Bd44DA15A8;
    address internal constant LBSBLOCKCHAIN_WALLET       = 0xB83b3e9C8E3393889Afb272D354A7a3Bd1Fbcf5C;
    address internal constant LLAMA_WALLET               = 0xA519a7cE7B24333055781133B13532AEabfAC81b;
    address internal constant CODEKNIGHT_WALLET          = 0x46dFcBc2aFD5DD8789Ef0737fEdb03489D33c428;
    address internal constant ONESTONE_WALLET            = 0x4eFb12d515801eCfa3Be456B5F348D3CD68f9E8a;
    address internal constant PVL_WALLET                 = 0x6ebB1A9031177208A4CA50164206BF2Fa5ff7416;
    

    function actions() public override {
        // Includes changes from the DssSpellCollateralAction
        // onboardNewCollaterals();

        // ---------------------------------------------------------------------
        // Collateral Auction Parameter Changes
        // https://vote.makerdao.com/polling/QmREbu1j#poll-detail
        // https://forum.makerdao.com/t/collateral-auctions-analysis-parameter-updates-september-2022/18063#proposed-changes-17
        
        // buf changes (Starting auction price multiplier)
        DssExecLib.setStartingPriceMultiplicativeFactor("ETH-A"           , 110_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("ETH-B"           , 110_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("ETH-C"           , 110_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("WBTC-A"          , 110_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("WBTC-B"          , 110_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("WBTC-C"          , 110_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("WSTETH-A"        , 110_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("WSTETH-B"        , 110_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("CRVV1ETHSTETH-A" , 120_00); 
        DssExecLib.setStartingPriceMultiplicativeFactor("LINK-A"          , 120_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("MANA-A"          , 120_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("MATIC-A"         , 120_00);
        DssExecLib.setStartingPriceMultiplicativeFactor("RENBTC-A"        , 120_00);
        
        // cusp changes (Max percentage drop permitted before auction reset)
        DssExecLib.setAuctionPermittedDrop("ETH-A"    , 45_00);
        DssExecLib.setAuctionPermittedDrop("ETH-B"    , 45_00);
        DssExecLib.setAuctionPermittedDrop("ETH-C"    , 45_00);
        DssExecLib.setAuctionPermittedDrop("WBTC-A"   , 45_00);
        DssExecLib.setAuctionPermittedDrop("WBTC-B"   , 45_00);
        DssExecLib.setAuctionPermittedDrop("WBTC-C"   , 45_00);
        DssExecLib.setAuctionPermittedDrop("WSTETH-A" , 45_00);
        DssExecLib.setAuctionPermittedDrop("WSTETH-B" , 45_00);
        
        // tail changes (Max auction duration)
        DssExecLib.setAuctionTimeBeforeReset("ETH-A"    , 7200);
        DssExecLib.setAuctionTimeBeforeReset("ETH-C"    , 7200);
        DssExecLib.setAuctionTimeBeforeReset("WBTC-A"   , 7200);
        DssExecLib.setAuctionTimeBeforeReset("WBTC-C"   , 7200);
        DssExecLib.setAuctionTimeBeforeReset("WSTETH-A" , 7200);
        DssExecLib.setAuctionTimeBeforeReset("WSTETH-B" , 7200);
        DssExecLib.setAuctionTimeBeforeReset("ETH-B"    , 4800);
        DssExecLib.setAuctionTimeBeforeReset("WBTC-B"   , 4800);
        
        // ilk hole changes (Max concurrent liquidation amount for an ilk)
        DssExecLib.setIlkMaxLiquidationAmount("ETH-A"    , 40 * MILLION);
        DssExecLib.setIlkMaxLiquidationAmount("ETH-B"    , 15 * MILLION);
        DssExecLib.setIlkMaxLiquidationAmount("WBTC-A"   , 30 * MILLION);
        DssExecLib.setIlkMaxLiquidationAmount("WBTC-B"   , 10 * MILLION);
        DssExecLib.setIlkMaxLiquidationAmount("WBTC-C"   , 20 * MILLION);
        DssExecLib.setIlkMaxLiquidationAmount("LINK-A"   ,  3 * MILLION);
        DssExecLib.setIlkMaxLiquidationAmount("YFI-A"    ,  1 * MILLION);
        DssExecLib.setIlkMaxLiquidationAmount("RENBTC-A" ,  2 * MILLION);

        // tip changes (Max keeper incentive in DAI)
        DssExecLib.setKeeperIncentiveFlatRate("ETH-A"           , 250);
        DssExecLib.setKeeperIncentiveFlatRate("ETH-B"           , 250);
        DssExecLib.setKeeperIncentiveFlatRate("ETH-C"           , 250);
        DssExecLib.setKeeperIncentiveFlatRate("WBTC-A"          , 250);
        DssExecLib.setKeeperIncentiveFlatRate("WBTC-B"          , 250);
        DssExecLib.setKeeperIncentiveFlatRate("WBTC-C"          , 250);
        DssExecLib.setKeeperIncentiveFlatRate("WSTETH-A"        , 250);
        DssExecLib.setKeeperIncentiveFlatRate("WSTETH-B"        , 250);
        DssExecLib.setKeeperIncentiveFlatRate("CRVV1ETHSTETH-A" , 250); 
        DssExecLib.setKeeperIncentiveFlatRate("LINK-A"          , 250);
        DssExecLib.setKeeperIncentiveFlatRate("MANA-A"          , 250);
        DssExecLib.setKeeperIncentiveFlatRate("MATIC-A"         , 250);
        DssExecLib.setKeeperIncentiveFlatRate("RENBTC-A"        , 250); 
        DssExecLib.setKeeperIncentiveFlatRate("YFI-A"           , 250);

        // dog Hole change (Max concurrent global liquidation value)
        DssExecLib.setMaxTotalDAILiquidationAmount(70 * MILLION);

        // ---------------------------------------------------------------------
        // MOMC Parameter Changes
        // https://vote.makerdao.com/polling/QmbLyNUd#poll-detail
        // https://forum.makerdao.com/t/parameter-changes-proposal-ppg-omc-001-29-september-2022/18143
        
        // CRVV1ETHSTETH-A stability fee change (2.0% --> 1.5%) 
        DssExecLib.setIlkStabilityFee("CRVV1ETHSTETH-A" , ONE_FIVE_PCT_RATE , true); 
        
        // YFI-A DC IAM line change (25M --> 10M)
        /*  
            Note that dss-auto-line does not automatically reduce this value
            It will need to be called permissionlessly by a keeper after spell
            deployment to take effect and reduce the ceiling.
        */
        DssExecLib.setIlkAutoLineDebtCeiling("YFI-A" , 10 * MILLION);

        // ---------------------------------------------------------------------
        // Delegate Compensation - September 2022 
        // https://forum.makerdao.com/t/recognized-delegate-compensation-september-2022/18257

        DssExecLib.sendPaymentFromSurplusBuffer(JUSTIN_CASE_WALLET,         12_000);
        DssExecLib.sendPaymentFromSurplusBuffer(DOO_WALLET,                 12_000);
        DssExecLib.sendPaymentFromSurplusBuffer(ULTRASCHUPPI_WALLET,        12_000);
        DssExecLib.sendPaymentFromSurplusBuffer(FLIPFLOPFLAP_WALLET,        11_633);
        DssExecLib.sendPaymentFromSurplusBuffer(FLIPSIDE_WALLET,            11_396);
        DssExecLib.sendPaymentFromSurplusBuffer(FEEDBLACKLOOPS_WALLET,      10_696);
        DssExecLib.sendPaymentFromSurplusBuffer(PENNBLOCKCHAIN_WALLET,      10_322);
        DssExecLib.sendPaymentFromSurplusBuffer(GFXLABS_WALLET,              8_509);
        DssExecLib.sendPaymentFromSurplusBuffer(MHONKASALOTEEMULAU_WALLET,   7_996);
        DssExecLib.sendPaymentFromSurplusBuffer(CHRISBLEC_WALLET,            7_372);
        DssExecLib.sendPaymentFromSurplusBuffer(ACREINVEST_WALLET,           6_681);
        DssExecLib.sendPaymentFromSurplusBuffer(BLOCKCHAINCOLUMBIA_WALLET,   3_506);
        DssExecLib.sendPaymentFromSurplusBuffer(FRONTIERRESEARCH_WALLET,     2_136);
        DssExecLib.sendPaymentFromSurplusBuffer(LBSBLOCKCHAIN_WALLET,        1_974);
        DssExecLib.sendPaymentFromSurplusBuffer(LLAMA_WALLET,                1_839);
        DssExecLib.sendPaymentFromSurplusBuffer(CODEKNIGHT_WALLET,             269);
        DssExecLib.sendPaymentFromSurplusBuffer(ONESTONE_WALLET,               108);
        DssExecLib.sendPaymentFromSurplusBuffer(PVL_WALLET,                     53);
        
        // ---------------------------------------------------------------------
    }
}

contract DssSpell is DssExec {
    constructor() DssExec(block.timestamp + 30 days, address(new DssSpellAction())) public {}
}