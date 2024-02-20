// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

contract GestioneUtenti {

    enum Ruolo { Null, Milkhub, Producer, Retailer, Consumer }

    struct Utente {
        string username;
        string PIVA;
        string ragioneSociale;
        string sede;
        Ruolo ruolo;
    }

    Utente milkhub1;
    Utente milkhub2;
    Utente milkhub3;

    Utente producer1;
    Utente producer2;
    Utente producer3;

    Utente retailer1;
    Utente retailer2;
    Utente retailer3;

    mapping(string => Utente) private utenti;

    constructor() {
        popolaUtenti();
    }

    function popolaUtenti() private {
        //definizione statica di un set di utenti milkhub

        milkhub1 = Utente({
            username : "milkhub1",
            PIVA : "55194110072",
            ragioneSociale : "Rossi Milkhub spa",
            sede : "Via Roma 31, Milano",
            ruolo : Ruolo.Milkhub
        });
        utenti["milkhub1"] = milkhub1;

        milkhub2 = Utente({
            username : "milkhub2",
            PIVA : "13828510803",
            ragioneSociale : "Verdi Milkhub srl",
            sede : "Piazza Plebiscito, Napoli",
            ruolo : Ruolo.Milkhub
        });
        utenti["milkhub2"] = milkhub2;

         milkhub3 = Utente({
            username : "milkhub3",
            PIVA : "15465950176",
            ragioneSociale : "Neri Milkhub spa",
            sede : "Piazza della Concordia, Salerno",
            ruolo : Ruolo.Milkhub
        });
        utenti["milkhub3"] = milkhub3;


        //definizione statica di un set di utenti producer

        producer1 = Utente({
            username : "producer1",
            PIVA : "22092130362",
            ragioneSociale : "Gatti Producer srl",
            sede : "Via Roma, Modena",
            ruolo : Ruolo.Producer
        });
        utenti["producer1"] = producer1;

        producer2 = Utente({
            username : "producer2",
            PIVA : "69784221009",
            ragioneSociale : "Cani Producer snc",
            sede : "Via dei Fori Imperiali, Roma",
            ruolo : Ruolo.Producer
        });
        utenti["producer2"] = producer2;

        producer3 = Utente({
            username : "producer3",
            PIVA : "64135140396",
            ragioneSociale : "Tigri Producer spa",
            sede : "Via Condotti, Roma",
            ruolo : Ruolo.Producer
        });
        utenti["producer3"] = producer3;


        //definizione statica di un set di utenti retailer

        retailer1 = Utente({
            username : "retailer1",
            PIVA : "64532390826",
            ragioneSociale : "Fabiano Retailer srl",
            sede : "Via Toledo, Napoli",
            ruolo : Ruolo.Retailer
        });
        utenti["retailer1"] = retailer1;

        retailer2 = Utente({
            username : "retailer2",
            PIVA : "42366330944",
            ragioneSociale : "De Rossi Retailer snc",
            sede : "Piazza Malta, Napoli",
            ruolo : Ruolo.Retailer
        });
        utenti["retailer2"] = retailer2;

        retailer3 = Utente({
            username : "retailer3",
            PIVA : "19034251207",
            ragioneSociale : "Santoso Retailer srl",
            sede : "Via Toledo, Napoli",
            ruolo : Ruolo.Retailer
        });
        utenti["retailer3"] = retailer3;
    }

    function getUtenteByUsername(string memory username) public view returns (Utente memory) {
        Utente memory tmp = utenti[username];
        require(tmp.ruolo != Ruolo.Null, "Utente non trovato");
        return tmp;
    }

    function isMilkhub(string memory username) public view returns (bool) {
        
        Utente memory utente = utenti[username];
        
        return utente.ruolo == Ruolo.Milkhub;
    }
    
        function isProducer(string memory username) public view returns (bool) {
        
        Utente memory utente = utenti[username];
        
        return utente.ruolo == Ruolo.Producer;
    }

        function isRetailer(string memory username) public view returns (bool) {
        
        Utente memory utente = utenti[username];
        
        return utente.ruolo == Ruolo.Retailer;
    }

        function isConsumer(string memory username) public view returns (bool) {
        
        Utente memory utente = utenti[username];
        
        return utente.ruolo == Ruolo.Consumer;
    }

}