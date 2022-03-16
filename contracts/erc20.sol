// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol"; // this imported link contains ERC20Token and IRC20Token

contract ERC20Token is IERC20Metadata {
    // creating ERC20Token using the Token Standard
    // Token = T, TDECIMAL, TNAME, TSYMBOl
 
    // VARIABLES
    string private _tokenName;
    string private _tokenSymbol;
    uint8 private _tokenDecimal;
    uint256 private _totalSupply;

    mapping (address => uint256) balances;
    mapping(address => mapping(address => uint256)) _allowance;

    // FUNCTIONS

    constructor(
        string memory tokenName_,
        string memory tokenSymbol_,
        uint8 tokenDecimal_,
        uint256 totalSupply_
    )
    {
        _tokenName = tokenName_;
        _tokenSymbol = tokenSymbol_;
        _tokenDecimal = tokenDecimal_;
        _totalSupply = totalSupply_;
        balances[msg.sender] = _totalSupply;
    }

    

    function name() external override view returns (string memory){
        return _tokenName;
    }

    function symbol() external override view returns (string memory){
        return _tokenSymbol;
    }

    function decimals() external override view returns (uint8){
        return _tokenDecimal;
    }

    function totalSupply() external override view returns (uint256){
        return _totalSupply;
    }

    // Account Balance

    function balanceOf(address account) external override view returns (uint256){
        return balances[account]; 
    }

    // Transfer
    function _transfer(address _from, address _to, uint256 _amount) internal returns(bool){
        require(_amount <= balances[_from], " Insufficient Balance");
        balances[_from] -= _amount;
        balances[_to] += _amount;
        //return true;

        emit Transfer(_from, _to, _amount);
        return true;
    }

    function transfer(address to, uint256 amount) external override returns (bool){
        _transfer(msg.sender, to, amount);

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // Allowance
    function allowance(address owner, address spender) public view override returns (uint256){
        return _allowance[owner][spender];
    }

    

    // Approve
    function approve(address spender, uint256 amount) external override returns (bool){
        _allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender, amount);
        return true;
    }

    // Transfer from
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool)
    {
       uint256 _allowedAmount = allowance(from, msg.sender);
       require(amount <= _allowedAmount, "You do not have suffcient amount approved");
       _allowance[from][msg.sender] -= amount;
       _transfer(from, to, amount);
       emit Transfer(msg.sender, to, amount);
       return true;
    }
}

// TEST ACCT1 0x793304f421b09D8fDa4225d7AAE33483fDA5406F

// TEST ACCT2 0x7cC71EE395b3ec41F04dCD9b13a079dA859A88a1

// OWNER ACCT 0xC635dC7e540d384876aC4D6178D9971241b8383B

// CONTRACT ADDRESS 0xe2326ce3317ba999b90f3ee2bff526f928a2e672