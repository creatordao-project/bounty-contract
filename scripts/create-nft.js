// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log(deployer.address);
    const Nft = await ethers.getContractFactory("CreaticlesNFT");
    const proxy = await upgrades.deployProxy(Nft, ["CreatorDAO NFT","CNFT","https://file.creatordao.dev/bounty/"]);
    await proxy.deployed();
    console.log("Nft deployed to:", proxy.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});;