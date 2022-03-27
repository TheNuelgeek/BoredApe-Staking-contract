import { ethers, network } from "hardhat";


const batToken = "0x6493AF7EF4bb3E3c6E4039095DD5fA75B40e2F85";
const boredApeHolder = "0x8BBc693D042cEA740e4ff01D7E0Efb36110c36BF"
const stakeAddr = "0x4bf010f1b9beDA5450a8dD702ED602A104ff65EE";

async function staking(){
    const stakeContract = await ethers.getContractAt("Stake", stakeAddr);
    // const stakeC = await ethers.getContractFactory("Stake");
    const tokenContract = await ethers.getContractAt("IERC20", batToken)

    // const stakeContract = await stakeC.deploy();
    // await stakeContract.deployed();

    console.log(stakeContract.address)

    //Account Impersonation()
    // @ts-ignore
    await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [boredApeHolder],
    });

    const batBal = await tokenContract.balanceOf(boredApeHolder)
    console.log(`Bat Token Balance of BoredApe Holder:${batBal}`)

    const signer = await ethers.getSigner(boredApeHolder)
    //await tokenContract.connect(signer).approve(stakeContract.address, "1000000")
    const allowance = await tokenContract.allowance(boredApeHolder, stakeContract.address)
    console.log(`amount allowed ${allowance}`)
    
   // const stake  = await stakeContract.connect(signer).stake(1000);
    const batBal3 = await tokenContract.balanceOf(boredApeHolder)
    console.log(`Bat Token Balance of BoredApe Holder:${batBal3}`)

    console.log(`Staker details before:${await stakeContract.connect(signer).seeStakeDetails()}`)
  

    await ethers.provider.send("evm_increaseTime", [2592000])
    await network.provider.send("evm_mine")

    const withdraw = await stakeContract.withdraw(boredApeHolder, 150)

    const batBal4 = await tokenContract.balanceOf(boredApeHolder)
    console.log(`Latest Bat Token Balance of BoredApe Holder:${batBal4}`)

    console.log(`Staker details after:${await stakeContract.connect(signer).seeStakeDetails()}`)
}

staking().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });