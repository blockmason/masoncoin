var MasonCoin = artifacts.require("./MasonCoin.sol");

contract('MasonCoin', function(accounts) {
    var account1 = accounts[0];
    var account2 = accounts[1];
    var account3 = accounts[2];
    var account4 = accounts[3];
    var account5 = accounts[4];
    var account6 = accounts[5];
    var u;

    it("iniatiates the contract", function() {
            return MasonCoin.new().then(function(instance) {
            u = instance;
                return u.getCurrentBlock.call()
            }).then(function(currentBlock) {
                console.log(currentBlock);
            });
        });
});
