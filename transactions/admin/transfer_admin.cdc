import SwayMoment from "../../contracts/SwayMoment.cdc"
import SwayMomentAdminReceiver from "../../contracts/SwayMomentAdminReceiver.cdc"

// this transaction takes a SwayMoment Admin resource and
// saves it to the account storage of the account
// where the contract is deployed

transaction {

    // Local variable for the SwayMoment Admin object
    let adminRef: @SwayMoment.Admin

    prepare(acct: AuthAccount) {

        self.adminRef <- acct.load<@SwayMoment.Admin>(from: /storage/SwayMomentAdmin)
            ?? panic("No SwayMoment admin in storage")
    }

    execute {

        SwayMomentAdminReceiver.storeAdmin(newAdmin: <-self.adminRef)

    }
}
