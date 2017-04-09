// This si marker
// for contract not
// to be deployed to 
// any environment
pragma solidity ^0.4.2;
contract Abstract {}

contract owned is Abstract {
  address owner;
  function owned() {
    owner = msg.sender;
  }
  function changeOwner(address newOwner) onlyOwner {
    owner = newOwner;
  }
  modifier onlyOwner() {
    if (msg.sender==owner) 
    _;
  }
}

// contract mortal is Abstract, owned {
//   function kill() onlyowner {
//     if (msg.sender == owner) suicide(owner);
//   }
// }

// contract NameReg is Abstract {
//   function register(bytes32 name) {}
//   function unregister() {}
//   function addressOf(bytes32 name) constant returns (address addr) {}
//   function nameOf(address addr) constant returns (bytes32 name) {}
//   function kill() {}
// }

// contract nameRegAware is Abstract {
//   function nameRegAddress() returns (address) {
//     return 0x0860a8008298322a142c09b528207acb5ab7effc;
//   }
  
//   function named(bytes32 name) returns (address) {
//     return NameReg(nameRegAddress()).addressOf(name);
//   }
// }

// contract named is Abstract, nameRegAware {
//   function named(bytes32 name) {
//     NameReg(nameRegAddress()).register(name);
//   }
// }

// // contract with util functions
// contract util is Abstract {
//   // Converts 'string' to 'bytes32'
//   function s2b(string s) internal returns (bytes32) {
//       bytes memory b = bytes(s);
//       uint r = 0;
//       for (uint i = 0; i < 32; i++) {
//           if (i < b.length) {
//               r = r | uint(b[i]);
//           }
//           if (i < 31) r = r * 256;
//       }
//       return bytes32(r);
//   }
// }