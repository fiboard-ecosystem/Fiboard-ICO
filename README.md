# Fiboard Token ICO

## ![Logo Fiboard](files/fiboard.svg) Overview
The Fiboard Token ICO smart contract facilitates the sale of Fibo tokens using BNB and USDT. The ICO consists of three stages, each with a different token price.

Website: [Fiboard Token](https://fiboard.org)

Smart Contract Address (BSC): `0xe6378c4D6209FA3a53110551CA6B692Bd8a11AbC`
[Link BSC](https://bscscan.com/address/0xe6378c4D6209FA3a53110551CA6B692Bd8a11AbC)

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
fiboICO.buyWithBNB({ value: amount });
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
- [Youtube Fiboard](https://www.youtube.com/@FBDToken)
- [Linkdin Account Fiboard](https://www.linkedin.com/company/fbd-foundation/)
- [Bitcoin MENA Event](https://youtu.be/gJFLXhtjEn8?si=Dlh6lyEBCifTzZCL)
- [Hardhat Documentation](https://hardhat.org/getting-started/)

## License
Fiboard

