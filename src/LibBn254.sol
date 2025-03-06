// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @dev https://eips.ethereum.org/EIPS/eip-196
/// @dev https://eips.ethereum.org/EIPS/eip-197
library LibBn254 {
    struct G1Point {
        bytes32 x;
        bytes32 y;
    }

    struct G2Point {
        // G2.X = x_c0 + x_ci * i (in Fp2)
        bytes32 x_c0;
        bytes32 x_ci;
        // G2.Y = y_c0 + y_ci * i (in Fp2)
        bytes32 y_c0;
        bytes32 y_ci;
    }

    struct PairingParams {
        G1Point a;
        G2Point b;
    }

    // constant

    address internal constant BN254_ADD = 0x0000000000000000000000000000000000000006;

    address internal constant BN254_MUL = 0x0000000000000000000000000000000000000007;

    address internal constant BN254_PAIRING = 0x0000000000000000000000000000000000000008;

    // error

    error Bn254_Add_Failed();

    error Bn254_Mul_Failed();

    error Bn254_Pairing_Failed();

    function ecAdd(G1Point memory point0, G1Point memory point1) internal view returns (G1Point memory result) {
        // payload
        bytes memory payload = abi.encodePacked(point0.x, point0.y, point1.x, point1.y);
        // call precompiled
        (bool success, bytes memory data) = address(BN254_ADD).staticcall(payload);
        // check `success`
        if (!success) revert Bn254_Add_Failed();
        // decode `data` and return
        result = abi.decode(data, (G1Point));
    }

    function ecMul(G1Point memory point0, uint256 scalar) internal view returns (G1Point memory result) {
        // payload
        bytes memory payload = abi.encodePacked(point0.x, point0.y, scalar);
        // call precompiled
        (bool success, bytes memory data) = address(BN254_MUL).staticcall(payload);
        // check `success`
        if (!success) revert Bn254_Mul_Failed();
        // decode `data` and return
        result = abi.decode(data, (G1Point));
    }

    function ecPairing(PairingParams[] memory params) internal view returns (bool) {
        // cache len
        uint256 len = params.length;
        // check: length should not be zero
        if (len == 0) revert Bn254_Pairing_Failed();

        // payload
        bytes memory payload = hex"";
        for (uint256 i = 0; i < len; i++) {
            payload = bytes.concat(
                payload,
                abi.encodePacked(
                    params[i].a.x, params[i].a.y, params[i].b.x_ci, params[i].b.x_c0, params[i].b.y_ci, params[i].b.y_c0
                )
            );
        }

        // call precompiled
        (bool success, bytes memory data) = address(BN254_PAIRING).staticcall(payload);
        // check `success`
        if (!success) revert Bn254_Pairing_Failed();
        // decode `data` and return
        return abi.decode(data, (bool));
    }
}
