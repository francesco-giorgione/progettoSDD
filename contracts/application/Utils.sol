// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;


library Utils {
    function compareStrings(string memory firstString, string memory secondString) internal pure returns (bool) {
      return keccak256(bytes(firstString)) == keccak256(bytes(secondString));
    }

    function findString(string[] memory array,string memory _string) internal pure returns (bool) {
    for (uint i = 0; i < array.length; i++) { 
        string memory stringToFind = array[i]; 
        bool exists = compareStrings(stringToFind, _string);

        if(exists == true) {
            return true;
        }   
    }
        return false;
    }

    function compareStringArrays(string[] memory array1, string[] memory array2) internal pure returns (bool) {
        if(array1.length != array2.length) {
            return false;
        }

        for(uint i = 0; i < array1.length; i++) {
            if(!compareStrings(array1[i], array2[i])) {
                return false;
            }
        }

        return true;
    }

    // Funzione per convertire libbre in grammi
    function libbreToGrammi(uint256 libbre) public pure returns (uint256) {
        // Una libbra è circa 453,59237 grammi
        uint256 grammi = libbre * 45359237;

        return grammi;
    }


    // Funzione per convertire grammi in libbre
    function grammiToLibbre(uint256 grammi) public pure returns (uint256) {
        // Un pound è circa 453,59237 grammi
        uint256 libbre = grammi / 45359237;

        return libbre;
    }
}