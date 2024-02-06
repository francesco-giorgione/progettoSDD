// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;
import "./Utils.sol";
import "./acquistoMilkhub.sol";


// manca id milkhub, id producer e in generale gestione delle identità
contract ScambioMilkhubProducer {

    struct PartitaLatte {
        uint id;
        string[] tipoTrasformazione;
        uint dataScadenza;                   
        uint temperaturaConservazione;
        uint quantita;                          // in litri
        uint dataAcquisto;
        uint[] idSilosUsati;
    }

    uint private lastPartitaLatteId;
    string[] private trasformazioniRichieste = ["Separazione della crema per l'ottenimento di una miscela parzialmente scremata",
                "Aggiunta di siero contenente batteri acidi per 10-12 minuti a temperatura di 33-35 gradi",
                "Aggiunta di caglio di vitello e riposo per 10-12 minuti a temperatura di 33-35 gradi",
                "Rottura della cagliata in piccoli pezzi per 10-12 minuti a temperatura di 55 gradi"];

    mapping(uint => PartitaLatte) private allPartiteLatte;
    address public acquistoMilkhubAddress;

    event MessaInVenditaPartitaLatte(PartitaLatte);
    event AcquistoPartitaLatte(PartitaLatte);


    constructor(address _acquistoMilkhubAddress) {
        lastPartitaLatteId = 0;
        acquistoMilkhubAddress = _acquistoMilkhubAddress;
    }

    function mettiInVenditaPartitaLatte(string[] memory _tipoTrasformazione, uint _dataScadenza, uint _temperaturaConservazione, uint _quantita,
                                            uint[] memory _idSilosUsati) public {
        
        checkDati(_dataScadenza, _tipoTrasformazione, _temperaturaConservazione, _idSilosUsati, _quantita);
        uint _id = getId();

        PartitaLatte memory daVendere = PartitaLatte({
            id:                             _id,
            tipoTrasformazione:             _tipoTrasformazione,
            dataScadenza:                   _dataScadenza,
            temperaturaConservazione:       _temperaturaConservazione,
            quantita:                       _quantita,
            dataAcquisto:                   0,
            idSilosUsati:                   _idSilosUsati
        });

        allPartiteLatte[_id] = daVendere;
        emit MessaInVenditaPartitaLatte(daVendere);
    }

    function acquistaPartitaLatte(uint id) public {
        PartitaLatte memory daAcquistare = allPartiteLatte[id];

        // Se i campi di daAcquistare contengono i valori di default, significa che non esiste una partita di latte associata all'id. Il controllo viene eseguito sul
        // campo quantità, ma può essere eseguito anche su altri campi
        require(daAcquistare.quantita > 0, "Partita di latte non trovata: operazione rifiutata");

        require(daAcquistare.dataAcquisto == 0, "La partita di latte e' gia' stata venduta: operazione rifiutata");                               

        daAcquistare.dataAcquisto = block.timestamp;
        allPartiteLatte[id] = daAcquistare;
        emit AcquistoPartitaLatte(daAcquistare);
    }

    function checkDati(uint dataScadenza, string[] memory tipoTrasformazione, uint temperaturaConservazione, uint[] memory idSilosUsati, uint quantita) private view {
        require(dataScadenza > block.timestamp, "La data di scadenza deve essere successiva a quella attuale");
        checkDisciplinare(tipoTrasformazione, temperaturaConservazione);
        
        AcquistoMilkhub acquistoMilkhub = AcquistoMilkhub(acquistoMilkhubAddress);

        for(uint i=0; i < idSilosUsati.length; i++) {
            AcquistoMilkhub.Silos memory tmp = acquistoMilkhub.getById(idSilosUsati[i]);
            require(tmp.quantita > 0, "Almeno uno dei silos usati non esiste: operazione rifiutata");
            require(block.timestamp < tmp.dataScadenza, "Si sta tentando di usare un silos scaduto: operazione rifiutata");
        }
    }

    function checkDisciplinare(string[] memory tipoTrasformazione, uint temperaturaConservazione) private view {
        require(temperaturaConservazione >= 18, "Temperatura di conservazione non lecita: registrazione rifiutata");
        require(tipoTrasformazione.length == trasformazioniRichieste.length, "Tipo di trasformazione non lecita: registrazione rifiutata, err 1");
        require(Utils.compareStringArrays(tipoTrasformazione, trasformazioniRichieste), "Tipo di trasformazione non lecita: registrazione rifiutata, err 2");
    }

    function getId() private returns(uint) {
        lastPartitaLatteId += 1;
        return lastPartitaLatteId;
    }

    function getById(uint id) public view returns(PartitaLatte memory) {
        return allPartiteLatte[id];
    }
}