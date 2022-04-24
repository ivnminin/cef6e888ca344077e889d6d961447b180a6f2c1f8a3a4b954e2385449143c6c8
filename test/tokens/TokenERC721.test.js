const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token-ERC721 | GameItem", function () {
  const amount = ethers.utils.parseEther("1.0");
  beforeEach(async function () {
    const signers = await ethers.getSigners();
    this.deployer = signers[0];
    const tokenFactory = await ethers.getContractFactory("GameItem");
    this.token = await tokenFactory.deploy();
  });
  describe("AwardItem", function () {
    beforeEach(async function () {
      await this.token.awardItem(
        this.deployer.address,
        "https://game.example/item-id-8u5h2m.json",
        {
          value: amount,
        }
      );
    });
    it("check account received token", async function () {
      expect(await this.token.ownerOf(1)).to.be.equal(this.deployer.address);
      expect(await this.token.balanceOf(this.deployer.address)).to.be.equal(1);
    });
    it("check collection received money", async function () {
      expect(await ethers.provider.getBalance(this.token.address)).to.be.equal(
        amount
      );
    });
  });
});
