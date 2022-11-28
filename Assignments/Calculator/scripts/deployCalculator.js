const hardhatRE = require("hardhat");

async function main(){
const calculatorContract = await hardhatRE.ethers.getContractFactory("Calculator");

const deployedCalculator = await calculatorContract.deploy();

console.log(
    `Calculator Contract has been deployed to ${deployedCalculator.address}`
  );
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});