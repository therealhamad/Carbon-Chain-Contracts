const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CarbonChain tests", () => {
    let adds = [];
    let refContract, carbonChain;

    beforeEach(async () => {
        carbonChain = await ethers.getContractFactory("CarbonChain");
        adds = await ethers.getSigners();
        refContract = await carbonChain.deploy(100, 200);
    });

    describe("Deployment", async () => {
        it("Should mint required tokens", async () => {
            expect(await refContract.totalSupply()).to.equal(BigInt(100000000000000000000));
        });
    });

    describe("generate credits", async () => {
        it ("should generate appropriate credits", async () => {
            const bmt = await refContract.totalSupply();
            await refContract.generateCredits("", adds[0].address);
            expect(await refContract.totalSupply()).to.equal(BigInt(101000000000000000000));
        });
    });
});