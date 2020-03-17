const BookRide = artifacts.require("BookRideContract");

contract("BookRide", accounts => {
    it("should register the user with the details => 'Kuldeep', 'kk23907.me@gmail.com', 123124, 123123123, 'url', '123123', 0]", function () {
        var bookRideContract;
        return BookRide.deployed().then(function (instance) {
            bookRideContract = instance;
            return instance.store(["Kuldeep", "kk23907.me@gmail.com", 123124, 123123123, "url", "123123", 0], { 'from': accounts[1] });
        }).then(function () {
            return bookRideContract.getUserDetails.call({ 'from': accounts[1] });
        }).then(function (result) {
            var [name, email, adharID, phone, profilePicUrl, password, utype] = result;
            assert.equal('Kuldeep', name, 'User name has changed/not properly added');
            assert.equal('kk23907.me@gmail.com', email, 'User email has changed/not properly added');
            assert.equal('123123123', phone, 'User phone number has changed/not properly added');
        }).then(function () {
            return bookRideContract.balanceOf.call(accounts[1]);
        }).then(function (balance) {
            assert.equal(100, balance.toNumber(), '100 tokens were not added for registration');
        })
    })
})

contract("BookRide", accounts => {
    it("should register vehicle to an user with the details => model:'a-series', make:'bmw' ", function () {
        var bookRideContract;
        return BookRide.deployed().then(function (instance) {
            bookRideContract = instance;
            instance.store(["Kuldeep", "kk23907.me@gmail.com", 123124, 123123123, "url", "123123", 0], { 'from': accounts[1] });
            return instance.addVehicle([0, 0, 0, "a-series", "bmw", 124, "url"], { 'from': accounts[1] });
        }).then(function () {
            return bookRideContract.getUserVehicleList.call({ 'from': accounts[1] });
        }).then(function (result) {
            var [ID, v_type, v_state, model, make, id_number, vehiclePicUrl] = result[0];
            assert.equal('a-series', model, 'Vehicle make not properly added');
            assert.equal('bmw', make, 'Vehicle model not properly added');
        }).then(function () {
            return bookRideContract.balanceOf.call(accounts[1]);
        }).then(function (balance) {
            assert.equal(300, balance.toNumber(), '300 tokens were not added for registration and vehicle adding');
        })
    })
})

contract("BookRide", accounts => {
    it("should add an offer ride with start location: bangalore and end location: allahabad", function () {
        var bookRideContract;
        return BookRide.deployed().then(function (instance) {
            bookRideContract = instance;
            instance.store(["Kuldeep", "kk23907.me@gmail.com", 123124, 123123123, "url", "123123", 0], { 'from': accounts[1] });
            instance.addVehicle([0, 0, 0, "a-series", "bmw", 124, "url"], { 'from': accounts[1] });
            return instance.addOfferRide([0, "0x0000000000000000000000000000000000000000", 1, "bangalore", "allahabad", 2, 5, "a", "b", 2, 100, 0], { 'from': accounts[1] });
        }).then(function () {
            return bookRideContract.getOfferRideByUser.call({ 'from': accounts[1] });
        }).then(function (result) {
            var [oid, user, vid, start_location, end_location, start_time, end_time, pickup_location, drop_location, no_of_seats, ride_fee, status] = Object.values(result)[Object.values(result).length - 1];
            assert.equal('bangalore', start_location, 'Start location not properly added');
            assert.equal('allahabad', end_location, 'End location not properly added');
        })
    })
})

contract("BookRide", accounts => {
    it("should cancel an offer ride with given offer id", function () {
        var bookRideContract;
        return BookRide.deployed().then(function (instance) {
            bookRideContract = instance;
            instance.store(["Kuldeep", "kk23907.me@gmail.com", 123124, 123123123, "url", "123123", 0], { 'from': accounts[1] });
            instance.addVehicle([0, 0, 0, "a-series", "bmw", 124, "url"], { 'from': accounts[1] });
            return instance.addOfferRide([0, "0x0000000000000000000000000000000000000000", 1, "bangalore", "allahabad", 2, 5, "a", "b", 2, 100, 0], { 'from': accounts[1] });
        }).then(function () {
            return bookRideContract.cancelOfferRide.call(0, { 'from': accounts[1] });
        })
    })
})

contract("BookRide", accounts => {
    it("should find an offer ride with start location: bangalore and end location: allahabad", function () {
        var bookRideContract;
        return BookRide.deployed().then(function (instance) {
            bookRideContract = instance;
            instance.store(["Kuldeep Pooler", "kk23907.me@gmail.com", 123124, 123123123, "url", "123123", 0], { 'from': accounts[1] });
            instance.addVehicle([0, 0, 0, "a-series", "bmw", 124, "url"], { 'from': accounts[1] });
            instance.addOfferRide([0, "0x0000000000000000000000000000000000000000", 1, "bangalore", "allahabad", 2, 5, "a", "b", 2, 100, 0], { 'from': accounts[1] });
            instance.store(["Kuldeep Rider", "kk23907.me@gmail.com", 123124, 123123123, "url", "123123", 0], { 'from': accounts[2] });
            return instance.findRides([2, 5, "bangalore", "allahabad"], { 'from': accounts[2] });
        })
            .then(function (result) {
                var [oid, user, vid, start_location, end_location, start_time, end_time, pickup_location, drop_location, no_of_seats, ride_fee, status] = Object.values(result)[Object.values(result).length - 1];
                assert.equal('bangalore', start_location, 'Start location not properly added');
                assert.equal('allahabad', end_location, 'End location not properly added');
            })
    })
})

contract("BookRide", accounts => {
    it("should book an offer ride with start location: bangalore and end location: allahabad", function () {
        var bookRideContract;
        return BookRide.deployed().then(function (instance) {
            bookRideContract = instance;
            instance.store(["Kuldeep Pooler", "kk23907.me@gmail.com", 123124, 123123123, "url", "123123", 0], { 'from': accounts[1] });
            instance.addVehicle([0, 0, 0, "a-series", "bmw", 124, "url"], { 'from': accounts[1] });
            instance.addOfferRide([0, "0x0000000000000000000000000000000000000000", 1, "bangalore", "allahabad", 2, 5, "a", "b", 2, 100, 0], { 'from': accounts[1] });
            instance.store(["Kuldeep Rider", "kk23907.me@gmail.com", 123124, 123123123, "url", "123123", 0], { 'from': accounts[2] });
            return instance.addBookRide([0, 0, "0x0000000000000000000000000000000000000000", 0], { 'from': accounts[2] });
        }).then(function () {
            return bookRideContract.getBookRideByUser.call({ 'from': accounts[2] });
        }).then(function (result) {
            var [bid, oid, rider, status] = Object.values(result)[Object.values(result).length - 1];
            assert.equal(accounts[2], rider, 'Rider not added properly');
            assert.equal('0', oid, 'Ride booked on wrong offer ride');
        })
    })
})


