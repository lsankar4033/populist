pragma solidity ^0.4.2;

import "./History.sol";

contract Voter {
  History public history;

  // Mapping of startup to votes in this cycle. This mapping is required to only contain state for this time
  // period's vote (i.e. doesn't have legacy voting information). This requires that we clear it out at every
  // 'endVote' call.
  mapping (string => uint) votes;

  string[] startups;
  // Number of valid elements in the startup array. Allows us to re-initialize the array by changing the value
  // of this pointer, instead of setting the array to an empty array (which requires a lot of gas).
  uint numStartups = 0;

  function Voter() public {
    history = new History();
  }

  function vote(string startup) public {
    if (votes[startup] == 0) {
      addStartup(startup);
    }

    votes[startup] += 1;
  }

  function addStartup(string startup) private {
    if (numStartups == startups.length) {
      startups.length += 1;
    }

    startups[numStartups] = startup;
    numStartups += 1;
  }

  function getVotes(string startup) view public returns(uint) {
    return votes[startup];
  }

  // Figures out the startup that's won the current vote and commit it to history. Also re-initializes
  // relevant state for next time period's voting.
  function endVote(string dateStr) public {
    string memory bestStartup;
    uint mostVotes = 0;
    for (uint i = 0; i < numStartups; i++) {
      string memory startup = startups[i];
      if (votes[startup] > mostVotes) {
        bestStartup = startup;
        mostVotes = votes[startup];
      }
    }

    // NOTE: Maybe we want to store some sort of 'null' record when there was no winner?
    if (mostVotes > 0) {
      history.archiveRecord(dateStr, bestStartup, mostVotes);
    }

    reinitializeState();
  }

  function reinitializeState() private {
    // This is expensive, but it's better to have this mapping up-to-date for all 'getVotes' and 'vote' calls
    // so that those are O(1) because they'll be called with much higher frequency.
    for (uint i = 0; i < numStartups; i++) {
      string memory startup = startups[i];
      votes[startup] = 0;
    }

    // This is all we need to do to re-initialize the array.
    numStartups = 0;
  }
}
