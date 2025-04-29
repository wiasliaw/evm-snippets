// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./utils/BLSG1.sol";
import "./utils/BLSG2.sol";

library LibBLS12_381 {
    struct BLS12_381_G1_MSM_Params {
        BLS_G1.G1Point point;
        uint256 scalar;
    }

    struct BLS12_381_G2_MSM_Params {
        BLS_G2.G2Point point;
        uint256 scalar;
    }

    struct BLS12_381_G2_Pairing_Params {
        BLS_G1.G1Point g1;
        BLS_G2.G2Point g2;
    }

    // constant

    address internal constant BLS12_381_G1_ADD = 0x000000000000000000000000000000000000000b;

    address internal constant BLS12_381_G1_MSM = 0x000000000000000000000000000000000000000C;

    address internal constant BLS12_381_G2_ADD = 0x000000000000000000000000000000000000000d;

    address internal constant BLS12_381_G2_MSM = 0x000000000000000000000000000000000000000E;

    address internal constant BLS12_381_PAIRING = 0x000000000000000000000000000000000000000F;

    address internal constant BLS12_381_MAP_G1 = 0x0000000000000000000000000000000000000010;

    address internal constant BLS12_381_MAP_G2 = 0x0000000000000000000000000000000000000011;

    // error

    error BLS12_381_G1_ADD_Failed();

    error BLS12_381_G1_MSM_Failed();

    error BLS12_381_G2_ADD_Failed();

    error BLS12_381_G2_MSM_Failed();

    error BLS12_381_G2_Pairing_Failed();

    error BLS12_381_MAP_G1_Failed();

    error BLS12_381_MAP_G2_Failed();

    function bls12_381_g1_add(BLS_G1.G1Point memory p, BLS_G1.G1Point memory q)
        internal
        view
        returns (BLS_G1.G1Point memory result)
    {
        // payload
        bytes memory payload = bytes.concat(BLS_G1.toBytes(p), BLS_G1.toBytes(q));
        // call precompiled
        (bool success, bytes memory data) = BLS12_381_G1_ADD.staticcall(payload);
        // check `success`
        if (!success) revert BLS12_381_G1_ADD_Failed();
        // decode `data`
        result = abi.decode(data, (BLS_G1.G1Point));
    }

    function bls12_381_g1_msm(BLS12_381_G1_MSM_Params[] memory params)
        internal
        view
        returns (BLS_G1.G1Point memory result)
    {
        // cache length
        uint256 len = params.length;
        // check: length should not be zero
        require(len > 0);

        // payload
        bytes memory payload = hex"";
        for (uint256 i = 0; i < len; i++) {
            payload = bytes.concat(payload, BLS_G1.toBytes(params[i].point), bytes32(params[i].scalar));
        }

        // call precompiled
        (bool success, bytes memory data) = BLS12_381_G1_MSM.staticcall(payload);
        // check `success`
        if (!success) revert BLS12_381_G1_MSM_Failed();
        // decode `data`
        result = abi.decode(data, (BLS_G1.G1Point));
    }

    function bls12_381_g2_add(BLS_G2.G2Point memory p, BLS_G2.G2Point memory q)
        internal
        view
        returns (BLS_G2.G2Point memory result)
    {
        // payload
        bytes memory payload = bytes.concat(BLS_G2.toBytes(p), BLS_G2.toBytes(q));
        // call precompiled
        (bool success, bytes memory data) = BLS12_381_G2_ADD.staticcall(payload);
        // check `success`
        if (!success) revert BLS12_381_G2_ADD_Failed();
        // decode `data`
        result = abi.decode(data, (BLS_G2.G2Point));
    }

    function bls12_381_g2_msm(BLS12_381_G2_MSM_Params[] memory params)
        internal
        view
        returns (BLS_G2.G2Point memory result)
    {
        // cache length
        uint256 len = params.length;
        // check: length should not be zero
        require(len > 0);

        // payload
        bytes memory payload = hex"";
        for (uint256 i = 0; i < len; i++) {
            payload = bytes.concat(payload, BLS_G2.toBytes(params[i].point), bytes32(params[i].scalar));
        }

        // call precompiled
        (bool success, bytes memory data) = BLS12_381_G2_MSM.staticcall(payload);
        // check `success`
        if (!success) revert BLS12_381_G2_MSM_Failed();
        // decode `data`
        result = abi.decode(data, (BLS_G2.G2Point));
    }

    function bls12_381_pairing(BLS12_381_G2_Pairing_Params[] memory params) internal view returns (bool result) {
        // cache length
        uint256 len = params.length;
        // check: length should not be zero
        require(len > 0);

        // payload
        bytes memory payload = hex"";
        for (uint256 i = 0; i < len; i++) {
            payload = bytes.concat(payload, BLS_G1.toBytes(params[i].g1), BLS_G2.toBytes(params[i].g2));
        }

        // call precompiled
        (bool success, bytes memory data) = BLS12_381_PAIRING.staticcall(payload);
        // check `success`
        if (!success) revert BLS12_381_G2_Pairing_Failed();
        // decode `data`
        result = abi.decode(data, (bool));
    }

    function map_to_g1(LibBytes64.Bytes64 memory fp) internal view returns (BLS_G1.G1Point memory result) {
        // payload
        bytes memory payload = LibBytes64.toBytes(fp);
        // call precompiled
        (bool success, bytes memory data) = BLS12_381_MAP_G1.staticcall(payload);
        // check `success`
        if (!success) revert BLS12_381_MAP_G1_Failed();
        // decode `data`
        result = abi.decode(data, (BLS_G1.G1Point));
    }

    function map_to_g2(LibBytes64.Bytes64 memory fp2_c0, LibBytes64.Bytes64 memory fp2_c1)
        internal
        view
        returns (BLS_G2.G2Point memory result)
    {
        // payload
        bytes memory payload = bytes.concat(LibBytes64.toBytes(fp2_c0), LibBytes64.toBytes(fp2_c1));
        // call precompiled
        (bool success, bytes memory data) = BLS12_381_MAP_G2.staticcall(payload);
        // check `success`
        if (!success) revert BLS12_381_MAP_G2_Failed();
        // decode `data`
        result = abi.decode(data, (BLS_G2.G2Point));
    }
}
