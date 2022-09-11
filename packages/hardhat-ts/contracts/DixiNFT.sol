pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./lib/Verify.sol";

//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721
// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract DixiNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  uint256 _currentPrice = 0.01 ether;

  mapping(uint256 => bytes32) public _inputHashes; // private
  mapping(uint256 => address) public _minters;
  mapping(uint256 => address) private _owners;
  mapping(uint256 => bool) public _gameParticipation;

  constructor() ERC721("DixiNFT", "DIXI") {}

  function transferOwnership(address owner) public override(Ownable) onlyOwner {
    transferOwnership(owner);
  }

  function withdraw(uint256 amount) public payable onlyOwner {
    payable(owner()).transfer(amount);
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

  function getCurrentPrice() public returns (uint256) {
    return _currentPrice;
  }

  function mintItem(
    address to,
    bytes32 inputHash,
    bool enterGame
  ) public payable returns (uint256) {
    require(msg.value >= _currentPrice, "Please check current price, it's already higher!");

    _tokenIds.increment();
    uint256 id = _tokenIds.current();
    _inputHashes[id] = inputHash;
    _minters[id] = to;
    _gameParticipation[id] = enterGame;
    return id;
  }

  function mintFinalize(uint256 id, string memory ipfsTokenUri) public onlyOwner returns (uint256) {
    // @! change onlyOwner to special sig

    _currentPrice = _currentPrice + _currentPrice / 200;
    address to = _minters[id];
    _mint(to, id);
    _setTokenURI(id, ipfsTokenUri);
    return id;
  }

  function enterTheGame(uint256 id) public {
    require(_minters[id] == msg.sender, "Only NFT owner can enter the Game");
    _gameParticipation[id] = true;
  }

  function exitGame(uint256 id) public {
    require(_minters[id] == msg.sender, "Only owner can take his NFT off the Game");
    _gameParticipation[id] = false;
  }

  function tryGuess(uint256 id, string memory phrase) public payable returns (bool) {
    // @! check stake
    // @!
  }

  function takeOver(
    uint256 id,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public {
    require(_gameParticipation[id], "This NFT owner decided not to participate in the Game");

    bytes memory message = abi.encodePacked(id, msg.sender);
    address signer = verifyBytes(message, v, r, s);

    require(signer == owner(), "Signature incorrect. Did you actually win to take over this NFT?");

    approve(msg.sender, id);

    // @! transfer token from proper owner's address
    transferFrom(_owners[id], msg.sender, id);

    // @! give new generation ticket
  }
}
