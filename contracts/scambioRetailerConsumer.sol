// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;
import "./Utils.sol";


contract ScambioRetailerConsumer {
    struct PezzoFormaggio {
        uint id;
        uint quantita;          // in grammi
        uint dataAcquisto;
        string eventoAcquistoFormaggio;       // id dell'evento riferito al formaggio a cui appartiene il pezzo
    }

    address private idGeneratorLibrary;

    constructor(address _idGeneratorLibrary) {
        idGeneratorLibrary = _idGeneratorLibrary;
    }

    // Dichiarazione evento
    event MessaInVenditaPezzoFormaggio(PezzoFormaggio pezzoFormaggio);    

    // Contiene l'emissione dell'evento di messa in vendita
    function mettiInVenditaPezzoFormaggio(uint _quantita, string memory _eventoAcquistoFormaggio) public {
        
        (bool success, bytes memory data) = idGeneratorLibrary.delegatecall(abi.encodeWithSignature("getPezzoFormaggioId()"));
        require(success, "Delegate call fallita");

        PezzoFormaggio memory pezzoFormaggio = PezzoFormaggio({
            id: abi.decode(data, (uint)),
            quantita: _quantita,
            dataAcquisto: 0,
            eventoAcquistoFormaggio: _eventoAcquistoFormaggio
        });

        emit MessaInVenditaPezzoFormaggio(pezzoFormaggio);
    }

}