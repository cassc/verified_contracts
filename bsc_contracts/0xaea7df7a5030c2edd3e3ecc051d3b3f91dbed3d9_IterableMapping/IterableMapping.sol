/**
 *Submitted for verification at BscScan.com on 2022-09-25
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

library IterableMapping {
    
    struct Map {
        address[] keys;
        mapping(address => uint256) values;
        mapping(address => uint256) indexOf;
        mapping(address => bool) inserted;
    }

    function get(Map storage map, address key) public view returns (uint256) {
        return map.values[key];
    }

    // start with 0 based. -1 not exists
    function getIndexOfKey(Map storage map, address key) public view returns (int256) {
        if (!map.inserted[key]) {
            return -1;
        }
        return int256(map.indexOf[key]);
    }

    function getKeyAtIndex(Map storage map, uint256 index) public view returns (address) {
        return map.keys[index];
    }

    function size(Map storage map) public view returns (uint256) {
        return map.keys.length;
    }

    function set( Map storage map, address key, uint256 val ) public {
        // change value in second
        if (map.inserted[key]) {
            map.values[key] = val;
        } else { // setting value in first
            map.inserted[key] = true;
            map.values[key] = val;
            map.indexOf[key] = map.keys.length; // save the index
            map.keys.push(key);  // add key
        }
    }

    function remove(Map storage map, address key) public {
        if (!map.inserted[key]) {
            return;
        }
        delete map.inserted[key];
        delete map.values[key];
        uint256 index = map.indexOf[key];
        uint256 lastIndex = map.keys.length - 1;
        address lastKey = map.keys[lastIndex];
        map.indexOf[lastKey] = index;
        delete map.indexOf[key];
        map.keys[index] = lastKey;
        map.keys.pop();
    }
}