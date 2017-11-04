pragma solidity ^0.4.2;

import "./History.sol";

contract Voter {
  History public history;

  mapping (string => uint) votes;
  string[] startups;

  function Voter() public {
    history = new History();
  }

  function vote(string startup) public {
    if (votes[startup] == 0) {
      startups.push(startup);
    }

    votes[startup] += 1;
  }

  function getVotes(string startup) view public returns(uint) {
    return votes[startup];
  }

  // Figures out the startup that's won the current vote and commit it to history.
  // NOTE: Maybe date computation could happen within contract
  function endVote(string dateStr) public {
    string memory bestStartup;
    uint mostVotes = 0;
    for (uint i = 0; i < startups.length; i++) {
      string memory startup = startups[i];
      if (votes[startup] > mostVotes) {
        bestStartup = startup;
        mostVotes = votes[startup];
      }
    }

    if (mostVotes > 0) {
      history.archiveRecord(dateStr, bestStartup, mostVotes);
    }
  }
}
