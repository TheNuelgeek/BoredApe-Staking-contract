import { ethers, network } from "hardhat";


const batToken = "0x6493AF7EF4bb3E3c6E4039095DD5fA75B40e2F85";
const boredApeHolder = "0xAcE9388E96555c7DaB7CF70D5dBC359ba54A8270"
const stakeAddr = "0x4bf010f1b9beDA5450a8dD702ED602A104ff65EE";

async function staking(){
    const stakeContract = await ethers.getContractAt("Stake", stakeAddr);
    const tokenContract = await ethers.getContractAt("IERC20", batToken)

    // const stakeDeploy = await stakeContract.deploy();
    // await stakeDeploy.deployed();

    // console.log(stakeDeploy.address)

    //Account Impersonation()
    // @ts-ignore
    await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
         params: [boredApeHolder],
    });

    const batBal = await tokenContract.balanceOf(boredApeHolder)
    console.log(`Bat Token Balance of BoredApe Holder:${batBal}`)
//     const transferBat = await tokenContract.transfer(boredApeHolder, "1000000000")
//     const batBal2 = await tokenContract.balanceOf(boredApeHolder)
//     console.log(`Latest Bat Token Balance of BoredApe Holder:${batBal2}`)

    const signer = await ethers.getSigner(boredApeHolder)
    //await tokenContract.connect(signer).approve(stakeContract.address, "1000000")
    const allowance = await tokenContract.allowance(boredApeHolder, stakeContract.address)
    console.log(`amount allowed ${allowance}`)
    
    //const stake  = await stakeContract.connect(signer).stake(boredApeHolder, 100);
    const batBal3 = await tokenContract.balanceOf(boredApeHolder)
    console.log(`Bat Token Balance of BoredApe Holder:${batBal3}`)

  

   // await ethers.provider.send("evm_increaseTime", [2592000])
   // await network.provider.send("evm_mine", [1650667236])

    const withdraw = await stakeContract.connect(signer).withdraw(boredApeHolder, 100)

    const batBal4 = await tokenContract.balanceOf(boredApeHolder)
    console.log(`Latest Bat Token Balance of BoredApe Holder:${batBal4}`)
}

staking().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });