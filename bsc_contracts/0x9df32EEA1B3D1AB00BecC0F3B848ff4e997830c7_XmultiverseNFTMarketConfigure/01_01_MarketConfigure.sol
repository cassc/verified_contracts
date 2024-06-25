//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract XmultiverseNFTMarketConfigure {


    constructor(address admin) {
        adminer[msg.sender] = 1;
        adminer[admin] = 1;
    }

    event Collect (
        uint256 ctId,
        string ctAddress,
        string ctBanner,
        string ctImage,
        string ctName,
        string ctDetails,
        string ctUrl,
        string nftType,
        string[] ctconf
    );

    struct Collects {
        uint256 ctId;
        string ctAddress;
        string ctBanner;
        string ctImage;
        string ctName;
        string ctDetails;
        string ctUrl;
        // string startTime;
        // string endTime;
        // uint256 ctprice;
        // uint256 ctamount;
        // uint256 weight;
        string nftType;
        string[] ctconf;
    }
    Collects[] public collects; 

    event HotAddress (
       address[]
    );
    address[] public hotAddresses;

    event CollectType (
       string[]
    );
    string[] public collectType;


    function isEqual(string memory a, string memory b) private pure returns (bool) {
        bytes memory aa = bytes(a);
        bytes memory bb = bytes(b);
        // 如果长度不等，直接返回
        if (aa.length != bb.length) return false;
        // 按位比较
        for(uint i = 0; i < aa.length; i ++) {
            if(aa[i] != bb[i]) return false;
        }

        return true;
    }

    function indexOf(address[] memory self, address value) private pure
        returns (uint)
    {
        for (uint i = 0; i < self.length; i++)
            if (self[i] == value) return i;
        return type(uint).max;
    }

    function indexOfStr(string[] memory self, string memory value) private pure
        returns (uint)
    {
        for (uint i = 0; i < self.length; i++)
            if (isEqual(self[i],value)) return i;
        return type(uint).max;
    }

    uint256 Index = 0;
    mapping (address => uint) adminer;

    
    modifier isadminer() {
        require(adminer[msg.sender] == 1, "Caller is not adminer");
        _;
    }
    
    function changeAdminer(address adminerAddr,uint state) public isadminer {
        require(state == 1 || state ==0 ,"state failed");
        adminer[adminerAddr] = state;
    }


    function addCollect(
        string memory ContractAddress,
        string memory Banner,
        string memory Image,
        string memory Name,
        string memory Details,
        string memory Url,
        // string memory StartTime,
        // string memory EndTime,
        // uint256 Price,
        // uint256 Amount,
        // uint256 Weight,
        string memory Type,
        string[] memory Conf
    )  external isadminer returns (uint256) {

        uint findindex = indexOfStr(collectType,Type);
        require(findindex != type(uint).max,"collectionType does not exist");


        Collects memory data = Collects({
            ctId : Index,
            ctAddress : ContractAddress,
            ctBanner : Banner,
            ctImage : Image,
            ctName : Name,
            ctDetails : Details,
            ctUrl : Url,
            nftType: Type,
            ctconf : Conf
        });
        collects.push(data);
        Index++;

        emit Collect(
            data.ctId,
            data.ctAddress,
            data.ctBanner,
            data.ctImage,
            data.ctName,
            data.ctDetails,
            data.ctUrl,
            data.nftType,
            data.ctconf
        );

        return Index;
    }

    function changeCollect(
        uint256 cgId,
        string memory ContractAddress,
        string memory Banner,
        string memory Image,
        string memory Name,
        string memory Details,
        string memory Url,
        // string memory StartTime,
        // string memory EndTime,
        // uint256 Price,
        // uint256 Amount,
        // uint256 Weight,
        string memory Type,
        string[] memory Conf
    )  external isadminer returns (uint256) {
        
        require(collects[cgId].ctId >=0 ,"not found Collect");

        uint findindex = indexOfStr(collectType,Type);
        require(findindex != type(uint).max,"collectionType does not exist");
        
        Collects memory data = Collects({
            ctId : cgId,
            ctAddress : ContractAddress,
            ctBanner : Banner,
            ctImage : Image,
            ctName : Name,
            ctDetails : Details,
            ctUrl : Url,
            nftType: Type,
            ctconf : Conf
        });
        collects[cgId]=data;

        emit Collect(
            data.ctId,
            data.ctAddress,
            data.ctBanner,
            data.ctImage,
            data.ctName,
            data.ctDetails,
            data.ctUrl,
            data.nftType,
            data.ctconf
        );
        return cgId;
    }

    // function removeCollect(
    //     uint256 cgId
    // )  external isadminer returns (uint256) {
        
    //     require(collects[cgId].ctId >=0 ,"not found Collect");

    //     delete collects[cgId];

    //     emit Collect(
    //         collects[cgId].ctId,
    //         collects[cgId].ctAddress,
    //         collects[cgId].ctBanner,
    //         collects[cgId].ctImage,
    //         collects[cgId].ctName,
    //         collects[cgId].ctDetails,
    //         collects[cgId].ctUrl,
    //         collects[cgId].nftType,
    //         collects[cgId].ctconf

    //     );
    //     return cgId;
    // }


    function addHotAddress(address _address) external isadminer {
        uint findindex = indexOf(hotAddresses,_address);
        require(findindex == type(uint).max,"address Already exists");
        hotAddresses.push(_address);

        emit HotAddress(hotAddresses);
    }

    // function removeHotAddress(address _address) external isadminer {
    //     uint findindex = indexOf(hotAddresses,_address);
    //     if (findindex != type(uint).max) {
    //         delete hotAddresses[findindex];
    //     }
    //     emit HotAddress(hotAddresses);
    // }

    function getHotAddresses() public view returns (address[] memory) {
        return hotAddresses;
    }


    function addCollectType(string memory _typerstr) external isadminer {
        uint findindex = indexOfStr(collectType,_typerstr);
        require(findindex == type(uint).max,"collectionType Already exists");
        collectType.push(_typerstr);

        emit CollectType(collectType);
    }

    // function removeCollectType(string memory _typerstr) external isadminer {
    //     uint findindex = indexOfStr(collectType,_typerstr);
    //     if (findindex != type(uint).max) {
    //         delete collectType[findindex];
    //     }
    //     emit CollectType(collectType);
    // }

    function getCollectType() public view returns (string[] memory) {
        return collectType;
    }


}