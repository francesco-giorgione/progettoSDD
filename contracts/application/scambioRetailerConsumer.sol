// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;
import "./Utils.sol";
import "./scambioProducerRetailer.sol";


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
        checkDati(_quantita, _idFormaggioUsato);
        emit MessaInVenditaPezzoFormaggio(daVendere);
    }

    function getId() private returns(uint) {
        lastPezzoFormaggioId += 1;
        return lastPezzoFormaggioId;
    }

    function checkDati(uint quantita, uint idFormaggioUsato) private view {
        ScambioProducerRetailer scambioProducerRetailer = ScambioProducerRetailer(scambioProducerRetailerAddress);
        ScambioProducerRetailer.Formaggio memory tmp = scambioProducerRetailer.getById(idFormaggioUsato);
        require(tmp.peso > 0, "Il formaggio usato non esiste: operazione rifiutata");
        require(block.timestamp < tmp.dataScadenza, "Si sta tentando di mettere in vendita un pezzo di un formaggio scaduto: operazione rifiutata");

        /*uint qtaRimanenteGrammi = Utils.grammiToLibbre(tmp.qtaRimanente);
        require(qtaRimanenteGrammi >= quantita, "Si sta tentando di acquistare una quantita' maggiore di quella disponibile: operazione rifiutata");
        scambioProducerRetailer.aggiornaQtaRimanente(idFormaggioUsato, quantita);*/
    }
}