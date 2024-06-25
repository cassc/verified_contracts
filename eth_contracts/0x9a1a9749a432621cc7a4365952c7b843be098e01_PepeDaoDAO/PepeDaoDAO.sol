/**
 *Submitted for verification at Etherscan.io on 2023-06-30
*/

/*
Pepe Dao

This contract is the basis of our decentralisation,
Pepe Dao is here to command.
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

abstract contract ERC20 {
    function balanceOf(address whom) public view virtual returns (uint256);
}

contract PepeDaoDAO {
    address public owner;
    uint256 public nextProposal;
    ERC20 token = ERC20(0xde16a7426b782D3679Ed8B8CbD42040D675008E2);

    uint256 public totalProposal;
    uint256 public totalProposalPassed;
    uint256 public tokenRequiredForProposal;
    uint256 public tokenRequiredForVoting;

    constructor() {
        owner = msg.sender;
        nextProposal = 1;
        totalProposal = 0;
        totalProposalPassed = 0;
        tokenRequiredForProposal = 30 * 10**9;
        tokenRequiredForVoting = 1 * 10**9;
    }

    struct proposal {
        uint256 id;
        address creator;
        bool exists;
        string title;
        string description;
        uint256 start;
        uint256 deadline;
        uint256 votesUp;
        uint256 votesDown;
        mapping(address => bool) voteStatus;
        address[] addresses;
        bool[] votes;
        bool countConducted;
        bool passed;
    }

    mapping(uint256 => proposal) public Proposals;

    function checkProposalEligibility(address _voter)
        private
        view
        returns (bool)
    {
        if (token.balanceOf(_voter) >= 0) {
            return true;
        }

        return false;
    }

    function checkVoteEligibility(address _voter) private view returns (bool) {
        if (token.balanceOf(_voter) >= 0) {
            return true;
        }

        return false;
    }

    function createProposal(
        string memory _title,
        string memory _description,
        uint256 _blocks
    ) public {
        require(
            token.balanceOf(msg.sender) >= tokenRequiredForProposal ||
                msg.sender == owner,
            "Only Owner Can Create Proposal"
        );
        /*require(
            checkProposalEligibility(msg.sender),
            "Only {token} holders can put forth Proposals"
        );*/

        proposal storage newProposal = Proposals[nextProposal];
        newProposal.id = nextProposal;
        newProposal.creator = msg.sender;
        newProposal.exists = true;
        newProposal.title = _title;
        newProposal.description = _description;
        newProposal.deadline = block.number + _blocks;
        newProposal.start = block.number;

      
        nextProposal++;
        totalProposal++;
    }

    function voteOnProposal(uint256 _id, bool _vote) public {
        require(Proposals[_id].exists, "This Proposal does not exist");
        require(
            checkVoteEligibility(msg.sender),
            "You can not vote on this Proposal"
        );
        require(
            !Proposals[_id].voteStatus[msg.sender],
            "You have already voted on this Proposal"
        );
        require(
            block.number <= Proposals[_id].deadline,
            "The deadline has passed for this Proposal"
        );
        require(
            token.balanceOf(msg.sender) >= tokenRequiredForProposal ||
                msg.sender == owner,
            "Not enough token to votes"
        );
        proposal storage p = Proposals[_id];
        Proposals[_id].addresses.push(msg.sender);
        Proposals[_id].votes.push(_vote);
        if (_vote) {
            p.votesUp++;
        } else {
            p.votesDown++;
        }

        p.voteStatus[msg.sender] = true;
    }

    function countVotes(uint256 _id) public {
        require(msg.sender == owner, "Only Owner Can Count Votes");
        require(Proposals[_id].exists, "This Proposal does not exist");
        require(
            block.number > Proposals[_id].deadline,
            "Voting has not concluded"
        );
        require(!Proposals[_id].countConducted, "Count already conducted");

        proposal storage p = Proposals[_id];

        if (Proposals[_id].votesDown < Proposals[_id].votesUp) {
            p.passed = true;
            totalProposalPassed++;
        }

        p.countConducted = true;

    }

    function getProposalVotes(uint256 _id)
        public
        view
        returns (address[] memory, bool[] memory)
    {
        return (Proposals[_id].addresses, Proposals[_id].votes);
    }

    function setRequiredTokens(uint256 _threshold) public {
        require(msg.sender == owner, "Only Owner Can Change the Threshold");
        tokenRequiredForProposal = _threshold;
    }

    function setRequiredTokensVoting(uint256 _threshold) public {
        require(msg.sender == owner, "Only Owner Can Change the Threshold");
        tokenRequiredForVoting = _threshold;
    }
}