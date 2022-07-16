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
        string[] owners;
        bool exists;
    }

    struct seller {
        string[] ownedProductID;
        string[] ownedProductName;
        string sellerID;
        address sellerAddress;
        bool exists;
    }

    struct consumer {
        string consumerID;
        address consumerAddress;
        bool exists;
    }

    mapping (string => product)  productArray;
    mapping (string => seller)  sellerArray;
    mapping (string => consumer)  consumerArray;

    constructor () {
        currOwner = msg.sender;
    }

    // abc, spatu abc, 1, 22-10-2021, 1, 24-10-2021, 25-10-2021, rar, manu1
    // create the traceable product 
    function createProduct (string memory productID, string memory productName, string memory productBatchNumber, string memory productProductionDate, string memory productShipmentBatch, string memory productShipmentDate, string memory productDateReceived, string memory productReceiverID, string memory manufacturerName) public returns (string memory){
        // check if product with the same productID exists 
        if (productArray[productID].exists) {
            return "Product With The Same Product ID Exists.";
        }

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
        newProd.exists = true;
        productArray[productID] = newProd;

        return "Product Registration Successful";
    }

    // rar, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    // bor, 0x617F2E2fD72FD9D5503197092aC168c91465E7f2
    function createSeller (string memory sellerID, address sellerAddress) public payable returns (string memory) {
        // check if seller with the same sellerID exists
        if (sellerArray[sellerID].exists) {
            return "Seller With The Same Seller ID Exists.";
        }

        seller memory newSeller;

        newSeller.sellerAddress = sellerAddress;
        newSeller.sellerID = sellerID;
        newSeller.exists = true;
        sellerArray[sellerID] = newSeller;

        return "Seller Registration Successful";
    }

    // zip,  0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    function createConsumer (string memory consumerID, address consumerAddress) public payable returns (string memory) {
        // check if consumer with the same consumerID exists
        if (consumerArray[consumerID].exists) {
            return "Consumer With The Same Consumer ID Exists.";
        }

        consumer memory newConsumer;

        newConsumer.consumerID = consumerID;
        newConsumer.consumerAddress = consumerAddress;
        consumerArray[consumerID] = newConsumer;
        consumerArray[consumerID].exists = true;

        return "Consumer Registration Successful";
    }

    // trf ownership dari manu ke seller 
    // abc, rar
    function manuToSeller (string memory productID, string memory sellerID) public payable returns (string memory) {
        // check if product exists 
        if (!productArray[productID].exists) {
            return "Product Doesn't Exists!";
        }
        // check if seller exists
        if (!sellerArray[sellerID].exists) {
            return "Seller Doesn't Exists!";
        }

        productArray[productID].ownerAddress = sellerArray[sellerID].sellerAddress;
        productArray[productID].owners.push(sellerID);
        sellerArray[sellerID].ownedProductID.push(productID);
        sellerArray[sellerID].ownedProductName.push(productArray[productID].productName);

        return "Transfer from Manufacturer to Seller Successful";
    }

    // trf ownership dari seller ke seller lain
    function sellerToSeller (string memory productID, string memory sellerFrom, string memory sellerTo) public payable returns (string memory){
        if (!productArray[productID].exists) {
            return "Product Doesn't Exists!";
        }

        if (!sellerArray[sellerFrom].exists || !sellerArray[sellerTo].exists) {
            return "Seller Doesn't Exists!";
        }

        bool flag = false;
        for (uint i = 0; i < sellerArray[sellerFrom].ownedProductID.length; i++) {
            string memory  text = sellerArray[sellerFrom].ownedProductID[i];
            if (stringToBytes32(text) == stringToBytes32(productID)) {
                delete sellerArray[sellerFrom].ownedProductID[i];
                flag = true;
            }
        }

        if (flag == false) {
            return "From Seller Doesn't Own The Product";
        }

        productArray[productID].ownerAddress = sellerArray[sellerTo].sellerAddress;
        productArray[productID].owners.push(sellerTo);
        sellerArray[sellerTo].ownedProductID.push(productID);
        sellerArray[sellerTo].ownedProductName.push(productArray[productID].productName);

        return "Transfer from Seller to Seller Successful";
    }

    // trf ownership dari seller ke consumer
    // abc, rar, zip
    function sellerToConsumer (string memory productID, string memory sellerID, string memory consumerID) public payable returns (string memory) {
        if (!productArray[productID].exists) {
            return "Product Doesn't Exists!";
        }

        if (!sellerArray[sellerID].exists) {
            return "Seller Doesn't Exists!";
        }

        if (!consumerArray[consumerID].exists) {
            return "Consumer Doesn't Exists!";
        }

        bool flag = false;
        for (uint i = 0; i < sellerArray[sellerID].ownedProductID.length; i++) {
            string memory  text = sellerArray[sellerID].ownedProductID[i];
            if (stringToBytes32(text) == stringToBytes32(productID)) {
                delete sellerArray[sellerID].ownedProductID[i];
                flag = true;
            }
        }

        if (flag == false) {
            return "Seller Doesn't Own The Product";
        }

        productArray[productID].ownerAddress = consumerArray[consumerID].consumerAddress;
        productArray[productID].owners.push(consumerID);

        return "Transfer from Seller to Consumer Successful";
    }

    // untuk cari manufacturer
    // abc
    function findManufacturer (string memory productID) public view returns (address, string memory) {
        // check if product exists
        if (!productArray[productID].exists) {
            return (productArray[productID].manufacturerAddress , "Product Doesn't Exists!");
        }

        return (productArray[productID].manufacturerAddress, string.concat("Product Manufacturer Name : ", productArray[productID].manufacturerName));
    }

    // buat consumer cari info tentang barang 
    // abc
    function findProductInfo (string memory productID) public view returns (string memory,  string memory,  string memory,  string memory, string memory) {
        // check if product exists
        if (!productArray[productID].exists) {
            return ("This Product Doesn't Exists", "This Product Doesn't Exists", "This Product Doesn't Exists", "This Product Doesn't Exists", "This Product Doesn't Exists");
        }
        return (string.concat("Product Name : ", productArray[productID].productName), string.concat("Product Batch Number : ", productArray[productID].productBatchNumber), string.concat("Product Production Batch : ", productArray[productID].productProductionDate), string.concat("Product Shipment Batch : ", productArray[productID].productShipmentBatch), string.concat("Product Shipment Date : ", productArray[productID].productShipmentDate));
    }

    // buat consumer cari seller Address (kalo dikasih IDnya seller)
    // rar
    function findSellerAddress (string memory sellerID) public view returns (address, string memory) {
        // check if seller exists
        if (!sellerArray[sellerID].exists) {
            return (sellerArray[sellerID].sellerAddress, "This Seller doesn't Exists");
        }

        return (sellerArray[sellerID].sellerAddress, "This Seller is Verified");
    }

    // check history dari owners product tsb
    // abc
    function viewHistory (string memory productID) public view returns (string[] memory) {
        if (!productArray[productID].exists) {
            string[] memory asd;
            asd[0] = "This Product Doesn't Exists";
            return asd;
        }

        return productArray[productID].owners;
    }

    // consumer verify apakah seller punya productnya
    // abc, rar
    function itemInSeller (string memory productID, string  memory sellerID, address sellerAddress) public view returns (string memory) {
        // check product exists
        if (!productArray[productID].exists) {
            return "The Product Doesn't Exists!";
        }
        // check seller exists
        if (!sellerArray[sellerID].exists) {
            return "This Seller Doesn't Exists!";
        }

        for (uint i = 0; i < sellerArray[sellerID].ownedProductID.length; i++) {
            string memory  text = sellerArray[sellerID].ownedProductID[i];
            if (sellerAddress == productArray[text].ownerAddress) {
                return "This Seller Owns The Product";
            }
        }

        return "This Seller Does Not Own The Product";
    }

    // change from string memory to byte 32 so bisa pake '=='
    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }   
    }    

}

