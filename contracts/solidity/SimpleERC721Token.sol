// SPDX-License-Identifier: GPL 3.0
pragma solidity >0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract SimpleERC721Token is ERC721, ERC721Burnable {

    address public owner;
    uint256 private _nextTokenId;

    constructor()
        ERC721("SimpleNFT", "SNFT")
    {
        owner = msg.sender;
    }

    function safeMint(address to) public {
        require(msg.sender == owner);
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function interChainBurn(uint tokenId) public {
        _burn(tokenId);
    }

    function interChainMint(address to) public {
        uint tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }
}