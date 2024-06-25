pragma solidity 0.8.17;

// SPDX-License-Identifier: MIT

import {IRDNRegistry} from "./RDNRegistry.sol";

interface IRDNFactors {

    function getFactor(uint _level, uint _tariff, uint _userId) external view returns(uint);

    function calc(uint _level, uint _tariff, uint _userId) external pure returns(uint);

    function getDecimals() external view returns(uint);
}

contract RDNFactors {

    IRDNRegistry public registry;

    uint public decimals = 4;

    uint[7][12] public factors = [
        [1500, 1956, 2413, 2869, 3326, 3782, 4239 ],
        [4239, 4467, 4695, 4924, 5152, 5380, 5608 ],
        [5608, 5760, 5913, 6065, 6217, 6369, 6521 ],
        [6521, 6635, 6750, 6864, 6978, 7092, 7206 ],
        [7206, 7297, 7389, 7480, 7571, 7663, 7754 ],
        [7754, 7830, 7906, 7982, 8058, 8134, 8210 ],
        [8210, 8276, 8341, 8406, 8471, 8536, 8602 ],
        [8602, 8659, 8716, 8773, 8830, 8887, 8944 ],
        [8944, 8995, 9045, 9096, 9147, 9198, 9248 ],
        [9248, 9294, 9340, 9385, 9431, 9477, 9522 ],
        [9522, 9564, 9605, 9647, 9688, 9730, 9771 ],
        [9771, 9809, 9847, 9885, 9923, 9961, 10000 ]
    ];

    constructor (address _registry) {
        registry = IRDNRegistry(_registry);
    }
    
    function getFactor(uint _level, uint _tariff, uint _userId) public view returns(uint) {
        _level = (_level >= 12)?11:(_level-1);
        _tariff = (_tariff >= 7)?6:(_tariff-1);
        return factors[_level][_tariff];
    }

    function calc(uint _level, uint _tariff, uint _userId) public pure returns(uint) {
        uint tariffsCount = 7;
        uint maxFactor = 1 ether;

        // return _level*(maxFactor/12)/(10**14);

        uint min = (_level >= 12 && _tariff >= 7)?maxFactor:(maxFactor - calcStep(_level, 12));
        uint max = (_level >= 12 && _tariff >= 7)?maxFactor:(maxFactor - calcStep(_level+1, 12));
        uint tariffStep = (max - min)/(tariffsCount-1);
        uint factor = min + tariffStep * (_tariff - 1);
        return factor/(10**14);
    }

    function test(uint x) public pure returns(uint) {
        return x*2;
    }

    function calcStep(uint _level, uint _levelMax) pure private returns(uint) {
        uint base = 0.2739 ether;
        if (_level > _levelMax) {
            return 0;
        } else {
            return (base/_levelMax + calcStep(_level, _levelMax-1));
        }
    }

    function getDecimals() public view returns(uint) {
        return decimals;
    }

    function getAllFactors() public view returns(uint[7][12] memory) {
        return factors;
    }

}