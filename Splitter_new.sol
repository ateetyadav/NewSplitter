pragma solidity ^0.4.11;

contract Splitter{
    address alice;
    address bob;
    address carol;
    address owner;
    
    mapping (address => uint) balances;
    //"0x04"
    //if (!msg.sender.call.value(transferAmt)()) throw; 
    event LogDeposit(address receiver, uint amount);
    event LogSender(address sender, uint amount);
    event LogWithdraw(address receiver, uint amount);

	function Splitter(address add1, address add2) {
	    require (add1 !=0);
	    require (add2 !=0);
	    require (add1 !=add2);
	    owner=msg.sender;
	    bob=add1;
	    carol=add2;
	} 
	
	function split(address rec1, address rec2) payable returns (bool success){
	    
	    //  if(balances[msg.sender]<msg.value) throw;
	  if(msg.value<=0)revert();
	  
	  if   (msg.value>0){
	       LogSender(msg.sender,msg.value);
	       var xferAmt=msg.value/2;
	      
	       balances[rec1]=xferAmt;
	       LogDeposit(rec1,xferAmt);
	       
	       balances[rec2]=xferAmt;
	       LogDeposit(rec2,xferAmt);
	       
	       //send back remaining ether.   
	     
	        balances[msg.sender]+=msg.value - xferAmt * 2;
	        LogDeposit(msg.sender,msg.value);
	    
	        return true;
	  }
	  else{
	    //Negative value or 0 
	    return false;  
	  }
}
	//Call fallback function. Log the event,
	function() payable {
	
	    LogDeposit(msg.sender,msg.value);
	    //Payable will take ether in fallback function 
	    //Log will be used to check the ether sender
	    
	}
	
    function withdrawfund() {
	   // msg.sender.transfer(amount);
        var amt=balances[msg.sender];
        if(amt>0){
            balances[msg.sender]=0;
            bob.transfer(amt);
            LogWithdraw(msg.sender, amt);
        }
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
    // SplitUtil.split(add1,add2).value(4).gas(2300)();
    }
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
