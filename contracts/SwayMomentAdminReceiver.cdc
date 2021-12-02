/*

  SwayMomentAdminReceiver.cdc

  This contract defines a function that takes a SwayMoment Admin
  object and stores it in the storage of the contract account
  so it can be used.

 */

import SwayMoment from "./SwayMoment.cdc"
import SwayMomentShardedCollection from "./SwayMomentShardedCollection.cdc"

pub contract SwayMomentAdminReceiver {

    // storeAdmin takes a SwayMoment Admin resource and
    // saves it to the account storage of the account
    // where the contract is deployed
    pub fun storeAdmin(newAdmin: @SwayMoment.Admin) {
        self.account.save(<-newAdmin, to: /storage/SwayMomentAdmin)
    }

    init() {
        // Save a copy of the sharded Moment Collection to the account storage
        if self.account.borrow<&SwayMomentShardedCollection.ShardedCollection>(from: /storage/ShardedMomentCollection) == nil {
            let collection <- SwayMomentShardedCollection.createEmptyCollection(numBuckets: 32)
            // Put a new Collection in storage
            self.account.save(<-collection, to: /storage/ShardedMomentCollection)

            self.account.link<&{SwayMoment.MomentCollectionPublic}>(/public/MomentCollection, target: /storage/ShardedMomentCollection)
        }
    }
}
