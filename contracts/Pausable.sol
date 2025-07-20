// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

/// @title Pausable - allows children to implement an emergency stop mechanism.
/// @dev This is a simplified reimplementation to keep changes small.
contract Pausable is Ownable {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor() {
        _paused = false;
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    function _pause() internal whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    function _unpause() internal whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    // External emergency control:
    // Allows the contract owner to unpause forcibly if needed,
    // providing a safety valve for deployments that encounter
    // unforeseen paused state during upgrades or migrations.
    function emergencyUnpause() external onlyOwner whenPaused {
        _unpause();
    }
}
