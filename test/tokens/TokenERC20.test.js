const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token-ERC20 | GLDToken", function () {
  const amount = ethers.utils.parseEther("1.0");
  const amoutHalf = amount.div(2);
  beforeEach(async function () {
    const signers = await ethers.getSigners();
    this.deployer = signers[0];
    const tokenFactory = await ethers.getContractFactory("GLDToken");
    this.token = await tokenFactory.deploy();
  });
  describe("Deposit", function () {
    beforeEach(async function () {
      await this.token.deposit({ value: amount });
    });
    it("check account received tokens", async function () {
      expect(await this.token.balanceOf(this.deployer.address)).to.be.equal(
        amount
      );
    });
    it("check contract received money", async function () {
      expect(await ethers.provider.getBalance(this.token.address)).to.be.equal(
        amount
      );
    });
    it("check Deposit event", async function () {
      await expect(this.token.deposit({ value: amount }))
        .to.emit(this.token, "Deposit")
        .withArgs(this.deployer.address, amount);
    });
    describe("Withdraw", function () {
      beforeEach(async function () {
        await this.token.withdraw(amoutHalf);
      });
      it("check account returned tokens", async function () {
        expect(await this.token.balanceOf(this.deployer.address)).to.be.equal(
          amoutHalf
        );
      });
      it("check contract returned money", async function () {
        expect(
          await ethers.provider.getBalance(this.token.address)
        ).to.be.equal(amoutHalf);
      });
      it("check Withdraw event", async function () {
        await expect(this.token.withdraw(amoutHalf))
          .to.emit(this.token, "Withdrawal")
          .withArgs(this.deployer.address, amoutHalf);
      });
    });
  });
});
