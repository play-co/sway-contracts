import SwayMoment from "../../contracts/SwayMoment.cdc"

// This transaction sets up an account to use Sway Moment
// by storing an empty moment collection and creating
// a public capability for it

transaction {

    prepare(acct: AuthAccount) {

        // First, check to see if a moment collection already exists
        if acct.borrow<&SwayMoment.Collection>(from: SwayMoment.CollectionStoragePath) == nil {

            // create a new SwayMoment Collection
            let collection <- SwayMoment.createEmptyCollection() as! @SwayMoment.Collection

            // Put the new Collection in storage
            acct.save(<-collection, to: SwayMoment.CollectionStoragePath)

            // create a public capability for the collection
            acct.link<&{SwayMoment.MomentCollectionPublic}>(SwayMoment.CollectionPublicPath, target: SwayMoment.CollectionStoragePath)
        }
    }
}
