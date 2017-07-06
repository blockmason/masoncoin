var MasonCoin = artifacts.require("./MasonCoin.sol");

contract('MasonCoin', function(accounts) {
    var account1 = accounts[0];
    var account2 = accounts[1];
    var account3 = accounts[2];
    var account4 = accounts[3];
    var account5 = accounts[4];
    var account6 = accounts[5];
    var u;

   /* it("iniatiates the contract", function() {
            return MasonCoin.new().then(function(instance) {
            u = instance;
                return u.getNow.call()
            }).then(function(timenow) {
                console.log(timenow);
            });
    });*/

    it("should NOT approve a user to spend from another user's account and then NOT spend correctly ", function() {
        return MasonCoin.new().then(function(instance) {
            u=instance;
            return u.bid(5, {from: account1, value: 1});
        }).catch(function(error) {
          assert.equal(error.toString(), "Error: VM Exception while processing transaction: invalid opcode", error)
        });
    });


    it("should not throw when bid with same as amount ", function() {
        return MasonCoin.new().then(function(instance) {
            u=instance;
            return u.bid(5, {from: account1, value: 5});
        }).then(function(transaction) {
            console.log(transaction);
//          assert.equal(error.toString(), "Error: VM Exception while processing transaction: invalid opcode", error)
    });
});


    it("should mine a new block ", function() {
        return MasonCoin.new().then(function(instance) {
            u=instance;
            return u.bid(5, {from: account1, value: 5});
        }).then(function(transaction) {
            return u.balanceOf(account1);
        }).then(function(balance) {
            console.log("balance equals " + balance.toNumber());
            assert.equal(balance.toNumber(), 1, "balance is not 1");
            return u.bid(5, {from: account1, value: 5});
        }).then(function(transaction) {
            return u.balanceOf(account1);
        }).then(function(balance) {
            console.log("balance equals " + balance.toNumber());
        });

    });

   /* it("bid throws when the amount sent doesn't match the amount said", function() {
        return MasonCoin.new().then(function(instance) {
            u = instance;
            return u.bid(5, {from: account1, value: 1});
        }).then(function(error) {
            console.log("error = ");
            assert.equal(error.toString(),  "Error: VM Exception while processing transaction: invalid opcode", error)
        });
    });*/
});
