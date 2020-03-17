pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./Subscription.sol";

interface BookRideInterface {
    enum bookRideStatus {
        request,
        reject,
        cancel,
        confirm,
        uncompleted,
        completed
    }
    struct bookRide {
        uint256 bid;
        uint256 oid;
        address rider;
        bookRideStatus status;
    }
    event Message(string message, bookRide _user);
}

contract BookRideContract is BookRideInterface, OfferRideContract {
    mapping(uint256 => bookRide) BookRideList;
    mapping(uint256 => uint256[]) OfferBookRideList;
    mapping(address => uint256[]) UserBookRideList;
    mapping(address => mapping(uint256 => uint256[])) UserOfferBookRideList;
    uint256 internal bookRideId;

    // for rider
    function addBookRide(bookRide memory _bookRide) public onlyRegisteredUser {
        require(offerRideId >= _bookRide.oid, "No such offer ride exist");
        require(
            OfferRideList[_bookRide.oid].status == offerRideStatus.active,
            "Offer is not active currently"
        );
        uint256 length = UserOfferBookRideList[msg.sender][_bookRide.oid]
            .length;
        if (length != 0) {
            bookRideStatus previousRideStatus = BookRideList[UserOfferBookRideList[msg
                .sender][_bookRide.oid][length - 1]]
                .status;
            require(
                previousRideStatus != bookRideStatus.request ||
                    previousRideStatus != bookRideStatus.confirm,
                "You previous booked ride with this Offer ride has not been resolved yet"
            );
        }
        _bookRide.rider = msg.sender;
        BookRideList[bookRideId] = _bookRide;
        OfferBookRideList[_bookRide.oid].push(bookRideId);
        UserBookRideList[msg.sender].push(bookRideId);
        transferFrom(msg.sender, address(this), 20);
        UserOfferBookRideList[msg.sender][_bookRide.oid].push(bookRideId);
        UserList[msg.sender].utype = UserType.Rider;
        emit Message("Booked ride successfully", BookRideList[bookRideId]);
        bookRideId++;
    }

    // function checkBookRideStatus(uint256 bid)
    //     public
    //     onlyRegisteredUser
    //     onlyRider
    //     returns (bookRideStatus)
    // {
    //     offerRideStatus ostatus = OfferRideList[BookRideList[bid].oid].status;
    //     bookRideStatus status = BookRideList[bid].status;
    //     if (
    //         ostatus == offerRideStatus.progress &&
    //         status != bookRideStatus.confirm
    //     ) {
    //         BookRideList[bid].status = bookRideStatus.reject;
    //     }
    //     return BookRideList[bid].status;
    // }

    function getBookRideByUser()
        public
        view
        onlyRegisteredUser
        onlyRider
        returns (bookRide[] memory)
    {
        uint256[] memory myBookRidesIds = UserBookRideList[msg.sender];
        require(myBookRidesIds.length > 0, "You have booked no rides yet");
        bookRide[] memory myBookRides = new bookRide[](myBookRidesIds.length);
        for (uint256 i = 0; i < myBookRidesIds.length; i++) {
            myBookRides[i] = BookRideList[myBookRidesIds[i]];
        }
        return myBookRides;
    }

    // function cancelBookRideByRider(uint256 bid)
    //     public
    //     onlyRegisteredUser
    //     onlyRider
    // {
    //     bookRideStatus currentStatus = BookRideList[bid].status;
    //     require(
    //         currentStatus == bookRideStatus.cancel,
    //         "Ride already cancelled"
    //     );
    //     if (currentStatus == bookRideStatus.confirm) {
    //         BookRideList[bid].status = bookRideStatus.cancel;
    //     } else {
    //         BookRideList[bid].status = bookRideStatus.cancel;
    //         transferFrom(address(this), msg.sender, 20);
    //     }

    // }

    // function riderCheckedIn(uint256 bid) public onlyRegisteredUser onlyRider {
    //     bookRideStatus currentStatus = BookRideList[bid].status;
    //     require(
    //         currentStatus != bookRideStatus.cancel,
    //         "Ride already cancelled"
    //     );
    //     require(
    //         currentStatus == bookRideStatus.confirm,
    //         "Ride should be confirm before checking in"
    //     );
    //     BookRideList[bid].status = bookRideStatus.uncompleted;
    //     OfferRideList[BookRideList[bid].oid].status = offerRideStatus
    //         .uncompleted;
    //     transferFrom(
    //         msg.sender,
    //         address(this),
    //         OfferRideList[BookRideList[bid].oid].ride_fee - 20
    //     );
    // }

    // function leaveRideByRider(uint256 bid) public onlyRegisteredUser onlyRider {
    //     bookRideStatus currentStatus = BookRideList[bid].status;
    //     require(
    //         currentStatus != bookRideStatus.cancel,
    //         "Ride already cancelled"
    //     );
    //     require(
    //         currentStatus == bookRideStatus.uncompleted,
    //         "Ride should be uncompleted before completed"
    //     );
    //     BookRideList[bid].status = bookRideStatus.completed;
    //     OfferRideList[BookRideList[bid].oid].status = offerRideStatus.completed;
    //     transferFrom(
    //         address(this),
    //         OfferRideList[BookRideList[bid].oid].user,
    //         OfferRideList[BookRideList[bid].oid].ride_fee
    //     );
    // }

    // function rideCompletedByRider(uint256 bid)
    //     public
    //     onlyRegisteredUser
    //     onlyRider
    // {
    //     require(
    //         OfferRideList[BookRideList[bid].oid].status ==
    //             offerRideStatus.completed,
    //         "Wait for pooler to mark ride as completed first"
    //     );
    //     bookRideStatus currentStatus = BookRideList[bid].status;
    //     require(
    //         currentStatus == bookRideStatus.uncompleted,
    //         "Ride should be uncompleted before completed"
    //     );
    //     BookRideList[bid].status = bookRideStatus.completed;
    //     transferFrom(
    //         address(this),
    //         OfferRideList[BookRideList[bid].oid].user,
    //         OfferRideList[BookRideList[bid].oid].ride_fee + 20
    //     );
    //     UserList[msg.sender].utype = UserType.None;
    // }

    // for pooler
    // function confirmBookRide(uint256 bid) public onlyRegisteredUser onlyPooler {
    //     require(
    //         OfferRideList[BookRideList[bid].oid].status ==
    //             offerRideStatus.active,
    //         "Offer ride is not active anymore"
    //     );
    //     require(
    //         BookRideList[bid].status == bookRideStatus.request,
    //         "Booked ride can not be confirmed now as it is not in request mode."
    //     );
    //     transferFrom(msg.sender, address(this), 20);
    //     BookRideList[bid].status = bookRideStatus.confirm;
    //     OfferRideList[BookRideList[bid].oid].status = offerRideStatus.progress;
    // }

    // function rejectBookRide(uint256 bid) public onlyRegisteredUser onlyPooler {
    //     require(
    //         BookRideList[bid].status == bookRideStatus.request,
    //         "Booked ride can not be reject now as it is not in request mode."
    //     );
    //     BookRideList[bid].status = bookRideStatus.reject;
    // }

    // function cancelBookRideByPooler(uint256 bid)
    //     public
    //     onlyRegisteredUser
    //     onlyPooler
    // {
    //     require(
    //         OfferRideList[BookRideList[bid].oid].status ==
    //             offerRideStatus.progress,
    //         "Offer ride is not in progress anymore"
    //     );
    //     require(
    //         BookRideList[bid].status == bookRideStatus.confirm,
    //         "Booked ride can not be cancelled now as it is not in progress mode."
    //     );
    //     BookRideList[bid].status = bookRideStatus.cancel;
    //     transferFrom(address(this), BookRideList[bid].rider, 20);
    //     OfferRideList[BookRideList[bid].oid].status = offerRideStatus.active;
    // }

    // function getAllOfferBookedRide()
    //     public
    //     view
    //     onlyRegisteredUser
    //     onlyPooler
    //     returns (bookRide[] memory)
    // {
    //     offerRide[] memory allOfferRides = getOfferRideByUser();
    //     uint256[] memory offerBookedRidesIds = OfferBookRideList[allOfferRides[allOfferRides
    //         .length -
    //         1]
    //         .oid];
    //     bookRide[] memory offerBookedRides = new bookRide[](
    //         offerBookedRidesIds.length
    //     );
    //     for (uint256 i = 0; i < offerBookedRidesIds.length; i++) {
    //         offerBookedRides[i] = BookRideList[offerBookedRidesIds[i]];
    //     }
    //     return offerBookedRides;
    // }

    // function leaveRideByPooler(uint256 bid)
    //     public
    //     onlyRegisteredUser
    //     onlyPooler
    // {
    //     require(
    //         BookRideList[bid].status == bookRideStatus.uncompleted,
    //         "Booked ride can not be left now as it is not in uncompleted mode."
    //     );
    //     BookRideList[bid].status = bookRideStatus.completed;
    //     transferFrom(
    //         address(this),
    //         BookRideList[bid].rider,
    //         OfferRideList[BookRideList[bid].oid].ride_fee + 40
    //     );
    //     OfferRideList[BookRideList[bid].oid].status = offerRideStatus.completed;
    // }

    // function rideCompletedByPooler(uint256 bid)
    //     public
    //     onlyRegisteredUser
    //     onlyPooler
    // {
    //     require(
    //         BookRideList[bid].status == bookRideStatus.uncompleted,
    //         "Booked ride can not be completed now as it is not in uncompleted mode."
    //     );
    //     BookRideList[bid].status = bookRideStatus.completed;
    //     OfferRideList[BookRideList[bid].oid].status = offerRideStatus.completed;
    //     UserList[msg.sender].utype = UserType.None;
    // }

}
