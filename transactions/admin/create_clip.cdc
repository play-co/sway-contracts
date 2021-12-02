import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction creates a new clip struct
// and stores it in the Sway Moment smart contract
// We currently stringify the metadata and insert it into the
// transaction string, but want to use transaction arguments soon

// Parameters:
//
// metadata: A dictionary of all the clip metadata associated

transaction(metadata: {String: String}) {

    // Local variable for the SwayMoment Admin object
    let adminRef: &SwayMoment.Admin
    let currClipID: UInt32

    prepare(acct: AuthAccount) {

        // borrow a reference to the admin resource
        self.currClipID = SwayMoment.nextClipID;
        self.adminRef = acct.borrow<&SwayMoment.Admin>(from: /storage/SwayMomentAdmin)
            ?? panic("No admin resource in storage")
    }

    execute {

        // Create a clip with the specified metadata
        self.adminRef.createClip(metadata: metadata)
    }

    post {

        SwayMoment.getClipMetaData(clipID: self.currClipID) != nil:
            "clipID doesnt exist"
    }
}
