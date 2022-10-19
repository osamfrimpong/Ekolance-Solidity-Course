// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract EtherWalletB {
    address payable public owner;
    mapping(address => uint256) private sender_deposit;

    constructor() {
        owner = payable(msg.sender);
    }

    // receive() external payable {}

    function deposit() external payable {

        require(msg.value > 0, "Amount Must Be Greater Than 0");
        sender_deposit[msg.sender] += msg.value;
        
    }


    function withdraw(uint _amount) external {
        require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(_amount);
    }


    function withdrawDeposit() public {

        address sender_address = payable(msg.sender);
        uint256 amount = sender_deposit[sender_address];
        (bool success, ) = sender_address.call{value: amount}("Withdrawal");
        require(success, "Withdrawal not Successful");
        sender_deposit[sender_address] = 0;
    }

    function getDeposit() public view returns (uint256){
        return sender_deposit[msg.sender];
    }


    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
