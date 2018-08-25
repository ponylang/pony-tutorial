# Chapter 9: C FFI

Pony supports integration with other native languages through the Foreign Function Interface (FFI). The FFI library provides a stable and portable API and high-level programming interface allowing Pony to integrate with native libraries easily.

Note that calling C (or other low-level languages) is inherently dangerous. C code fundamentally has access to all memory in the process and can change any of it, either deliberately or due to bugs. This is one of the language's most useful, but also most dangerous, features. Calling well written, bug-free, C code will have no ill effects on your program. However, calling buggy or malicious C code or calling C incorrectly can cause your Pony program to go wrong, including corrupting data and crashing. Consequently, all of the Pony guarantees regarding not crashing, memory safety and concurrent correctness can be voided by calling FFI functions.
