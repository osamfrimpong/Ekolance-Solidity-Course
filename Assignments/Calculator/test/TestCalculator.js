const {
    expect
} = require('chai');
const {
    ethers
} = require('hardhat');
const {
    loadFixture
} = require('@nomicfoundation/hardhat-network-helpers');

describe("Calculator Contract", function () {

    async function deployCalculatorFixture() {
        const CalculatorToken = await ethers.getContractFactory('Calculator');
        const [owner] = await ethers.getSigners();

        const deployCalculator = await CalculatorToken.deploy();

        await deployCalculator.deployed();

        return {
            deployCalculator
        };
    }

    describe("Do Addition", function () {
        it("Should Add First and Second Number", async function () {
            const {
                deployCalculator
            } = await loadFixture(deployCalculatorFixture);

            expect(await deployCalculator.addNumbers(2, 3)).to.equal(5);
        });
    });

    describe("Do Subtraction", function () {
        it("Should Subtract Second Number From First Number", async function () {
            const {
                deployCalculator
            } = await loadFixture(deployCalculatorFixture);

            expect(await deployCalculator.subtractNumbers(3, 5)).to.equal(2);
        });
    });

    describe("Do Multiplication", function () {
        it("Should Multiply First and Second Number", async function () {
            const {
                deployCalculator
            } = await loadFixture(deployCalculatorFixture);

            expect(await deployCalculator.multiplyNumbers(5, 3)).to.equal(15);
        });
    });
    

    describe("Do Division", function () {
        it("Should Divide First Number by Second Number", async function () {
            const {
                deployCalculator
            } = await loadFixture(deployCalculatorFixture);

            expect(await deployCalculator.divideNumbers(10, 2)).to.equal(5);
        });


        it("Should show division by zero error", async function () {
            const {
                deployCalculator
            } = await loadFixture(deployCalculatorFixture);

            expect(await deployCalculator.divideNumbers(10, 0)).to.be.revertedWith("Sorry you can't divide by zero");
        });
    });

});