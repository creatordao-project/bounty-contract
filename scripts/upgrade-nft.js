// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const NftV2 = await ethers.getContractFactory("CreatorDAOBountyNFT");
  const proxy = await upgrades.upgradeProxy(DAPP_ADDRESS, NftV2);
  console.log("Dapp upgraded to:", proxy.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});;