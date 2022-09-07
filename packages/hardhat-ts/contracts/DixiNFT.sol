pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract DixiNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  uint256 _currentPrice = 0.01;

  mapping(uint256 => bytes32) public _inputHashes; // private
  mapping(uint256 => bool) public _gameParticipation;

  constructor() ERC721("DixiNFT", "DIXI") {}

  function transferOwnership(address owner) onlyOwner {
    transferOwnership(owner);
  }

  function withdraw(uint256 amount) public payable {
    require(balances[msg.sender] >= amount, "not enough funds");
    balances[msg.sender] -= amount;
    payable(msg.sender).transfer(amount);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return "https://ipfs.io/ipfs/";
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal override(ERC721, ERC721Enumerable) {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    return super.tokenURI(tokenId);
  }

  function mintItem(address to, bytes32 inputHash) public returns (uint256) {
    require(msg.value >= _currentPrice, "Please check current price, it's already higher!");

    _tokenIds.increment();
    uint256 id = _tokenIds.current();
    _inputHashes[id] = inputHash;
    _owners[id] = to;
    return id;
  }

  function mintFinalize(uint256 id, string memory tokenURI) public onlyOwner returns (uint256) {
    // @! change onlyOwner to special sig

    address to = _owners[id];
    _mint(to, id);
    _setTokenURI(id, tokenURI);
    return id;
  }

  function enterTheGame(uint256 id) {
    require(_owners[id] == msg.sender, "Only NFT owner can enter the Game");
    _gameParticipation[id] = true;
  }

  function exitGame(uint256 id) {
    require(_owners[id] == msg.sender, "Only owner can take his NFT off the Game");
    _gameParticipation[id] = false;
  }

  // @! stake fight

  function takeOver(
    bytes sig,
    uint256 id,
    bytes32 hash
  ) {
    require(_gameParticipation[id], "This NFT owner decided not to participate in the Game");
    // @! check sig and transfer ownership

    // @! give new generation ticket
  }
}
