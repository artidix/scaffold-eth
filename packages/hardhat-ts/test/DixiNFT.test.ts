import '../helpers/hardhat-imports';
import './helpers/chai-imports';

import { expect } from 'chai';
import { DixiNFT__factory, DixiNFT } from 'generated/contract-types';
import hre from 'hardhat';
import { SignerWithAddress } from 'hardhat-deploy-ethers/signers';
import { getHardhatSigners } from 'tasks/functions/accounts';

describe('🚩 Challenge 0: 🎟 Simple NFT Example 🤓', function () {
  this.timeout(180000);

  // console.log("hre:",Object.keys(hre)) // <-- you can access the hardhat runtime env here

  describe('DixiNFT', function () {
    let dixiNFTContract: DixiNFT;
    let owner: SignerWithAddress;

    before(async () => {
      const { deployer } = await getHardhatSigners(hre);
      owner = deployer;
      const factory = new DixiNFT__factory(deployer);
      dixiNFTContract = await factory.deploy();
    });

    beforeEach(async () => {
      // put stuff you need to run before each test here
    });

    describe('mintItem()', function () {
      it('Should be able to mint an NFT', async function () {
        const { user1 } = await getHardhatSigners(hre);

        console.log('\t', ' 🧑‍🏫 Tester Address: ', user1.address);

        const startingBalance = await dixiNFTContract.balanceOf(user1.address);
        console.log('\t', ' ⚖️ Starting balance: ', startingBalance.toNumber());

        console.log('\t', ' 🔨 Minting...');
        const someHash = 'QmfVMAmNM1kDEBYrC2TPzQDoCRFH6F5tE1e9Mr4FkkR5Xr';
        const mintResult = await dixiNFTContract.mintItem(user1.address, someHash, true);
        console.log('\t', ' 🏷  mint tx: ', mintResult.hash);

        // @! impersonate as owner and finalize minting
        const ownerContract = dixiNFTContract.connect(owner);
        console.log(ownerContract.address);

        console.log('\t', ' ⏳ Waiting for confirmation...');
        const txResult = await mintResult.wait(1);
        expect(txResult.status).to.equal(1);

        console.log('\t', ' 🔎 Checking new balance: ', startingBalance.toNumber());
        expect(await dixiNFTContract.balanceOf(user1.address)).to.equal(startingBalance.add(1));
      });
    });
  });
});
