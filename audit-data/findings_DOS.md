### [M-#] TITLE Looping through `Players` array to check for POS in the `PuppyRaffle::enterRaffle` function allows for a DOS attack.



**Description:** 
The `PuppyRaffle::enterRaffle` function loops through the players array to check for duplicates, however the longer the `PuppyRaffle::players` array is the more checks a new player has to make. This means the gas cost for older players is far less 
for new players. Every additional address in the `players` array is an additional check the loop has to make.

**Impact:** 
The gas cost for raffle entrants will greatly increase as more players enter the raffle. Discouraging Later users from entering.

An attacker might make the `PuppyRaffle::entrants` array so big, that no one else enters guaranteeing they win.

**Proof of Concept:**

If we have 2 sets of 100 players enter, the gas cost be as such:
- 1st 100 players: ~6272127
- 2nd 100 players: ~40082831

This is around 6x more expensive for the second 100 players

```javascript
 //@audit - DOS Exploit, an attacker looking to win the raffle could enter with a lot of accounts stopping the function from being
        //entered in the future. The prices would need to be worth more than the entrance fee though, so this is a viable attack if the
        //attacker wants to take down the system, and doesn't care too much about money
        for (uint256 i = 0; i < players.length - 1; i++) {
            for (uint256 j = i + 1; j < players.length; j++) {
                require(players[i] != players[j], "PuppyRaffle: Duplicate player");
            }
        }
```
Place the following test into `PuppyRaffleTest.t.sol`
<details>

```javascript
    function test_denialOfService() public {

        vm.txGasPrice(1);
        uint256 playersNum = 100;
        address[][] memory listOfPlayerAddress = new address[][](2);

        for (uint256 i = 0; i < 2; i++){
            listOfPlayerAddress[i] = new address[](playersNum);
            for (uint256 j = 0; j < playersNum; j++){
                listOfPlayerAddress[i][j] = address(j + playersNum);
            }
            
            uint256 gasStart = gasleft();
            puppyRaffle.enterRaffle{value: entranceFee * listOfPlayerAddress[i].length}(listOfPlayerAddress[i]);
            uint256 gasEnd = gasleft();

            uint256 gasUsedFirst = (gasStart - gasEnd) * tx.gasprice;

            console.log("Gas cost for %s00 players: %d ", i+1, gasUsedFirst);

            playersNum += 100;
        }
    }
```
</details>

**Recommended Mitigation:** 

1. Consider allowing duplicates. Users can create new wallets anyways.

2. Consider using a mapping to check for duplicates. This allows constant time lookup of whether a user has already entered.