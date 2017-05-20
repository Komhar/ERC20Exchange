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
        bytes32 token;
        Decimal hardRatio;
        
    }
    mapping(bytes32 => TokenRate) tokenRates;
    
   /* simple univeral ratio*/
    function getExchangeRate(address from, address to, bool weight) 
    constant returns (uint numerator, uint denominator){
        
        ERC20Interface eRC20InterfaceFrom  =  ERC20Interface(from);   
         ERC20Interface eRC20InterfaceTo  =  ERC20Interface(from);   
        
         numerator = tokenRates[eRC20InterfaceFrom.symbol()].hardRatio.numerator*tokenRates[eRC20InterfaceTo.symbol()].hardRatio.denominator;
         denominator = tokenRates[eRC20InterfaceFrom.symbol()].hardRatio.denominator*tokenRates[eRC20InterfaceTo.symbol()].hardRatio.numerator;
    }
    
    //methods to initiate and update the TokenRate mappings through an ACL
    
    function updateToken(address tokenAddress, uint numerator, uint denominator) {
        ERC20Interface eRC20Interface  =  ERC20Interface(tokenAddress); 
        //ACL through custom modifier
        tokenRates[eRC20Interface.symbol()] = TokenRate(eRC20Interface.symbol(), Decimal(numerator, denominator));
    }
    
}

/* ERC interface just using the symbol */

contract ERC20Interface {
    //this is not as per definition, its of the type string - please change it
    bytes32 public symbol = "CURR0";
    

}

