pragma solidity ^0.8.15;

// SPDX-License-Identifier: GPL-3.0

contract manuContract {
    // address dari contract owner
    address currOwner;

    struct product {
        address manufacturerAddress;
        address ownerAddress;
        string productID;
        string productName;
        string productBatchNumber;
        string productProductionDate;
        string productShipmentBatch;
        string productShipmentDate;
        string productDateReceived;
        string productReceiverID;
        string manufacturerName;
    }

    struct seller {
        string[] ownedProductID;
        string[] ownedProductName;
        string sellerID;
        address sellerAddress;
    }

    struct consumer {
        string consumerID;
        address consumerAddress;
    }

    mapping (string => product) productArray;
    mapping (string => seller) sellerArray;
    mapping (string => consumer) consumerArray;

    constructor () {
        currOwner = msg.sender;
    }

    // abc, spatu abc, 1, 22-10-2021, 1, 24-10-2021, 25-10-2021, rar, manu1

    // create the traceable product 
    function createProduct (string memory productID, string memory productName, string memory productBatchNumber, string memory productProductionDate, string memory productShipmentBatch, string memory productShipmentDate, string memory productDateReceived, string memory productReceiverID, string memory manufacturerName) public returns (int){
        product memory newProd;

        newProd.manufacturerAddress = msg.sender;
        newProd.ownerAddress = msg.sender;
        newProd.productID = productID;
        newProd.productName = productName;
        newProd.productBatchNumber = productBatchNumber;
        newProd.productProductionDate = productProductionDate;
        newProd.productShipmentBatch = productShipmentBatch;
        newProd.productShipmentDate = productShipmentDate;
        newProd.productDateReceived = productDateReceived;
        newProd.productReceiverID = productReceiverID;
        newProd.manufacturerName = manufacturerName;
        productArray[productID] = newProd;

        return 0;
    }

    // rar, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    function createSeller (string memory sellerID, address sellerAddress) public payable returns (int) {
        seller memory newSeller;

        newSeller.sellerAddress = sellerAddress;
        newSeller.sellerID = sellerID;
        sellerArray[sellerID] = newSeller;

        return 0;
    }

    // zip,  0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    function createConsumer (string memory consumerID, address consumerAddress) public payable returns (int) {
        consumer memory newConsumer;

        newConsumer.consumerID = consumerID;
        newConsumer.consumerAddress = consumerAddress;
        consumerArray[consumerID] = newConsumer;

        return 0;
    }

    // trf ownership dari manu ke seller 
    function manuToSeller (string memory productID, string memory sellerID) public payable returns (int) {
        return 0;
    }

    // trf ownership dari seller ke seller lain
    function sellerToSeller () public payable returns (int){
        return 0;
    }

    // trf ownership dari seller ke customer
    function sellerToConsumer () public payable returns (int) {
        return 0;
    }

    // untuk cari manufacturer
    // abc
    function findManufacturer (string memory productID) public view returns (address, string memory) {
        return (productArray[productID].manufacturerAddress, string.concat("Product Manufacturer Name : ", productArray[productID].manufacturerName));
    }

    // buat customer cari info tentang barang (verify)
    // abc
    function findProductInfo (string memory productID) public view returns (string memory,  string memory,  string memory,  string memory, string memory) {
        return (string.concat("Product Name : ", productArray[productID].productName), string.concat("Product Batch Number : ", productArray[productID].productBatchNumber), string.concat("Product Production Batch : ", productArray[productID].productProductionDate), string.concat("Product Shipment Batch : ", productArray[productID].productShipmentBatch), string.concat("Product Shipment Date : ", productArray[productID].productShipmentDate));
    }

    // buat customer cari seller Address (kalo dikasih IDnya seller)
    // rar
    function findSellerAddress (string memory sellerID) public view returns (address) {
        return sellerArray[sellerID].sellerAddress;
    }

    // customer verify apakah seller punya productnya
    function itemInSeller (string memory productID, string memory sellerID) public view returns (int) {
        return 0;
    }
}

