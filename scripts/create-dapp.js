// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log(deployer.address);
    const Dapp = await ethers.getContractFactory("CreaticlesDapp");
    const proxy = await upgrades.deployProxy(Dapp, [7,25,"0x4a44a94dFcd91d6A269fEF0F167133f3231A7338"]);
    await proxy.deployed();
    console.log("Dapp deployed to:", proxy.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});;