// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VotingSystem {
    // Structure to hold the details of each proposal
    struct Proposal {
        string description;    // Description of the proposal
        uint voteCount;        // Number of accumulated votes
    }

    // List of proposals in the system
    Proposal[] public proposals;

    // Mapping to keep track of who has voted
    mapping(address => bool) public hasVoted;

    // Address of the contract owner
    address public owner;

    // Event to log when a proposal is created
    event ProposalCreated(uint proposalId, string description);
    
    // Event to log when a vote is cast
    event Voted(uint proposalId, address voter);

    // Modifier to restrict actions to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to create a new proposal
    function createProposal(string memory _description) public onlyOwner {
        proposals.push(Proposal({
            description: _description,
            voteCount: 0
        }));
        emit ProposalCreated(proposals.length - 1, _description);
    }

    // Function to vote on a proposal
    function vote(uint _proposalId) public {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        require(!hasVoted[msg.sender], "You have already voted");

        proposals[_proposalId].voteCount += 1;
        hasVoted[msg.sender] = true;
        emit Voted(_proposalId, msg.sender);
    }

    // Function to get the winning proposal
    function getWinningProposal() public view returns (uint winningProposalId) {
        uint winningVoteCount = 0;

        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
    }

    // Function to get the details of a proposal
    function getProposal(uint _proposalId) public view returns (string memory description, uint voteCount) {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.description, proposal.voteCount);
    }
}
