// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface ICurvePool {
    function A() external view returns (uint256);
    function A_precise() external view returns (uint256);
    function admin_balances(uint256 i) external view returns (uint256);
    function admin_fee() external view returns (uint256);
    function allowance(address arg0, address arg1) external view returns (uint256);
    function approve(address _spender, uint256 _value) external returns (bool);
    function balanceOf(address arg0) external view returns (uint256);
    function balances(uint256 arg0) external view returns (uint256);
    function calc_withdraw_one_coin(uint256 _burn_amount, int128 i) external view returns (uint256);
    function calc_withdraw_one_coin(uint256 _burn_amount, int128 i, bool _previous) external view returns (uint256);
    function coins(uint256 arg0) external view returns (address);
    function decimals() external view returns (uint256);
    function exchange(int128 i, int128 j, uint256 _dx, uint256 _min_dy) external returns (uint256);
    function exchange(int128 i, int128 j, uint256 _dx, uint256 _min_dy, address _receiver) external returns (uint256);
    function fee() external view returns (uint256);
    function future_A() external view returns (uint256);
    function future_A_time() external view returns (uint256);
    function get_balances() external view returns (uint256[2] memory);
    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256);
    function get_virtual_price() external view returns (uint256);
    function initial_A() external view returns (uint256);
    function initial_A_time() external view returns (uint256);
    function name() external view returns (string memory);
    function ramp_A(uint256 _future_A, uint256 _future_time) external;
    function remove_liquidity_one_coin(uint256 _burn_amount, int128 i, uint256 _min_received)
        external
        returns (uint256);
    function remove_liquidity_one_coin(uint256 _burn_amount, int128 i, uint256 _min_received, address _receiver)
        external
        returns (uint256);
    function stop_ramp_A() external;
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function withdraw_admin_fees() external;
}