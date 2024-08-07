// contracts/Token.sol
// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

import {ERC20} from "solmate/tokens/ERC20.sol";

// :.                                                             
//                                     .#+=-..                                                         
//                                      +..-==:.                                                       
//                                      --   :==-:.                                                    
//                                      .+     .-==-.                                                  
//                                       =:       .=+:                                                 
//                                       :+         .+=.                                               
//                                        +:          -+-.                                             
//                                        :+        ...:=+:                                            
//                                         +    ..:-====-=#-                                           
//                                         +..:-===-:...:-=*:                                          
//                                         -=+=-::..       .+                                          
//                                          :*:=+==-        =:                                         
//                                           =----:.        :+                                         
//                                           +:+%%#=         +                                         
//                                          :+ -**+:    .    +                                         
//                                         .+:   .     :=-   +                                         
//                                         ==          ++*:  +                                         
//                                        -= .         =+#- .+                                         
//                                       .+ .=:      ::.=*= -=                                         
//                                       -=.:==      .+:-=: *:                                         
//                                       :==++        =- = -#-                                         
//                                        .=++..      :+ -.=-=                                         
//           .                             +=--=     .-= +...+                                         
//         .---:.. ..                      =*===    :==  +:  +                                         
//         =+--==----:.    .....           .*=.     -:  .+.  +                                         
//         *+--:---:-==:::--===--..        .*:        .:=-   +.                       ::   .           
//        :+*++=-     :+==-:...:=+--::.   .=-      ..:==-    =:                      -=+. :-.          
//        +-  ..                 ---===-. -=     .:+==: ..   =:                    :.+.+:-=-=          
//        ==--==.                     :==:-=....:==*.   =-   =:                   :+++ +:+ :=          
//        .*#+:..:.                     :+:-=-==+:.*:  .+.   =-..                 =-*+.+--.+.          
//        -+:  :===                .:..  :+.-=+=---*+ :=- .:-++--:.               --+*:+-===   .       
//        *-::-=:-*..:      :.     :---:  =+=----:-#+ =-:-+=-:.::==:.             :=-*:-+=:= .--.      
//        -====:-=-.++-:::::*-.       :=: .=.   .:+#. --=+%.      :==:            .+.=. -- + -=-=      
//          .  -=. -=.=========:       .=      .-=+=.-=-.=*:        -=:            -=      * +: +      
//            .*  .+.   .    .-+.       -     .==.*:-=. :#-.         :=-.           +:    .*:+. +      
//            :+::==           -+.            ==  *=-  :**            .==.          ==     -=-.-=      
//             ===-             -=:           *   :.   **-              ==         -=-    .:::-=.      
//                               -=-:        .+        *-                +:      .-=.    :==---.       
//                                .==:.      :+        -=.               .+.    .-=      +-.           
//                                  :==-     -=         -=.

contract TRT is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        address receiver,
        uint256 initialSupply
    ) ERC20(name, symbol, 18) {
        _mint(receiver, initialSupply);
    }
}