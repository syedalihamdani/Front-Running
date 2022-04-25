    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";


contract IntermediateState is Ownable{
    event _removeAdmin(address indexed _remover,address indexed  other,uint _complaintTime);
    event _enternewAdmin(address indexed adder,address indexed  newAdmin);
    event _voteCasted(address indexed voter,address indexed  voterFor);
    event _adminRights(address indexed Caller,address indexed adminRemoved);

    struct adminData{
        bool member;
        bool suspend;
        uint8 noOfVotes;
    }

    mapping(address=>adminData) adminshipList;
    mapping (address=>mapping(address=>bool)) intermediateVoteFor;

    constructor(){
        adminshipList[msg.sender]=adminData(true,false,0);
    }

    function isAdmin(address _admin) external view returns(bool){
        return adminshipList[_admin].member;
    }
    function adminVotes(address _admin) external view returns(uint8){
        return adminshipList[_admin].noOfVotes;
    }

    function isAdminSuspended(address _admin) external view returns(bool){
        return adminshipList[_admin].suspend;
    }


    // I will add 5 admin to the list
    function enterNewAdmin(address _admin) external onlyOwner{
        adminshipList[_admin]=adminData(true,false,0);
        emit _enternewAdmin(msg.sender, _admin);
    }

    function removeAdmin(address _admin) external{
        require(adminshipList[msg.sender].member,"IntermediateState: Only admin can remove the other admin");
        require(!adminshipList[msg.sender].suspend,"IntermediateState: Only non suspended admin can remove the other admin");
        intermediateState(_admin);
        emit _removeAdmin(msg.sender,_admin,block.timestamp);


        // If ther is no intermediate state function;
        // adminshipList[_admin].member=false;


    }
     function intermediateState(address _admin) private{
        adminshipList[_admin].suspend=true;
        adminshipList[msg.sender].suspend=true;
    }



    function adminVote(address _voteFor) external{
        require(adminshipList[msg.sender].member,"IntermediateState: only admin allowed to call this function");
        require(!adminshipList[msg.sender].suspend,"IntermediateState: Only non suspended admin can vote for the other admin");
        require(!intermediateVoteFor[msg.sender][_voteFor],"IntermediateState:You have already vote for this admin");
        require(msg.sender!=_voteFor,"IntermediateState:You can not vote for your self");

        intermediateVoteFor[msg.sender][_voteFor]=true;
        adminshipList[_voteFor].noOfVotes +=1;

        emit _voteCasted(msg.sender, _voteFor);
    }

    function useRight(address _admin) external {
        require(adminshipList[msg.sender].member,"IntermediateState: only admin allowed to call this function");
        require(adminshipList[msg.sender].noOfVotes>=2,"IntermediateState:The admin who has high votes can cal this function");
        require(adminshipList[_admin].suspend,"IntermediateState: Only suspended admin can be remove from the administration");

        adminshipList[_admin].member=false;
        adminshipList[msg.sender].suspend=false;
        adminshipList[msg.sender].noOfVotes=0;

        emit _adminRights(msg.sender, _admin);
    }



}