import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying AuditHub with", deployer.address);

  const AuditHubFactory = await ethers.getContractFactory("AuditHub");
  const auditHub = await AuditHubFactory.deploy();
  const receipt = await auditHub.deployTransaction.wait();

  console.log("AuditHub deployed at:", auditHub.address);
  console.log("Gas used for deployment:", receipt.gasUsed.toString());
  console.log("Gas price:", (receipt.effectiveGasPrice ?? 0).toString());
  const costEth = ethers.utils.formatEther(
    receipt.gasUsed.mul(receipt.effectiveGasPrice ?? 0)
  );
  console.log("Total cost (ETH, approx):", costEth);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
