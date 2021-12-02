import FungibleToken from "../../contracts/FungibleToken.cdc"
import DapperUtilityCoin from 0xDUCADDRESS
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import SwayMoment from "../../contracts/SwayMoment.cdc"
import NFTStorefront from "../contracts/NFTStorefront.cdc"

transaction(storefrontAddress: Address, listingResourceID: UInt64, expectedPrice: UFix64, buyerAddress: Address) {
    let paymentVault: @FungibleToken.Vault
    let buyerNFTCollection: &ExampleNFT.Collection{NonFungibleToken.Receiver}
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}
    let listing: &NFTStorefront.Listing{NFTStorefront.ListingPublic}

    // The Dapper Wallet admin Flow account will provide the authorizing signature,
		// which allows Dapper to purhase the NFT with DUC, on behalf of the buyer
    prepare(dapper: AuthAccount) {
        self.storefront = getAccount(storefrontAddress)
						.getCapability<&NFTStorefront.Listing{NFTStorefront.ListingPublic}>(
							NFTStorefront.StorefrontStoragePath
						)
						.borrow()
						?? panic("Could not borrow a reference to the storefront")

        self.listing = self.storefront.borrowListing(listingResourceID: listingResourceID)
                    ?? panic("No Listing with that ID in Storefront")
        let salePrice = self.listing.getDetails().salePrice
        
        if expectedPrice != salePrice {
            panic("Sale price not expected value")
        }

				// Because Dapper signed as the authorizer, we can borrow a reference 
				// to Dapper admin's account DUC vault to withdraw the amount required 
				// to purchase the NFT
        let mainDUCVault = dapper.borrow<&DapperUtilityCoin.Vault>(from: /storage/dapperUtilityCoinVault)
					?? panic("Could not borrow reference to Dapper Utility Coin vault")
        self.paymentVault <- mainDUCVault.withdraw(amount: salePrice)

        self.buyerNFTCollection = getAccount(buyerAddress)
            .getCapability<&ExampleNFT.Collection{NonFungibleToken.Receiver}>(
                ExampleNFT.CollectionPublicPath
            )
            .borrow()
            ?? panic("Cannot borrow ExampleNFT collection receiver from buyerAddress")
    }

    execute {
        let item <- self.listing.purchase(
            payment: <-self.paymentVault
        )

        self.buyerNFTCollection.deposit(token: <-item)
    }
}