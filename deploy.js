require("dotenv").config();
const hre = require("hardhat");

async function main() {
  console.log("🚀 Starting deployment...\n");

  // Compile contracts
  await hre.run("compile");

  // Get deployer account
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  // Check balance
  const balance = await deployer.getBalance();
  console.log("Account balance:", hre.ethers.utils.formatEther(balance), "MATIC\n");

  // Deploy FeeCollector
  console.log("Deploying FeeCollector...");
  const FeeCollector = await hre.ethers.getContractFactory("FeeCollector");
  const feeCollector = await FeeCollector.deploy();
  await feeCollector.deployed();
  console.log("✅ FeeCollector deployed to:", feeCollector.address, "\n");

  // Polygon Uniswap (QuickSwap) Router
  const uniswapRouterAddress = "0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff";

  // Deploy DexRouter
  console.log("Deploying DexRouter...");
  const DexRouter = await hre.ethers.getContractFactory("DexRouter");
  const dexRouter = await DexRouter.deploy(
    feeCollector.address,
    uniswapRouterAddress
  );
  await dexRouter.deployed();
  console.log("✅ DexRouter deployed to:", dexRouter.address, "\n");

  console.log("🎉 Deployment complete!");
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});