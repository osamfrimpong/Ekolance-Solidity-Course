// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;

import "./StringUtils.sol";

contract Modifiers {
    modifier pinModifier(string memory pin) {
        require(
            StringUtils.getPinLength(pin) == 4,
            "Pin Must Be Exactly 4 Digits"
        );
        _;
    }

    modifier ownerModifier(address payable owner) {
        require(
            owner == msg.sender,
            "Sorry You Are not the owner of the wallet"
        );
        _;
    }

    modifier isLoggedInModifier(bool isLoggedIn) {
        require(isLoggedIn, "Sorry You Are not logged in yet");
        _;
    }
}
