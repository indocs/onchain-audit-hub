// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// A minimal AuditHub with simple ownership and pause controls.
// This augments existing functionality with basic access control and pausing
// to improve testability and reliability in CI.

contract AuditHub {
    // Ownership control
    address private _owner;

    // Pause control
    bool public paused;
    event PausedStateChanged(bool paused);

    // Simple audit entry
    struct Audit {
        uint256 id;
        string data;
        address proposer;
        uint256 timestamp;
    }

    uint256 private _nextId = 1;
    mapping(uint256 => Audit) private _audits;

    event AuditProposed(uint256 indexed id, address indexed proposer, string data);

    modifier onlyOwner() {
        require(msg.sender == _owner, "AuditHub: caller is not the owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "AuditHub: paused");
        _;
    }

    constructor() {
        _owner = msg.sender;
        paused = false;
    }

    // Ownership helpers
    function owner() external view returns (address) {
        return _owner;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "AuditHub: new owner is zero address");
        _owner = newOwner;
    }

    // Pause controls
    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
        emit PausedStateChanged(_paused);
    }

    // Core functionality (example, kept minimal for reliability)
    function proposeAudit(string calldata data) external whenNotPaused {
        require(bytes(data).length > 0, "AuditHub: empty data");
        uint256 id = _nextId++;
        _audits[id] = Audit({
            id: id,
            data: data,
            proposer: msg.sender,
            timestamp: block.timestamp
        });
        emit AuditProposed(id, msg.sender, data);
    }

    function getAudit(uint256 id) external view returns (
        uint256, string memory, address, uint256
    ) {
        Audit memory a = _audits[id];
        require(a.id != 0, "AuditHub: audit does not exist");
        return (a.id, a.data, a.proposer, a.timestamp);
    }
}
