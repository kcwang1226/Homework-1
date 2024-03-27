// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract LiaoToken is IERC20 {
    // TODO: you might need to declare several state variable here
    mapping(address account => mapping(address to => uint256 value)) private _allowance;
    mapping(address account => uint256) private _balances;
    mapping(address account => bool) isClaim;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    event Claim(address indexed user, uint256 indexed amount);

    constructor(string memory name_, string memory symbol_) payable {
        _name = name_;
        _symbol = symbol_;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function claim() external returns (bool) {
        if (isClaim[msg.sender]) revert();
        _balances[msg.sender] += 1 ether;
        _totalSupply += 1 ether;
        emit Claim(msg.sender, 1 ether);
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        // TODO: please add your implementaiton here
        address owner = msg.sender;
        emit Transfer(owner, to, amount);
        if(_balances[owner] >= amount){
            _balances[owner]-=amount;
            _balances[to]+=amount;
            return true;
        }
        else{
            revert();
        }

    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        // TODO: please add your implementaiton here
        address owner = msg.sender;
        
        if(_balances[from]>=value && _allowance[from][owner]>=value){
            emit Transfer(from, to, value);
            _allowance[from][owner]-=value;
            _balances[from]-=value;
            _balances[to]+=value;
            return true;
        }
        else{
            revert();
        }
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        // TODO: please add your implementaiton here
        address owner = msg.sender;
        emit Approval(owner, spender, amount);
        // if(_balances[owner]>=amount){
        _allowance[owner][spender] = amount;
            return true;
        // }
        // else{
            // revert();
        // }
        

    }

    function allowance(address owner, address spender) public view returns (uint256) {
        // TODO: please add your implementaiton here
        return _allowance[owner][spender];
    }
}
