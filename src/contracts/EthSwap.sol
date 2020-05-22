pragma solidity ^0.5.0;

import "./Token.sol";

contract EthSwap {
	string public name = "EthSwap Instant Exchange";
	Token public token;
	uint public rate = 100;

	event TokensPurchase(
		address account,
		address token,
		uint amount,
		uint rate
	);

	event TokensSold(
		address account,
		address token,
		uint amount,
		uint rate
	);

	constructor(Token _token) public {
		token = _token;
	}

	function buyTokens() public payable {
		// Redemtion rate = # of tokens they receive for 1 ether
		// Amount of ethereum * redemption rate
		uint tokenAmount = msg.value * rate;

		// Require that EthSwap has enough tokens
		require(token.balanceOf(address(this)) >= tokenAmount);

		// Transfer tokens to the user
		token.transfer(msg.sender, tokenAmount);

		// Emit event
		emit TokensPurchase(msg.sender, address(token), tokenAmount, rate);
	}

	function sellTokens(uint _amount) public {
		// User can't sell more tokens than they have
		require(token.balanceOf(msg.sender) >= _amount);

		// Calculate
		uint etherAmount = _amount / rate;

		// Require that EthSwap has enough Ether
		require(address(this).balance >= etherAmount);

		// Peform sale
		token.transferFrom(msg.sender, address(this), _amount);
		msg.sender.transfer(etherAmount);

		emit TokensSold(msg.sender, address(token), _amount, rate);
	}

}
