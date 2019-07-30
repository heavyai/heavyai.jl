# OmniSci.jl

Linux: [![Build Status](https://travis-ci.org/omnisci/OmniSci.jl.svg?branch=master)](https://travis-ci.org/omnisci/OmniSci.jl) <br>
Codecov: [![codecov](https://codecov.io/gh/omnisci/OmniSci.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/omnisci/OmniSci.jl) <br>

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://omnisci.github.io/OmniSci.jl/stable/)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://omnisci.github.io/OmniSci.jl/latest/)


JuliaCon 2019 OmniSci.jl announcement: https://www.youtube.com/watch?v=coPbmYuUah0 <br>
Announcement blog post: [Announcing OmniSci.jl: A Julia Client for OmniSci](https://www.omnisci.com/blog/announcing-omnisci.jl-a-julia-client-for-omnisci)

## Description
This package is an Apache Thrift-based client for OmniSci, with similar functionality to our Python package [pymapd](https://pymapd.readthedocs.io/en/latest/). Because of the rapid pace of [OmniSciDB](https://github.com/omnisci/omniscidb) development, this package will attempt to always run against the most recent version of OmniSci. In most cases, OmniSci.jl should be backwards compatible to the last few OmniSciDB releases, but if you run into an issue, the first step would be to run the OmniSci.jl test suite against the [newest stable CPU Docker image](https://hub.docker.com/r/omnisci/core-os-cpu) to validate the tests pass.
