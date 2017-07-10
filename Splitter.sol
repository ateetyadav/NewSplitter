pragma solidity ^0.4.4;

import "./ConvertLib.sol";


contract Splitter {
	address public bob;
	address public carol;	
	mapping (address => uint) balances;

	function Splitter(address add1, address add2) {

		bob = add1;
		carol = add2;

	}

	event Transfer(address indexed _from, address indexed _to, uint256 _value);


	function Split (address receiver, uint amount, address acc2, address 		acc3) returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;

		if (msg.value%2==0){
			balances[msg.sender] -= msg.value;
			balances[acc2] += msg.value/2;
			Transfer(msg.sender, acc2, msg.value/2);
			balances[acc3] += msg.value/2;
			Transfer(msg.sender, acc3, msg.value/2);
			return true;
		}
		else{
	
			var xferfund=msg.value/2;
			
			balances[msg.sender] -= xferfund*2;
			balances[acc2] += xferfund;
			Transfer(msg.sender, acc2, xferfund);
			balances[acc3] += xferfund;
			Transfer(msg.sender, acc3, xferfund);
			return true;
		}
	}
	function getBalanceInEth(address addr) returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}
	function getBalance(address addr) returns(uint) {
		return balances[addr];
	}
}
