// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;
import "./Utils.sol";
import "./scambioMilkhubProducer.sol";

// manca id producer, id retailer e in generale gestione delle identità
contract ScambioProducerRetailer {

    struct Formaggio {
        uint id;
        string[] tipoTrasformazione;

        // 1 CERT. 12 MESI --- 2 CERT. 18 MESI --- 3 CERT. 24 MESI --- 4 CERT. 30 MESI
        uint certificatoStagionatura;
        uint dataScadenza;        
        uint altezza;               // in pollici/10
        uint diametro;              // in pollici
        uint peso;                  // in libbre
        uint dataAcquisto;
        uint[] idPartiteLatteUsate;
        uint qtaRimanente;
        string venditore;
        string compratore;
    }

    uint private lastFormaggioId;
    string[] private trasformazioniRichieste = ["Brandizzazione con il logo del consorzio",
                "Conservazione per 6 mesi in aging room a una temperatura di 18-20 gradi",
                "Immersione per 20-25 giorni in acqua salina a temperatura di 16-18 gradi",
                "Conservazione per 2-3 giorni in una ruota d'acciaio a temperatura di 16-18 gradi"];

    mapping(uint => Formaggio) public allFormaggi;
    address private scambioMilkhubProducerAddress;
    address private producerInterfaceAddress;
    address private retailerInterfaceAddress;
    address private nodoAdminAddress;

    event MessaInVenditaFormaggio(Formaggio);
    event AcquistoFormaggio(Formaggio);

    constructor(address _scambioMilkhubProducerAddress, address _nodoAdminAddress) {
        scambioMilkhubProducerAddress = _scambioMilkhubProducerAddress;
        nodoAdminAddress = _nodoAdminAddress; 
    }

    function mettiInVenditaFormaggio(string[] memory _tipoTrasformazione, uint _stagionatura, uint _dataScadenza, uint _altezza, uint _diametro, 
                                        uint _peso, uint[] memory _idPartiteLatteUsate, string memory user) public {
        
        // Check sul chiamante
        require(msg.sender == producerInterfaceAddress, "Operazione non autorizzata: transazione rifiutata");
        
        checkDati(_dataScadenza, _tipoTrasformazione, _stagionatura, _altezza, _diametro, _peso, _idPartiteLatteUsate, user);
        uint _id = getId();

        Formaggio memory daVendere = Formaggio({
            id:                         _id,
            tipoTrasformazione:         _tipoTrasformazione,
            certificatoStagionatura:    getCertificatoStagionatura(_stagionatura),
            dataScadenza:               _dataScadenza,
            altezza:                    _altezza,
            diametro:                   _diametro,
            peso:                       _peso,
            dataAcquisto:               0,
            idPartiteLatteUsate:        _idPartiteLatteUsate,
            qtaRimanente:               _peso,
            venditore:                  user,
            compratore:                 ""
        });

        allFormaggi[_id] = daVendere;
        emit MessaInVenditaFormaggio(daVendere);
    }

    function acquistaFormaggio(uint id, string memory user) public {

        // Check sul chiamante
        require(msg.sender == retailerInterfaceAddress, "Operazione non autorizzata: transazione rifiutata");

        Formaggio memory daAcquistare = allFormaggi[id];

        // Se i campi di daAcquistare contengono i valori di default, significa che non esiste una partita di latte associata all'id. Il controllo viene eseguito sul
        // campo altezza, ma può essere eseguito anche su altri campi
        require(daAcquistare.altezza > 0, "Formaggio non trovato: operazione rifiutata");

        require(daAcquistare.dataAcquisto == 0, "Il formaggio e' gia' stato venduto: operazione rifiutata");  

        daAcquistare.dataAcquisto = block.timestamp;
        daAcquistare.compratore = user;
        allFormaggi[id] = daAcquistare;
        emit AcquistoFormaggio(daAcquistare);
    }

    function checkDisciplinare(string[] memory tipoTrasformazione, uint stagionatura, uint altezza, uint diametro, uint peso) private view {
        require(stagionatura >= 12, "Tempo di stagionatura insufficiente: registrazione rifiutata");
        require(altezza >= 71 && altezza <= 94, "Altezza del formaggio non lecita: registrazione rifiutata");
        require(diametro >= 16 && diametro <= 18, "Diametro del formaggio non lecito: registrazione rifiutata");
        require(peso == 84, "Peso del formaggio non lecito: registrazione rifiutata");
        require(tipoTrasformazione.length == trasformazioniRichieste.length, "Tipo di trasformazione non lecita: registrazione rifiutata");
        require(Utils.compareStringArrays(tipoTrasformazione, trasformazioniRichieste), "Tipo di trasformazione non lecita: registrazione rifiutata");
    }

    function checkDati(uint dataScadenza, string[] memory tipoTrasformazione, uint stagionatura, uint altezza, uint diametro, uint peso, 
                            uint[] memory idPartiteLatteUsate, string memory user) private view {

        require(dataScadenza > block.timestamp, "La data di scadenza deve essere successiva a quella attuale");
        checkDisciplinare(tipoTrasformazione, stagionatura, altezza, diametro, peso);
        
        ScambioMilkhubProducer scambioMilkhubProducer = ScambioMilkhubProducer(scambioMilkhubProducerAddress);
        
        for(uint i=0; i < idPartiteLatteUsate.length; i++) {
            ScambioMilkhubProducer.PartitaLatte memory tmp = scambioMilkhubProducer.getById(idPartiteLatteUsate[i]);
            require(tmp.quantita > 0, "Almeno una delle partite di latte usate non esiste: operazione rifiutata");
            require(Utils.compareStrings(tmp.compratore, user), "Almeno una delle partite di latte indicate non appartiene al produttore: operazione rifiutata");
            require(block.timestamp < tmp.dataScadenza, "Si sta tentando di usare una partita di latte scaduta: operazione rifiutata");
        }
    }

    function getCertificatoStagionatura(uint stagionatura) private pure returns(uint) {
        if(stagionatura < 18)           return 1;       // CERTIFICATO 12 MESI
        if(stagionatura < 24)           return 2;       // CERTIFICATO 18 MESI
        if(stagionatura < 30)           return 3;       // CERTIFICATO 24 MESI
        return 4;                                       // CERTIFICATO 30 MESI
    }

    function getId() private returns(uint) {
        lastFormaggioId += 1;
        return lastFormaggioId;
    }

    function getById(uint id) public view returns (Formaggio memory) {
        return allFormaggi[id];
    }

    function aggiornaQtaRimanente(uint id, uint qtaDaSottrarre) public view {
        Formaggio memory tmp = allFormaggi[id];
        require(tmp.peso > 0, "Id formaggio errato: impossibile continuare");

        tmp.qtaRimanente -= qtaDaSottrarre;
    }

    function setProducerInterfaceAddress(address _producerInterfaceAddress) public {
        // Check sul chiamante: deve essere il nodo ff admin       
        require(msg.sender == nodoAdminAddress, "Operazione consentita solo al nodo admin: transazione rifiutata");
        
        producerInterfaceAddress = _producerInterfaceAddress;
    }

    function setRetailerInterfaceAddress(address _retailerInterfaceAddress) public {
        // Check sul chiamante: deve essere il nodo ff admin       
        require(msg.sender == nodoAdminAddress, "Operazione consentita solo al nodo admin: transazione rifiutata");
        
        retailerInterfaceAddress = _retailerInterfaceAddress;
    }

    function getIdFormaggiByVenditore(string memory user) public view returns(uint[] memory) {
        return getIdFormaggiByUser(true, user);
    }

    function getIdFormaggiByCompratore(string memory user) public view returns(uint[] memory) {
        return getIdFormaggiByUser(false, user);
    }

    function getIdFormaggiByUser(bool byVenditore, string memory user) private view returns(uint[] memory) {
        uint[] memory tmpIdFormaggi = new uint[](lastFormaggioId);

        uint j = 0;
        for(uint i = 1; i <= lastFormaggioId; i++) {
            if(byVenditore && Utils.compareStrings(allFormaggi[i].venditore, user)) {
                tmpIdFormaggi[j] = i;
                j++;
            }
            else if(!byVenditore && Utils.compareStrings(allFormaggi[i].compratore, user)) {
                tmpIdFormaggi[j] = i;
                j++;
            }
        }

        uint[] memory toReturn = new uint[](j);

        for(uint i=0; i < j; i++) {
            toReturn[i] = tmpIdFormaggi[i];
        }
        
        return toReturn;
    }
}