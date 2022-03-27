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

    address constant boredContractApe = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    address constant BAT = 0x6493AF7EF4bb3E3c6E4039095DD5fA75B40e2F85;
    address[] stakers;
    mapping(address => bool)staker;
    mapping(address => StakerDetails) addrToStaker;
    uint contractBal;

    struct StakerDetails{
        address staker;
        uint amount;
        uint mainBal;
        uint96 stakedTime;
    }

    // FUNCTION

    modifier addAddress(){
        //address _boredApeAddr = msg.sender;
        assert( IERC721(boredContractApe).balanceOf(msg.sender) >= 1);

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
        contractBal += _amount;
        s.mainBal += _amount;
        s.stakedTime = uint96(block.timestamp);

        return true;
    }

    function calculateIntrestPerDay(uint96 currentDay, uint amount)private pure returns(uint intrest){
         //((((0.1 / 30)/864000) * currentDay) * amount)*10000000000000; 25920000
        uint c = 0.00333333333 * 10000000000000000;
        uint d = c/86400;
        uint intrestDay = (currentDay * d );
        uint currentIntrest = intrestDay * amount;
        intrest = currentIntrest ;
        return intrest; 
    }

    // function to withdraw
    function withdraw(address _staker, uint _amount)external returns(bool success, string memory message){
        //assert(staker[_staker]);
        StakerDetails storage s = addrToStaker[_staker];
        assert(s.mainBal >= _amount);
        uint96 numOfDaysInSecs  = uint96(block.timestamp) - s.stakedTime;
        if(numOfDaysInSecs >= 3 days  ){
           //uint96 numOfDaysInSecs  = uint96(block.timestamp) - s.stakedTime;
            uint interest = calculateIntrestPerDay(numOfDaysInSecs, s.mainBal);

            contractBal -= _amount;
            s.mainBal -= _amount;
            contractBal += (interest / 10000000000000000);
            s.mainBal += (interest / 10000000000000000);

            // Auto compounding always happens here immedaitely stakedTime is reset to block.timestamp
            s.stakedTime = uint96(block.timestamp);
            IERC20(BAT).transfer(_staker,_amount);
        }else if(numOfDaysInSecs < 3 days){
            contractBal -= _amount;
            s.mainBal -= _amount;
            s.stakedTime = uint96(block.timestamp);
            IERC20(BAT).transfer(_staker,_amount);
        }else{
            message = "You've got no money";
        }

        success = true;
    }

    function seeStakeDetails()external view returns(StakerDetails  memory s){
         s = addrToStaker[msg.sender];
    }

}