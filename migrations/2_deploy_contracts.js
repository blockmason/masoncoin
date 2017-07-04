var MasonCoin = artifacts.require("./MasonCoin.sol");

module.exports = function(deployer) {
    deployer.deploy(MasonCoin);
};
