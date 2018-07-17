pragma solidity ^0.4.20;
pragma experimental ABIEncoderV2; // to be able to return struct arrays 

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
    
    
    constructor() public {
        //Set owner to who creates the contract
        owner = msg.sender;
        //add owner to managers list
        managers.push(owner); 
    }
    
    //Managers
    address[] managers;
    
    //Throws if called by an account that is not a manager.
    modifier isManager(address _address){
        for (uint i = 0; i < managers.length; i++ ){
            if (managers[i] == _address){
            _; 
            }
        }
    }
    
    //addition of approved managers can only be done by an existing manager 
    function _addManager(address _address) public isManager(msg.sender) {
        managers.push(_address);         
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
        //new category to be added to the array 
        if (!found){
            newCategory._name = _name;
            newCategory._budget = _budget;
            categories.push(newCategory);
        }

    }
    
 
    //function to delete category by name which can only be done by an existing manager
    // TODO: what is the cheapest way to do this?
    function _deleteCategory(string _name) public isManager(msg.sender) returns(string){
        bool found = false; 
        for (uint i = 0; i < categories.length; i++){
            expense memory item = categories[i];
            if (keccak256(abi.encodePacked(item._name)) == keccak256(abi.encodePacked(_name))){
                found = true;
                delete categories[i];
                categories[i] = categories[categories.length - 1];
                delete categories[categories.length - 1];
                
            }
        }
        if (!found){
            string memory notFound = " Category was not found.";
            return notFound;
 
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
    
    //GetFunctions 
    function _viewManagers() view external returns(address[]) {
        return managers;
    }
    
    function _viewCategories() view external returns(expense[]){
        return categories;
    }
    /*
    function _employeeSpent(address _employee) external{
        spent storage spending = employeeExpenses[_employee]; //holds the _spent and _remainder for employeeExpenses
        //creats array of employee expenses
        expense[] storage expenses = expense("", 0); 
       // expense[] storage expenses; 
        //create a temp array to store categories
        expense[] memory allSpent = categories; //will store _name and _budget
        for (uint i = 0; i < allSpent.length; i++){
            expense memory item = allSpent[i];
            item._budget = spending._spent[item._name];
            if (i == 0){
                
            }
            expenses.push(item);
            
        }
    
    function _employeeSpent(address _employee) view returns(spent[]){
        return employeeExpenses[_employee]; 
        
    }
    */
    

    
}

//Flat company structure: where the quota for each category is set for all employees in the org 
