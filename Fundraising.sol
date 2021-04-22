pragma solidity ^0.8.0;

contract FundRaising {

        mapping(address => uint) public contributors;
        address public admin;
        uint public numOfContributors;
        uint public minContribution;
        uint public deadline;
        uint public goal;
        uint raisedAmount = 0;

        struct Request {
            string description;
            address payable recipient;
            uint value;
            bool completed;
            uint numOfVoters;

        }
         mapping(address => bool)  voters;

        Request[] public requests;
        event ContributeEvent(address sender, uint value);
        event CreateRequestEvent(string  _description, address _recipient, uint _value);
        event MakePaymentEvent(address recipient, uint value);
        constructor(uint _goal, uint _deadline) {
            admin = msg.sender;
            numOfContributors = 0;
            minContribution = 10;
            deadline = block.timestamp + _deadline;
            goal = _goal;
        }

        modifier onlyAdmin() {
            require(msg.sender == admin);
            _;
        }

        function contribute() public payable {
            require(block.timestamp < deadline);
            require(msg.value >= minContribution);
            if(contributors[msg.sender] == 0) {
                numOfContributors++;
            }
            contributors[msg.sender] += msg.value;
            raisedAmount += msg.value;
            if(raisedAmount >= goal) {

            }
            emit ContributeEvent(msg.sender, msg.value);
        }

        function getBalance() public view returns(uint) {
            return address(this).balance;
        }

        function getRefund() public {
            require(block.timestamp > deadline);
            require(raisedAmount < goal);
            require(contributors[msg.sender] > 0);

            address payable recipient = payable(msg.sender);
            uint value = contributors[msg.sender];
            recipient.transfer(value);
            contributors[msg.sender] = 0;


        }

        function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin {
            Request memory newRequest =  Request({
                description: _description,
                recipient: _recipient,
                value: _value,
                completed: false,
                numOfVoters: 0
            });
            requests.push(newRequest);
            emit CreateRequestEvent(_description, _recipient, _value);
        }

        function voteRequest(uint index) public {
            Request storage thisRequest = requests[index];

            require(contributors[msg.sender] > 0);
            require(voters[msg.sender] == false);

            voters[msg.sender] = true;
            thisRequest.numOfVoters++;
        }

        function makePayment(uint index) public onlyAdmin {
            Request storage request = requests[index];
            require(request.completed == false);
            require(request.numOfVoters > numOfContributors / 2);
            request.recipient.transfer(request.value);
            request.completed = true;
            emit MakePaymentEvent(request.recipient, request.value);
        }
}