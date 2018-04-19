pragma solidity ^0.4.4;

import './UpgradeableToken.sol';

/**
 * A crowdsaled token.
 *
 * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
 *
 * - The token contract gives an opt-in upgrade path to a new contract
 *
 */
contract YBKToken is UpgradeableToken {

  string public name;
  string public symbol;
  uint public decimals;
  string public version;

  /**
   * Construct the token.
   */
   // Constructor
   function YBKToken(string _name, string _symbol, uint _initialSupply, uint _decimals, string _version) public {
     
     owner = msg.sender;
     
     // Initially set the upgrade master same as owner
     upgradeMaster = owner;
     
     name = _name;
     decimals = _decimals;
     symbol = _symbol;
     version = _version;
     
     totalSupply = _initialSupply;
     balances[msg.sender] = totalSupply;
     
   }

}
