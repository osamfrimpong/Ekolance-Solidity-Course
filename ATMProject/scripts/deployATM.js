 const hardhatRE = require('hardhat');


 async function main(){

//deploy all your libraries created and used
const Lib = await ethers.getContractFactory("StringUtils");
const lib = await Lib.deploy();
await lib.deployed();

const ATMContract = await hardhatRE.ethers.getContractFactory("ATM",{
    libraries: {
        StringUtils: lib.address,
    }
});

const deployATMContract = await ATMContract.deploy();

console.log(`ATM Contract has been deployed to ${deployATMContract.address}`);
 }

 main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
