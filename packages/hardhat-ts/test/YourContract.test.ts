import '../helpers/hardhat-imports';
import './helpers/chai-imports';

import { expect } from 'chai';
import { ArtiDix__factory, ArtiDix } from 'generated/contract-types';
import hre from 'hardhat';
import { getHardhatSigners } from 'tasks/functions/accounts';

describe('ArtiDix', function () {
  let artiDix: ArtiDix;

  before(async () => {
    const { deployer } = await getHardhatSigners(hre);
    const factory = new ArtiDix__factory(deployer);
    artiDix = await factory.deploy();
  });

  beforeEach(async () => {
    // put stuff you need to run before each test here
  });

  it("Should return the new purpose once it's changed", async function () {
    await artiDix.deployed();
    expect(await artiDix.purpose()).to.equal('Building Unstoppable Apps!!!');

    const newPurpose = 'Hola, mundo!';
    await artiDix.setPurpose(newPurpose);
    expect(await artiDix.purpose()).to.equal(newPurpose);
  });
});
