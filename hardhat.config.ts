import { HardhatUserConfig } from 'hardhat/types';
import '@nomicfoundation/hardhat-toolbox';

const config: HardhatUserConfig = {
  solidity: {
    compilers: [{ version: '0.8.20' }],
  },
  paths: {
    sources: 'contracts',
    tests: 'test',
    artifacts: 'artifacts'
  },
  mocha: {
    timeout: 20000
  },
  networks: {
    hardhat: {
      chainId: 1337
    },
    local: {
      url: process.env.RPC_URL || 'http://127.0.0.1:8545',
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : undefined
    }
  }
};

export default config;
