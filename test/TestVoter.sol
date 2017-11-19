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

  // TODO
  //function testEndingVoteArchivesRecord() public {

  //}
}
