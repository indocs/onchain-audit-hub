import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Gas estimates helper ready. Deployer:", deployer.address);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
