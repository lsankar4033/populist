pragma solidity ^0.4.2;

contract History {
  // we may want to store more information, like % of vote won
  struct Record {
    string startup;
    uint votes;
  }

  // key is date string of form 1/2/2017 representing Jan 2, 2017
  mapping (string => Record) dateToRecord;
  string[] dates;

  // NOTE: Currently only assumes that this is called *once* for each dateStr
  function archiveRecord(string dateStr, string startup, uint votes) public {
    dateToRecord[dateStr] = Record(startup, votes);
    dates.push(dateStr);
  }
}
