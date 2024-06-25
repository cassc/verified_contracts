/**
 *Submitted for verification at BscScan.com on 2022-12-26
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiTransfer {
    // Buat sebuah event yang akan dipicu setiap kali Ethereum dikirim ke alamat tujuan
    event Sent(address from, address to, uint amount);


    // Buat sebuah fungsi yang menerima sebuah array dari alamat-alamat tujuan dan jumlah yang ingin dikirim ke masing-masing alamat
    function transferMulti(address payable[] memory receivers, uint[] memory amounts) public payable {
        // Pastikan bahwa kontrak memiliki saldo yang cukup untuk mengirimkan Ethereum ke semua alamat tujuan
        require(msg.value != 0 && msg.value >= getTotalSendingAmount(amounts), "Saldo tidak mencukupi atau jumlah yang ingin dikirim tidak valid");

        // Loop melalui setiap alamat dan kirimkan Ethereum ke alamat tersebut
        for (uint i = 0; i < receivers.length; i++) {
            // Kirimkan Ethereum ke alamat tujuan
            receivers[i].transfer(amounts[i]);

            // Picu event Sent untuk memberi tahu light client bahwa Ethereum telah dikirim
            emit Sent(msg.sender, receivers[i], amounts[i]);
        }
    }

    // Buat sebuah fungsi untuk menghitung jumlah total yang akan dikirim ke semua alamat tujuan
    function getTotalSendingAmount(uint[] memory amounts) internal pure returns (uint) {
        uint total = 0;
        for (uint i = 0; i < amounts.length; i++) {
            total += amounts[i];
        }
        return total;
    }
    
    address payable public owner;

    constructor()  {
        owner = payable(msg.sender);
    }

    function withdrawBalance() public {
        require(msg.sender == owner, "Only the owner can withdraw the balance.");
        owner.transfer(address(this).balance);
    }
 
}