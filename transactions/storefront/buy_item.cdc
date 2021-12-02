import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import DapperUtilityCoin from "../../contracts/DapperUtilityCoin.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import NFTStorefront from "../../contracts/NFTStorefront.cdc"

transaction(storefrontAddress: Address, listingResourceID: UInt64) {
    let paymentVault: @FungibleToken.Vault
    let buyerNFTCollection: &SwayMoment.Collection{NonFungibleToken.Receiver}
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}
    let listing: &NFTStorefront.Listing{NFTStorefront.ListingPublic}

    // The Dapper Wallet admin Flow account will provide the authorizing signature,
	// which allows Dapper to purhase the NFT with DUC, on behalf of the buyer
    prepare(dapper: AuthAccount) {
        self.storefront = getAccount(storefrontAddress)
            .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
                NFTStorefront.StorefrontPublicPath
            )!
            .borrow()
            ?? panic("Could not borrow Storefront from provided address")

        self.listing = self.storefront.borrowListing(listingResourceID: listingResourceID)
                    ?? panic("No Offer with that ID in Storefront")
        let salePrice = self.listing.getDetails().salePrice

        // Because Dapper signed as the authorizer, we can borrow a reference
		// to Dapper admin's account DUC vault to withdraw the amount required
		// to purchase the NFT
        let mainDUCVault = dapper.borrow<&DapperUtilityCoin.Vault>(from: /storage/dapperUtilityCoinVault)
            ?? panic("Could not borrow reference to Dapper Utility Coin vault")
        self.paymentVault <- mainDUCVault.withdraw(amount: salePrice)

        self.buyerNFTCollection = dapper.borrow<&SwayMoment.Collection{NonFungibleToken.Receiver}>(
            from: /storage/NFTCollection
        ) ?? panic("Cannot borrow NFT collection receiver from account")
    }

    execute {
        let item <- self.listing.purchase(
            payment: <-self.paymentVault
        )

        self.buyerNFTCollection.deposit(token: <-item)

        /* //-
        error: Execution failed:
        computation limited exceeded: 100
        */
        // Be kind and recycle
        //self.storefront.cleanup(listingResourceID: listingResourceID)
    }

    //- Post to check item is in collection?
}
