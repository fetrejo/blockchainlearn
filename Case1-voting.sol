// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0;

contract Poll {

    // object with properties of a voter
    struct Voter {
        bool voted;
        uint vote;
    }

    // object with properties of a proposal
    struct Proposal {
        string name;
        uint voteCount;
        address crAddress;
    }

    // Ethereum address of the poll creator
    address public chairperson;

    // maps an arbitrary Ethereum address on the voter-Object
    mapping(address => Voter) public voters;
    
    // creates a list for all added proposalso
    Proposal[] public proposals;

    // constructor function gets called when the contract is deployed
    constructor() {
        chairperson = msg.sender;
    }
    
    // function to add a proposal others can vote for
    function addProposal(string memory proposalName) public {
        require(msg.sender == chairperson);
        proposals.push(
            Proposal(proposalName, 0, chairperson)
        );
    }
           
     // function to ban a vote
    function ban(address banAddress) public {
        Voter storage sender = voters[banAddress];
        sender.voted = true;
    }
    
    // function to vote for a proposal
    function vote(uint proposalNumber, address voteAddress) public {
        Voter storage sender = voters[voteAddress];
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposalNumber;
        proposals[proposalNumber].voteCount += 1;
    }

    // function to count out the votes and determine a winner
    function winningProposal() public view returns (uint winningProposalNumber) {
        uint winningVoteCount = 0;
        
        // iterate the array to determine the winner
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposalNumber = p;
            }
        }
    }

    // function to print out the name of the winning proposal
    function winnerName() public view returns (string memory winnerName_) {
        require(proposals.length!=0, "There is no proposal in the list!");
        winnerName_ = proposals[winningProposal()].name;
    }

}