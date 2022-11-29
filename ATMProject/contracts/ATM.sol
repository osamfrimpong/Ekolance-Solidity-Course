// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;

import "../node_modules/@openzeppelin/contracts/utils/Strings.sol";
import "./utils/Modifiers.sol";
import "./utils/StringUtils.sol";

contract ATM is Modifiers {
    address payable public owner;

    mapping(address => uint256) private sender_deposit;

    struct ATMCardStruct {
        address onwer_address;
        string holder_name;
        bytes32 card_number;
        bytes32 pin;
    }

    mapping(address => ATMCardStruct) atmCard;

    bool private isLoggedIn = false;

    event LogMessage(string message, address indexed owner);

    constructor() {
        owner = payable(msg.sender);
    }

    function generateCardNumber()
        internal
        view
        returns (string memory cardNumber)
    {
        return
            StringUtils.substring(
                Strings.toString(
                    uint(
                        keccak256(
                            abi.encodePacked(
                                block.difficulty,
                                block.timestamp,
                                owner
                            )
                        )
                    )
                ),
                0,
                16
            );
    }

    function registerATM(
        string calldata name,
        string calldata pin
    ) public pinModifier(pin) returns (string memory) {
        require(
            atmCard[msg.sender].onwer_address != msg.sender,
            "You can't register more than one ATM card per account"
        );

        string memory generatedCardNumber = generateCardNumber();
        atmCard[msg.sender].onwer_address = msg.sender;
        atmCard[msg.sender].holder_name = name;
        atmCard[msg.sender].pin = keccak256(abi.encodePacked(pin));
        atmCard[msg.sender].card_number = keccak256(
            abi.encodePacked(generatedCardNumber)
        );

        emit LogMessage(
            string.concat(
                "ATM Registered successfully with Card Number: ",
                generatedCardNumber
            ),
            owner
        );

        return generatedCardNumber;
    }

    function login(
        string calldata card,
        string calldata pin
    ) public ownerModifier(owner) returns (bool loginResult) {
        require(!isLoggedIn, "You are already logged In");
        //gas optimization technique

        if (bytes(card).length != 16 || bytes(pin).length != 4) {
            //emit some message. Credentials length does not match
            revert("Card and Pin lengths do not match");
        } else {
            if (
                keccak256(abi.encodePacked(card)) ==
                atmCard[msg.sender].card_number &&
                keccak256(abi.encodePacked(pin)) == atmCard[msg.sender].pin
            ) {
                isLoggedIn = true;
                loginResult = true;
                emit LogMessage("Login Sucessful", owner);
            } else {
                loginResult = false;
                revert("Could not log in");
            }
        }
    }

    function deposit()
        external
        payable
        ownerModifier(owner)
        isLoggedInModifier(isLoggedIn)
    {
        require(msg.value > 0, "Amount to Deposit must be greater than zero");
        sender_deposit[msg.sender] += msg.value;
        //do the deposit over here
        emit LogMessage("Amount Deposited", owner);
    }

    function withdraw(
        uint _amount
    ) external ownerModifier(owner) isLoggedInModifier(isLoggedIn) {
        //check if balance is not less than withdrawal amount
        require(
            _amount <= getBalance(),
            "Your withdrawal amount should not be more than your balance"
        );
        payable(msg.sender).transfer(_amount);
        emit LogMessage("Amount Successfully Withdrawn", owner);
    }

    function getDeposit()
        public
        view
        isLoggedInModifier(isLoggedIn)
        ownerModifier(owner)
        returns (uint256)
    {
        return sender_deposit[msg.sender];
    }

    function getBalance()
        public
        view
        isLoggedInModifier(isLoggedIn)
        ownerModifier(owner)
        returns (uint)
    {
        return address(this).balance;
    }

    function getCardDetails()
        public
        view
        isLoggedInModifier(isLoggedIn)
        ownerModifier(owner)
        returns (ATMCardStruct memory)
    {
        return atmCard[msg.sender];
    }

    function logOut()
        public
        ownerModifier(owner)
        isLoggedInModifier(isLoggedIn)
        returns (bool)
    {
        isLoggedIn = false;
        emit LogMessage("You have logged out successfully", owner);
        return isLoggedIn;
    }
}
