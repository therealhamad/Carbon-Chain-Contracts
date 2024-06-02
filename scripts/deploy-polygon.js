async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
    // console.log("Account balance:", (await deployer.getBalance()).toString());
    // Chainlink Price Feed address for ETH/USD on Polygon
    const priceFeedAddressPolygon = "0xF03c83b0fF20D5D5A13A15Fa8b0BA66385E9c91d"; 
    // Use the appropriate address based on the network you are deploying to
    const priceFeedAddress = priceFeedAddressPolygon; 
    
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
