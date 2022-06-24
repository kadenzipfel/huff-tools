// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../lib/ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "./utils/HuffDeployer.sol";

interface SafeMath {
    function safeAdd(uint256,uint256) external pure returns (uint256);
    function safeSub(uint256,uint256) external pure returns (uint256);
    function safeMul(uint256,uint256) external pure returns (uint256);
    function safeDiv(uint256,uint256) external pure returns (uint256);
}

contract MathTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    ///@notice create a new instance of HuffDeployer
    HuffDeployer huffDeployer = new HuffDeployer();

    SafeMath safeMath;

    function setUp() public {
        ///@notice deploy a new instance of ISimplestore by passing in the address of the deployed Huff contract
        safeMath = SafeMath(huffDeployer.deploy("SafeMath"));
    }

    function testSafeAdd() public {
        uint256 result = safeMath.safeAdd(420, 69);
        assertEq(result, 489);
    }

    function testSafeAdd(uint256 a, uint256 b) public {
        unchecked {
            uint256 c = a + b;
            
            if (a > c) {
                vm.expectRevert();
                safeMath.safeAdd(a, b);
                return;
            }
            
            uint256 result = safeMath.safeAdd(a, b);
            assertEq(result, a + b);
        }
    }

    function testSafeSub() public {
        uint256 result = safeMath.safeSub(420, 69);
        assertEq(result, 351);
    }

    function testSafeSub(uint256 a, uint256 b) public {
        unchecked {
            if (b > a) {
                vm.expectRevert();
                safeMath.safeSub(a, b);
                return;
            }
            
            uint256 result = safeMath.safeSub(a, b);
            assertEq(result, a - b);
        }
    }

    function testSafeMul() public {
        uint256 result = safeMath.safeMul(420, 69);
        assertEq(result, 28980);
    }

    function testSafeMul(uint256 a, uint256 b) public {
        unchecked {
            uint256 result;
            if (a == 0 || b == 0) {
                result = safeMath.safeMul(a, b);
                assertEq(result, 0);
                return;
            }

            uint256 c = a * b;
            if (c / a != b) {
                vm.expectRevert();
                safeMath.safeMul(a, b);
                return;
            }
            
            result = safeMath.safeMul(a, b);
            assertEq(result, c);
        }
    }

    function testSafeDiv() public {
        uint256 result = safeMath.safeDiv(420, 69);
        assertEq(result, 6);
    }

    function testSafeDiv(uint256 a, uint256 b) public {
        unchecked {
            if (b == 0) {
                vm.expectRevert();
                safeMath.safeDiv(a, b);
                return;
            }
            
            uint256 result = safeMath.safeDiv(a, b);
            assertEq(result, a / b);
        }
    }
}