const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Market | Buy GameItem | Buy GameItems", function () {
  const amount = ethers.utils.parseEther("1.0");
  const amountNonFungible = 1;
  const amountFungible = ethers.utils.parseEther("1.0");
  const amountFungibleLimited100 = 100;
  beforeEach(async function () {
    const signers = await ethers.getSigners();
    this.deployer = signers[0];
    const tokenFactory = await ethers.getContractFactory("GLDToken");
    this.token = await tokenFactory.deploy();
    await this.token.deposit({ value: amount });
    const tokenGameItemFactory = await ethers.getContractFactory("GameItem");
    this.tokenGameItem = await tokenGameItemFactory.deploy(this.token.address);
    this.baseURI = await this.tokenGameItem.baseURI();
    const tokenGameItemsFactory = await ethers.getContractFactory(
      "MockGameItems"
    );
    this.tokenGameItems = await tokenGameItemsFactory.deploy();
    this.NON_FUNGIBLE = await this.tokenGameItems.NON_FUNGIBLE();
    this.FUNGIBLE = await this.tokenGameItems.FUNGIBLE();
    this.FUNGIBLE_LIMITED_100 =
      await this.tokenGameItems.FUNGIBLE_LIMITED_100();

    this.ENTITY1 = await this.tokenGameItems.ENTITY1();
    this.ENTITY2 = await this.tokenGameItems.ENTITY2();
    this.ENTITY3 = await this.tokenGameItems.ENTITY3();

    const tokenMarketFactory = await ethers.getContractFactory("Market");
    this.tokenMarket = await tokenMarketFactory.deploy(
      this.token.address,
      this.tokenGameItem.address,
      this.tokenGameItems.address
    );
    const buyerRole = await this.tokenGameItem.BUYER_ROLE();
    this.tokenGameItem.grantRole(buyerRole, this.tokenMarket.address);
  });
  describe("Buy GameItem", function () {
    beforeEach(async function () {
      await this.tokenMarket.buyTokenGameItem({
        value: amount,
      });
    });
    it("check account received GameItem token", async function () {
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
    it("check collection received money", async function () {
      expect(
        await ethers.provider.getBalance(this.tokenGameItem.address)
      ).to.be.equal(amount);
    });
  });
  describe("Buy GameItems NON_FUNGIBLE token", function () {
    beforeEach(async function () {
      await this.tokenMarket.buyTokenGameItems(
        this.deployer.address,
        this.ENTITY1,
        amountNonFungible,
        {
          value: amount,
        }
      );
    });
    it("check account received token NON_FUNGIBLE", async function () {
      this.currentTokenId = await this.tokenGameItems.getCurrentTokenId(
        this.ENTITY1
      );
      expect(
        await this.tokenGameItems.balanceOf(
          this.deployer.address,
          this.currentTokenId
        )
      ).to.be.equal(amountNonFungible);
    });
    it("check type token is NON_FUNGIBLE", async function () {
      expect(
        await this.tokenGameItems.isNonFungible(this.currentTokenId)
      ).to.be.equal(true);
    });
    describe("Buy GameItems FUNGIBLE token", function () {
      beforeEach(async function () {
        await this.tokenMarket.buyTokenGameItems(
          this.deployer.address,
          this.ENTITY2,
          amountFungible,
          {
            value: amount,
          }
        );
      });
      it("check account received token FUNGIBLE", async function () {
        this.currentTokenId = await this.tokenGameItems.getCurrentTokenId(
          this.ENTITY2
        );
        expect(
          await this.tokenGameItems.balanceOf(
            this.deployer.address,
            this.currentTokenId
          )
        ).to.be.equal(amountFungible);
      });
      it("check type token is FUNGIBLE", async function () {
        expect(
          await this.tokenGameItems.isFungible(this.currentTokenId)
        ).to.be.equal(true);
      });
      describe("Buy GameItems FUNGIBLE_LIMITED_100 token", function () {
        beforeEach(async function () {
          await this.tokenMarket.buyTokenGameItems(
            this.deployer.address,
            this.ENTITY3,
            amountFungibleLimited100,
            {
              value: amount,
            }
          );
        });
        it("check account received token FUNGIBLE_LIMITED_100", async function () {
          this.currentTokenId = await this.tokenGameItems.getCurrentTokenId(
            this.ENTITY3
          );
          expect(
            await this.tokenGameItems.balanceOf(
              this.deployer.address,
              this.currentTokenId
            )
          ).to.be.equal(amountFungibleLimited100);
        });
        it("check type token is FUNGIBLE_LIMITED_100", async function () {
          expect(
            await this.tokenGameItems.isFungibleLimited(this.currentTokenId)
          ).to.be.equal(true);
        });
      });
    });
  });
});
