pragma solidity ^0.4.11;
import 'zeppelin-solidity/contracts/SafeMath.sol';

//decisions:
//must have bid for new block or if blocktime is missed get reward of all blocks before


/**
@title Loony
@author Jared Bowie
@dev An ERC20 "minable" coin.  For Fun. Integrates FoundationID.
*/


contract MasonCoin {
  uint minerReward;
  uint timePerMint;
  uint masonsPerMint;
  uint currentBlock;
  uint lastTime;
  uint endSupply;
  uint currentSupply;
  mapping (uint => uint) totalBidBlock;

   struct Masonite {
    uint coins;
    uint currentBid;
    uint currentBlockBid;
   }

    mapping (address => Masonite) masons;

    modifier mintTime() {
      if ((now-lastTime)<timePerMint) throw;
      _;
    }

  modifier correctAmount(uint saidAmount, uint realAmount) {
    if (saidAmount==0) throw;
    if (realAmount==0) throw;
    if (saidAmount!=realAmount) throw;
    _;
    }

  function MasonCoin() {
    currentBlock=0;
    masonsPerMint=5;
    minerReward=1;
    timePerMint = 600000; //10 minutes
    currentSupply=0;
    lastTime=now;
  }

  function getNow() constant returns (uint currentTime) {
    return now;
  }

  function checkUpdateBlock(address miner) {
    if ((now-lastTime)<timePerMint) {
      lastTime=now;
      currentBlock+=1;
    }
  }

  function moveUserBalance(address user) private returns (bool success)  {
    Masonite ourUser = masons[user];
    uint userBid = masons[user].currentBid;
    uint userBidBlock = masons[user].currentBlockBid;
    uint totalBid = totalBidBlock[userBidBlock];
    if ((totalBid>0) && (userBid>0)) {
      masons[user].coins+=(userBid/totalBid) * masonsPerMint;
      masons[user].currentBid=0;
      return true;
    }
    return false;
  }

  function checkBidDone(address user) {
    if ((now-lastTime)>=timePerMint) {
      masons[user].coins+=minerReward;
      lastTime=now;
      currentSupply+=masonsPerMint;
      currentBlock+=1;
    }
  }

  //checks if we should update current block
  //moves all bids to balance except current block

  function standardCalls(address user) private returns (bool success) {
    checkBidDone(user);
    moveUserBalance(user);
  }


  function bid(uint amountWei) payable correctAmount(amountWei, msg.value) returns (bool success) {
    standardCalls(msg.sender);
    totalBidBlock[currentBlock]+=msg.value;
    masons[msg.sender].currentBid+=msg.value;
    masons[msg.sender].currentBlockBid=currentBlock;
  }


  //checks if we should update current block
  //moves all bids to balance except unfinished block
  //transfers eth
  //supports foundationID
  function withdrawMason() {
    standardCalls(msg.sender);
    //transfer
  }
 }
