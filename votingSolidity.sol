// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract VotingSystem {
  // Define the structure of a voter isRegisteres, hasVoted, voteProposal

  struct Voter {
      bool isRegistered;
      bool hasVoted;
      uint votingProposal;
  } 

  // Define the propasal and also define properties, name , number of counters

    struct Propasal {
        string name; // Name of Prop
        uint voteCount;
    }

    address public chairperson; // Address of chairperson of the voting system

    mapping(address => Voter) public voters; // Mapping a Voter address to voter informatioin

   Propasal[] public propasals; // Array of all proposals to store

 // Set the chair person
 // Set all propsal names and push it into the arrays

   constructor(string[] memory propasalNames) {
       chairperson = msg.sender;

       // Add each proposal to the propsal array
       for(uint i =0; i<propasalNames.length; i++) {
           propasals.push(Propasal({
               name : propasalNames[i],
               voteCount : 0
           }));
       }
   }

   function register(address voter) public {
       require(msg.sender == chairperson, "Only the chair person can register voters");

       require(!voters[voter].isRegistered , "Voter is already Registered" );

       voters[voter].isRegistered = true;
   }

   function Vote(uint proposalIndex) public{

       Voter storage sender = voters[msg.sender];

       require(sender.isRegistered, "Voter is not Registered");
       require(!sender.hasVoted, "Voter has already Voted");
       require(proposalIndex < propasals.length , "Inavlid Proposal ");

       sender.hasVoted = true;
       sender.votingProposal = proposalIndex;
       propasals[proposalIndex].voteCount +=1;

   }

   function winningProposal()  public view returns (uint winningProposalIndex) {
       uint winningVoteCount = 0;

       for(uint i=0; i< propasals.length; i++){
           if(propasals[i].voteCount > winningVoteCount) {
               winningVoteCount = propasals[i].voteCount;
               winningProposalIndex = i;
           }

       }
   }

     function winnerName () public view returns(string memory){
         return propasals[winningProposal()].name;
     }

}
