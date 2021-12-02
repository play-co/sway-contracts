import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction is for retiring a clip from a set, which
// makes it so that moments can no longer be minted from that edition

// Parameters:
//
// setID: the ID of the set in which a clip is to be retired
// clipID: the ID of the clip to be retired

transaction(setID: UInt32, clipID: UInt32) {

    // local variable for storing the reference to the admin resource
    let adminRef: &SwayMoment.Admin

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&SwayMoment.Admin>(from: /storage/SwayMomentAdmin)
            ?? panic("No admin resource in storage")
    }

    execute {

        // borrow a reference to the specified set
        let setRef = self.adminRef.borrowSet(setID: setID)

        // retire the clip
        setRef.retireClip(clipID: clipID)
    }

    post {

        self.adminRef.borrowSet(setID: setID).getRetired()[clipID]!:
            "clip is not retired"
    }
}
