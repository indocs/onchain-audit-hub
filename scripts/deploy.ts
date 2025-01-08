// Deploy script for local Hardhat network
import { ethers } from 'hardhat';

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying to local network with', deployer.address);

  const Factory = await ethers.getContractFactory('AuditHub');
  const hub = await Factory.deploy();
  await hub.deployed();
  console.log('AuditHub deployed at', hub.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
