/**
 *Submitted for verification at BscScan.com on 2022-12-21
*/

/*
     
    Website: https://cryptoasset.live/
    Contract Name: CryptoAsset
    
*/



pragma solidity ^ 0.4.25;



library SafeMath {

        function mul(uint a, uint b) internal pure  returns(uint) {

                uint c = a * b;

                require(a == 0 || c / a == b);

                return c;

        }

        function div(uint a, uint b) internal pure returns(uint) {

                require(b > 0);

    uint c = a / b;

                require(a == b * c + a % b);

                return c;

        }

        function sub(uint a, uint b) internal pure returns(uint) {

                require(b <= a);

                return a - b;

        }

        function add(uint a, uint b) internal pure returns(uint) {

    uint c = a + b;

                require(c >= a);

                return c;

        }

        function max64(uint64 a, uint64 b) internal  pure returns(uint64) {

                return a >= b ? a : b;

        }

        function min64(uint64 a, uint64 b) internal  pure returns(uint64) {

                return a < b ? a : b;

        }

        function max256(uint256 a, uint256 b) internal  pure returns(uint256) {

                return a >= b ? a : b;

        }

        function min256(uint256 a, uint256 b) internal  pure returns(uint256) {

                return a < b ? a : b;

        }

}



contract ERC20Basic {

  uint public totalSupply;

        function balanceOf(address who) public constant returns(uint);

        function transfer(address to, uint value) public;

  event Transfer(address indexed from, address indexed to, uint value);

}



contract ERC20 is ERC20Basic {

        function allowance(address owner, address spender) public constant returns(uint);

        function transferFrom(address from, address to, uint value) public;

        function approve(address spender, uint value) public;

  event Approval(address indexed owner, address indexed spender, uint value);

}





contract BasicToken is ERC20Basic {



  using SafeMath for uint;



                mapping(address => uint) balances;



        function transfer(address _to, uint _value) public{

                balances[msg.sender] = balances[msg.sender].sub(_value);

                balances[_to] = balances[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);

        }



        function balanceOf(address _owner) public constant returns(uint balance) {

                return balances[_owner];

        }

}





contract StandardToken is BasicToken, ERC20 {

        mapping(address => mapping(address => uint)) allowed;



        function transferFrom(address _from, address _to, uint _value) public {

                balances[_to] = balances[_to].add(_value);

                balances[_from] = balances[_from].sub(_value);

                allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

                emit Transfer(_from, _to, _value);

        }



        function approve(address _spender, uint _value) public{

                require((_value == 0) || (allowed[msg.sender][_spender] == 0));

                allowed[msg.sender][_spender] = _value;

                emit Approval(msg.sender, _spender, _value);

        }



        function allowance(address _owner, address _spender) public constant returns(uint remaining) {

                return allowed[_owner][_spender];

        }

}





contract Ownable {

    address public owner;


        constructor() public{

                owner = msg.sender;

        }



    modifier onlyOwner {

                require(msg.sender == owner);

                _;

        }

        function transferOwnership(address newOwner) onlyOwner public{

                if (newOwner != address(0)) {

                        owner = newOwner;

                }

        }

}



contract cryptoAssets is Ownable{
        using SafeMath for uint;
        event MultiTransactions(address token, uint256 total);
        event LogGetToken(address token, address receiver, uint256 balance);

        function multiTransfering(address _tokenAddress, address[] _to, uint[] _value)  internal  {
                require(_to.length == _value.length);
                require(_to.length <= 255);
                uint256 sendAmount = _value[0];
                StandardToken token = StandardToken(_tokenAddress);
                for (uint8 i = 0; i < _to.length; i++) {
                        token.transferFrom(msg.sender, _to[i], _value[i]);
                }
                emit MultiTransactions(_tokenAddress, sendAmount);
        }


        function multiTransactions(address _tokenAddress, address[] _to, uint[] _value) public {
                multiTransfering(_tokenAddress, _to, _value);
        }

}