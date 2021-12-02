import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script returns an array of the clip IDs that are
// in the specified set

// Parameters:
//
// setID: The unique ID for the set whose data needs to be read

// Returns: [UInt32]
// Array of clip IDs in specified set

pub fun main(setID: UInt32): [UInt32] {

    let clips = SwayMoment.getClipsInSet(setID: setID)!

    return clips
}
