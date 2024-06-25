// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "./Data_Structures.sol";
import "./Constants.sol";

library Helper_Functions {

    // ------- Basic -------

    /*
        Adjust a value so it stays within a range
    */
    function fix_for_range(
        uint128 variable,
        uint128 min,
        uint128 max
        )
        public pure
        returns(uint128)

    {

        variable = variable < min ? min : variable;
        variable = variable > max ? max : variable;
        return variable;

    }

    /* 
        Adjust time to reference contract creation time and maximum time
        For cases where there is no maximum it can be used simply by passing max_time = current_time
    */
    function normalize_time(
        uint32 current_time,
        uint32 init_time,
        uint32 max_time
        )
        public pure
        returns (uint32)
    {   
        current_time = current_time < init_time ? init_time : current_time;
        uint32 relative_time = current_time - init_time;
        relative_time = relative_time > max_time ? max_time : relative_time;
        return relative_time;
    }

    // ------- Subsidy -------
    /*
        Calculates the integral of the subsidy, basically:
        ∫ C(t) dt = (A * t) + ((A * t^3) / (3 T^2)) - ((A * t^2)/T)
    */
    function subsidy_integral(
        uint32 time,
        uint32 init_time
        )
        public pure
        returns(uint256)
    {
        // Cast up then down
        uint256 normalized_time = uint256(normalize_time(time, init_time, uint32(Constants.subsidy_duration)));
        uint256 max_subsidy_rate = uint256(Constants.max_subsidy_rate);
        uint256 subsidy_duration = uint256(Constants.subsidy_duration);

        uint256 integral =
            (max_subsidy_rate * normalized_time) +
            ((max_subsidy_rate * normalized_time ** 3) / (3 * subsidy_duration ** 2)) -
            ((max_subsidy_rate * normalized_time ** 2) / subsidy_duration);
        
        return integral;
    }

    /*
        Returns the total subsidy to be distributed in a range of time
    */
    function calculate_subsidy_for_range(
        uint32 start_time,
        uint32 end_time,
        uint32 init_time // Time the contract was initialized
        )
        public pure
        returns(uint128)
    {
        uint256 integral_range =  
            subsidy_integral(end_time, init_time) -
            subsidy_integral(start_time, init_time);

        return uint128(integral_range);
    }

    // ------- Fees -------
    /*
        Returns percentage tax at current time
        Tax ranges from 1% to 5%
        In 100x denomination
    */
    function calculate_tax(
        uint128 total_staked
        )
        public pure
        returns(uint128)
    {

        if (total_staked >= Constants.maximum_subsidy) {
            return Constants.maximum_tax_rate;
        }

        return
            Constants.minimum_tax_rate +
            Constants.tax_rate_range *
            total_staked /
            Constants.maximum_subsidy;

    }

    /*
        Calculates fees to be shared amongst all parties when a new stake comes in
    */
    function calculate_inbound_fees(
        uint128 amount_staked,
        uint16 royalties,
        uint128 total_staked
        )
        public pure
        returns(Data_Structures.Split memory)
    {
        Data_Structures.Split memory inbound_fees;
        
        inbound_fees.staker = Constants.finders_fee * amount_staked / 10000;
        inbound_fees.ministerial = Constants.ministerial_fee * amount_staked / 10000;
        inbound_fees.tax = amount_staked * calculate_tax(total_staked) / 10000;
        inbound_fees.creator = amount_staked * royalties / 1000000;
        
        inbound_fees.total =
            inbound_fees.staker +
            inbound_fees.ministerial + 
            inbound_fees.tax +
            inbound_fees.creator;

        return inbound_fees;
    }

    /*
        Fixes the royalties values if needed
    */
    function fix_royalties(
        uint16 royalties
        )
        public pure
        returns (uint16)
    {
        return royalties > Constants.maximum_royalties ? Constants.maximum_royalties : royalties;
    }

    // ------- Delay -------
    /*
        Determins the amount of delay received
        It is here with the share since the calculation are inherently linked
        More share = more delay...

        switched to -->
        f(a, t, n) = (315,360,000 * (a/t)^3) * (n/10000)
    */
    function delay_function(
        uint128 amount_staked,
        uint128 total_staked,
        uint64 number_of_staking_contracts
        )
        public pure
        returns(uint32)
    {
        uint256 decimals = 10**18;
        uint256 a = uint256(amount_staked);
        uint256 t = uint256(total_staked);
        uint256 n = uint256(number_of_staking_contracts);

        uint256 delay =
            315360000 *
            (decimals * a / t)**3 *
            n /
            10000 /
            (decimals**3);
        
        if (delay > uint256(type(uint32).max)) {
            return type(uint32).max;
        }

        return uint32(delay);


    }

    // ------- Presale -------
    function verify_minting_authorization(
        uint128 total_minted,
        uint256 block_time,
        uint128 amount_payable,
        uint128 quantity,
        uint32 timestamp,
        uint8 currency_index,
        uint8 v, bytes32 r, bytes32 s
        )
        public pure
    {
        // Sanity checks
        require(total_minted + quantity < Constants.max_presale_quantity, "Exceeds maximum total supply");
        require(timestamp + 60 * 60 * 24 > block_time, "Pricing has expired");

        // Verify signature
        require(ecrecover(keccak256(
          abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            keccak256(abi.encodePacked(amount_payable, quantity, timestamp, currency_index))
        )), v, r, s) == Constants.pricing_authority, "Invalid signature");
    }

}