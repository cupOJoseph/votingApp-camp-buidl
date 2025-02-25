pragma solidity ^0.8.26;

import "./VotingSystem.sol";

contract Treasury {
    
    address public votingSystemAddress;

    constructor(address _votingSystem){
        votingSystemAddress = _votingSystem;
    }

    //should we have re-entry protection here???
    function sendAssets(uint proposalId) external{ //should we have re-entry protection here???
        require(msg.sender == votingSystemAddress, "Only voting system can send assets");

        require(VotingSystem(votingSystemAddress).checkProposalStatus(proposalId), "Proposal has not passed");
        
        VotingSystem.ProposalStruct memory proposal = VotingSystem(votingSystemAddress).getProposal(proposalId);

        require(!proposal.executed, "Proposal has already been executed");

        // Update execution status through voting system
        VotingSystem(votingSystemAddress).updateExecuted(proposalId);

        (bool success, ) = proposal.target.call{value: proposal.value}("");
        require(success, "Failed to send assets");
    }
    
    
}