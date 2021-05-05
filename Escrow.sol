// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Escrow
 * @dev escrow DAI, make a bet based on ETH price.
 */
contract Storage {
    address owner;
    address daiAddress= 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    IERC20 DAI;
    
    address friendA;
    address friendB;
    
    uint256 betAmount = 5000000000000000000000; //5000 * 10^18 
    
    bool setA = false;
    bool setB = false;
    //Once these are both set, you cannot withdraw until end time.
    
    
    
    event RescuedERC20Tokens(address tokenAddress, address to, uint256 amount);

    
    
    constructor(){
        //contract deployer is the owner
        owner = msg.sender;
        
        DAI = IERC20(daiAddress);
        
    }
    
    //only friend A can call this.
    //moves 5000 DAI to this address. Sets set# to true.
    //DAI can be withdrawn before the other person funds their side 
    function depositA() public{
        require(msg.sender == friendA);
        DAI.transferFrom(friendA, address(this), betAmount);
        setA = true;
    }
    
    //only friendB can call this.
    function depositB() public{ 
        require(msg.sender == friendB);
        DAI.transferFrom(friendB, address(this), betAmount);
        setB = true;
    }
    
    function preWithdraw() public{
        //an only be called by the betters
        require(msg.sender == friendA || msg.sender == friendB);
        //one of the sets must be unlocked / not submitted.
        require(!setA || !setB); //if both are set, this will fail
        
        if(msg.sender == friendA && setA){
            //a has submitted their bet.
            DAI.transfer(friendA, betAmount);
        }
        
        else if(msg.sender == friendB && setB){
            //b has submiited their bet
            DAI.transfer(friendB, betAmount);
        }
        
    }
    
    
    function winner() public{
        //TODO decide price oracle.
    }
    
    
    uint8 wantsEndA = 0;
    uint8 wantsEndB = 0;
    uint8 wantsEndOwner = 0;
    
    function emergencyEndBet() public{
        if(msg.sender == friendA){
            wantsEndA = 1;
        }
        
        if(msg.sender == friendB){
            wantsEndB = 1;
        }
        
        if(msg.sender == owner){
            wantsEndOwner = 1;
        }
        
        if(wantsEndOwner + wantsEndB + wantsEndA >= 2){
            DAI.transferFrom(address(this), friendA, betAmount);
            DAI.transferFrom(address(this), friendB, betAmount);
        }
        
    }
    
    
    //HELPDERS FOR RECUES
    
    //can not rescue DAI. 
    function rescueERC20(
    address _tokenAddress,
    address _to,
    uint256 _amount
  ) public {
     require(msg.sender == owner);
     require(_tokenAddress != daiAddress); //cannot withdraw dai
    IERC20 c = IERC20(_tokenAddress);

    c.transfer(_to, _amount);
    emit RescuedERC20Tokens(_tokenAddress, _to, _amount);
  }
  
  function recueEth(address payable _to, uint _amount) public{
      require(msg.sender == owner);
      _to.transfer(_amount);
  }
    
    
}
