// SPDX-License-Identifier: Apache 2.0

pragma solidity >=0.8.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleERC20Token is ERC20 {

    address public owner;

    constructor () ERC20("SimpleToken", "STK") {
        owner = msg.sender;
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }

    function interChainBurn(address sender, uint amount) public {
        _burn(sender, amount);
    }

    function interChainMint(address sender, uint amount) public {
        _mint(sender, amount);
    }

}