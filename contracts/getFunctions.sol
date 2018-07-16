pragma experimental ABIEncoderV2;
pragma solidity ^0.4.20;

import "./Expenses.sol";

contract getFunctions is Expenses{
    
 /*   
    function _viewManagers() view public returns(manager[]) {
        return managers;
    }
    
    function _viewCategories() view public returns(expense[]){
        return categories;
    }
    
    function _employeeSpent(address _employee) view public {
        //create a temp array to store categories
        expense[] memory allSpent; //will store _name and _budget
        spent employeeInfo = employeeExpenses[_employee]; // equals the spent struct (_spent and remainder)
        expense memory temp;  //will store _name and _budget to be pushed to allSpent
        for( uint i = 0; i < categories.length; i++){
            expense memory item = categories[i]; //_name and _budget 
            string memory category = item._name;
            temp._name = category;
            //now search employeeInfo for the _spent status of this category 
            uint spent = employeeInfo[category]; 
            temp._budget = spent;
        }
        
        
    } 
    
    
    
*/    
}