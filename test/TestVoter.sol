pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import "../contracts/Voter.sol";

contract TestVoter {
  function testInitialVotes() public {
    Voter voter = new Voter();
    Assert.equal(voter.getVotes("foo"), 0, "All initial votes should be 0");
  }

  function testVote() public {
    Voter voter = new Voter();
    voter.vote("foo");
    Assert.equal(voter.getVotes("foo"), 1, "Voting should increment vote count");
  }

  function testIndependentVoting() public {
    Voter voter = new Voter();
    voter.vote("foo");
    voter.vote("bar");
    Assert.equal(voter.getVotes("foo"), 1, "Voting should be independent among startups (foo)");
    Assert.equal(voter.getVotes("foo"), 1, "Voting should be independent among startups (bar)");
  }

  function testEndingVoteResetsVotes() public {
    Voter voter = new Voter();
    voter.vote("foo");
    voter.endVote("11/18/2017");
    Assert.equal(voter.getVotes("foo"), 0, "Ending the vote resets all votes in voter");
  }

  function testEndingVoteArchivesRecord() public {
    Voter voter = new Voter();
    History history = voter.history();

    for (uint i = 0; i < 2; i++) {
      voter.vote("foo");
    }
    for (uint j = 0; j < 3; j++) {
      voter.vote("bar");
    }

    voter.endVote("11/28/2017");

    // TODO: This test is currently broken because solidity doesn't support returning a string from one
    // contract to another! Possible solutions:
    // 1. pack string into byte array
    // 2. test this functionality in js (this might not actually work)
    Assert.equal(history.getRecord("11/28/2017"), ("bar", 3), "Ending the vote archives the correct winner");
  }
}
