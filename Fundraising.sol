pragma solidity ^0.8.0;

contract FundRaising {

        mapping(address => uint) public contributors;
        address public admin;
        uint public numOfContributors;
        uint public minContribution;
        uint public deadline;
        uint public goal;
        uint raisedAmount = 0;
        constructor(uint _goal, uint _deadline) {
            admin = msg.sender;
            numOfContributors = 0;
            minContribution = 10;
            deadline = block.timestamp + _deadline;
            goal = _goal;
        }


}