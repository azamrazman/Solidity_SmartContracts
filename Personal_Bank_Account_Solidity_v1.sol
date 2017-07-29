contract Bank{
    
    //"address" is a type, this is what we use to refer to an addreess.
    address owner;
    
    //This works like a hash mapping.
    //The 'key' here would be an address, but the value is 256-bit unsigned integer [that is what "uint" is]. 
    mapping (address => uint) balances;
    
    //Constructor
    //Note: Contracts can be created 'from outside' or from Solidity contracts. When a contract is created, its constructor (a function with the same name as the contract) is executed once.
    //For msg.~ , please refer to "Special Variables and Functions" at GitHub - Solidity-Tutorial
    //But for simplicity, msg.sender (address) is the account/sender that trigered the contract... basically, the person who send ETH to trigger the contract.
    //Some other important special variable includes - msg.value && msg.gas.
    function Bank(){
        owner = msg.sender;
    }
    
    function deposit(){
        //This is same as balances[msg.sender] = balances[msg.sender] + msg.value;
        //So, what happen here is that, when we take the address of the caller (by using msg.sender) and use that as a key in 'balances' to store (and add existing) balances. 
        balances[msg.sender] += msg.value;
        
        //If you want to deposit, and remove contract...
        //this.remove();
        
        //If you want to send this address somewhere or just what to show this address
        //address me = address(this);
    }
    
    function withdraw(uint amount){
        //We must have controls where the caller can't simply withdraw by blindly
        if (balances[msg.sender] < amount || amount == 0){
            return;
        }
        
        else {
            //Again, balances[msg.sender] -= amount; is the same as balances[msg.sender] = balances[msg.sender] - amount;
            //We deduct the value being withdrawn.
            balances[msg.sender] -= amount;
            
            //We send the caller the amount he/she/they want to withdraw. 
            msg.sender.send(amount);
        }
    }
    
    //We must allow people to delete their "Bank Account".
    function remove(){
        if (msg.sender == owner){
            suicide(owner);
        }
    }
}
