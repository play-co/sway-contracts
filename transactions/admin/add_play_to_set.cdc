import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction is how a Sway Moment admin adds a created clip to a set

// Parameters:
//
// setID: the ID of the set to which a created clip is added
// clipID: the ID of the clip being added

transaction(setID: UInt32, clipID: UInt32) {

    // Local variable for the SwayMoment Admin object
    let adminRef: &SwayMoment.Admin

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&SwayMoment.Admin>(from: /storage/SwayMomentAdmin)
            ?? panic("Could not borrow a reference to the Admin resource")
    }

    execute {

        // Borrow a reference to the set to be added to
        let setRef = self.adminRef.borrowSet(setID: setID)

        // Add the specified clip ID
        setRef.addClip(clipID: clipID)
    }

    post {

        SwayMoment.getClipsInSet(setID: setID)!.contains(clipID):
            "set does not contain clipID"
    }
}
