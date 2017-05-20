pragma solidity ^0.4.0;

/**
 * @title contract to provide interoperability between ERC 20 tokens in runtime
 * Based on the addresses.
 * 
 * @author : Komhar Consulting Services Private Limited.(komhar.com) * 
 *  
 */

contract ERC20ExchangeType {
    
    /*
    This needs to be better structed.
    */
    struct Decimal {
        uint numerator;
        uint denominator;
    }
    
    /*
    The algorithms supporting the exchange should be implemented in the 
    inheriting contracts, 
    1. we should have a hard coded map with a single 
    2. exchange calculation. 
    3. Or an algorithm, yet to decide the inputs
    */
    function getExchangeRate(address from, address to) 
    constant returns (uint numerator, uint denominator);
    
}

/**
 * @title this is a single instance of the ERC20ExchangeType for hardcoded exchange rates.
 */

contract ERC20Exchange is ERC20ExchangeType {
    /* this should hold the hardcoding of token reference (Address for now) and a ratio */
    struct TokenRate {
        address token;
        Decimal hardRatio;
        
    }
    mapping(address => TokenRate) tokenRates;
    
   /* simple univeral ratio*/
    function getExchangeRate(address from, address to, bool weight) 
    constant returns (uint numerator, uint denominator){
         numerator = tokenRates[from].hardRatio.numerator*tokenRates[to].hardRatio.denominator;
         denominator = tokenRates[from].hardRatio.denominator*tokenRates[to].hardRatio.numerator;
    }
    
     //methods to initiate and update the TokenRate mappings through an ACL
    
    function updateToken(address tokenAddress, uint numerator, uint denominator) {
        //ACL through custom modifier
        tokenRates[tokenAddress] = TokenRate(tokenAddress, Decimal(numerator, denominator));
    }
    
}

contract ERC20Interface {
    //this is not as per definition, its of the type string - please change it
    bytes32 public symbol = "CURR0";
    

}


