// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Ownable } from "./Ownable.sol";

/// @title Pausable
/// @notice Simple pause/unpause mechanism controlled by the contract owner.
/// This utility can be inherited by other contracts to gate functionality
/// during maintenance or emergency.
contract Pausable is Ownable {
    bool private _paused;

    event Paused(address account);
    event Unpaused(address account);

    /// @notice Returns true if the contract is paused, false otherwise.
    function paused() external view returns (bool) {
        return _paused;
    }

    /// @notice Modifier to make a function callable only when not paused.
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /// @notice Pauses the contract. Can only be called by the owner.
    function pause() external onlyOwner {
        require(!_paused, "Pausable: already paused");
        _paused = true;
        emit Paused(msg.sender);
    }

    /// @notice Unpauses the contract. Can only be called by the owner.
    function unpause() external onlyOwner {
        require(_paused, "Pausable: not paused");
        _paused = false;
        emit Unpaused(msg.sender);
    }
}
