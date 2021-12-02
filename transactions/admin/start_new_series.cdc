import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction is for an Admin to start a new Sway Moment series

transaction {

    // Local variable for the SwayMoment Admin object
    let adminRef: &SwayMoment.Admin
    let currentSeries: UInt32

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&SwayMoment.Admin>(from: /storage/SwayMomentAdmin)
            ?? panic("No admin resource in storage")

        self.currentSeries = SwayMoment.currentSeries
    }

    execute {

        // Increment the series number
        self.adminRef.startNewSeries()
    }

    post {

        SwayMoment.currentSeries == self.currentSeries + 1 as UInt32:
            "new series not started"
    }
}
