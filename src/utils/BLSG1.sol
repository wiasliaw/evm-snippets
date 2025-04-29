// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library LibBytes64 {
    struct Bytes64 {
        bytes32[2] inner;
    }

    function from(bytes memory data) internal pure returns (Bytes64 memory result) {
        // check
        require(data.length <= 64);
        // padding with zero
        data = _paddingStart(data, 64);
        // result
        (bytes32 upper, bytes32 lower) = _slice(data);
        result.inner[0] = upper;
        result.inner[1] = lower;
    }

    function toBytes(Bytes64 memory data) internal pure returns (bytes memory result) {
        result = bytes.concat(data.inner[0], data.inner[1]);
    }

    function _paddingStart(bytes memory data, uint256 size) private pure returns (bytes memory result) {
        result = data;
        while (result.length < size) {
            result = bytes.concat(bytes1(0x00), result);
        }
    }

    function _slice(bytes memory data) private pure returns (bytes32 u, bytes32 l) {
        assembly {
            u := mload(add(data, 0x20))
            l := mload(add(data, 0x40))
        }
    }
}

library BLS_G1 {
    struct G1Point {
        LibBytes64.Bytes64 x;
        LibBytes64.Bytes64 y;
    }

    function from(bytes memory x, bytes memory y) internal pure returns (G1Point memory result) {
        result.x = LibBytes64.from(x);
        result.y = LibBytes64.from(y);
    }

    function toBytes(G1Point memory data) internal pure returns (bytes memory result) {
        result = bytes.concat(LibBytes64.toBytes(data.x), LibBytes64.toBytes(data.y));
    }
}
