import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script checks whether for each SetID/ClipID combo,
// they own a moment matching that SetClip.

// Parameters:
//
// account: The Flow Address of the account whose moment data needs to be read
// setIDs: A list of unique IDs for the sets whose data needs to be read
// clipIDs: A list of unique IDs for the clips whose data needs to be read

// Returns: Bool
// Whether for each SetID/ClipID combo,
// account owns a moment matching that SetClip.

pub fun main(account: Address, setIDs: [UInt32], clipIDs: [UInt32]): Bool {

    assert(
        setIDs.length == clipIDs.length,
        message: "set and clip ID arrays have mismatched lengths"
    )

    let collectionRef = getAccount(account).getCapability(/public/MomentCollection)
                .borrow<&{SwayMoment.MomentCollectionPublic}>()
                ?? panic("Could not get public moment collection reference")

    let momentIDs = collectionRef.getIDs()

    // For each SetID/ClipID combo, loop over each moment in the account
    // to see if they own a moment matching that SetClip.
    var i = 0

    while i < setIDs.length {
        var hasMatchingMoment = false
        for momentID in momentIDs {
            let token = collectionRef.borrowMoment(id: momentID)
                ?? panic("Could not borrow a reference to the specified moment")

            let momentData = token.data
            if momentData.setID == setIDs[i] && momentData.clipID == clipIDs[i] {
                hasMatchingMoment = true
                break
            }
        }
        if !hasMatchingMoment {
            return false
        }
        i = i + 1
    }

    return true
}
