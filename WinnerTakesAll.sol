pragma solidity ^0.4.4;

contract WinnerTakesAll {
    
    uint minimum_entry_fee;
    uint public deadline_project;
    uint public deadline_campaign;
    uint public winning_funds;
    address public winning_address;
    
    struct Project {
        
        address addr;
        string name;
        string url;
        uint funds;
        bool initialized;
    }
    
    mapping (address => Project) projects;
    
    address[] public project_address;
    
    uint public number_of_projects;
    
    event ProjectSubmitted(address addr, string name, string url, uint funds, bool initialized);
    
    event ProjectSupported(address addr, uint amount);
    
    event PaidOutTo(address addr, uint winning_funds);
    
    function WinnerTakesAll(uint _minimum_entry_fee, uint _duration_of_project, uint _duration_of_campaign) public {
        
        if (_duration_of_campaign <= _duration_of_project) {
            throw;
        }
        
        minimum_entry_fee = _minimum_entry_fee;
        deadline_project = now + _duration_of_project * 1 seconds;
        deadline_campaign = now + _duration_of_campaign * 1 seconds;
        winning_address = msg.sender;
        winning_funds = 0;
    }
    
    function SubmitProject(string name, string url) payable public returns (bool success) {
        
        if (msg.value < minimum_entry_fee) {
            throw;
        }
        
        if (now > deadline_project) {
            throw;
        }
        
        if(!projects[msg.sender].initialized) {
            projects[msg.sender] = Project(msg.sender, name, url, 0, true);
            project_address.push(msg.sender);
            number_of_projects = project_address.length;
            ProjectSubmitted(msg.sender, name, url, msg.value, projects[msg.sender].initialized);
            return true;
        }
        
        return false;
    }
    
    function SupportProject(address addr) payable public returns (bool success) {
        
        if(msg.value <= 0) {
            throw;
        }
        
        if(now > deadline_campaign || now <= deadline_project) {
            throw;
        }
        
        if(!projects[addr].initialized) {
            throw;
        }
        
        projects[addr].funds += msg.value;

        if (projects[addr].funds > winning_funds) {
            winning_address = addr;
            winning_funds = projects[addr].funds;
        }

        ProjectSupported(addr, msg.value);
        return true;
    }

    function GetProjectInfo(address addr) public constant returns (string name, string url, uint funds) {

        var project = projects[addr];
        
        if (!project.initialized) {
            throw;
        }

        return (project.name, project.url, project.funds);
    }

    function finish() {
        if (now >= deadline_campaign){
            PaidOutTo(winning_address, winning_funds);
            selfdestruct(winning_address);
        }
    }
}