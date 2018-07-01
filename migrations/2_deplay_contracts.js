var HelloWorld = artifacts.require("./helloworld.sol")
var AccountValidator = artifacts.require("./AccountValidator.sol")

module.exports = function(deployer) {
    deployer.deploy(HelloWorld);
    deployer.deploy(AccountValidator);
};