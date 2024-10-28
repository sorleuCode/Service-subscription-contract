// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SoliuService {
    address public owner;
    uint256 public  serviceFees;
    uint256 public  servicePeriod;


    struct Subscription {
        bool autoRenewal;
        uint256 startDate;
        uint256 expiryDate;
    }


    mapping (address => Subscription) public subscriber;


    constructor(uint256 _servicePeriod, uint256 _serviceFees) {
        owner = msg.sender;
        serviceFees = _serviceFees;
        servicePeriod = _servicePeriod;
    }


    //events 

    event SubscriptionStarted(address indexed subscriber, uint256 expiration);

    event SubscriptionRenewed(address indexed subscriber, uint256 expiration);

    event SubscriptionCancelled(address indexed subscriber);

    event AutoRenewalActivated(address indexed  subscriber);

    event FundsWithdrawn(address indexed serviceProvider, uint amount);

    function subscribe () external payable  {
        require(msg.sender != address(0), "Zero is not allowed");
        require(msg.value == serviceFees, "Invalid amount");

        Subscription memory newSubscription;
        newSubscription.autoRenewal = false;
        newSubscription.startDate = block.timestamp;
        newSubscription.expiryDate = block.timestamp + servicePeriod;
        subscriber[msg.sender] = newSubscription;

        emit SubscriptionStarted (msg.sender, subscriber[msg.sender].expiryDate);
    }


    function activateAutoRenewal() external {
        require(msg.sender != address(0), "Zero not allowed");
        require(subscriber[msg.sender].startDate > 0, "You are not a subscriber");

        subscriber[msg.sender].autoRenewal = true;

        emit AutoRenewalActivated (msg.sender);


    }


   function renewSubscription() external payable {
    require(msg.sender != address(0), "Zero address not allowed");
    require(subscriber[msg.sender].expiryDate < block.timestamp, "Subscription is still active");
    require(subscriber[msg.sender].autoRenewal, "Auto-renewal is disabled");
    require(msg.value == serviceFees, "Incorrect Ether amount sent for renewal");

    subscriber[msg.sender].expiryDate = block.timestamp + servicePeriod;

    emit SubscriptionRenewed(msg.sender, subscriber[msg.sender].expiryDate);
}


    function cancelAutoRenewal () external {
        require(msg.sender != address(0), "Zero not allowed");
        require(subscriber[msg.sender].autoRenewal, "No auto-renewal set");

        subscriber[msg.sender].autoRenewal = false;

        emit SubscriptionCancelled(msg.sender);

    }


    function widthrawfund () external {
        require(msg.sender != address(0), "Zero not allowed");
        require(msg.sender == owner, "Only owner can withdraw");
        require(address(this).balance > 0, "No balance to withdraw");

        payable(owner).transfer(address(this).balance);

        emit FundsWithdrawn(owner, address(this).balance);



    }


    receive() external payable { }

    fallback() external payable { }

    
}