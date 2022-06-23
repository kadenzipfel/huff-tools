// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "../../lib/ds-test/test.sol";
import "forge-std/console.sol";
import "./utils/HuffDeployer.sol";

interface Math {
    function addition(uint256,uint256) external pure returns (uint256);
}

contract MathTest is DSTest {
    ///@notice create a new instance of HuffDeployer
    HuffDeployer huffDeployer = new HuffDeployer();

    Math math;

    function setUp() public {
        ///@notice deploy a new instance of ISimplestore by passing in the address of the deployed Huff contract
        math = Math(huffDeployer.deploy("Math"));
    }

    function testAddition() public {
        uint256 result = math.addition(420, 69);
        assertEq(result, 489);
    }

    function testAddition(uint256 a, uint256 b) public {
        unchecked {
            uint256 result = math.addition(a, b);
            assertEq(result, a + b);
        }
    }
}