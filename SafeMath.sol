pragma solidity ^0.4.0; 
 
 
contract SafeMath { 
   //internals 
 
 
   function safeMul(uint a, uint b) internal returns (uint) { 
     uint c = a * b; 
     assert(a == 0 || c / a == b); 
     return c; 
   } 
 
   function safeDiv(uint a, uint b) internal returns (uint) { 
     assert(b != 0 ); //|| c * b == a
     uint c = a / b; 
     return c; 
   } 
 
 
   function safeSub(uint a, uint b) internal returns (uint) { 
     assert(b <= a); 
     return a - b; 
   } 
 
 
   function safeAdd(uint a, uint b) internal returns (uint) { 
     uint c = a + b; 
     assert(c>=a && c>=b); 
     return c; 
   } 
 
   function assert(bool assertion) internal { 
    if (!assertion) throw; 
  } 
} 
    // function safeToAdd(uint a, uint b) internal returns (bool) {
    //     return (a + b >= a);
    // }
    // function safeAdd(uint a, uint b) internal returns (uint) {
    //     if (!safeToAdd(a, b)) throw;
    //     return a + b;
    // }
    // function safeToSubtract(uint a, uint b) internal returns (bool) {
    //     return (b <= a);
    // }
    // function safeSub(uint a, uint b) internal returns (uint) {
    //     if (!safeToSubtract(a, b)) throw;
    //     return a - b;
    // } 
    
    /// math.sol -- mixin for inline numerical wizardry

// Copyright (C) 2015, 2016, 2017  DappHub, LLC

// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).

contract DSMath {
    
    /*
    standard uint256 functions
     */

    function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
        assert((z = x + y) >= x);
    }

    function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
        assert((z = x - y) <= x);
    }

    function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
        assert((z = x * y) >= x);
    }

    function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
        z = x / y;
    }

    function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
        return x <= y ? x : y;
    }
    function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
        return x >= y ? x : y;
    }

    /*
    uint128 functions (h is for half)
     */


    function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
        assert((z = x + y) >= x);
    }

    function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
        assert((z = x - y) <= x);
    }

    function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
        assert((z = x * y) >= x);
    }

    function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
        z = x / y;
    }

    function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
        return x <= y ? x : y;
    }
    function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
        return x >= y ? x : y;
    }


    /*
    int256 functions
     */

    function imin(int256 x, int256 y) constant internal returns (int256 z) {
        return x <= y ? x : y;
    }
    function imax(int256 x, int256 y) constant internal returns (int256 z) {
        return x >= y ? x : y;
    }
    
     function parseInt(string _a, uint _b)  constant returns (uint) { //No writing to blockchain, so return constant
            bytes memory bresult = bytes(_a);
            uint mint = 0;
            bool decimals = false;
            for (uint i=0; i<bresult.length; i++){
                if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
                    if (decimals){
                       if (_b == 0){
                        //Round up if next value is 5 or greater
                        if(uint(bresult[i])- 48>4){
                            mint = mint+1;
                        }    
                        break;
                       }
                       else _b--;
                    }
                    mint *= 10;
                    mint += uint(bresult[i]) - 48;
                } else if (bresult[i] == 46||bresult[i] == 44) { // cope with euro decimals using commas
                    decimals = true;
                }
            }
            if (_b > 0) mint *= 10**_b;
           return mint;
    }

    /*
    WAD math
     */
    uint8 constant WAD_Dec=18;
    uint128 constant WAD = 10 ** 18;

    function parseInt128(string _a)  constant returns (uint) { //No writing to blockchain, so return constant
        return cast(parseInt( _a, WAD_Dec));
    }

    function wadd(uint128 x, uint128 y) constant returns (uint128) {
        return hadd(x, y);
    }

    function wsub(uint128 x, uint128 y) constant returns (uint128) {
        return hsub(x, y);
    }

    function wmul(uint128 x, uint128 y) constant returns (uint128 z) {
        z = cast((uint256(x) * y + WAD / 2) / WAD);
    }

    function wdiv(uint128 x, uint128 y) constant  returns (uint128 z) {
        z = cast((uint256(x) * WAD + y / 2) / y);
    }

    function wmin(uint128 x, uint128 y) constant returns (uint128) {
        return hmin(x, y);
    }
    function wmax(uint128 x, uint128 y) constant returns (uint128) {
        return hmax(x, y);
    }

    function wpow(uint128 x, uint64 n) constant  returns (uint128 z) {
        // This famous algorithm is called "exponentiation by squaring"
        // and calculates x^n with x as fixed-point and n as regular unsigned.
        //
        // It's O(log n), instead of O(n) for naive repeated multiplication.
        //
        // These facts are why it works:
        //
        //  If n is even, then x^n = (x^2)^(n/2).
        //  If n is odd,  then x^n = x * x^(n-1),
        //   and applying the equation for even x gives
        //    x^n = x * (x^2)^((n-1) / 2).
        //
        //  Also, EVM division is flooring and
        //    floor[(n-1) / 2] = floor[n / 2].

        z = n % 2 != 0 ? x : WAD;

        for (n /= 2; n != 0; n /= 2) {
            x = wmul(x, x);

            if (n % 2 != 0) {
                z = wmul(z, x);
            }
        }
    }


    function wstr(uint128 x) constant returns (string) {
        if (x == 0) return "0";
        uint j = x;
        uint len;//=0
        uint k;//=0
        uint zeros;//=0
        bytes memory bstr;
        
        while (j != 0){
            len++;
            j /= 10;
        }

        if (len<=WAD_Dec){
            //Less than 1
            zeros = WAD_Dec-len;
            bstr = new bytes(len+2+zeros);
            k = len - 1;
            while (x != 0){
                bstr[2+zeros+k--] = byte(48 + x % 10);
                x /= 10;
            }
            
            while (zeros != 0){
                bstr[1+zeros] = byte(48);
                zeros--;
            }
            
            bstr[1]=byte(46); //"."
            bstr[0]=byte(48); //"0"
                
        }else{
            //Greater than 1
            bstr = new bytes(len+1);
            k = len;
            while (x != 0){
                if(len-k==WAD_Dec){
                    bstr[k--] = byte(46); //"."
                }else{
                    bstr[k--] = byte(48 + x % 10);
                    x /= 10;
                }

            }
        }
        
        return string(bstr);
    }
    
    function TrimL(string _a, bytes1 _char) constant internal returns (string){
        bytes memory bresult = bytes(_a);
        bytes memory bstr;
        bool isChar=true;
        uint16 charLength;//=0
        for (uint16 i=0; i<bresult.length; i++){
            if(bresult[i] == _char && isChar){
              charLength++;  
            } else {
              if(isChar){
                  isChar = false;
                  bstr = new bytes(bresult.length-charLength);
              }
              bstr[i-charLength]=bresult[i];
            }
        }
        return string(bstr);        
    }
    
    function TrimL0(string _a) constant returns (string){
        return TrimL(_a,48);
    }

    function TrimR0(string _a) constant returns (string){
        return TrimR(_a,48);
    }


    function TrimR(string _a, bytes1 _char) constant internal returns (string){
        bytes memory bresult = bytes(_a);
        bytes memory bstr;
        bool isChar=true;
        uint16 charLength;//=0
        for (uint16 i=0; i<bresult.length; i++){
            if(bresult[bresult.length-i-1] == _char && isChar){
              charLength++;  
            } else {
              if(isChar){
                  isChar = false;
                  bstr = new bytes(bresult.length-charLength);
              }
              bstr[bstr.length-(i-charLength)-1]=bresult[bresult.length-i-1];
            }
        }
        return string(bstr);
    }
    
    function uint2str(uint i) internal constant returns (string){
        if (i == 0) return "0";
        uint j = i;
        uint len;
        while (j != 0){
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (i != 0){
            bstr[k--] = byte(48 + i % 10);
            i /= 10;
        }
        return string(bstr);
    }
    

    /*
    RAY math
     */

    uint128 constant RAY = 10 ** 27;

    function radd(uint128 x, uint128 y) constant internal returns (uint128) {
        return hadd(x, y);
    }

    function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
        return hsub(x, y);
    }

    function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
        z = cast((uint256(x) * y + RAY / 2) / RAY);
    }

    function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
        z = cast((uint256(x) * RAY + y / 2) / y);
    }

    function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
        // This famous algorithm is called "exponentiation by squaring"
        // and calculates x^n with x as fixed-point and n as regular unsigned.
        //
        // It's O(log n), instead of O(n) for naive repeated multiplication.
        //
        // These facts are why it works:
        //
        //  If n is even, then x^n = (x^2)^(n/2).
        //  If n is odd,  then x^n = x * x^(n-1),
        //   and applying the equation for even x gives
        //    x^n = x * (x^2)^((n-1) / 2).
        //
        //  Also, EVM division is flooring and
        //    floor[(n-1) / 2] = floor[n / 2].

        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }

    function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
        return hmin(x, y);
    }
    function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
        return hmax(x, y);
    }

    function cast(uint256 x) constant internal returns (uint128 z) {
        assert((z = uint128(x)) == x);
    }
    
    function assert(bool assertion) internal { 
        if (!assertion) throw; 
    } 

}
