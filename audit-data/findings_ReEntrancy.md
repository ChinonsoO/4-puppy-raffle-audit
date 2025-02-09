### [H-#] TITLE Sending the users refund before updating the player address state allows for ReEntrancy

**Description:** 

`PuppyRaffle::refund` sends money to the player address before updating the player address requesting a refund to 0.
This allows for an external malicious contract to immediately make another call to `PuppyRaffle::refund` allowing them to extract more funds than allowed.


**Impact:** 
Allows a malicious contract to drain all of the contracts funds.

**Proof of Concept:**
Paste the below code into `PuppyRaffle.t.sol`, and run the test. We can see that the asserts prove the contracts funds were drained.

**Recommended Mitigation:** 