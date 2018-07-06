pragma solidity ^0.4.20;

import "./safemath.sol";

contract Expenses {
    
    using SafeMath for uint256;
    
    
    //sets the owner of the contract
    address owner;
    
    //TODO: events 
    event overBudget();
    event endOfCategory();
    event expenseApproved();
    event requestCategory(string _name);
    
    
    constructor(Expenses) public {
        //Set owner to who creates the contract
        owner = msg.sender;
        //add owner to managers list
        manager memory temp = manager(owner, true);
        managers.push(temp); 
    }
    
    //Managers
    struct manager{
        address _address;
        bool _exists;
    }
    
    //To remove a manager, just change the _exists bool to false
    manager[] managers;
    
    //Throws if called by an account that is not a manager.
    modifier isManager(address _address){
        for (uint i = 0; i < managers.length; i++ ){
            manager memory temp = managers[i];
            if (temp._address == _address){
            _; 
            }
        }
    }
    
    //addition of approved managers can only be done by an existing manager 
    function _addManager(address _address) public isManager(msg.sender) {
        manager memory newManager = manager(_address, true);
        managers.push(newManager);         
    }
    
    //Categories
    //Stores all current expenseCategory and its allocated budget 
    //TODO: To delete a category 
    struct expense {
        string _name;
        uint _budget;
    }
    
    expense[] categories; 
    
    //  function to create new expense categories which can only be done by an existing manager
    // TODO: what is the cheapest way to do this?
    function _createCategory(string _name, uint _budget) public payable isManager(msg.sender) {
        //duplicate category names will update the original 
        bool found = false; 
        expense memory newCategory; 
        for (uint i = 0; i < categories.length; i++){
            expense memory item = categories[i];
            if (keccak256(abi.encodePacked(item._name)) == keccak256(abi.encodePacked(_name))){
                found = true;
                categories[i]._budget = _budget;
            }
        }
        //duplicate category names will update the original
        if (!found){
            newCategory._name = _name;
            newCategory._budget = _budget;
            categories.push(newCategory);
        }

    }
    
 
    //function to delete category by name which can only be done by an existing manager
    // TODO: what is the cheapest way to do this?
    function _deleteCategory(string _name) public view isManager(msg.sender) {
        bool found = false; 
        expense memory newCategory; 
        for (uint i = 0; i < categories.length; i++){
            expense memory item = categories[i];
            if (keccak256(abi.encodePacked(item._name)) == keccak256(abi.encodePacked(_name))){
                found = true;
                newCategory = item;
            }
        }
    }
    
    
    
    modifier isCategory(string _name){
        //category does not exist so trigger event to request the manager to create a new category
        for (uint i = 0; i < categories.length; i++){
            expense memory item = categories[i];
            if (keccak256(abi.encodePacked(item._name)) == keccak256(abi.encodePacked(_name))){
                _;
            }
        }
        emit requestCategory(_name);
    }
    
    
    
    //Employees
    //holds an employee current expenses 
    //Placed it in a struct because mapping cannot have embedded mappings 
    struct spent {
        mapping (string => uint) _spent;
        mapping (string => uint) _remainder;
    }
    
    //maps an employee address to their current expenses
    mapping (address => spent) employeeExpenses;
    

    //Throws if there is no more budget for a specific category
    function  _isValidExpense(address _address, string _name, uint _cost) public isCategory(_name) returns(bool) {
            //therefore this category exists 
            uint temp =  employeeExpenses[_address]._spent[_name];
            // add new cost to existing category expenditure
            temp = temp.add(_cost);
            //get the max budget for category
            uint budget;
            for (uint i = 0; i < categories.length; i++){
                expense memory item = categories[i];
                if (keccak256(abi.encodePacked(item._name)) == keccak256(abi.encodePacked(_name))){
                    budget = item._budget;
                }
            }            
            if ( temp <= budget){
                //update employee expenditure for that category 
                employeeExpenses[_address]._spent[_name]= temp;
                employeeExpenses[_address]._remainder[_name]= budget.sub(temp);
                emit expenseApproved();
                return true;
            }
            else{
                emit overBudget();
                return false;
            }
    }
    
    

    
    
   


    
    
    
    
}

//Flat company structure: where the quota for each category is set for all employees in the org 
