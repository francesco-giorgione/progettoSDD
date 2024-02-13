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
        string venditore;
    }

    uint private lastPezzoFormaggioId;
    mapping(uint => PezzoFormaggio) public allPezziFormaggio;
    address private scambioProducerRetailerAddress;
    address private retailerInterfaceAddress;
    address private nodoAdminAddress;

    constructor(address _scambioProducerRetailerAddress, address _nodoAdminAddress) {
        scambioProducerRetailerAddress = _scambioProducerRetailerAddress;
        nodoAdminAddress = _nodoAdminAddress; 
    }

    event MessaInVenditaPezzoFormaggio(PezzoFormaggio);

    function mettiInVenditaPezzoFormaggio(uint _quantita, uint _idFormaggioUsato, string memory user) public {

        // Check sul chiamante
        require(msg.sender == retailerInterfaceAddress , "Operazione non autorizzata: transazione rifiutata");
        
        uint _id = getId();

        PezzoFormaggio memory daVendere = PezzoFormaggio({
            id:                 _id,
            quantita:           _quantita,
            dataAcquisto:       0,
            idFormaggioUsato:   _idFormaggioUsato,
            venditore:          user
        });
       
        allPezziFormaggio[_id] = daVendere;
        checkDati(_quantita, _idFormaggioUsato, user);
        emit MessaInVenditaPezzoFormaggio(daVendere);
    }

    function getId() private returns(uint) {
        lastPezzoFormaggioId += 1;
        return lastPezzoFormaggioId;
    }

    function getById(uint id) public view returns(PezzoFormaggio memory) {
        return allPezziFormaggio[id];
    }

    function checkDati(uint quantita, uint idFormaggioUsato, string memory user) private view {

        ScambioProducerRetailer scambioProducerRetailer = ScambioProducerRetailer(scambioProducerRetailerAddress);
        ScambioProducerRetailer.Formaggio memory tmp = scambioProducerRetailer.getById(idFormaggioUsato);
        require(tmp.peso > 0, "Il formaggio usato non esiste: operazione rifiutata");
        require(Utils.compareStrings(tmp.compratore, user), "Il formaggio indicato non appartiene al retailer: operazione rifiutata");
        require(block.timestamp < tmp.dataScadenza, "Si sta tentando di mettere in vendita un pezzo di un formaggio scaduto: operazione rifiutata");

        /*uint qtaRimanenteGrammi = Utils.grammiToLibbre(tmp.qtaRimanente);
        require(qtaRimanenteGrammi >= quantita, "Si sta tentando di acquistare una quantita' maggiore di quella disponibile: operazione rifiutata");
        scambioProducerRetailer.aggiornaQtaRimanente(idFormaggioUsato, quantita);*/
    }

    function setRetailerInterfaceAddress(address _retailerInterfaceAddress) public {
        // Check sul chiamante: deve essere il nodo ff admin       
        require(msg.sender == nodoAdminAddress, "Operazione consentita solo al nodo admin: transazione rifiutata");
        
        retailerInterfaceAddress = _retailerInterfaceAddress;
    }
}