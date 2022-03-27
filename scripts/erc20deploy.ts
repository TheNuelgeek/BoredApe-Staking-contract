import { ethers } from "hardhat";

const name:string = "Bored Ape Token";
const symbol:string = "BAT";
const dec:number = 18;
const totalsupply = "10000000000000000000000000000000000000000000000";
const owner ="0xC635dC7e540d384876aC4D6178D9971241b8383B"
const batToken = "0x6493AF7EF4bb3E3c6E4039095DD5fA75B40e2F85"
const boredApeHolder = "0x8BBc693D042cEA740e4ff01D7E0Efb36110c36BF"

async function erc20(){
 //
    //Account Impersonation()
    // @ts-ignore
    await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
         params: [owner],
    });

    // @ts-ignore
    await network.provider.send("hardhat_setBalance", [
        owner,
        "0x20000000000000000000",
    ]);

    const ownerSigner = await ethers.getSigner(owner)

    //const ERC20 = await ethers.getContractAt("ERC20Token", batToken);
    const ERC20 = await ethers.getContractFactory("ERC20Token");
    const ERC20Depoly = await ERC20.connect(ownerSigner).deploy(name, symbol, dec, totalsupply);
    await ERC20Depoly.deployed();

    console.log(ERC20Depoly.address);
    console.log( await ethers.provider.getBalance(owner))
    console.log(await ERC20Depoly.balanceOf(owner))

    await ERC20Depoly.connect(ownerSigner).transfer(boredApeHolder, "200000000")

    const batBal = await ERC20Depoly.balanceOf(boredApeHolder)
    console.log(`Bat Token Balance of BoredApe Holder:${batBal}`)
}

erc20().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });