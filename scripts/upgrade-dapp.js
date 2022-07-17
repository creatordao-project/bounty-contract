// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const DappV2 = await ethers.getContractFactory("CreaticlesDapp");
  const proxy = await upgrades.upgradeProxy(DAPP_ADDRESS, DappV2);
  console.log("Dapp upgraded to:", proxy.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});;