pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./User.sol";

interface OfferRideInterface {
    enum offerRideStatus {active, progress, cancel, completed, uncompleted}
    struct offerRide {
        uint256 oid;
        address user;
        uint256 vid;
        string start_location;
        string end_location;
        uint256 start_time;
        uint256 end_time;
        string pickup_location;
        string drop_location;
        uint256 no_of_seats;
        uint256 ride_fee;
        offerRideStatus status;
    }
    event Message(string message, offerRide _user);
}

contract OfferRideContract is OfferRideInterface, User {
    mapping(uint256 => offerRide) OfferRideList;
    mapping(address => uint256[]) UserOfferRideList;
    uint256 public offerRideId;

    function addOfferRide(offerRide memory _offerRide)
        public
        onlyRegisteredUser
    {
        require(
            getUserVehicleList().length > 0,
            "You do not have a vehicle to offer ride, Please add one."
        );
        require(
            VehicleList[_offerRide.vid].v_state == vstate.active,
            "Your vehicle is not active"
        );
        uint256 length = UserOfferRideList[msg.sender].length;
        if (length != 0) {
            offerRideStatus previousRideStatus = OfferRideList[UserOfferRideList[msg
                .sender][length - 1]]
                .status;
            require(
                previousRideStatus == offerRideStatus.completed ||
                    previousRideStatus == offerRideStatus.cancel ||
                    previousRideStatus == offerRideStatus.uncompleted,
                "Your previous ride is still either active or in progress"
            );
        }
        _offerRide.oid = offerRideId;
        _offerRide.user = msg.sender;
        OfferRideList[offerRideId] = _offerRide;
        UserOfferRideList[msg.sender].push(offerRideId);
        UserList[msg.sender].utype = UserType.Pooler;
        emit Message(
            "Added offer ride successfully",
            OfferRideList[offerRideId]
        );
        offerRideId++;
    }

    function getOfferRideByUser()
        public
        view
        onlyRegisteredUser
        returns (offerRide[] memory)
    {
        uint256[] memory myOfferRidesIds = UserOfferRideList[msg.sender];
        require(myOfferRidesIds.length > 0, "You have offered no rides yet");
        offerRide[] memory myOfferRides = new offerRide[](
            myOfferRidesIds.length
        );
        for (uint256 i = 0; i < myOfferRidesIds.length; i++) {
            myOfferRides[i] = OfferRideList[myOfferRidesIds[i]];
        }
        return myOfferRides;
    }

    function getAllOfferRides() public view returns (offerRide[] memory) {
        offerRide[] memory myOfferRides = new offerRide[](offerRideId);
        for (uint256 i = 0; i < offerRideId; i++) {
            myOfferRides[i] = OfferRideList[i];
        }
        return myOfferRides;
    }

    function cancelOfferRide(uint256 _id) public onlyRegisteredUser {
        require(
            OfferRideList[_id].user == msg.sender,
            "You are not authorised for this"
        );
        offerRideStatus rideStatus = OfferRideList[_id].status;
        require(rideStatus != offerRideStatus.cancel, "Ride already cancelled");
        require(
            rideStatus == offerRideStatus.active ||
                rideStatus == offerRideStatus.progress,
            "This ride is already in go, can not cancel"
        );
        if (rideStatus == offerRideStatus.active) {
            OfferRideList[_id].status = offerRideStatus.cancel;
        } else if (rideStatus == offerRideStatus.progress) {
            // return CPT to rider and fine rider
            OfferRideList[_id].status = offerRideStatus.cancel;
        }
        emit Message("Cancelled offer ride successfully", OfferRideList[_id]);
    }

    struct findRide {
        uint256 start_time;
        uint256 end_time;
        string start_location;
        string end_location;
    }

    function findRides(findRide memory _finfRide)
        public
        view
        onlyRegisteredUser
        returns (offerRide[] memory)
    {
        offerRide[] memory currentRides = new offerRide[](offerRideId);
        for (uint256 i = 0; i < offerRideId; i++) {
            if (
                OfferRideList[i].status == offerRideStatus.active &&
                keccak256(
                    abi.encodePacked((OfferRideList[i].start_location))
                ) ==
                keccak256(abi.encodePacked((_finfRide.start_location))) &&
                keccak256(abi.encodePacked((OfferRideList[i].end_location))) ==
                keccak256(abi.encodePacked((_finfRide.end_location))) &&
                OfferRideList[i].start_time >= _finfRide.start_time &&
                OfferRideList[i].end_time <= _finfRide.end_time
            ) {
                currentRides[i] = OfferRideList[i];
            }
        }
        return currentRides;
    }
}
