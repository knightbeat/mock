import ballerina/graphql;

// Define the types for ATMs and Branches
type ATM record {
    string atmId;
    string location;
    string address;
    string city;
    string postalCode;
    string country;
    string status;
};

type Branch record {
    string branchId;
    string name;
    string address;
    string city;
    string postalCode;
    string country;
    string phoneNumber;
    string openingHours;
};

// Hardcoded list of ATMs
ATM[] atms = [
    {
        atmId: "ATM001",
        location: "High Street",
        address: "123 High Street",
        city: "London",
        postalCode: "EC1A 1AA",
        country: "UK",
        status: "Operational"
    },
    {
        atmId: "ATM002",
        location: "City Center Mall",
        address: "45 Oxford Street",
        city: "London",
        postalCode: "WC1A 1BB",
        country: "UK",
        status: "Out of Service"
    },
    {
        atmId: "ATM003",
        location: "Train Station",
        address: "Kings Cross Station",
        city: "London",
        postalCode: "N1C 4AL",
        country: "UK",
        status: "Operational"
    }
];

// Hardcoded list of branches
Branch[] branches = [
    {
        branchId: "BR001",
        name: "Main Branch",
        address: "123 High Street",
        city: "London",
        postalCode: "EC1A 1AA",
        country: "UK",
        phoneNumber: "+44 20 7946 0958",
        openingHours: "Mon-Fri: 9 AM - 5 PM"
    },
    {
        branchId: "BR002",
        name: "City Branch",
        address: "45 Oxford Street",
        city: "London",
        postalCode: "WC1A 1BB",
        country: "UK",
        phoneNumber: "+44 20 7847 3729",
        openingHours: "Mon-Fri: 9 AM - 6 PM"
    },
    {
        branchId: "BR003",
        name: "Station Branch",
        address: "Kings Cross Station",
        city: "London",
        postalCode: "N1C 4AL",
        country: "UK",
        phoneNumber: "+44 20 7319 3874",
        openingHours: "Mon-Sun: 7 AM - 9 PM"
    }
];

// Resolver for querying all ATMs
function getAllATMs() returns ATM[] {
    return atms;
}

// Resolver for querying a specific ATM by ID
function getATMById(string atmId) returns ATM|error {
    foreach ATM atm in atms {
        if atm.atmId == atmId {
            return atm;
        }
    }
    return error("ATM not found");
}

// Resolver for querying all Branches
function getAllBranches() returns Branch[] {
    return branches;
}

// Resolver for querying a specific Branch by ID
function getBranchById(string branchId) returns Branch|error {
    foreach Branch branch in branches {
        if branch.branchId == branchId {
            return branch;
        }
    }
    return error("Branch not found");
}

// Define the GraphQL service
service /branchlocatorgql on new graphql:Listener(9081) {

    // Query for all ATMs
    resource function get atms() returns ATM[] {
        return getAllATMs();
    }

    // Query for specific ATM by ID
    resource function get atm(string atmId) returns ATM|error {
        return getATMById(atmId);
    }

    // Query for all Branches
    resource function get branches() returns Branch[] {
        return getAllBranches();
    }

    // Query for specific Branch by ID
    resource function get branch(string branchId) returns Branch|error {
        return getBranchById(branchId);
    }
}
