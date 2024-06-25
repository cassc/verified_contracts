/**
 *Submitted for verification at BscScan.com on 2023-01-05
*/

interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface IERC721  {
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}

contract Test{

    uint256 public res;
    IERC20 public usdc = IERC20(0x779497A66fc99f5aB2c9218c542C3540c0eA7e9A);

    mapping (bytes => bool) public executed;

	event Go();

    function badHigh (address token, uint amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        res += amount;
    }

    function bad2High (address token, uint amount) public  {
        (bool success, bytes memory result) = token.call(
            abi.encodeWithSelector(0x23b872dd, msg.sender, address(this), amount)
        );
        if (success) {
            res += amount;
        }
    }

    function bad3High (bytes calldata offerData) public {
        require(!executed[offerData], "already executed");

        (
        address _token, 
        uint256 _tokenId, 
        address _buyer, 
        uint256 _price
        ) = abi.decode(offerData, (address, uint, address, uint));   

        IERC721(_token).safeTransferFrom(msg.sender, _buyer, _tokenId);
        usdc.transferFrom(_buyer, msg.sender, _price);

        executed[offerData] = true;
    }

	function goodInfo (address token, uint amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
    }

	function good2Info (bytes calldata offerData) public {
        require(!executed[offerData], "already executed");

        (
        address _token, 
        uint256 _tokenId, 
        address _buyer, 
        uint256 _price
        ) = abi.decode(offerData, (address, uint, address, uint));         
        usdc.transferFrom(_buyer, msg.sender, _price);
        executed[offerData] = true;

		IERC721(_token).safeTransferFrom(msg.sender, _buyer, _tokenId);
    }

	function badMedium (address token, uint amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        emit Go();
    }

    function bad2Medium (address token, uint amount) public  {
        (bool success, bytes memory result) = token.call(
            abi.encodeWithSelector(0x23b872dd, msg.sender, address(this), amount)
        );
        if (success) {
            emit Go();
        }
    }

    function bad3Medium (bytes calldata offerData) public {
        require(!executed[offerData], "already executed");
        executed[offerData] = true;

        (
        address _token, 
        uint256 _tokenId, 
        address _buyer, 
        uint256 _price
        ) = abi.decode(offerData, (address, uint, address, uint));   

        usdc.transferFrom(_buyer, msg.sender, _price);

		IERC721(_token).safeTransferFrom(msg.sender, _buyer, _tokenId);
		emit Go();
    }



}