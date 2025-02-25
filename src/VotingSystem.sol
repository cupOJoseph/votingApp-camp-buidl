pragma solidity ^0.8.26;

contract VotingSystem {
    
    uint quorumRequirement; 

    address public treasuryAddress;


    uint passingThreshold; //percentage of votes needed to pass. 
    //divide by 100 to get a percentage

    struct ProposalStruct {
        uint numberOfVotes;
        uint yesVotes;
        uint noVotes;
        uint abstainVotes;
        uint deadLine;

        //execution info
        bool executed;
        address target;
        uint value;
    }

    ProposalStruct[] public proposals;

    uint public proposalCount = 0;


    constructor(address _treasury){
        treasuryAddress = _treasury;
    }

    //data structures do we need here?
    //0 = no, 1 = yes, 2 = abstain
    function vote(uint proposalId, uint voteType) external{
        require(voteType == 0 || voteType == 1 || voteType == 2, "Invalid vote type");
        require(block.timestamp < proposals[proposalId].deadLine, "Deadline has passed");
        
        proposals[proposalId].numberOfVotes++;
        if(voteType == 0){
            proposals[proposalId].noVotes++;
        }
        else if(voteType == 1){
            proposals[proposalId].yesVotes++;
        }
        else if(voteType == 2){
            proposals[proposalId].abstainVotes++;
        }
    }

    function createProposal(uint proposalId, uint deadLine, address target, uint valueToSend) external{
        ProposalStruct memory proposal = ProposalStruct({
            numberOfVotes: 0,
            yesVotes: 0,
            noVotes: 0,
            abstainVotes: 0,
            deadLine: deadLine,
            executed: false,
            target: target,
            value: valueToSend
        });

        proposals.push(proposal);
        proposalCount++;
    }

    //After a proposal deadline is passed we can see if it passed or not
    function checkProposalStatus(uint proposalId) external view returns (bool){
        require(block.timestamp > proposals[proposalId].deadLine, "Voting is still ongoing");
        
        if((proposals[proposalId].yesVotes / proposals[proposalId].noVotes) * 100 > passingThreshold){
            if(proposals[proposalId].yesVotes >= quorumRequirement){
                return true;
            }
        }
        return false;
    }

    //execute successful proposals
    function updateExecuted(uint proposalId) external{
        require(msg.sender == treasuryAddress, "Only treasury can update executed");
        proposals[proposalId].executed = true;
    }

    //Updater functions
    function updateQuorum(uint newQuorum) external{
        quorumRequirement = newQuorum;
    }

    function updatePassingThreshold(uint newThreshold) external{
        passingThreshold = newThreshold;
    }

    // Add getter function
    function getProposal(uint256 proposalId) external view returns (ProposalStruct memory) {
        return proposals[proposalId];
    }
  
    
    
}