const IntermediateState = artifacts.require("IntermediateState");

module.exports = function (deployer) {
  deployer.deploy(IntermediateState);
};
