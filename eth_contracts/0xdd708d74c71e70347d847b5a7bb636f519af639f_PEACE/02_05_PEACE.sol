// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Oneness Collection
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                                                                               //
//     **         *******   **      ** ********                                                  //
//    /**        **/////** /**     /**/**/////                                                   //
//    /**       **     //**/**     /**/**                                                        //
//    /**      /**      /**//**    ** /*******                                                   //
//    /**      /**      /** //**  **  /**////                                                    //
//    /**      //**     **   //****   /**                                                        //
//    /******** //*******     //**    /********                                                  //
//    ////////   ///////       //     ////////                                                   //
//       ********  *******       **     ********** ** ********** **     ** *******   ********    //
//      **//////**/**////**     ****   /////**/// /**/////**/// /**    /**/**////** /**/////     //
//     **      // /**   /**    **//**      /**    /**    /**    /**    /**/**    /**/**          //
//    /**         /*******    **  //**     /**    /**    /**    /**    /**/**    /**/*******     //
//    /**    *****/**///**   **********    /**    /**    /**    /**    /**/**    /**/**////      //
//    //**  ////**/**  //** /**//////**    /**    /**    /**    /**    /**/**    ** /**          //
//     //******** /**   //**/**     /**    /**    /**    /**    //******* /*******  /********    //
//      ////////  //     // //      //     //     //     //      ///////  ///////   ////////     //
//     ******** *******   ******** ******** *******     *******   ****     ****                  //
//    /**///// /**////** /**///// /**///// /**////**   **/////** /**/**   **/**                  //
//    /**      /**   /** /**      /**      /**    /** **     //**/**//** ** /**                  //
//    /******* /*******  /******* /******* /**    /**/**      /**/** //***  /**                  //
//    /**////  /**///**  /**////  /**////  /**    /**/**      /**/**  //*   /**                  //
//    /**      /**  //** /**      /**      /**    ** //**     ** /**   /    /**                  //
//    /**      /**   //**/********/********/*******   //*******  /**        /**                  //
//    //       //     // //////// //////// ///////     ///////   //         //                   //
//       *******   ****     ** ******** ****     ** ********  ********  ********                 //
//      **/////** /**/**   /**/**///// /**/**   /**/**/////  **//////  **//////                  //
//     **     //**/**//**  /**/**      /**//**  /**/**      /**       /**                        //
//    /**      /**/** //** /**/******* /** //** /**/******* /*********/*********                 //
//    /**      /**/**  //**/**/**////  /**  //**/**/**////  ////////**////////**                 //
//    //**     ** /**   //****/**      /**   //****/**             /**       /**                 //
//     //*******  /**    //***/********/**    //***/******** ********  ********                  //
//      ///////   //      /// //////// //      /// //////// ////////  ////////                   //
//                                                                                               //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////


contract PEACE is ERC721Creator {
    constructor() ERC721Creator("Oneness Collection", "PEACE") {}
}