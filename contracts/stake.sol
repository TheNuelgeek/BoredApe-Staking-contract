// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract Stake is IERC721{

    //     Write  a staking contract that accepts an erc20 token called boredApeToken(created by you,18 decimasls)

    // - When people stake brt, they earn 10% of it per month provided they have staked for 3 days or more
    // - IMPORTANT: Only BoredApes owners can use your contract

    // BOREDAPES NFT: 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d
    // DEPLOYED ERC20 BAT ADDRESS: 0x0ed64d01D0B4B655E410EF1441dD677B695639E7

    //address boredApe = 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d;

    address boredContractApe = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;

    // FUNCTION

    function addAddress(address _boredApeAddr)external{
        IERC721(boredContractApe).balanceOf(_boredApeAddr);
    }

    // function to stake

    // function to withdraw
}