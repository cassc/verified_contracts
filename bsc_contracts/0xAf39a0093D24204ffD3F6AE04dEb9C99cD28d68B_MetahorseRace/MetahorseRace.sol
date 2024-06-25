/**
 *Submitted for verification at BscScan.com on 2022-10-22
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
interface IERC721 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}



interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address _owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}



library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
       if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}



contract Ownable {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) 
    {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() 
    {
        require(_owner == msg.sender , "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}




contract MetahorseRace is Ownable 
{   

    IERC721 public NFT;
    IBEP20 public token;
    address nftcontractaddress;


    constructor(IERC721 _NFT,IBEP20 _token,address _nftcontractaddress)
    {
       NFT=_NFT;
       token=_token;
       nftcontractaddress =_nftcontractaddress;
    }
    
    address [15] public card_probability;
    uint256[] public tokenstaked;



    uint256 public ids = 0;
    uint256 public startTime=0;
    uint256 public timetoRace = 2 minutes;
    uint256 public pricetime = 10 minutes;
    uint256 public Pricein_token =1;
    uint256 public  ITEMNO = 1000000;
    uint256 public  pkgNo = 2000e18;
    uint256 public firstprize = 10e18;
    uint256 public second_prize = 5e18;
    uint256 public third_prize = 3e18;
    uint256 public rounds=1;


    struct User
    {
        uint256 pkgNotoID;
        uint256 Getreward;
        uint256 perDay;
        uint256 time;
        bool activate;
    }

    mapping(uint256 => uint256) public idcheck;
    mapping(uint256 => bool) public cyclecheck;
    mapping(uint256 => uint256) public winner;
    mapping(uint256=>address[]) public roundedata;
    mapping (address => mapping(uint256 => uint256)) public  itemNo;
    mapping (uint256 => User ) public UserInfo;

    mapping(address => uint256[]) public UserNFTIds;
    mapping(uint256 => bool) public checkID;
    mapping(address => uint256) public CurrentId;


function stakedIds(address add) public view  returns(uint256  [] memory)
{
    uint256 z=0;
    uint256 [] memory  a = new uint256[](UserNFTIds[add].length);

    for(uint256 i=0 ; i< UserNFTIds[add].length ; i++)
    {
        if(checkID[UserNFTIds[add][i]] == true)
        {
            a[z] = UserNFTIds[add][i];
            z++;
        }
        
    }

    return a;
}



    function createBet(uint256 tokenId,address add) external 
    {
        uint256 userid;
       
        
        require( idcheck[tokenId]<=15,"Maximum bet for this id is reached");
        require(uint256(block.timestamp) > startTime+timetoRace , "time end" );
        require(cyclecheck[tokenId]==false,"aleady participate in this round!");
        require(ids <= 14 , "spacefill " );


        if(itemNo[add][tokenId] == 0)
        {
            require(NFT.ownerOf(tokenId)==msg.sender,"you are not owner of this id");
             require(NFT.balanceOf(msg.sender)>0,"You Can't Bet!");
            itemNo[add][tokenId]  = ITEMNO;
            UserInfo[ITEMNO].pkgNotoID = pkgNo;
            UserInfo[ITEMNO].activate = true;
            NFT.transferFrom(msg.sender, address(this), tokenId);
            UserNFTIds[msg.sender].push(tokenId);
            checkID[tokenId] = true;
            ITEMNO++;
        }
        userid = itemNo[add][tokenId];
        CurrentId[msg.sender] = tokenId;

        require(UserInfo[tokenId].Getreward+firstprize <= UserInfo[userid].pkgNotoID , "please boost you NFT " );

        if( block.timestamp  < UserInfo[userid].time + 1 days  )
        {
             require( UserInfo[userid].perDay <= 12, "you play 12 time only  in one day");
            
            UserInfo[userid].perDay+=1;
        }
        else 
        {
            UserInfo[userid].time = block.timestamp ;
            UserInfo[userid].perDay+=1;
        }

        card_probability[ids] = msg.sender ;
        if(startTime == 0)
        {
          startTime = uint256(block.timestamp);
        }
        ids++;
        idcheck[tokenId]+=1;
        cyclecheck[tokenId]=true;
        tokenstaked.push(tokenId);
        
    }

    function getreward(uint256 a,uint256 b, uint256 c ) internal 
    {
        uint256 p = itemNo[nftcontractaddress][a];
        uint256 o = itemNo[nftcontractaddress][b];
        uint256 u = itemNo[nftcontractaddress][c];


        UserInfo[p].Getreward = firstprize;
        UserInfo[o].Getreward =second_prize ;
        UserInfo[u].Getreward = third_prize;

        address x = NFT.ownerOf(a);
        address y = NFT.ownerOf(b);
        address z = NFT.ownerOf(c);


        token.transfer(x, firstprize);
        token.transfer(y, second_prize);
        token.transfer(z, third_prize);


        roundedata[rounds].push(x);
        roundedata[rounds].push(y);
        roundedata[rounds].push(z);
        rounds++;

    }

    function BoostNFT(uint256 _item) public
    {
        UserInfo[_item].pkgNotoID += 1000;
    }
    

    
    function getResult()  external
    {
       if(ids < 14 )
       {
           while(ids <= 14)
           {
               card_probability[ids] = address(this) ;
               ids++;
           }
           
       }

    }

    function withdrawbep20(uint256 _amount ) public onlyOwner{
        token.transfer(msg.sender,_amount);
    }

        function withdrawNFT(address add, uint256 id ) public 
    {  
        NFT.transferFrom(address(this),msg.sender,id);
        itemNo[add][id]  = 0;
        UserInfo[itemNo[add][id]].pkgNotoID = 0;
        UserInfo[itemNo[add][id]].activate = false;
        checkID[UserNFTIds[add][id]] = false;
    }

    function enableForRace(uint256 a,uint256 b, uint256 c) public{
        uint id;
        for(uint i=0;i<tokenstaked.length;i++){
        id=tokenstaked[i];
        cyclecheck[id]=false;
        }
        delete tokenstaked;
        delete card_probability;
        ids=0;
        startTime=0;


        getreward(a,b,c);

    }



}