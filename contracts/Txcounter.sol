// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.2;

// contract Txcounter {
//   uint256  private price;
//   uint256  private txCounter;
//   address private Owner;
  
//   event Purchase(address _buyer, uint256 _price);
//   event PriceChange(address _owner, uint256 _price);

//   constructor(address _owner){
//       Owner=_owner;
//       price=100;
//       txCounter=0;
//   }
  
//   modifier ownerOnly() {
//     require(msg.sender == Owner);
//     _;
//   }
//   function getPrice() external view returns (uint256) {
//     return price;
//   }

//   function getTxCounter() external view returns (uint256) {
//     return txCounter;
//   }

//   function buy(uint256 _txCounter) external returns (uint256) {
//     require(_txCounter == txCounter);
//     emit Purchase(msg.sender, price);
//     return price;
//   }

//   function setPrice(uint256 _price) external ownerOnly() {
//     price = _price;
//     txCounter += 1;
//    emit  PriceChange(Owner, price);
//   }
// }