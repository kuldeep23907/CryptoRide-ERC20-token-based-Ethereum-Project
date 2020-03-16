pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {CarPoolingToken} from "./CarPoolingToken.sol";
import "./Vehicle.sol";
interface UserInterface {
    enum UserType {None, Pooler, Rider}
    struct User {
        string name;
        string email;
        uint256 adharID;
        uint256 phone;
        string profilePicUrl;
        string password;
        UserType utype;
    }

    function store(User calldata _user) external;
    function update(User calldata _user) external;
    event Message(string message, User _user);
}

contract User is UserInterface, CarPoolingToken, Vehicle {
    mapping(address => UserInterface.User) internal UserList;
    mapping(address => bool) internal AddressAvailable;

    modifier onlyRegisteredUser() {
        require(AddressAvailable[msg.sender], "You are not registered");
        _;
    }

    modifier onlyPooler() {
        require(
            UserList[msg.sender].utype == UserType.Pooler,
            "You are not a pooler"
        );
        _;
    }

    modifier onlyRider() {
        require(
            UserList[msg.sender].utype == UserType.Rider,
            "You are not a rider"
        );
        _;
    }

    function store(UserInterface.User memory _user)
        public
        override
    {
        require(idVerification(_user.adharID), "Id verification failed");
        UserList[msg.sender] = _user;
        AddressAvailable[msg.sender] = true;
        transfer(msg.sender, 100);
        emit UserInterface.Message(
            "User registered successfully",
            UserList[msg.sender]
        );
    }

    function idVerification(uint256 _id) private pure returns (bool) {
        if (_id % 2 == 0) {
            return true;
        }
        return false;
    }

    function update(UserInterface.User memory _user)
        public
        onlyRegisteredUser
        override
    {
        require(_user.adharID == 0, "Adhar ID can not be updated.");
        _user.adharID = UserList[msg.sender].adharID;
        UserList[msg.sender] = _user;
        emit UserInterface.Message(
            "User data updated successfully",
            UserList[msg.sender]
        );
    }

    function getUserDetails() public view returns (User memory user) {
        require(AddressAvailable[msg.sender], "No such user");
        return UserList[msg.sender];
    }

    function addVehicle(VehicleInterface.Vehicle memory _vehicle) public {
        if (store(_vehicle) && getUserVehicleList().length == 1) {
            transfer(msg.sender, 200);
        }
    }

    function getUserVehicleList()
        public
        view
        returns (VehicleInterface.Vehicle[] memory)
    {
        return getVehicleList();
    }

}