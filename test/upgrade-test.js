const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");


describe("CreatorDAOBountyDapp", function() {
  it('works', async () => {
    const Dapp = await ethers.getContractFactory("CreatorDAOBountyDapp");
    const DappV2 = await ethers.getContractFactory("CreatorDAOBountyDapp");
    // Upgrade
    const instance = await upgrades.deployProxy(Dapp,[7,25,"0x4a44a94dFcd91d6A269fEF0F167133f3231A7338"]);
    console.log("instance deployed to:", instance.address);
    const upgraded = await upgrades.upgradeProxy(instance.address, DappV2);
    console.log("instance upgraded to:", upgraded.address);
  });
});