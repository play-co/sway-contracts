import SwayMoment from "../../contracts/SwayMoment.cdc"

// This script reads the current number of moments that have been minted
// from the SwayMoment contract and returns that number to the caller

// Returns: UInt64
// Number of moments minted from SwayMoment contract

pub fun main(): UInt64 {

    return SwayMoment.totalSupply
}
