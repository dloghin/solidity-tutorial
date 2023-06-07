// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./MyERC721.sol";
import "./MyERC20.sol";

contract MyMarketplace {
    uint256[] private properties;
    mapping(uint256 => uint256) private prices;
    mapping(uint256 => address) private addresses;

    address private marketPlaceOwner;
    address private addrERC20;
    address private addrERC721;

    constructor (address _addrERC20, address _addrERC721) {
        marketPlaceOwner = msg.sender;
        addrERC20 = _addrERC20;
        addrERC721 = _addrERC721;
    }

    // msg.sender = address of the function caller (tx)
    function listProperty(uint256 propertyId, uint256 price) public {
        // checks
        MyERC721 myERC721Contract = MyERC721(addrERC721);
        require(myERC721Contract.ownerOf(propertyId) == msg.sender);
        myERC721Contract.transferFrom(msg.sender, marketPlaceOwner, propertyId);

        // contract internal data structures
        prices[propertyId] = price;
        addresses[propertyId] = msg.sender;
        properties.push(propertyId);
    }

    // this should be called by the buyer
    function buyProperty(uint256 propertyId) public returns(string memory) {
        if (prices[propertyId] == 0) {
            return "Property does not exist!";
        }

        MyERC20 myERC20Contract = MyERC20(addrERC20);
        MyERC721 myERC721Contract = MyERC721(addrERC721); 

        address buyerAddress = msg.sender;
        if (myERC20Contract.balanceOf(buyerAddress) < prices[propertyId]) {
            return "Buyer does not have sufficient funds!";
        }

        address sellerAddress = addresses[propertyId];
        bool status1 = myERC20Contract.transferFrom(buyerAddress, sellerAddress, prices[propertyId]);
        if (!status1) {
            return "Error on transfer of ERC20!";
        }
        myERC721Contract.transferFrom(marketPlaceOwner, buyerAddress, propertyId);

        // 
        prices[propertyId] = 0;
        addresses[propertyId] = address(0);
        for (uint i=0; i < properties.length; i++) {
            if (properties[i] == propertyId) {
                properties[i] = 0;
                break;
            }
        }
        return "Success";
    }

    function getNFTOwner(uint256 propertyId) public view returns(address) {
        MyERC721 myERC721Contract = MyERC721(addrERC721);
        return myERC721Contract.ownerOf(propertyId);
    }

    function getSender() public view returns(address) {        
        return msg.sender;
    }

    function getMarketPlaceOwner() public view returns(address) {        
        return marketPlaceOwner;
    }

    function getAllListedProperties() public view returns(uint256[] memory) {
        return properties;
    }

}