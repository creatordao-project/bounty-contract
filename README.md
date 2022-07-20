# Request-contract

## Functions

### createRequest

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

### acceptProposals

can only be called by the CreaticlesNFT contract. Used to pay winners after the CreaticlesNFT contract mints the winning NFTs

```
  function acceptProposals(
        address _to,
        uint256 _requestId,
        uint256[] memory _proposalId,
        uint256[] memory _tokenIds,
        string[] memory _tokenURLs,
        address[] memory _winners,
        uint256 _tokenSupplies
    ) public
```

Parameters:

| Name           | Type      | Description                                 |
| :------------- | :-------- | :------------------------------------------ |
| _to            | address   | the address that should receive the NFTs    |
| _requestId     | uint256   | the requestId of the respective request     |
| _proposalId    | uint256[] | the list of proposalId                      |
| _tokenIds      | uint256[] | the list of tokenIds                        |
| _tokenURLs     | string[]  | the list of tokenURLs                       |
| _winners       | string[]  | list of the addresses of the chosen winners |
| _tokenSupplies | uint256   | supply of the NFTs                          |


### reclaimFunds

allows requester to reclaim their funds if they still have funds and the choosing period is over

```
function reclaimFunds(uint256 _requestId) public
```

Parameters:

| Name           | Type      | Description                                 |
| :------------- | :-------- | :------------------------------------------ |
| _requestId            | uint256   | the requestId of the respective request   |

### isRequester

used by CreaticlesNFT contract to determine if the minter is the owner of the specified request

```
function isRequester(address _addr, uint256 _requestId)
        public
        view
        returns (bool)
```

Parameters:

| Name           | Type      | Description                                 |
| :------------- | :-------- | :------------------------------------------ |
| _addr            | address   | the target address   |
| _requestId            | uint256   | the requestId of the respective request   |

### isOpenForChoosing

used by CreaticlesNFT contract to determine if the specified request is not closed

```
 function isOpenForChoosing(uint256 _requestId) public view returns (bool)
```

Parameters:

| Name           | Type      | Description                                 |
| :------------- | :-------- | :------------------------------------------ |
| _requestId            | uint256   | the requestId of the respective request   |