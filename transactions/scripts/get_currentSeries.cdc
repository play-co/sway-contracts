import SwayMoment from "../../contracts/SwayMoment.cdc"

// This script reads the current series from the SwayMoment contract and
// returns that number to the caller

// Returns: UInt32
// currentSeries field in SwayMoment contract

pub fun main(): UInt32 {

    return SwayMoment.currentSeries
}
