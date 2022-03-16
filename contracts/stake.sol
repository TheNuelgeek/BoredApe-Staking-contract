// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Stake {


    /*

    ** Write  a staking contract that accepts an erc20 token called boredApeToken(created by you,18 decimasls)
    ** When people stake brt, they earn 10% of it per month provided they have staked for 3 days or more
    ** IMPORTANT: Only BoredApes owners can use your contract

    ** BOREDAPES NFT: 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d
    ** DEPLOYED ERC20 BAT ADDRESS: 0x0ed64d01D0B4B655E410EF1441dD677B695639E7
    ** address boredApe = 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d;
    **/

    address public boredContractApe = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    address public BAT = 0x0ed64d01D0B4B655E410EF1441dD677B695639E7;
    address[] stakers;
    mapping(address => bool)staker;
    mapping(address => StakerDetails) addrToStaker;
    uint bal;
    
    struct StakerDetails{
        address staker;
        uint amount;
        uint stakedTime;
    }

    // FUNCTION

    modifier addAddress(){
        address _boredApeAddr = msg.sender;
        require( IERC721(boredContractApe).balanceOf(_boredApeAddr) > 0 , ""); 

        staker[_boredApeAddr] = true;

        _;
    }

    // function to stake
    function stake(address _staker, uint _amount)external addAddress() returns(bool){
        assert(staker[_staker]);
        IERC20(BAT).transferFrom(_staker, address(this), _amount);
        StakerDetails storage s = addrToStaker[_staker];
        s.staker = _staker;
        s.amount = _amount;
        bal += _amount;
        s.stakedTime = block.timestamp;

        return true;
    }

    // function to withdraw
    function withdraw(address _staker, uint _amount)external addAddress returns(bool){
        assert(staker[_staker]);
        StakerDetails memory s = addrToStaker[_staker];
        assert(addrToStaker[_staker].amount==_amount);
        if(s.stakedTime > block.timestamp + 3 days){
            bal -= _amount;
            uint intrest = _amount/10 * 100;
            uint main = _amount += intrest;
            IERC20(address(this)).transfer(_staker,main);
        }else{
            bal -= _amount;
            IERC20(address(this)).transfer(_staker,_amount);
        }
    }
}