pragma solidity ^0.4.0; 
 
 
contract SafeMath { 
   //internals 
 
 
   function safeMul(uint a, uint b) internal returns (uint) { 
     uint c = a * b; 
     assert(a == 0 || c / a == b); 
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