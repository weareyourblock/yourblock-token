pragma solidity ^0.4.4;

import '../math/SafeMath.sol';
import "../ownership/Ownable.sol";
import "../lifecycle/Pausable.sol";
import "../lifecycle/Mortal.sol";

contract BaseToken is Ownable, Pausable, Mortal{

  using SafeMath for uint256;

  // ERC20 State
  mapping (address => uint256) public balances;
  mapping (address => mapping (address => uint256)) public allowances;
  mapping (address => bool) public frozenAccount;
  uint256 public totalSupply;

  // Human State
  string public name;
  uint8 public decimals;
  string public symbol;
  string public version;

  // ERC20 Events
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  //Frozen event
  event FrozenFunds(address target, bool frozen);

  // ERC20 Methods
  function totalSupply() public constant returns (uint _totalSupply) {
      return totalSupply;
  }

  function balanceOf(address _address) public view returns (uint256 balance) {
    return balances[_address];
  }

  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowances[_owner][_spender];
  }

  //Freeze/unfreeze specific address
  function freezeAccount(address target, bool freeze) onlyOwner public{
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
    }

  //Check if given address is frozen
  function isFrozen(address _address) public view returns (bool frozen) {
      return frozenAccount[_address];
  }

  //ERC20 transfer
  function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success)  {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
    //REMOVED - SH 20180430 - WOULD PREVENT SENDING TO MULTISIG WALLET
    //require(isContract(_to) == false);
    require(!frozenAccount[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  //REMOVED - SH 20180430 - WOULD PREVENT SENDING TO MULTISIG WALLET
  //Check if to address is contract
  //function isContract(address _addr) private constant returns (bool) {
  //      uint codeSize;
  //      assembly {
  //          codeSize := extcodesize(_addr)
  //      }
  //      return codeSize > 0;
  //  }

  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowances[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function transferFrom(address _owner, address _to, uint256 _value) whenNotPaused public returns (bool success) {
    require(_to != address(0));
    require(_value <= balances[_owner]);
    require(_value <= allowances[_owner][msg.sender]);
    require(!frozenAccount[_owner]);

    balances[_owner] = balances[_owner].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowances[_owner][msg.sender] = allowances[_owner][msg.sender].sub(_value);
    Transfer(_owner, _to, _value);
    return true;
  }

}
