# Gas optimization notes for AuditHub

This document outlines a small, incremental approach to reduce gas costs in the AuditHub contract suite without changing external behavior.

1) Prefer internal calls over external when interacting with your own contract functions
- If a public/external function can be inlined via an internal function, prefer the internal path to save the overhead of msg.sender/msg.value propagation and reduce SLOADs.

2) Minimize state writes inside loops
- When batching operations, accumulate results locally (in memory or calldata) and update state once, if possible.
- If state writes are necessary inside a loop, consider early exits to avoid unnecessary iterations.

3) Use short-circuit checks
- Place inexpensive checks before heavier logic to avoid unnecessary work in the common case.

4) Avoid heavy arithmetic in hot paths
- Use unchecked blocks for known-safe arithmetic inside loops to save gas, but ensure correctness and potential overflows are considered.

5) Batch operations carefully
- If there is a function that can be called in a loop, consider a batched version that processes multiple targets within a single transaction to amortize fixed costs (like SLOADs for access control and event emission).

6) Testing and benchmarks
- Add tests that compare gas usage before/after small changes to ensure improvements are realized in practice.

Note: Any future changes should be validated with a gas report (e.g., using scripts/gas_report.ts) and unit tests to ensure no behavioral regressions.
