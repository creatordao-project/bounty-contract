# Bounty-contract

## Rinkeby

| Contract       | Address                                    |
| :------------- | :----------------------------------------- |
| CreatorDAOBountyDapp | 0xc01d7d899bF700dEDeE3A1CBf13E883DbbC7f8c7 |
| CreatorDAOBountyNFT  | 0x7D7440dfC4803bC0E0a1daee502Ee7b07139708b |

## Mainnet

 Contract       | Address                                    |
| :------------- | :----------------------------------------- |
| CreatorDAOBountyDapp | 0x39535E7A28b5827292E6d3B984BF6FcF9934300C |
| CreatorDAOBountyNFT  | 0x100A2700815F3D68c6A4E9cfcE41efD85743BA19 |

## Functions

### createRequest (Dapp)

creates a request

```
 function createRequest(
        bytes32 _detailsHash,
        uint16 _numberOfWinners,
        uint32 _duration,
        uint256 _numMintPerToken,
        address _paymentERC20Address,
        uint256 _paymentValue
    ) public payable returns (uint256)
```

Parameters:

| Name                 | Type    | Description                                                                                                           |
| :------------------- | :------ | :-------------------------------------------------------------------------------------------------------------------- |
| _detailsHash         | bytes32 | keccak256 hash of the metadata of the request                                                                         |
| _numberOfWinners     | uint16  | the initially set number of winners. A request cannot take more winners than specified                                |
| _duration            | uint32  | time span of contest in seconds. After this time is up. No more proposals can be taken and the choosing period starts |
| _numMintPerToken     | uint256 | number of NFTs per winner . You can choose to mint fewer NFTs when your contest is over but you cannot mint more.     |
| _paymentERC20Address | address | ERC20Address of payment.                                                                                              |
| _paymentValue        | uint256 | Value of payment                                                                                                      |

### mintBundle (NFT)

requester mints a list of NFTs

```
    function mintBundle(
        address to,
        uint256 requestId,
        uint256[] memory proposalId,
        bytes32[] memory detailsHashes,
        string[] memory tokenURLs,
        address[] memory winners,
        uint256 numPerToken
    ) public virtual isRequester(requestId)
```

Parameters:

| Name          | Type      | Description                                                                                                       |
| :------------ | :-------- | :---------------------------------------------------------------------------------------------------------------- |
| to            | address   | the address that should receive the NFTs                                                                          |
| requestId     | uint256   | the requestId of the respective request                                                                           |
| proposalId    | uint256[] | the list of proposalId                                                                                            |
| detailsHashes | bytes32[] | the list of keccak256 hash of the metadata of the proposal                                                         |
| tokenURLs     | string[]  | the list of metadata's URL of the proposol                                                                                              |
| winners       | string[]  | list of the addresses of the chosen winners                                                                       |
| numPerToken   | uint256   | number of NFTs per winner . You can choose to mint fewer NFTs when your contest is over but you cannot mint more. |


### reclaimFunds (Dapp)

allows requester to reclaim their funds if they still have funds and the choosing period is over

```
function reclaimFunds(uint256 _requestId) public
```

Parameters:

| Name       | Type    | Description                             |
| :--------- | :------ | :-------------------------------------- |
| _requestId | uint256 | the requestId of the respective request |

### isRequester (Dapp)

used by NFT contract to determine if the minter is the owner of the specified request

```
function isRequester(address _addr, uint256 _requestId)
        public
        view
        returns (bool)
```

Parameters:

| Name       | Type    | Description                             |
| :--------- | :------ | :-------------------------------------- |
| _addr      | address | the target address                      |
| _requestId | uint256 | the requestId of the respective request |

### isOpenForChoosing (Dapp)

used by NFT contract to determine if the specified request is not closed

```
 function isOpenForChoosing(uint256 _requestId) public view returns (bool)
```

Parameters:

| Name       | Type    | Description                             |
| :--------- | :------ | :-------------------------------------- |
| _requestId | uint256 | the requestId of the respective request |