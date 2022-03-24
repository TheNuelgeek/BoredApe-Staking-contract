// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Stake {


    /*

    ** Write  a staking contract that accepts an erc20 token called boredApeToken(created by you,18 decimasls)
    ** When people stake brt, they earn 10% of it per month provided they have staked for 3 days or more
    ** IMPORTANT: Only BoredApes owners can use your contract (ignore = 0x0ed64d01D0B4B655E410EF1441dD677B695639E7)

    ** BOREDAPES NFT: 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d
    ** DEPLOYED ERC20 BAT ADDRESS: 0x6493AF7EF4bb3E3c6E4039095DD5fA75B40e2F85
    ** address boredApe = 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d;
    **/

    address public boredContractApe = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    address public BAT = 0x6493AF7EF4bb3E3c6E4039095DD5fA75B40e2F85;
    address[] stakers;
    mapping(address => bool)staker;
    mapping(address => StakerDetails) addrToStaker;
    uint bal;
    
    struct StakerDetails{
        address staker;
        uint amount;
        uint stakedBal;
        uint mainBal;
        uint intrestBal;
        uint stakedTime;
        uint timeLast;
    }

    // FUNCTION

    modifier addAddress(){
        //address _boredApeAddr = msg.sender;
        require( IERC721(boredContractApe).balanceOf(msg.sender) >= 1 , ""); 

        staker[msg.sender] = true;

        _;
    }

    // function to stake
    function stake(address _staker, uint _amount)external payable addAddress returns(bool){
        assert(staker[_staker]);
        IERC20(BAT).transferFrom(_staker, address(this), _amount);
        StakerDetails storage s = addrToStaker[_staker];
        s.staker = _staker;
        s.amount = _amount;
        bal += _amount;
        s.stakedBal += _amount;
        s.mainBal += _amount;
        s.stakedTime = block.timestamp;
        s.timeLast = s.stakedTime;

        return true;
    }

    function calculateIntrestPerDay(address _staker, uint currentDay)private view returns(uint intrest){
        StakerDetails storage s = addrToStaker[_staker];
        uint a = 50; //0.333 * 1000;
        uint b = s.stakedBal / 100;
        uint intrestPerday = a * b ;// / 1000;
        uint currentIntrest = intrestPerday * currentDay;
        return intrest = currentIntrest;
        // s.intrestBal += intrestPerday;
        // s.mainBal += intrestPerday;
    }

    // function to withdraw
    function withdraw(address _staker, uint _amount)external returns(bool success){
        assert(staker[_staker]);
        StakerDetails storage s = addrToStaker[_staker];
        assert(addrToStaker[_staker].amount >= _amount);
        if(s.stakedTime > block.timestamp + 60 seconds ){
            uint withdrawTime  = block.timestamp - s.stakedTime;
            uint numOfDays = withdrawTime / 60;
            uint intrest = calculateIntrestPerDay(msg.sender, numOfDays);
            // uint newIntrest = _amount*10 / 100;
            uint main = _amount + intrest;
            bal -= main;
            s.mainBal -= main;
            s.stakedBal -= main;
            s.stakedTime = block.timestamp;
            s.stakedTime = s.timeLast;
            IERC20(BAT).transfer(_staker,main);
        }else{
            bal -= _amount;
            s.mainBal -= _amount;
            s.stakedBal -= _amount;
            s.stakedTime = block.timestamp;
            s.stakedTime = s.timeLast;
            IERC20(BAT).transfer(_staker,_amount);
        }

        success = true;
    }
}