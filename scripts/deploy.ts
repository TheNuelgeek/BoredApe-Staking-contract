// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

import { ethers } from "hardhat";

const contractAdrr = "0x4bf010f1b9beDA5450a8dD702ED602A104ff65EE"
async function hhddh() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
   //const Greeter = await ethers.getContractFactory("Greeter")
  const Greeter = await ethers.getContractAt("Greeter", contractAdrr)
  //const greeter = await Greeter.deploy("Hello, Hardhat!");

 // await greeter.deployed();
  const changeGreet = await Greeter.setGreeting("Hey, What's good?")
  const greet = await Greeter.greet()
  console.log(`This is my greeting;${greet}`);
  //console.log("Greeter deployed to:", greeter.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
hhddh().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
