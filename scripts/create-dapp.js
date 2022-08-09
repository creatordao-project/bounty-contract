// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log(deployer.address);
    const Dapp = await ethers.getContractFactory("CreaticlesDapp");
    const proxy = await upgrades.deployProxy(Dapp, [7,25,"0x374DbA11C39343EA1eC11352726d5A6B5Fd3b367","0x374DbA11C39343EA1eC11352726d5A6B5Fd3b367"]);
    await proxy.deployed();
    console.log("Dapp deployed to:", proxy.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});;