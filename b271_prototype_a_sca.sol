/**
 * @title b271_prototype_a_sca
 * @author [Your Name]
 * @notice Prototype for a scalable API service parser
 * @dev This contract is a starting point for a scalable API service parser
 */

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract b271_prototype_a_sca is Ownable {
    // Mapping of API services to their corresponding parsers
    mapping(string => address) public apiParsers;

    // Event emitted when a new API service is added
    event APIServiceAdded(string serviceName, address parserAddress);

    // Event emitted when a new parser is updated for an API service
    event ParserUpdated(string serviceName, address newParserAddress);

    // Event emitted when a request is made to parse API data
    event ParseRequest(string serviceName, string data);

    // Modifier to check if the caller is the owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner(), "Only the owner can call this function");
        _;
    }

    /**
     * @notice Add a new API service with its corresponding parser
     * @param _serviceName The name of the API service
     * @param _parserAddress The address of the parser contract
     */
    function addAPIService(string memory _serviceName, address _parserAddress) public onlyOwner {
        apiParsers[_serviceName] = _parserAddress;
        emit APIServiceAdded(_serviceName, _parserAddress);
    }

    /**
     * @notice Update the parser for an API service
     * @param _serviceName The name of the API service
     * @param _newParserAddress The new address of the parser contract
     */
    function updateParser(string memory _serviceName, address _newParserAddress) public onlyOwner {
        apiParsers[_serviceName] = _newParserAddress;
        emit ParserUpdated(_serviceName, _newParserAddress);
    }

    /**
     * @notice Request to parse API data
     * @param _serviceName The name of the API service
     * @param _data The API data to be parsed
     */
    function parseData(string memory _serviceName, string memory _data) public {
        address parserAddress = apiParsers[_serviceName];
        require(parserAddress != address(0), "Parser not found for this API service");
        // Call the parser contract to parse the data
        (bool success, ) = parserAddress.call(abi.encodeWithSignature("parseData(string)", _data));
        require(success, "Failed to parse data");
        emit ParseRequest(_serviceName, _data);
    }
}