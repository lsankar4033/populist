pragma solidity ^0.4.2;

contract Voter {
  mapping (string => uint) votes;

  function vote(string startup) public {
    votes[startup] += 1;
  }

  function getVote(string startup) view public returns(uint) {
    return votes[startup];
  }
}
