// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;
import "./Utils.sol";


contract ScambioRetailerConsumer {
    struct PezzoFormaggio {
        uint id;
        uint quantita;                      // in grammi
        uint dataAcquisto;
        uint idFormaggioUsato;
    }

    uint private lastPezzoFormaggioId;
    mapping(uint => PezzoFormaggio) public allPezziFormaggio;
    address public scambioProducerRetailerAddress;

    constructor(address _scambioProducerRetailerAddress) {
        scambioProducerRetailerAddress = _scambioProducerRetailerAddress;
    }

    event MessaInVenditaPezzoFormaggio(PezzoFormaggio);


    function mettiInVenditaPezzoFormaggio(uint _quantita, uint _idFormaggioUsato) public {

        uint _id = getId();

        PezzoFormaggio memory daVendere = PezzoFormaggio({
            id:                 _id,
            quantita:           _quantita,
            dataAcquisto:       0,
            idFormaggioUsato:   _idFormaggioUsato
        });
       
        allPezziFormaggio[_id] = daVendere;
        emit MessaInVenditaPezzoFormaggio(daVendere);
    }

    function getId() private returns(uint) {
        lastPezzoFormaggioId += 1;
        return lastPezzoFormaggioId;
    }

    function checkDati(uint idFormaggioUsato) private view {
        /* ScambioProducerRetailer scambioProducerRetailer = ScambioProducerRetailer(scambioProducerRetailerAddress);
        Formaggio memory tmp = scambioProducerRetailer.allFormaggi[idFormaggioUsato];
        require(tmp.peso > 0, "Il formaggio usato non esiste: operazione rifiutata"); */
    }
}