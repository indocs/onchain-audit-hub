# onchain-audit-hub

Outline
- What it is: A local, deterministic gas profiler and verifier for complex L2 transactions, enabling precise cost budgeting and reproducible audits.
- Core ideas: deterministic gas profiling, deterministic benchmarks, access-controlled audit registry, and HHL tooling for local verification.
- How to use: Hardhat-based workflow with env-driven RPC URLs and local testing harness.

Quickstart
1. Install dependencies
   - Ensure Node.js >= 18.
   - Run: npm ci
2. Run tests
   - Copy environment: cp .env.example .env (set RPC_URL, PRIVATE_KEY as needed)
   - npx hardhat test
3. Run a local deploy (script)
   - npx hardhat run scripts/deploy.ts --network local

Deployment
- Prepare a local Hardhat network (or use a local node).
- Deploy AuditHub contract via scripts/deploy.ts; logs include deployed address.
- Use tests to validate deterministic gas profiling and revert behaviors.

Outline of the project
- contracts/AuditHub.sol: Core deterministic profiler with access control and audit registry.
- test/AuditHub.test.ts: Unit tests covering ownership, reverts, and deterministic outputs.
- scripts/deploy.ts: Deploy to a local network with environment-driven configuration.
- hardhat.config.ts: Hardhat config with TS support and toolbox plugin.
- package.json: Minimal, realistic dependencies for a compact production-ready setup.
