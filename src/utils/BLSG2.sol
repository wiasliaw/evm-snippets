// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {LibBytes64} from "./BLSG1.sol";

library BLS_G2 {
    struct G2Point {
        LibBytes64.Bytes64 x_c0;
        LibBytes64.Bytes64 x_c1;
        LibBytes64.Bytes64 y_c0;
        LibBytes64.Bytes64 y_c1;
    }

    function from(bytes memory x_c0, bytes memory x_c1, bytes memory y_c0, bytes memory y_c1)
        internal
        pure
        returns (G2Point memory result)
    {
        result.x_c0 = LibBytes64.from(x_c0);
        result.x_c1 = LibBytes64.from(x_c1);
        result.y_c0 = LibBytes64.from(y_c0);
        result.y_c1 = LibBytes64.from(y_c1);
    }

    function toBytes(G2Point memory data) internal pure returns (bytes memory result) {
        result = bytes.concat(
            LibBytes64.toBytes(data.x_c0),
            LibBytes64.toBytes(data.x_c1),
            LibBytes64.toBytes(data.y_c0),
            LibBytes64.toBytes(data.y_c1)
        );
    }
}
