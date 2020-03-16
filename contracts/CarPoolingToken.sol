pragma solidity ^0.6.0;

contract CarPoolingToken {
    string private name = "CarPoolingToken";
    string private symbol = "CPT";
    uint256 private decimals = 2;

    uint256 internal supply;
    address internal founder;

    mapping(address => uint256) internal balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );
    constructor() public {
        supply = 1000000;
        founder = msg.sender;
        balances[founder] = supply;
    }

    function allowance(address tokenOwner, address spender)
        internal
        view
        returns (uint256 remaining)
    {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint256 tokens)
        internal
        returns (bool success)
    {
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint256 tokens)
        internal
        returns (bool success)
    {
        require(balances[from] >= tokens);
        balances[from] -= tokens;
        balances[to] += tokens;
        return true;
    }

    function totalSupply() private view returns (uint256) {
        return supply;
    }

    function balanceOf(address tokenOwner)
        public
        view
        returns (uint256 balance)
    {
        return balances[tokenOwner];
    }

    function transfer(address to, uint256 tokens)
        internal
        returns (bool success)
    {
        require(tokens > 0, "token < 0 ");
        balances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
}
