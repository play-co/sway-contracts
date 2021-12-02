import SwayMoment from "../../../contracts/SwayMoment.cdc"

// This script reads the series of the specified set and returns it

// Parameters:
//
// setID: The unique ID for the set whose data needs to be read

// Returns: UInt32
// unique ID of series

pub fun main(setID: UInt32): UInt32 {

    let series = SwayMoment.getSetSeries(setID: setID)
        ?? panic("Could not find the specified set")

    return series
}
