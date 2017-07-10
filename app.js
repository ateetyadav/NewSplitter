const Web3 = require("web3");
const Promise = require("bluebird");
const truffleContract = require("truffle-contract");
const $ = require("jquery");
// Not to forget our built contract
const SplitterJson = require("../../build/contracts/Splitter.json")
require("file-loader?name=../index.html!../index.html");

// Supports Mist, and other wallets that provide 'web3'.
if (typeof web3 !== 'undefined') {
    // Use the Mist/wallet/Metamask provider.
    window.web3 = new Web3(web3.currentProvider);
} else {
    // Your preferred fallback.
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545')); 
}
Promise.promisifyAll(web3.eth, { suffix: "Promise" });
const Splitter = truffleContract(SplitterJson);
Splitter.setProvider(web3.currentProvider);

window.addEventListener('load', function() {
    return web3.eth.getAccountsPromise()
        .then(accounts => {
            if (accounts.length == 0) {
                $("#balance").html("N/A");
                throw new Error("No account with which to transact");
            }
            window.account = accounts[0];
	    window.balanceAlice=accounts[0];
	    window.balanceBob=accounts[1];
	    window.balanceCarol=accounts[2];

		return Splitter.deployed();
        })
        .then(deployed => deployed.getBalance.call(window.account))
        .then(balance => $("#balanceAlice").html(balance.toString(10)))
	.then(deployed => deployed.getBalance.call(window.balanceBob))
        .then(balance => $("#balanceBob").html(balance.toString(10)))
	.then(deployed => deployed.getBalance.call(window.balanceCarol))
        .then(balance => $("#balanceCarol").html(balance.toString(10)))
        .catch(console.error);
});

const sendcoin = function() {
    let deployed;
    return Splitter.deployed()
        .then(_deployed => {
            deployed = _deployed;
            // .sendTransaction so that we get the txHash immediately.
            return _deployed.sendcoin.sendTransaction(
                $("input[name='recipient']").val(),
              	$("input[name='amount']").val(),
		acc2,
		acc3,
                { from: window.account });
        })
        .then(txHash => {
            $("#status").html("Transaction on the way " + txHash);
            // Now we wait for the tx to be mined.
            const tryAgain = () => web3.eth.getTransactionReceiptPromise(txHash)
                .then(receipt => receipt !== null ?
                    receipt :
                    // Let's hope we don't hit the max call stack depth
                    Promise.delay(500).then(tryAgain));
            return tryAgain();
        })
        .then(receipt => {
            if (receipt.logs.length == 0) {
                console.error("Empty logs");
                console.error(receipt);
                $("#status").html("There was an error in the tx execution");
            } else {
                // Format the event nicely.
                console.log(deployed.Transfer().formatter(receipt.logs[0]).args);
                $("#status").html("Transfer executed");
            }
            // Make sure we update the UI.
            return deployed.getBalance.call(contract.address);
        })
        .then(balance => $("#balanceSplitter").html(balanceSplitter.toString(10)))
        .catch(e => {
            $("#status").html(e.toString());
            console.error(e);
        });
};


window.addEventListener('load', function() {
    $("#send").click(sendcoin);
    return web3.eth.getAccountsPromise()
        .then(accounts => {
            if (accounts.length == 0) {
                $("#balanceSplitter").html("N/A");
                throw new Error("No account with which to transact");
            }
            window.account = accounts[0];
            return Splitter.deployed();
        })
        
	.then(deployed => deployed.getBalance.call(window.account))
	.then(balance => $("#balanceAlice").html(balance.toString(10)))
	.then(deployed => deployed.getBalance.call(window.balanceBob))
        .then(balance => $("#balanceBob").html(balance.toString(10)))
	.then(deployed => deployed.getBalance.call(window.balanceCarol))
        .then(balance => $("#balanceCarol").html(balance.toString(10)))
        .catch(console.error);
});
