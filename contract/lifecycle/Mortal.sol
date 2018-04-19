pragma solidity ^0.4.4;

import "../ownership/Ownable.sol";

// allow contract to be destructible
contract Mortal is Ownable {
    function kill() onlyOwner public {
        selfdestruct(owner);
    }
}
