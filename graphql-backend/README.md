```
query {
  atms {
    atmId
    location
    address
    city
    postalCode
    country
    status
  }
}
```

```
query {
  atm(atmId: "ATM001") {
    atmId
    location
    address
    city
    postalCode
    country
    status
  }
}
```

```
query {
  branches {
    branchId
    name
    address
    city
    postalCode
    country
    phoneNumber
    openingHours
  }
}
```

```
query {
  branch(branchId: "BR001") {
    branchId
    name
    address
    city
    postalCode
    country
    phoneNumber
    openingHours
  }
}
```