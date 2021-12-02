import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction is for the admin to create a new set resource
// and store it in the sway moment smart contract

// Parameters:
//
// setName: the name of a new Set to be created

transaction(setName: String) {

    // Local variable for the SwayMoment Admin object
    let adminRef: &SwayMoment.Admin
    let currSetID: UInt32

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&SwayMoment.Admin>(from: /storage/SwayMomentAdmin)
            ?? panic("Could not borrow a reference to the Admin resource")
        self.currSetID = SwayMoment.nextSetID;
    }

    execute {

        // Create a set with the specified name
        self.adminRef.createSet(name: setName)
    }

    post {

        SwayMoment.getSetName(setID: self.currSetID) == setName:
          "Could not find the specified set"
    }
}
