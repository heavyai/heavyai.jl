OmniSci.jl is an Apache 2.0 licensed library, and as such, we welcome any and all contributions! From the most trivial typo to adding sections to this documentation, or even bug fixes and new features are greatly appreciated.

It is suggested, but not required, that you create a [GitHub issue](https://github.com/omnisci/OmniSci.jl/issues) before contributing a feature or bug fix. This is so that other developers 1) know that you are working on the feature/issue and 2) that internal OmniSci experts can help you navigate any database-specific logic that may not be obvious within the package. All patches should be submitted as pull requests, and upon passing the test suite and review by OmniSci, will be merged to master for release as part of the next package release cycle.

## Updating Thrift Bindings

The core functionality of this package relies on [Apache Thrift](https://thrift.apache.org/) to pass and receive messages from an OmniSciDB backend. While a discussion of the mechanics of Apache Thrift is beyond the scope of this documentation, what is important to note is that as the OmniSciDB project changes its Thrift specification (files with a `.thrift` extension), the auto-generated bindings from Thrift,jl need to be updated here.

Because of quirks in the Julia Thrift.jl package (mainly, no forward declaration/mutually referential types), updating the Thrift bindings does require manual intervention. If attempting to update the bindings, take note of commented out code in the existing definition, which usually means that either the order of the struct definition needed to be changed or that the struct itself needed to be changed.
