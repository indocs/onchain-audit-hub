// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AuditHub
/// @notice A deterministic gas profiler and verifier for complex L2 transactions with simple on-chain registry
/// @author onchain-audit-hub

contract AuditHub {
    // Simple access control (owner)
    address public owner;

    // Deterministic gas profile model: mapping from txData hash to a computed gasCost
    mapping(bytes32 => uint256) private _profiledGas;

    // Audit records
    struct AuditRecord {
        uint256 gasCost;
        uint256 timestamp;
        string description;
    }

    mapping(bytes32 => AuditRecord) private _audits;

    // Events
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event GasProfileComputed(bytes32 indexed txHash, uint256 gasCost);
    event AuditRegistered(bytes32 indexed txHash, uint256 gasCost, string description);

    modifier onlyOwner() {
        require(msg.sender == owner, "AuditHub: caller is not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "AuditHub: new owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /// @notice deterministically profile a transaction payload and cache the result
    /// @param txData arbitrary data payload representing a complex L2 tx
    /// @return gasCost deterministic gas estimate derived from txData length and content
    function profileTx(bytes memory txData) external returns (uint256) {
        bytes32 h = keccak256(txData);
        uint256 existing = _profiledGas[h];
        if (existing != 0) {
            emit GasProfileComputed(h, existing);
            return existing;
        }
        // Simple deterministic model: base 1000 + 7 * data length + hash-derived offset
        uint256 base = 1000;
        uint256 len = txData.length;
        uint256 hashFactor = uint256(h) % 97; // keep small variation
        uint256 computed = base + (len * 7) + hashFactor;
        _profiledGas[h] = computed;
        emit GasProfileComputed(h, computed);
        return computed;
    }

    /// @notice Register an audit for a given tx hash with a description and derived gasCost
    function registerAudit(bytes32 txHash, uint256 gasCost, string calldata description) external onlyOwner {
        require(_audits[txHash].timestamp == 0, "AuditHub: audit already exists");
        _audits[txHash] = AuditRecord({ gasCost: gasCost, timestamp: block.timestamp, description: description });
        emit AuditRegistered(txHash, gasCost, description);
    }

    /// @notice Retrieve an audit by txHash
    function getAudit(bytes32 txHash) external view returns (AuditRecord memory) {
        AuditRecord memory rec = _audits[txHash];
        require(rec.timestamp != 0, "AuditHub: audit not found");
        return rec;
    }
}
