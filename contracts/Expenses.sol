pragma solidity ^0.4.20;

contract Expenses {
    
    
    //Struct to contain the information relating to an expense category
    
    /* 
    struct ExpenseCategory{
        string name;
        uint budget; 
    }
    */
    //connects all expense categories to the address of the manager
    mapping (string => uint) ExpenseCategory;
    //DELETE: array to hold all categories
    //DELETE: ExpenseCategory[] public expenses;
    //mapping to hold all managers address
    mapping (address => bool) managers; 
    
    
    /**
   * @dev Throws if called by an account that is not a manager.
   */
    modifier isManager(address _address){
        require(managers[_address] == true);
        _;
    }
   
    //  function to create expenditure categories
    // TODO: only the manager can create new categories
    // TODO: what is the cheapest way to do this?
    // TODO: is an event needed for this?
    function _createCategory(string _name, uint _budget) internal isManager(msg.sender) {
        //duplicate category names will update the original 
        ExpenseCategory[_name] = _budget;
    }
    
 
    //function to delete category by name
    // delete item at index, and replace the last element at the index that was deleted to prevent leaving a hole in the array
    // TODO: only the manager can create new categories
    // TODO: what is the cheapest way to do this?
    // TODO: is an event needed for this?
    function _deleteCategory(string _name) internal isManager(msg.sender) {
        delete ExpenseCategory[_name];
    }
    
    
}

//TODO: need a isManager modifier 
//Flat structure: where the quota for each category is set for all employees in the org 
/*
        for (uint i = 0; i < categories.length; i++){
            if (keccak256(categories[i].name) == keccak256(_name)){
                return "This expense category already exists. Call the update function.";
            }
        }

*/