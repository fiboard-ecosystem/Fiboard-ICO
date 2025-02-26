/**
 *Submitted for verification at BscScan.com on 2025-02-23
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

contract FiboTokenICO {
    IERC20 public fibotoken;
    IERC20 public usdt;
    AggregatorV3Interface internal priceFeed;
    address private _owner;

    uint256 public constant STAGE_DURATION = 21 days;
    uint256 public startTime;
    uint256 public totalTokensForSale;
    uint256 public tokensSold;

    address public constant FUNDS_ADDRESS =
        0xc0Cc068Fd44766ADEFbdBcEb9c685F73D20351e8;
    address public constant MARKETING_ADDRESS =
        0xA8FFB0Fd06b50f5329A28b66Fe3954f829624C3d;

    enum Stage {
        Stage1,
        Stage2,
        Stage3,
        Ended
    }

    mapping(Stage => uint256) public stagePrices;
    mapping(Stage => uint256) public tokensSoldPerStage;

    event TokensPurchased(
        address buyer,
        uint256 amount,
        uint256 cost,
        string currency
    );

    constructor(address _token, address _usdt) {
        fibotoken = IERC20(_token);
        usdt = IERC20(_usdt);

        //0x1A26d803C2e796601794f8C5609549643832702C In test net
        //0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE In Main Net
        priceFeed = AggregatorV3Interface(
            payable(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE)
        );
        totalTokensForSale = 5_000_000_000 * (10 ** 6);
        _owner = msg.sender;

        stagePrices[Stage.Stage1] = 8 * 10 ** 15; // 0.008 USD per token
        stagePrices[Stage.Stage2] = 9 * 10 ** 15; // 0.009 USD per token
        stagePrices[Stage.Stage3] = 10 * 10 ** 15; // 0.01 USD per token
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function startICO() external onlyOwner {
        require(startTime == 0, "ICO already started");
        startTime = block.timestamp;
    }

    function getCurrentStage() public view returns (Stage) {
        if (startTime == 0) return Stage.Ended;
        uint256 elapsedTime = block.timestamp - startTime;
        if (elapsedTime < STAGE_DURATION) return Stage.Stage1;
        if (elapsedTime < 2 * STAGE_DURATION) return Stage.Stage2;
        if (elapsedTime < 3 * STAGE_DURATION) return Stage.Stage3;
        return Stage.Ended;
    }

    function getLatestBNBPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price) * 10 ** 10; // Adjust decimals (67998020014)
    }

    function getTokenRateInBNB() public view returns (uint256) {
        uint256 bnbPrice = getLatestBNBPrice();
        return (stagePrices[getCurrentStage()] * 1 ether) / bnbPrice;
    }

    function getTokenRateInUSDT() public view returns (uint256) {
        return stagePrices[getCurrentStage()];
    }

    function buyWithBNB() external payable {
        require(startTime > 0, "ICO not started");
        require(getCurrentStage() != Stage.Ended, "ICO ended");

        uint256 tokensToBuy = calculateTokens(msg.value, true);

        require(tokensToBuy > 0, "Amount too small");
        require(
            tokensSold + tokensToBuy <= totalTokensForSale,
            "Not enough tokens left"
        );

        uint256 contractBalance = fibotoken.balanceOf(address(this));
        require(
            contractBalance >= tokensToBuy,
            "Not enough tokens available in contract"
        );

        tokensSold += tokensToBuy;
        tokensSoldPerStage[getCurrentStage()] += tokensToBuy;

        require(fibotoken.transfer(msg.sender, tokensToBuy), "Transfer failed");

        // Send 10% to marketing address
        uint256 marketingAmount = msg.value / 10;
        payable(MARKETING_ADDRESS).transfer(marketingAmount);

        // Send 90% to FUNDS_ADDRESS
        uint256 remainingAmount = msg.value - marketingAmount;
        payable(FUNDS_ADDRESS).transfer(remainingAmount);

        emit TokensPurchased(msg.sender, tokensToBuy, msg.value, "BNB");
    }

    function buyWithUSDT(uint256 usdtAmount) external {
        require(startTime > 0, "ICO not started");
        require(getCurrentStage() != Stage.Ended, "ICO ended");

        uint256 tokensToBuy = calculateTokens(usdtAmount, false);

        require(tokensToBuy > 0, "Amount too small");
        require(
            tokensSold + tokensToBuy <= totalTokensForSale,
            "Not enough tokens left"
        );

        uint256 contractBalance = fibotoken.balanceOf(address(this));
        require(
            contractBalance >= tokensToBuy,
            "Not enough tokens available in contract"
        );

        require(
            usdt.transferFrom(msg.sender, address(this), usdtAmount),
            "USDT transfer failed"
        );

        tokensSold += tokensToBuy;
        tokensSoldPerStage[getCurrentStage()] += tokensToBuy;

        require(
            fibotoken.transfer(msg.sender, tokensToBuy),
            "Token transfer failed"
        );

        // Send 10% to marketing address
        uint256 marketingAmount = usdtAmount / 10;
        require(
            usdt.transfer(MARKETING_ADDRESS, marketingAmount),
            "Marketing transfer failed"
        );

        // Send 90% to FUNDS_ADDRESS
        uint256 remainingAmount = usdtAmount - marketingAmount;
        require(
            usdt.transfer(FUNDS_ADDRESS, remainingAmount),
            "Remaining funds transfer failed"
        );

        emit TokensPurchased(msg.sender, tokensToBuy, usdtAmount, "USDT");
    }

    function tokensSoldInStage(uint256 _stage) external view returns (uint256) {
        require(_stage >= 1 && _stage <= 3, "Invalid stage");
        return tokensSoldPerStage[Stage(_stage - 1)];
    }

    function getTokenBalance() external view returns (uint256) {
        return fibotoken.balanceOf(address(this));
    }

    function calculateTokens(
        uint256 amount,
        bool isBNB
    ) public view returns (uint256) {
        require(startTime > 0, "ICO not started");
        require(getCurrentStage() != Stage.Ended, "ICO ended");

        uint256 tokensToBuy;

        if (isBNB) {
            uint256 bnbPrice = getLatestBNBPrice(); // Assuming this returns BNB price in USD with 18 decimals
            uint256 tokenPriceInBNB = (stagePrices[getCurrentStage()] * 1e18) /
                bnbPrice;
            tokensToBuy = (amount * 1e6) / tokenPriceInBNB; // Adjust for 8 decimals of Fibo
        } else {
            tokensToBuy = (amount * 1e6) / stagePrices[getCurrentStage()]; // Adjust for 8 decimals of Fibo
        }

        require(tokensToBuy > 0, "Amount too small");
        return tokensToBuy;
    }

    function withdrawTokens() external onlyOwner {
        fibotoken.transfer(_owner, fibotoken.balanceOf(address(this)));
    }
}

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}