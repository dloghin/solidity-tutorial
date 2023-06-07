// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Property {

    enum PropertyType {HDB, CONDO, LANDED, INDUSTRIAL}

    struct PropertyData {
        uint64 id;
        address ownerEthAddress;
        string propertyAddress;
        uint32 yearBuilt;
        uint32 surface;
        PropertyType propertyType;
    }

    uint64[] private propertyIds;
    mapping(uint64 => PropertyData) private properties;

    event PropertyAdded(PropertyData data);

    function getPropertyData(uint64 id) public view returns(PropertyData memory) {
        return properties[id];
    }

    function getPropertyData(address ownerEthAddress) public view returns(PropertyData memory) {        
        for (uint32 i = 0; i < propertyIds.length; i++) {
            if (properties[propertyIds[i]].ownerEthAddress == ownerEthAddress) {
                return properties[propertyIds[i]];
            }
        }
        PropertyData memory none;
        return none;
    }

    function addPropertyData(PropertyData memory data) public {
        properties[data.id] = data;
        propertyIds.push(data.id);
        emit PropertyAdded(data);
    }

    function getAllPropertyData() public view returns(PropertyData[] memory) {
        PropertyData[] memory arr = new PropertyData[](propertyIds.length);
        for (uint32 i = 0; i < propertyIds.length; i++) {
            arr[i] = properties[propertyIds[i]];
        }
        return arr;
    }
}