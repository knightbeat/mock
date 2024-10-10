import ballerina/http;
import ballerina/log;

// Define the types for ATMs and Branches
type ATM record {
    string AtmId;
    string Location;
    string Address;
    string City;
    string PostalCode;
    string Country;
    string Status;
};

type Branch record {
    string BranchId;
    string Name;
    string Address;
    string City;
    string PostalCode;
    string Country;
    string PhoneNumber;
    string OpeningHours;
};

// Hardcoded list of ATMs
ATM[] atms = [
    {
        AtmId: "ATM001",
        Location: "High Street",
        Address: "123 High Street",
        City: "London",
        PostalCode: "EC1A 1AA",
        Country: "UK",
        Status: "Operational"
    },
    {
        AtmId: "ATM002",
        Location: "City Center Mall",
        Address: "45 Oxford Street",
        City: "London",
        PostalCode: "WC1A 1BB",
        Country: "UK",
        Status: "Out of Service"
    },
    {
        AtmId: "ATM003",
        Location: "Train Station",
        Address: "Kings Cross Station",
        City: "London",
        PostalCode: "N1C 4AL",
        Country: "UK",
        Status: "Operational"
    }
];

// Hardcoded list of branches
Branch[] branches = [
    {
        BranchId: "BR001",
        Name: "Main Branch",
        Address: "123 High Street",
        City: "London",
        PostalCode: "EC1A 1AA",
        Country: "UK",
        PhoneNumber: "+44 20 7946 0958",
        OpeningHours: "Mon-Fri: 9 AM - 5 PM"
    },
    {
        BranchId: "BR002",
        Name: "City Branch",
        Address: "45 Oxford Street",
        City: "London",
        PostalCode: "WC1A 1BB",
        Country: "UK",
        PhoneNumber: "+44 20 7847 3729",
        OpeningHours: "Mon-Fri: 9 AM - 6 PM"
    },
    {
        BranchId: "BR003",
        Name: "Station Branch",
        Address: "Kings Cross Station",
        City: "London",
        PostalCode: "N1C 4AL",
        Country: "UK",
        PhoneNumber: "+44 20 7319 3874",
        OpeningHours: "Mon-Sun: 7 AM - 9 PM"
    }
];

service /bank on new http:Listener(9080) {

    // Endpoint to get the list of ATMs
    resource function get atms(http:Caller caller, http:Request req) returns error? {
        log:printInfo("Fetching ATM information");
        check caller->respond(atms);
    }

    // Endpoint to get the list of Branches
    resource function get branches(http:Caller caller, http:Request req) returns error? {
        log:printInfo("Fetching Branch information");
        check caller->respond(branches);
    }

    // Endpoint to get details of a specific ATM by its ID
    resource function get atms/[string atmId](http:Caller caller, http:Request req) returns error? {
        foreach ATM atm in atms {
            if atm.AtmId == atmId {
                check caller->respond(atm);
                return;
            }
        }
        http:Response res = new;
        res.statusCode = 404;
        res.setPayload({message: "ATM not found"});
        check caller->respond(res);
    }

    // Endpoint to get details of a specific Branch by its ID
    resource function get branches/[string branchId](http:Caller caller, http:Request req) returns error? {
        foreach Branch branch in branches {
            if branch.BranchId == branchId {
                check caller->respond(branch);
                return;
            }
        }
        http:Response res = new;
        res.statusCode = 404;
        res.setPayload({message: "Branch not found"});
        check caller->respond(res);
    }
}
