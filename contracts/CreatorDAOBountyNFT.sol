// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./CreatorDAOBountyDapp.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract CreatorDAOBountyNFT is
    Initializable,
    ContextUpgradeable,
    ERC721EnumerableUpgradeable,
    ERC721BurnableUpgradeable,
    ERC721PausableUpgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private _tokenIdTracker;

    // mapping tokenId to token URIs
    mapping(uint256 => string) private _tokenURIs;
    // mapping tokenId to a hash of the metadata
    mapping(uint256 => bytes32) public _detailsHash;
    // mapping tokenId to the creator of the data
    mapping(uint256 => address) public _proposer;

    string public _baseTokenURI;

    address private admin;

    address public dappContractAddress;

    modifier isDappContract() {
        require(
            _msgSender() == dappContractAddress,
            "Only CreatorDAOBounty Dapp Contract has permission to call this function"
        );
        _;
    }

    modifier isAdmin() {
        require(
            msg.sender == admin,
            "Only Admin has permission to call this function"
        );
        _;
    }

    modifier isRequester(uint256 requestId) {
        CreatorDAOBountyDapp _dapp = CreatorDAOBountyDapp(dappContractAddress);
        require(_dapp.isRequester(_msgSender(), requestId));
        _;
    }

    function initialize(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) public {
        __CreatorDAOBountyNFT_init(name, symbol);
        admin = _msgSender();

        _baseTokenURI = baseTokenURI;
    }

    function __CreatorDAOBountyNFT_init(
        string memory name,
        string memory symbol
    ) internal initializer {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __ERC721_init_unchained(name, symbol);
        __ERC721Enumerable_init_unchained();
        __ERC721Burnable_init_unchained();
        __Pausable_init_unchained();
        __ERC721Pausable_init_unchained();
    }

    function __CreatorDAOBountyNFT_init_unchained(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) internal initializer {}

    function setDappContractAddress(address nftAddress) public isAdmin {
        dappContractAddress = nftAddress;
    }

    /*
     * @dev mints a list of NFTs
     * @param to => the address that should receive the NFTs
     * @param proposalId => the list of proposalId
     * @param detailsHashes => the list of keccak256 hash of the metadata of the request
     * @param tokenURLs => the list of tokenURLs
     * @param winners => list of the addresses of the chosen winners
     * @param numPerToken => number of NFTs per winner . You can choose to mint fewer NFTs when your contest is over but you cannot mint more.
     */
    function mintBundle(
        address to,
        uint256 requestId,
        uint256[] memory proposalId,
        bytes32[] memory detailsHashes,
        string[] memory tokenURLs,
        address[] memory winners,
        uint256 numPerToken
    ) public virtual isRequester(requestId) {
        CreatorDAOBountyDapp _dapp = CreatorDAOBountyDapp(dappContractAddress);
        require(_dapp.isOpenForChoosing(requestId));
        require(tokenURLs.length > 0, "No tokenURLs detected");
        require(
            detailsHashes.length == tokenURLs.length,
            "TokenURLs length does not equal that of detailHashes"
        );

        uint256[] memory tokenIds = new uint256[](winners.length * numPerToken);
        // We cannot just use balanceOf to create the new tokenId because tokens
        // can be burned (destroyed), so we need a separate counter.
        uint8 id = 0;
        for (uint8 i = 0; i < winners.length; i++) {
            for (uint8 j = 0; j < numPerToken; j++) {
                _mint(to, _tokenIdTracker.current());
                _tokenURIs[_tokenIdTracker._value] = tokenURLs[i];
                _detailsHash[_tokenIdTracker._value] = detailsHashes[i];
                _proposer[_tokenIdTracker._value] = winners[i];
                tokenIds[id] = _tokenIdTracker._value;
                _tokenIdTracker.increment();
                id++;
            }
        }
        _dapp.acceptProposals(
            to,
            requestId,
            proposalId,
            tokenIds,
            tokenURLs,
            winners,
            numPerToken
        );
    }

    function setTokenURI(uint256[] memory tokenIds, string[] memory tokenURIs)
        external
        isAdmin
    {
        require(tokenIds.length > 0, "no tokens provided");
        require(
            tokenIds.length == tokenURIs.length,
            "tokenIds and tokenURIs do not have the same number of items"
        );
        for (uint i = 0; i < tokenIds.length; i++) {
            if (_exists(tokenIds[i])) {
                _tokenURIs[tokenIds[i]] = tokenURIs[i];
            }
        }
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI query for nonexistent token"
        );

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseTokenURI;

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )
        internal
        virtual
        override(
            ERC721Upgradeable,
            ERC721EnumerableUpgradeable,
            ERC721PausableUpgradeable
        )
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
    @dev used to set new admin
    */
    function setAdmin(address newAdmin) external isAdmin {
        CreatorDAOBountyDapp _dapp = CreatorDAOBountyDapp(dappContractAddress);
        admin = newAdmin;
        _dapp.setAdmin(newAdmin);
    }

    function setBaseTokenURI(string memory newBase) external isAdmin {
        _baseTokenURI = newBase;
    }
}
