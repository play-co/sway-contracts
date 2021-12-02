import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction locks a set so that new clips can no longer be added to it

// Parameters:
//
// setID: the ID of the set to be locked

transaction(setID: UInt32) {

    // local variable for the admin resource
    let adminRef: &SwayMoment.Admin

    prepare(acct: AuthAccount) {
        // borrow a reference to the admin resource
        self.adminRef = acct.borrow<&SwayMoment.Admin>(from: /storage/SwayMomentAdmin)
            ?? panic("No admin resource in storage")
    }

    execute {
        // borrow a reference to the Set
        let setRef = self.adminRef.borrowSet(setID: setID)

        // lock the set permanently
        setRef.lock()
    }

    post {

        SwayMoment.isSetLocked(setID: setID)!:
            "Set did not lock"
    }
}
