const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");


describe("CreatorDAOBountyDapp", function() {
  it('works', async () => {
    const Dapp = await ethers.getContractFactory("CreatorDAOBountyDapp");
    const DappV2 = await ethers.getContractFactory("CreatorDAOBountyDapp");
    // Upgrade
    const instance = await upgrades.deployProxy(Dapp,[7,"0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0"]);
    console.log("instance deployed to:", instance.address);
    const upgraded = await upgrades.upgradeProxy(instance.address, DappV2);
    console.log("instance upgraded to:", upgraded.address);
  });
});