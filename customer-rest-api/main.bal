import ballerina/http;

// Define a record to represent customer bio information
public type CustomerBio record {
    int id;
    string name;
    int age;
    string gender;
    string nationality;
};

// Define a record to represent customer contact information
public type CustomerContact record {
    int id;
    string email;
    string phone;
    string address;
    string city;
};

// Mock customer bio data
CustomerBio[] customerBios = [
    {id: 1, name: "Alice Johnson", age: 34, gender: "Female", nationality: "British"},
    {id: 2, name: "Bob Smith", age: 45, gender: "Male", nationality: "British"},
    {id: 3, name: "Charlie Brown", age: 29, gender: "Male", nationality: "British"},
    {id: 4, name: "Diana Prince", age: 40, gender: "Female", nationality: "British"},
    {id: 5, name: "Ethan Hunt", age: 50, gender: "Male", nationality: "British"},
    {id: 6, name: "Fiona Gallagher", age: 38, gender: "Female", nationality: "British"},
    {id: 7, name: "George Bailey", age: 55, gender: "Male", nationality: "British"},
    {id: 8, name: "Hannah Wells", age: 32, gender: "Female", nationality: "British"}
];

// Mock customer contact data
CustomerContact[] customerContacts = [
    {id: 1, email: "alice@example.com", phone: "123-456-7890", address: "123 Main St", city: "London"},
    {id: 2, email: "bob@example.com", phone: "987-654-3210", address: "456 Elm St", city: "Manchester"},
    {id: 3, email: "charlie@example.com", phone: "555-666-7777", address: "789 Oak St", city: "Birmingham"},
    {id: 4, email: "diana@example.com", phone: "222-333-4444", address: "321 Maple St", city: "Liverpool"},
    {id: 5, email: "ethan@example.com", phone: "111-222-3333", address: "654 Pine St", city: "Bristol"},
    {id: 6, email: "fiona@example.com", phone: "444-555-6666", address: "987 Birch St", city: "Leeds"},
    {id: 7, email: "george@example.com", phone: "777-888-9999", address: "135 Cedar St", city: "Glasgow"},
    {id: 8, email: "hannah@example.com", phone: "999-888-7777", address: "246 Spruce St", city: "Edinburgh"}
];

// Define the service
service /customers on new http:Listener(8080) {

    // Retrieve all customer bios
    resource function get bios() returns CustomerBio[] {
        return customerBios;
    }

    // Retrieve a specific customer bio by ID
    resource function get [int id]/bio() returns CustomerBio|error {
        foreach var bio in customerBios {
            if bio.id == id {
                return bio;
            }
        }
        return error("Customer bio not found");
    }

    // Retrieve all customer contacts
    resource function get contacts() returns CustomerContact[] {
        return customerContacts;
    }

    // Retrieve a specific customer contact by ID
    resource function get [int id]/contact() returns CustomerContact|error {
        foreach var contact in customerContacts {
            if contact.id == id {
                return contact;
            }
        }
        return error("Customer contact not found");
    }

    // Retrieve combined customer bio and contact by ID in a flat format
    resource function get [int id]/details() returns json|error {
        CustomerBio|error bio = getCustomerBio(id);
        CustomerContact|error contact = getCustomerContact(id);
        if bio is CustomerBio && contact is CustomerContact {
            return {
                id: bio.id,
                name: bio.name,
                age: bio.age,
                gender: bio.gender,
                nationality: bio.nationality,
                email: contact.email,
                phone: contact.phone,
                address: contact.address,
                city: contact.city
            };
        }
        return error("Customer not found");
    }

    // Create a new customer bio
    resource function post bios(@http:Payload json payload) returns json|error {
        customerBios.push( check payload.cloneWithType(CustomerBio));
        return {message: "Customer bio added successfully"};
    }

    // Create a new customer contact
    resource function post contacts(@http:Payload json payload) returns json|error {
        customerContacts.push(check payload.cloneWithType(CustomerContact));
        return {message: "Customer contact added successfully"};
    }

    // Update a customer bio
    resource function put [int id]/bio(@http:Payload json payload) returns json|error {
        foreach var i in 0 ..< customerBios.length() {
            if customerBios[i].id == id {
                customerBios[i] = check payload.cloneWithType(CustomerBio);
                return {message: "Customer bio updated successfully"};
            }
        }
        return error("Customer bio not found");
    }

    // Update a customer contact
    resource function put [int id]/contact(@http:Payload json payload) returns json|error {
        foreach var i in 0 ..< customerContacts.length() {
            if customerContacts[i].id == id {
                customerContacts[i] = check payload.cloneWithType(CustomerContact);
                return {message: "Customer contact updated successfully"};
            }
        }
        return error("Customer contact not found");
    }

    // Delete a customer bio
    resource function delete bios/[int id]() returns json {
        customerBios = customerBios.filter(c => c.id != id);
        return {message: "Customer bio deleted successfully"};
    }

    // Delete a customer contact
    resource function delete contacts/[int id]() returns json {
        customerContacts = customerContacts.filter(c => c.id != id);
        return {message: "Customer contact deleted successfully"};
    }

}

function getCustomerBio(int id) returns CustomerBio|error {
    foreach var bio in customerBios {
        if bio.id == id {
            return bio;
        }
    }
    return error("Customer bio not found");
}

function getCustomerContact(int id) returns CustomerContact|error {
    foreach var contact in customerContacts {
        if contact.id == id {
            return contact;
        }
    }
    return error("Customer contact not found");
}
