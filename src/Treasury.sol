pragma solidity ^0.8.26;

contract Treasury {
    
    address public votingSystem;

    constructor(address _votingSystem){
        votingSystem = _votingSystem;
    }

    function sendAssets(uint amount, address reciever) external{
        require(msg.sender == votingSystem, "Only voting system can send assets");
    
    }
    
    
}