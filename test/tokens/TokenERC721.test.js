const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token-ERC721 | GameItem", function () {
  const amount = ethers.utils.parseEther("1.0");
  beforeEach(async function () {
    const signers = await ethers.getSigners();
    this.deployer = signers[0];
    const tokenFactory = await ethers.getContractFactory("GLDToken");
    this.token = await tokenFactory.deploy();
    await this.token.deposit({ value: amount });
    const tokenGameItemFactory = await ethers.getContractFactory("GameItem");
    this.tokenGameItem = await tokenGameItemFactory.deploy(
      this.token.address,
      amount.div(2)
    );
    await this.token.approve(this.tokenGameItem.address, amount);
    this.baseURI = await this.tokenGameItem.baseURI();
    const buyerRole = await this.tokenGameItem.BUYER_ROLE();
    this.tokenGameItem.grantRole(buyerRole, this.deployer.address);
  });
  describe("AwardItem", function () {
    beforeEach(async function () {
      await this.tokenGameItem.awardItem(this.deployer.address);
    });
    it("check account received token", async function () {
      expect(await this.tokenGameItem.ownerOf(1)).to.be.equal(
        this.deployer.address
      );
      expect(
        await this.tokenGameItem.balanceOf(this.deployer.address)
      ).to.be.equal(1);
    });
    it("check tokenURI", async function () {
      expect(await this.tokenGameItem.tokenURI(1)).to.be.equal(
        this.baseURI + 1
      );
    });
    it("check collection received GLDToken", async function () {
      expect(
        await this.token.balanceOf(this.tokenGameItem.address)
      ).to.be.equal(amount.div(2));
    });
  });
});
