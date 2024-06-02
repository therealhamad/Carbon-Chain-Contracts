async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
    // console.log("Account balance:", (await deployer.getBalance()).toString());
    // Chainlink Price Feed address for ETH/USD on Sepolia
    const priceFeedAddressSepolia = "0xbA6D779Ebf3EADA6c805c29215751004dBDa46ef"; 

    // Use the appropriate address based on the network you are deploying to
    const priceFeedAddress = priceFeedAddressSepolia;
  
    const TokenBalanceChecker = await ethers.getContractFactory("CarbonChain");
    const tokenBalanceChecker = await TokenBalanceChecker.deploy(1000, 1500);
  
    console.log("TokenBalanceChecker contract deployed to:", await tokenBalanceChecker.getAddress());
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
