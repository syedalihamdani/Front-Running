  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";


contract IntermediateState is Ownable{
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
    }

    function removeAdmin(address _admin) external{
        require(adminshipList[msg.sender].member,"IntermediateState: Only admin can remove the other admin");
        require(!adminshipList[msg.sender].suspend,"IntermediateState: Only non suspended admin can remove the other admin");
        adminshipList[_admin].suspend=true;
        adminshipList[msg.sender].suspend=true;
    }


    function intermediateState(address _voteFor) external{
        require(adminshipList[msg.sender].member,"IntermediateState: only admin allowed to call this function");
        require(!adminshipList[msg.sender].suspend,"IntermediateState: Only non suspended admin can vote for the other admin");
        require(!intermediateVoteFor[msg.sender][_voteFor],"IntermediateState:You have already vote for this admin");
        require(msg.sender!=_voteFor,"IntermediateState:You can not vote for your self");

        intermediateVoteFor[msg.sender][_voteFor]=true;
        adminshipList[_voteFor].noOfVotes +=1;
    }

    function useRight(address _admin) external {
        require(adminshipList[msg.sender].member,"IntermediateState: only admin allowed to call this function");
        require(adminshipList[msg.sender].noOfVotes>=2,"IntermediateState: only admin allowed to call this function");
        require(adminshipList[_admin].suspend,"IntermediateState: Only suspended admin can be remove from the administration");

        adminshipList[_admin].member=false;
        adminshipList[msg.sender].suspend=false;
    }



}