# FiboToken ICO

## ![Logo Fiboard](files/fiboard.svg) Overview
The FiboTokenICO smart contract facilitates the sale of Fibo tokens using BNB and USDT. The ICO consists of three stages, each with a different token price.

Website: [FiboToken](https://fiboard.org)

Smart Contract Address (BSC): `0x49ac8DDeA22db459EC7f45790553a2650828658C`
[Link BSC](https://bscscan.com/address/0x49ac8DDeA22db459EC7f45790553a2650828658C)

## Features
- Buy Fibo tokens using BNB or USDT.
- Three-stage pricing model.
- Funds distribution to marketing and main fund addresses.
- Uses Chainlink for BNB price feed.
- Admin functions for starting the ICO and withdrawing remaining tokens.

## Deployment
### Prerequisites
- Node.js & NPM
- Hardhat
- dotenv (for environment variables)

### Installation
1. Clone the repository:
   ```sh
   git clone <repo_url>
   cd fibo-ico
   ```
2. Install dependencies:
   ```sh
   npm install
   ```
3. Create a `.env` file and add:
   ```sh
   PRIVATE_KEY=your_private_key
   RPC_URL=your_rpc_url
   ```

### Compile & Deploy
1. Compile contract:
   ```sh
   npx hardhat compile
   ```
2. Deploy contract:
   ```sh
   npx hardhat run scripts/deploy.js --network <network>
   ```

## Usage
### Buy Tokens with BNB
Send BNB to the contract:
```solidity
FiboTokenICO.buyWithBNB({ value: amount });
```

### Buy Tokens with USDT
Approve & Transfer USDT:
```solidity
usdt.approve(fiboICOAddress, amount);
fiboICO.buyWithUSDT(amount);
```

## Owner Functions
- `startICO()`: Starts the ICO.
- `withdrawTokens()`: Withdraws remaining tokens to the owner.

## Resources

- [Official Fiboard Website](https://fiboard.org/)
- [X Account Fiboard](https://x.com/FBDtoken)
- [Linkdin Account Fiboard](https://www.linkedin.com/company/fbd-foundation/)
- [ByBit Event](https://www.youtube.com/shorts/UfNhDbusZPY)
- [Hardhat Documentation](https://hardhat.org/getting-started/)

## License
Fiboard

