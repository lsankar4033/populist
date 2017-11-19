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

  // NOTE: Change the return type here based on structure of Record. Sadly, solidity doesn't allow returning
  // Structs.
  function getRecord(string dateStr) view public returns(string, uint) {
    Record memory rec = dateToRecord[dateStr];
    return (rec.startup, rec.votes);
  }
}
