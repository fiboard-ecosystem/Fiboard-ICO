const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("DeployFibo", (m) => {
    const tokenAddress = "TOKEN_ADDRESS";
    const usdtAddress = "USDT_ADDRESS";

    const fiboICO = m.contract("FiboTokenICO", [tokenAddress, usdtAddress]);

    return { fiboICO };
});
