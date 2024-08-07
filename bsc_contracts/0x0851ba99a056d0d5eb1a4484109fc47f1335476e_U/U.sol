/**
 *Submitted for verification at BscScan.com on 2023-02-14
*/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.16;

interface Erc20Token {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _who) external view returns (uint256);
    function transfer(address _to, uint256 _value) external;
    function allowance(address _owner, address _spender) external view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _value) external;
    function approve(address _spender, uint256 _value) external; 
    function burnFrom(address _from, uint256 _value) external; 
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract U{
    uint256  ServiceCharge100 ;
    mapping(address=>bool) public addressPlay;
    mapping(uint256=>mapping(uint256=>uint256)) public commodityPrice;
    address  _owner ;
    address  whiteAddress ;
    address  ServiceCharge ;

    constructor() {
        _owner = msg.sender; 
    }
    modifier onlyOwner() {
        require(msg.sender == _owner , "Permission denied"); _;
    }
    Erc20Token USDT = Erc20Token(0x55d398326f99059fF775485246999027B3197955); 
    Erc20Token AMA = Erc20Token(0x55d398326f99059fF775485246999027B3197955); 
    Erc20Token LAND = Erc20Token(0x55d398326f99059fF775485246999027B3197955); 
    address AMALP = address(0x55d398326f99059fF775485246999027B3197955); 
    address LANDLP = address(0x55d398326f99059fF775485246999027B3197955); 

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        _owner = newOwner;
    }

    receive() external payable {} 

    function setServiceCharge100( uint256 percentage ) public onlyOwner {
        ServiceCharge100 = percentage;
    }

    function setCommodityPrice(uint256 commodityID,uint256 TypeID,uint256 price ) public   onlyOwner {
        commodityPrice[commodityID][TypeID] = price;

    }

    function BuyCommodity(uint256 commodityID,uint256 TypeID , uint256 addressID,
        uint256  aount ,uint256 Erc20TokenType ) public onlyOwner {
        uint256 allUSDT = commodityPrice[commodityID][TypeID] * aount;
       ( uint256 AMAPrice, uint256 LandPrice) =  L_A_price();
        if(Erc20TokenType == 0){
            USDT.transferFrom(msg.sender, address(this), allUSDT);
            USDT.transfer(ServiceCharge,  allUSDT*ServiceCharge100/100);
        }else if (Erc20TokenType == 1)
        {
            uint256 LANDBalance = allUSDT*LandPrice/10000000;
            LAND.transferFrom(msg.sender, address(whiteAddress), LANDBalance);
            LAND.transferFrom(whiteAddress, ServiceCharge,LANDBalance - LANDBalance*ServiceCharge100/100);
            LAND.transferFrom(whiteAddress, address(this), LANDBalance*ServiceCharge100/100);
        }

        else if(Erc20TokenType == 2){
            uint256 AMABalance = allUSDT*AMAPrice/10000000;
            AMA.transferFrom(msg.sender, address(this), AMABalance);
            AMA.transfer(ServiceCharge,  AMABalance*ServiceCharge100/100);
        }
        else{
            require(false , "Erc20TokenType err"); 
            require(addressID == 1 , "1"); 

        }
    }

      function Recharge(uint256  aount ,uint256 Erc20TokenType ) public onlyOwner {
        uint256 allUSDT =  aount;
       (uint256 AMAPrice, uint256 LandPrice) =  L_A_price();
        if(Erc20TokenType == 0){
            USDT.transferFrom(msg.sender, address(this), allUSDT);
        }else if (Erc20TokenType == 1)
        {
            uint256 LANDBalance = allUSDT*LandPrice/10000000;
            LAND.transferFrom(msg.sender, address(whiteAddress), LANDBalance);
            LAND.transferFrom(whiteAddress, address(this),LANDBalance );
         }
        else if(Erc20TokenType == 2){
            uint256 AMABalance = allUSDT*AMAPrice/10000000;
            AMA.transferFrom(msg.sender, address(this), AMABalance);
        }
        else{
            require(false , "Erc20TokenType err"); 
        }
    }

    function WithdrawalOperator(address ERC20Address,address Addrs,uint256 Quantity) public onlyOwner {
        Erc20Token ErcAddr = Erc20Token(ERC20Address);
        require(ErcAddr.balanceOf(address(this)) >= Quantity, "404");
        ErcAddr.transfer(Addrs, Quantity);
    }

    function L_A_price () public view returns(uint256,uint256)   {
        uint256 USDTAMABalance = USDT.balanceOf(AMALP);
        uint256 AMABalance = AMA.balanceOf(AMALP);
        uint256 USDTLANDBalance = USDT.balanceOf(AMALP);
        uint256 LANDBalance = AMA.balanceOf(AMALP);
        return  (AMABalance *(10000000) / (USDTAMABalance),LANDBalance*(10000000)/(USDTLANDBalance));
    }

    function getPrice (uint256 commodityID,uint256 TypeID) public view returns(uint256 )   {
        return commodityPrice[commodityID][TypeID];
    }
    function UpdateBankCardBalance(uint256 ID) public {
    }
    function UpdateBankCardPassword(uint256 ID) public     {
    }
    function RealNameAuthentication(uint256 ID) public     {
    }
    function SetShippingAddress(uint256 ID) public     {
    }
    function DeleteShippingAddress(uint256 ID) public     {

 

    }

    

}