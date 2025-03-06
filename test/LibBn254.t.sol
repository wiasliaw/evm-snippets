// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {LibBn254} from "../src/LibBn254.sol";

contract TestLibBn254 is Test {
    function test_ec_add() external view {
        LibBn254.G1Point memory a = LibBn254.G1Point({x: bytes32(uint256(1)), y: bytes32(uint256(2))});

        LibBn254.G1Point memory result = LibBn254.ecAdd(a, a);

        LibBn254.G1Point memory expected = LibBn254.G1Point({
            x: 0x030644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd3,
            y: 0x15ed738c0e0a7c92e7845f96b2ae9c0a68a6a449e3538fc7ff3ebf7a5a18a2c4
        });

        assertEq(expected.x, result.x);
        assertEq(expected.y, result.y);
    }

    function test_ec_mul() external view {
        LibBn254.G1Point memory a = LibBn254.G1Point({x: bytes32(uint256(1)), y: bytes32(uint256(2))});

        LibBn254.G1Point memory result = LibBn254.ecMul(a, 2);

        LibBn254.G1Point memory expected = LibBn254.G1Point({
            x: 0x030644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd3,
            y: 0x15ed738c0e0a7c92e7845f96b2ae9c0a68a6a449e3538fc7ff3ebf7a5a18a2c4
        });

        assertEq(expected.x, result.x);
        assertEq(expected.y, result.y);
    }

    function test_ec_pairing() external view {
        // testcases: https://github.com/bluealloy/revm/blob/dd8c1c040258223236f2ed8c27bacbfdaaf84408/crates/precompile/src/bn128.rs#L395-L409
        LibBn254.G1Point memory g1a = LibBn254.G1Point({
            x: 0x1c76476f4def4bb94541d57ebba1193381ffa7aa76ada664dd31c16024c43f59,
            y: 0x3034dd2920f673e204fee2811c678745fc819b55d3e9d294e45c9b03a76aef41
        });

        LibBn254.G2Point memory g2a = LibBn254.G2Point({
            x_ci: 0x209dd15ebff5d46c4bd888e51a93cf99a7329636c63514396b4a452003a35bf7,
            x_c0: 0x04bf11ca01483bfa8b34b43561848d28905960114c8ac04049af4b6315a41678,
            y_ci: 0x2bb8324af6cfc93537a2ad1a445cfd0ca2a71acd7ac41fadbf933c2a51be344d,
            y_c0: 0x120a2a4cf30c1bf9845f20c6fe39e07ea2cce61f0c9bb048165fe5e4de877550
        });

        LibBn254.G1Point memory g1b = LibBn254.G1Point({
            x: 0x111e129f1cf1097710d41c4ac70fcdfa5ba2023c6ff1cbeac322de49d1b6df7c,
            y: 0x2032c61a830e3c17286de9462bf242fca2883585b93870a73853face6a6bf411
        });

        LibBn254.G2Point memory g2b = LibBn254.G2Point({
            x_ci: 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2,
            x_c0: 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed,
            y_ci: 0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b,
            y_c0: 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa
        });

        LibBn254.PairingParams[] memory params = new LibBn254.PairingParams[](2);
        params[0] = LibBn254.PairingParams({a: g1a, b: g2a});
        params[1] = LibBn254.PairingParams({a: g1b, b: g2b});

        assertTrue(LibBn254.ecPairing(params));
    }
}
