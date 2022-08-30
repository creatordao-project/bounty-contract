// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const DappV2 = await ethers.getContractFactory("CreatorDAOBountyDapp");
  const proxy = await upgrades.upgradeProxy("0x39535E7A28b5827292E6d3B984BF6FcF9934300C", DappV2);
  console.log("Dapp upgraded to:", proxy.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});;