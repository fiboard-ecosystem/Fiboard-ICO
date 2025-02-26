const hre = require("hardhat");

async function main() {
    const FiboTokenICO = await hre.ethers.getContractFactory("FiboTokenICO");
    const fiboICO = await FiboTokenICO.deploy("TOKEN_ADDRESS", "USDT_ADDRESS");

    await fiboICO.deployed();

    console.log("FiboTokenICO deployed to:", fiboICO.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
