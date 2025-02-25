pragma solidity ^0.8.26;

contract Proposal {
    

    //list of proposals
    ProposalStruct[] public proposals;

    struct ProposalStruct {
        uint numberOfVotes;
        uint yesVotes;
        uint noVotes;
        uint abstainVotes;
        uint deadLine;
    }

   
    
}