# betDaiEscrow
An escrow smart contract on ethereum for betting the price using DAI and uniswap

## Escrow.sol
Sets an owner, hard-coded with address of DAI token to use, Friend A \ friend B, and `betAmount`.

### DepositA / DepositB
User much be one of the friends, you can only call your own deposit function, and much approve our contract to spend 5000 of your DAI before hand.
Deposits 5000 DAI into this contract. The `setA` and `setB` variables muct be false to call this, they are set to true after calling so you can not make multiple deposits by accident. 

### preWithdraw
If you deposit your DAI first, you can withdraw it at any time until the other person deposits. If both people have deposited the 5000 DAI, then this function will fail.

### winner
Called by anyone, uses [TBD] to check the price, and then sends the funds to the winning friend.

### EmergencyEndBet
In case there is ever a vulnerability found in DAI or something else crazy happens, anyone can call this function. If at least 2/3 of the Owner (escrow deployer). friendA, friendB have called the function, then all funds are returned to both friends.

### RescueERC20
Rescue function I add to every contract that lets the owner transfer any ERC20 off the contract that were sent here by mistake.
modified:
```javascript
require(_tokenAddress != daiAddress); //cannot withdraw dai
```
This prevents moving any DAI with this function, so it will not effect bet deposits ever.


### RescueEth
Allows the owner to move any ETH that might have accidently ended up on this contract.

