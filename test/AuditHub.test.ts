// SPDX-License-Identifier: MIT
import { expect } from "chai";
import { ethers } from "hardhat";

describe("AuditHub - pause and ownership tests", function () {
  it("owner can pause and unpause, and non-owner cannot", async function () {
    const [owner, nonOwner] = await ethers.getSigners();

    const AuditHub = await ethers.getContractFactory("AuditHub");
    const hub = await AuditHub.deploy();
    await hub.deployed();

    // initial state
    expect(await hub.paused()).to.equal(false);

    // owner can pause
    await hub.connect(owner).setPaused(true);
    expect(await hub.paused()).to.equal(true);

    // non-owner cannot pause/unpause
    await expect(
      hub.connect(nonOwner).setPaused(false)
    ).to.be.reverted;

    // owner can unpause
    await hub.connect(owner).setPaused(false);
    expect(await hub.paused()).to.equal(false);
  });

  it("only owner can transfer ownership", async function () {
    const [owner, newOwner, other] = await ethers.getSigners();
    const AuditHub = await ethers.getContractFactory("AuditHub");
    const hub = await AuditHub.deploy();
    await hub.deployed();

    // non-owner cannot transfer
    await expect(
      hub.connect(other).transferOwnership(newOwner.address)
    ).to.be.reverted;

    // owner can transfer
    await hub.connect(owner).transferOwnership(newOwner.address);
    expect(await hub.owner()).to.equal(newOwner.address);
  });

  it("proposeAudit should respect paused state", async function () {
    const [owner, proposer] = await ethers.getSigners();
    const AuditHub = await ethers.getContractFactory("AuditHub");
    const hub = await AuditHub.deploy();
    await hub.deployed();

    // propose when not paused
    await hub.connect(proposer).proposeAudit("first audit");

    // pause and ensure proposeAudit reverts
    await hub.connect(owner).setPaused(true);
    await expect(
      hub.connect(proposer).proposeAudit("second audit")
    ).to.be.reverted;
  });
});
