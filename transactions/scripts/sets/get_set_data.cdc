import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script returns all the metadata about the specified set

// Parameters:
//
// setID: The unique ID for the set whose data needs to be read

// Returns: SwayMoment.QuerySetData

pub fun main(setID: UInt32): SwayMoment.QuerySetData {

    let data = SwayMoment.getSetData(setID: setID)
        ?? panic("Could not get data for the specified set ID")

    return data
}
