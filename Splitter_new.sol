pragma solidity ^0.4.4;

contract Splitter{
    address alice;
    address bob;
    address carol;
    address owner;
    
    mapping (address => uint) balances;
    //"0x04"
    //if (!msg.sender.call.value(transferAmt)()) throw; 
    event LogDeposit(address sender, uint amount);

	function Splitter(address add1, address add2) {
	    require (add1 !=0);
	    require (add2 !=0);
	    alice=msg.sender;
	    owner=msg.sender;
	    bob=add1;
	    carol=add2;
	}
	
	function split() payable returns (bool success){
	    
	    //Check Alice has enough Balance.
	    //  if(balances[msg.sender]<msg.value) throw;
	    //Check and handle odd/even Ether case.
	    if (msg.value%2==0){ 
	        var xferamt=msg.value/2;
	    }
	    else{
	        xferamt=(msg.value-1)/2;
	    }
	     if(xferamt >0){
	      
	      balances[bob]=xferamt;
	      LogDeposit(bob,xferamt);
	      balances[carol]=xferamt;
	      LogDeposit(carol,xferamt);
	      LogDeposit(msg.sender,msg.value);
	      return true;
	     }
	     else{
	         return false;
	     }
	}
	//Call fallback function if transction failed
	function() {
	    
	}

	function kill() {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }
    
	function getBalance(address addr) returns(uint){
	    return balances[addr];
	}
}
//Contract Utility to be used David,Emma and others.
contract SplitterUtility{
   
    Splitter SplitUtil;
    function uSplit(){ 
     SplitUtil.split.value(4).gas(2300)();
    }
}