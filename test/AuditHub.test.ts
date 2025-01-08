import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('AuditHub', function () {
  let AuditHub: any;
  let hub: any;
  let owner: any;
  let addr1: any;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    const factory = await ethers.getContractFactory('AuditHub');
    hub = await factory.deploy();
    await hub.deployed();
  });

  it('should set owner on deployment', async function () {
    const currentOwner = await hub.owner();
    expect(currentOwner).to.equal(await ethers.getSigner(0).getAddress());
  });

  it('should allow owner to profile a tx deterministically and cache result', async function () {
    const [signer] = await ethers.getSigners();
    // prepare a payload
    const data = ethers.utils.toUtf8Bytes('complex-l2-tx-payload-001');
    const txHash = ethers.utils.keccak256(data);

    // first call computes and caches
    const gas1 = await hub.connect(signer).profileTx(data) as any;
    // second call should emit and return cached value via constant, but function returns computed value on call as well
    const gas2 = await hub.connect(signer).profileTx(data) as any;
    expect(gas1).to.equal(gas2);
  });

  it('should revert when non-owner tries to register audit', async function () {
    const data = ethers.utils.toUtf8Bytes('payload');
    const txHash = ethers.utils.keccak256(data);
    const gasCost = 1234;

    await expect(hub.connect(addr1).registerAudit(txHash, gasCost, 'test')).to.be.revertedWith('AuditHub: caller is not the owner');
  });

  it('owner can register and retrieve an audit', async function () {
    const data = ethers.utils.toUtf8Bytes('payload-for-audit');
    const txHash = ethers.utils.keccak256(data);
    const gasCost = 2000;

    // profile first to ensure we have a gas cost
    const grad = await hub.profileTx(data);
    // register audit
    await expect(hub.registerAudit(txHash, gasCost, 'audit-desc')).to.not.be.reverted;
    // retrieve audit
    const rec = await hub.getAudit(txHash);
    expect(rec.gasCost).to.equal(gasCost);
    expect(rec.description).to.equal('audit-desc');
  });
});
