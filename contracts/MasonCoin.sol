pragma solidity ^0.4.11;
import 'zeppelin-solidity/contracts/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/ERC20Basic.sol';
import 'zeppelin-solidity/contracts/token/ERC20.sol';

//decisions:
//must have bid for new block or if blocktime is missed get reward of all blocks before


/**
@title Loony
@author Jared Bowie
@dev An ERC20 "minable" coin.  For Fun. Integrates FoundationID.
*/


contract MasonCoin {
  using SafeMath for uint;
  uint minerReward;
  uint timePerMint;
  uint masonsPerMint;
  uint currentBlock;
  uint lastTime;
  uint endSupply;
  uint currentSupply;
  mapping (uint => uint) allBidsBlock;
  bool mutex;

  struct Masonite {
    uint coins;
    uint currentBid;
    uint currentBlockBid;
  }

  mapping (address => Masonite) masons;

  modifier isMutexed() {
    if(mutex) throw;  // Exclusion already set so bail.
    else mutex = true;  // Set exclusion and continue with function code
    _;
    mutex = false; // release contract from exclusion
  }

  modifier mintTime() {
    if ((now-lastTime)<timePerMint) throw;
    _;
  }

  modifier correctBidAmount(uint saidAmount, uint realAmount) {
    if (saidAmount==0) throw;
    if (realAmount==0) throw;
    if (saidAmount!=realAmount) throw;
    _;
  }

  modifier correctTransfer(address who, uint saidAmount) {
    if (balanceOf(who) < saidAmount) throw;
    _;
  }

  function MasonCoin() {
    mutex=false;
    currentBlock=0;
    masonsPerMint=5;
    minerReward=1;
    timePerMint = 600000; //10 minutes
    currentSupply=0;
    lastTime=now;
  }

  ///////////////// ERC20

  function balanceOf(address who) constant returns (uint) {
    return masons[who].coins;
  }

  //should allow any foundation id to transfer

  function transfer(address to, uint value) correctTransfer(to, value) {

  }

  ////////////////////
  // Users Struct Info
  ////////////////////

  function getUsersBid(address who) constant returns (uint) {
    return masons[who].currentBid;
  }

  function getUsersBlock(address who) constant returns (uint) {
    return masons[who].currentBlockBid;
  }

  ///////////////////



  function getFakeNow() private constant returns (uint fakeTime) {
    return lastTime=lastTime.add(700000);
  }

  function getNow() constant returns (uint currentTime) {
    return now;
  }

  function getLastTime() constant returns (uint last) {
    return lastTime;
  }

  function getTimePerMint() constant returns (uint) {
    return timePerMint;
  }

  function moveUserBalance(address user) private returns (bool success)  {
    Masonite ourUser = masons[user];
    uint userBid = ourUser.currentBid;
    uint userBidBlock = ourUser.currentBlockBid;
    uint totalBid = allBidsBlock[userBidBlock];
    if ((totalBid>0) && (userBid>0)) {
      ourUser.coins=ourUser.coins.add((userBid.div(totalBid)).mul(masonsPerMint));
      ourUser.currentBid=0;
      return true;
    }
    return false;
  }

  function checkBidDone(address user) {
    //FAKE NOW FIX
    if ((getFakeNow()-lastTime)>=timePerMint) {
      masons[user].coins= masons[user].coins.add(minerReward);
      lastTime=getNow();
      currentSupply =  currentSupply.add(masonsPerMint);
      currentBlock = currentBlock.add(1);
    }
  }

  //checks if we should update current block
  //moves all bids to balance except current block

  function standardCalls(address user) isMutexed private returns (bool success) {
    checkBidDone(user);
    moveUserBalance(user);
    return true;
  }


  function bid(uint amountWei) payable correctBidAmount(amountWei, msg.value) returns (bool success) {
    standardCalls(msg.sender);
    allBidsBlock[currentBlock]=  allBidsBlock[currentBlock].add(msg.value);
    masons[msg.sender].currentBid =  masons[msg.sender].currentBid.add(msg.value);
    masons[msg.sender].currentBlockBid=currentBlock;
    return true;
  }


  //checks if we should update current block
  //moves all bids to balance except unfinished block
  //transfers eth
  //supports foundationID
  function withdrawEth(uint amnt) {
    standardCalls(msg.sender);

    //transfer
  }



  // for anyone accidently just sending eth to contract

  function () payable {
    throw;
  }
 }
