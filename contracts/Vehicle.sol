pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface VehicleInterface {
    enum vstate {active, inactive}
    enum vtype {car, bike}
    struct Vehicle {
        uint256 ID;
        vtype v_type;
        vstate v_state;
        string model;
        string make;
        uint256 id_number;
        string vehiclePicUrl;
    }
    event Message(string message);
}

contract Vehicle is VehicleInterface {
    mapping(uint256 => VehicleInterface.Vehicle) internal VehicleList;
    mapping(address => VehicleInterface.Vehicle[]) internal UserVehicleList;
    uint256 private VID = 0;
    function store(VehicleInterface.Vehicle memory _vehicle)
        internal
        returns (bool)
    {
        require(
            vehicleIdVerification(_vehicle.id_number),
            "Id verification failed"
        );
        _vehicle.ID = VID;
        VehicleList[VID] = _vehicle;
        UserVehicleList[msg.sender].push(_vehicle);
        VID++;
        emit VehicleInterface.Message("Vehicle registered successfully");
        return true;
    }

    function vehicleIdVerification(uint256 _id) private pure returns (bool) {
        if (_id % 2 == 0) {
            return true;
        }
        return false;
    }

    function getVehicleList()
        internal
        view
        returns (VehicleInterface.Vehicle[] memory)
    {
        return UserVehicleList[msg.sender];
    }
}
