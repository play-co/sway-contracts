import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction adds multiple clips to a set

// Parameters:
//
// setID: the ID of the set to which multiple clips are added
// clips: an array of clip IDs being added to the set

transaction(setID: UInt32, clips: [UInt32]) {

    // Local variable for the SwayMoment Admin object
    let adminRef: &SwayMoment.Admin

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&SwayMoment.Admin>(from: /storage/SwayMomentAdmin)!
    }

    execute {

        // borrow a reference to the set to be added to
        let setRef = self.adminRef.borrowSet(setID: setID)

        // Add the specified clip IDs
        setRef.addClips(clipIDs: clips)
    }
}
