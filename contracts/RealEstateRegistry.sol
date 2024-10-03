// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract RealEstateRegistry {
    struct Property {
        uint256 id;
        string location;
        address owner;
        bool forSale;
        uint256 price;
    }

    mapping(uint256 => Property) public properties;
    uint256 public propertyCount;

    event PropertyRegistered(uint256 id, string location, address owner);
    event PropertyTransferred(uint256 id, address from, address to);
    event PropertyListed(uint256 id, uint256 price);
    event PropertyDelisted(uint256 id);

    function registerProperty(string memory _location) public {
        propertyCount++;
        properties[propertyCount] = Property(propertyCount, _location, msg.sender, false, 0);
        emit PropertyRegistered(propertyCount, _location, msg.sender);
    }

    function listProperty(uint256 _id, uint256 _price) public {
        require(properties[_id].owner == msg.sender, "Only the owner can list the property");
        properties[_id].forSale = true;
        properties[_id].price = _price;
        emit PropertyListed(_id, _price);
    }

    function delistProperty(uint256 _id) public {
        require(properties[_id].owner == msg.sender, "Only the owner can delist the property");
        properties[_id].forSale = false;
        emit PropertyDelisted(_id);
    }

    function transferProperty(uint256 _id, address _to) public payable {
        require(properties[_id].forSale, "Property is not for sale");
        require(msg.value >= properties[_id].price, "Insufficient funds sent");
        require(properties[_id].owner == msg.sender, "Only the owner can transfer the property");

        address previousOwner = properties[_id].owner;
        properties[_id].owner = _to;
        properties[_id].forSale = false;
        properties[_id].price = 0;

        payable(previousOwner).transfer(msg.value);
        emit PropertyTransferred(_id, previousOwner, _to);
    }
}

