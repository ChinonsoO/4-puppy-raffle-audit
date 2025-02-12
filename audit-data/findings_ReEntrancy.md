### [H-#] TITLE Sending the users refund before updating the player address state allows for ReEntrancy

**Description:** 

`PuppyRaffle::refund` sends money to the player address before updating the player address requesting a refund to 0.
This allows for an external malicious contract to immediately make another call to `PuppyRaffle::refund` allowing them to extract more funds than allowed.


**Impact:** 
Allows a malicious contract to drain all of the contracts funds.

**Proof of Concept:**
Paste the below code into `PuppyRaffle.t.sol`, and run the test. We can see that the asserts prove the contracts funds were drained.

**Recommended Mitigation:** 




## [I-1] Using an outdated version of solidity is not recommended. 

**Description**
solc frequently releases new compiler versions. Using an old version prevents access to new Solidity security checks. We also recommend avoiding complex pragma statement.

**Recommendation**
Deploy with a recent version of Solidity (at least 0.8.0) with no known severe issues.

Use a simple pragma version that allows any of these versions. Consider using the latest version of Solidity for testing.

### [I-2]: Solidity pragma should be specific, not wide

Consider using a specific version of Solidity in your contracts instead of a wide version. For example, instead of `pragma solidity ^0.8.0;`, use `pragma solidity 0.8.0;`

<details><summary> Found Instance</summary>
- Found in src/PuppyRaffle.sol [Line: 2](src/PuppyRaffle.sol#L2)

    ```solidity
    pragma solidity ^0.7.6; 
    ```
</details>


### [I-3]: Missing checks for Zero Address when assigning values to address state variables

We are assining address state variables without checking for `address(0)`

- Found in src/PuppyRaffle.sol#69
- Found in src/PuppyRaffle.sol#222


<br></br>

# Gas

### [G-1] Unchanged state variables should be declared constant or immutable.

Reading from storage is more expensive than reading from a constant or immutable.
Instances: 
- `PuppyRaffle::raffleDuration` should be `immutable`
- `PuppyRaffle::commonImageURI` should be `constant`
- `PuppyRaffle::rareImageURI` should be `constant`
- `PuppyRaffle::LegendaryImageURI` should be `constant`

## [G-2] Use cached array length instead of referencing `length` member of the storage array .

Everytime you call `players.length` you read from storage instead of memory which is more gas efficient

```diff
+ uint256 playerLength = players.length;
+ for (uint256 i = 0; i < playerLength - 1; i++) 
- for (uint256 i = 0; i < players.length - 1; i++) {
-            for (uint256 j = i + 1; j < players.length; j++) {
+            for (uint256 j = i + 1; j < playerLength j++) {  
                require(players[i] != players[j], "PuppyRaffle: Duplicate player");
            }
        }
```