pragma solidity ^0.4.0;

/**
 * @title Indi Coin - to be in structure and format an ERC20 token meant for india 
 * 
 * @author : Komhar Consulting Services Private Limited.(komhar.com) * 
 *  
 */

/**
 * @title This contract forms the basis for GSTIN mapped tax credit token - or GstCoin.
 */
contract ERC20Token {
     uint256 public totalSupply;
    function balanceOf( address who ) constant returns (uint value);
    function allowance( address owner, address spender ) constant returns (uint _allowance);

    function transfer( address to, uint value) returns (bool ok);
    function transferFrom( address from, address to, uint value) returns (bool ok);
    function approve( address spender, uint value ) returns (bool ok);

    event Transfer( address indexed from, address indexed to, uint value);
    event Approval( address indexed owner, address indexed spender, uint value);
}


contract StandardToken is ERC20Token {

    function transfer(address _to, uint256 _value) returns (bool success) {
      
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}

contract GstCoin is StandardToken{
    
    /*
    Base62 coersion of GSTIN format = State code + PAN +Entity reg number+Z + checksum
    
    */
    mapping(uint => address) gstinAddress; 
    
    function getCredit(uint _gstin) constant returns (uint credit) {
        credit = balanceOf(gstinAddress[_gstin]);
    }
    
    function taxCreditTo(uint _gstin, uint _credit) {
        transfer(gstinAddress[_gstin], _credit);
    }
    
    function taxCreditFromTo(uint _from, uint _to, uint256 _value) {
        transferFrom(gstinAddress[_from], gstinAddress[_to], _value);
    }
    
    function approveTaxCredit(uint _creditor, uint256 _value) returns (bool success) {
        return approve(gstinAddress[_creditor], _value);
        
    }
    
    
    function allowCreditOnBehalf(uint _creditor, uint _credited ) constant returns (uint256 remaining) {
        return allowance(gstinAddress[_creditor], gstinAddress[_credited]);
    }
}

