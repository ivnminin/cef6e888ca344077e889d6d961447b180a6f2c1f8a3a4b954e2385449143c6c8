const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token-ERC1155 | GameItems", function () {
  const amountNonFungible = 1;
  const amountFungible = ethers.utils.parseEther("1.0");
  const amountFungibleLimited100 = 100;
  beforeEach(async function () {
    const signers = await ethers.getSigners();
    this.deployer = signers[0];
    const tokenFactory = await ethers.getContractFactory("MockGameItems");
    this.token = await tokenFactory.deploy();
    this.NON_FUNGIBLE = await this.token.NON_FUNGIBLE();
    this.FUNGIBLE = await this.token.FUNGIBLE();
    this.FUNGIBLE_LIMITED_100 = await this.token.FUNGIBLE_LIMITED_100();

    this.ENTITY1 = await this.token.ENTITY1();
    this.ENTITY2 = await this.token.ENTITY2();
    this.ENTITY3 = await this.token.ENTITY3();
  });
  describe("Mint NON_FUNGIBLE token", function () {
    beforeEach(async function () {
      await this.token.mint(
        this.deployer.address,
        this.ENTITY1,
        amountNonFungible
      );
    });
    it("check account received token NON_FUNGIBLE", async function () {
      this.currentTokenId = await this.token.getCurrentTokenId(this.ENTITY1);
      expect(
        await this.token.balanceOf(this.deployer.address, this.currentTokenId)
      ).to.be.equal(amountNonFungible);
    });
    it("check type token is NON_FUNGIBLE", async function () {
      expect(await this.token.isNonFungible(this.currentTokenId)).to.be.equal(
        true
      );
    });
    describe("Mint FUNGIBLE token", function () {
      beforeEach(async function () {
        await this.token.mint(
          this.deployer.address,
          this.ENTITY2,
          amountFungible
        );
      });
      it("check account received token FUNGIBLE", async function () {
        this.currentTokenId = await this.token.getCurrentTokenId(this.ENTITY2);
        expect(
          await this.token.balanceOf(this.deployer.address, this.currentTokenId)
        ).to.be.equal(amountFungible);
      });
      it("check type token is FUNGIBLE", async function () {
        expect(await this.token.isFungible(this.currentTokenId)).to.be.equal(
          true
        );
      });
      describe("Mint FUNGIBLE_LIMITED_100 token", function () {
        beforeEach(async function () {
          await this.token.mint(
            this.deployer.address,
            this.ENTITY3,
            amountFungibleLimited100
          );
        });
        it("check account received token FUNGIBLE_LIMITED_100", async function () {
          this.currentTokenId = await this.token.getCurrentTokenId(
            this.ENTITY3
          );
          expect(
            await this.token.balanceOf(
              this.deployer.address,
              this.currentTokenId
            )
          ).to.be.equal(amountFungibleLimited100);
        });
        it("check type token is FUNGIBLE_LIMITED_100", async function () {
          expect(
            await this.token.isFungibleLimited(this.currentTokenId)
          ).to.be.equal(true);
        });
      });
    });
  });
});
