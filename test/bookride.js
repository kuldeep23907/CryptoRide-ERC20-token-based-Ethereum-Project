const BookRide = artifacts.require("BookRideContract");

contract("BookRide", accounts => {
    it("should register the user with the details => 'Kuldeep', 'kk23907.me@gmail.com', 123124, 123123123, 'url', '123123', 0]", () =>
        BookRide.deployed()
            .then(instance => {
                instance.store.call(["Kuldeep", "kk23907.me@gmail.com", 123124, 123123123, "url", "123123", 0]);
            })
    );
});

contract("BookRide", accounts => {
    it("should get the user just registered", () =>
        BookRide.deployed()
            .then(instance => instance.getUserDetails.call())
            .then(result => console.log(result))
    );
});

contract("BookRide", accounts => {
    it("should get 100 bonus tokens given to user ", () =>
        BookRide.deployed()
            .then(instance => instance.balanceOf.call(accounts[0]))
            .then(balance => { assert.equal(1000100 - 100, balance.toNumber(), '100 tokens were not added'); })
    );
});

// contract("BookRide", accounts => {
//     it("should add vehicle to an user ", () =>
//         BookRide.deployed()
//             .then(instance => instance.addVehicle.call()
//             .then(balance => { assert.equal(1000100 - 100, balance.toNumber(), '100 tokens were not added'); })
//     );
// });

