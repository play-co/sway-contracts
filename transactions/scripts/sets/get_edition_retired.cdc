import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This transaction reads if a specified edition is retired

// Parameters:
//
// setID: The unique ID for the set whose data needs to be read
// clipID: The unique ID for the clip whose data needs to be read

// Returns: Bool
// Whether specified set is retired

pub fun main(setID: UInt32, clipID: UInt32): Bool {

    let isRetired = SwayMoment.isEditionRetired(setID: setID, clipID: clipID)
        ?? panic("Could not find the specified edition")

    return isRetired
}
