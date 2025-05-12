// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FiboardICO is Ownable {
    using SafeERC20 for IERC20;

    struct History {
        address wallet;
        uint256 amount;
        address token;
    }

    address private walletAddress;

    History[] private history;
    address public usdcStableCoinAddress;
    address public usdtStableCoinAddress;

    AggregatorV3Interface internal priceFeed;

    event TokensTransferred(
        address indexed sender,
        address indexed token,
        uint256 amount
    );

    constructor(
        address _usdtStableCoinAddress,
        address _usdcStableCoinAddress
    ) Ownable(msg.sender) {
        walletAddress = payable(msg.sender);
        usdtStableCoinAddress = _usdtStableCoinAddress;
        usdcStableCoinAddress = _usdcStableCoinAddress;
        priceFeed = AggregatorV3Interface(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);
    }

    function getBNBPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    function buyTokens(
        address tokenAddress,
        uint256 amount
    ) external payable {
        uint256 valueSent = msg.value;
        if (valueSent > 0 && tokenAddress == address(0)) {
            (bool sent, ) = walletAddress.call{value: valueSent}("");
            require(sent, "BNB transfer failed");
            history.push(
                History(msg.sender, amount, address(0))
            );
            emit TokensTransferred(msg.sender, tokenAddress, amount);
        } else {
            require(tokenAddress != address(0), "Invalid token address");
            require(amount > 0, "Amount must be > 0");
            if (_isStableCoin(tokenAddress)) {
                IERC20 token = IERC20(tokenAddress);
                token.safeTransferFrom(msg.sender, walletAddress, amount);
                history.push(
                    History(msg.sender, amount, tokenAddress)
                );
                emit TokensTransferred(msg.sender, tokenAddress, amount);
            }
        }
    }


    function getHistory() external view returns (History[] memory) {
        return history;
    }

    function setUsdcStableCoinAddress(address _usdcStableCoinAddress) external onlyOwner {
        usdcStableCoinAddress = _usdcStableCoinAddress;
    }

    function setUsdtStableCoinAddress(address _usdtStableCoinAddress) external onlyOwner {
        usdtStableCoinAddress = _usdtStableCoinAddress;
    }

    function _isStableCoin(address _token) private view returns (bool) {
        return _token == usdcStableCoinAddress || _token == usdtStableCoinAddress;
    }

    function updateWalletAddress(address newAddress) external onlyOwner {
        walletAddress = newAddress;
    }

    function getWalletAddress() external view onlyOwner returns (address) {
        return walletAddress;
    }

    function withdrawERC20(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransfer(msg.sender, balance);
    }

    function withdrawBNB() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No BNB balance to withdraw");

        (bool sent, ) = walletAddress.call{value: balance}("");
        require(sent, "Failed to withdraw BNB");
    }
}
