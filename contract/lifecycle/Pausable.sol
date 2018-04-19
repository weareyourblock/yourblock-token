pragma solidity ^0.4.4;

import "../ownership/Ownable.sol";

contract Pausable is Ownable {
  event Pause();
  event Unpause();
    
  bool public paused = false;

  //Allow transfers from owner even in paused state - block all others
  modifier whenNotPaused() {
    require(!paused || msg.sender == owner);
    _;
  }

  modifier whenPaused() {
    require(paused);
    _;
  }

  // called by the owner on emergency, triggers paused state
  function pause() onlyOwner public{
    require(paused == false);
    paused = true;
    Pause();
  }

  // called by the owner on end of emergency, returns to normal state
  function unpause() onlyOwner whenPaused public{
    paused = false;
    Unpause();
  }

}
