pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract ArtiDix is OwnableUpgradeable {
  mapping(address => uint256) public balances;

  // @! mint (cost)

  // takeover (sig)
  //

  function withdraw(uint256 amount) public payable {
    require(balances[msg.sender] >= amount, "not enough funds");
    balances[msg.sender] -= amount;
    payable(msg.sender).transfer(amount);
  }

  // error EmptyPurposeError(uint code, string message);

  constructor() {}

  // trash
  string public purpose = "Building Unstoppable Apps!!!";
  event SetPurpose(address sender, string purpose);

  function setPurpose(string memory newPurpose) public {
    require(msg.sender == owner(), "not the owner");

    //     revert EmptyPurposeError({code: 1, message: "Purpose can not be empty"});
    purpose = newPurpose;
    console.log(msg.sender, "set purpose to", purpose);
    emit SetPurpose(msg.sender, purpose);
  }
}
