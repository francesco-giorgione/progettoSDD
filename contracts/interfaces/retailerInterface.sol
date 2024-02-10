// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

import "./appInterfaces.sol";

contract RetailerInterface {
    
    address public scambioProducerRetailerAddress;
    address public scambioRetailerConsumerAddress;

    constructor(address _scambioProducerRetailerAddress, address _scambioRetailerConsumerAddress) {
        scambioProducerRetailerAddress = _scambioProducerRetailerAddress;
        scambioRetailerConsumerAddress = _scambioRetailerConsumerAddress;
    }

    function acquistaFormaggio(string memory user, uint id) public {
        // require(isRetailer(user), "Operazione non consentita ai retailer: transazione rifiutata");
        ScambioProducerRetailer scambioProducerRetailer = ScambioProducerRetailer(scambioProducerRetailerAddress);
        scambioProducerRetailer.acquistaFormaggio(id);
    }

    function mettiInVenditaPezzoFormaggio(string memory user, uint quantita, uint idFormaggioUsato) public {
        // require(isRetailer(user), "Operazione non consentita ai retailer: transazione rifiutata");
        ScambioRetailerConsumer scambioRetailerConsumer = ScambioRetailerConsumer(scambioRetailerConsumerAddress);
        scambioRetailerConsumer.mettiInVenditaPezzoFormaggio(quantita, idFormaggioUsato, user);
    }
}