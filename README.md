<!--

Copyright (c) 2020 Python Data APIs Consortium

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-->

# Array API Comparison

> Data and tooling to compare the API surfaces of various array libraries.

## Overview

The goal of this repository is to compare the public API surfaces of various PyData array libraries in order to better understand existing practice. In analyzing both the commonalities and differences across array libraries, we can derive a common API subset which can be standardized and used to ensure consistency (naming and otherwise) across array libraries. This API subset should include attribute names, method names, and positional and keyword arguments.

By deriving a common API subset, we can reduce friction among library consumers by reducing the cognitive overhead of learning array dialects. This is exemplified by the following user story:

> As an array library author, I know that, regardless of the input array, whether NumPy, Dask, PyTorch, etc, the array has a method to compute the transpose which is guaranteed to have options `x`, `y`, and `z`.

Currently, the needs of the library author in the above user story are not met, as libraries vary in their naming conventions and the optional arguments they support.

Through specification and array library compliance, we facilitate array interoperability for both users and library developers.

* * *

## Array Libraries

Currently, the following array libraries are evaluated:

-   [**NumPy**][numpy]: serves as the reference API against which all other array libraries are compared.
-   [**CuPy**][cupy]
-   [**Dask.array**][dask-array]
-   [**JAX**][jax]
-   [**MXNet**][mxnet]
-   [**PyTorch**][pytorch]
-   [**rnumpy**][rnumpy]: an opinionated curation of NumPy APIs, serving as an exercise in evaluating what is most "essential" (i.e., the smallest set of building block functionality on which most array functionality can be built).
-   [**PyData/Sparse**][pydata-sparse]
-   [**Tensorflow**][tensorflow]

* * *

## Installation

Navigate to the directory into which you want to clone this repository

```bash
$ cd ./repository/destination/directory
```

Next, clone the repository

```bash
$ git clone https://github.com/pydata-apis/array-api-comparison.git
```

Once cloned, navigate to the repository directory


```bash
$ cd ./array-api-comparison
```

Create an Anaconda environment

```bash
$ conda create -n array-api-comparison -c conda-forge python=3.8 nodejs
```

To activate the environment,

```bash
$ conda activate array-api-comparison
```

Run the installation sequence

```bash
$ make
```

* * *

## Usage

To view all array API tables in your local web browser,

```bash
$ make view-docs
```

To view cross-library array API data,

```bash
$ make view-join
```

To view the intersection of array library APIs,

```bash
$ make view-intersection
```

To view a table ranking the intersection of array library APIs,

```bash
$ make view-intersection-ranks
```

To view relatively common array library APIs,

```bash
$ make view-common-apis
```

To view a table ranking relatively common array library APIs,

```bash
$ make view-common-apis-ranks
```

To view array library APIs which are not in the intersection,

```bash
$ make view-complement
```

To view array library APIs which are not among the list of relatively common APIs,

```bash
$ make view-common-complement
```

To view a table displaying the top `K` (relatively) common array library APIs across various libraries,

```bash
$ make view-lib-top-k-common
```

To view a table displaying the top `K` array library APIs in the complement across various libraries,

```bash
$ make view-lib-top-k-complement
```

To view a table displaying the top `K` array library APIs in the complement of the list of (relatively) common APIs across various libraries,

```bash
$ make view-lib-top-k-common-complement
```

* * *

## Organization

This repository contains the following directories:

-   **data**: array API data (e.g., array library APIs and their NumPy equivalents).
-   **docs**: browser-based documentation for viewing array API data.
-   **etc**: configuration files.
-   **scripts**: scripts for data manipulation and documentation generation.

The `data` directory contains the following directories

-   **raw**: raw array library API data.
-   **joins**: array library APIs matched to their NumPy equivalents.

The **raw** data directory contains the following datasets:

-   `XXXXX.(csv|json)`: raw array library API data.

The **joins** data directory contains the following datasets:

-   `XXXXX_numpy.(csv|json)`: array library APIs and their NumPy equivalents.

Lastly, the root **data** directory contains the following additional datasets:

-   `join.(csv|json)`: array library API data combined in a single file.
-   `intersection.(csv|json)`: array library API intersection.

When editing data files, consider the JSON data to be the source of truth. CSV files are generated from the JSON data.

* * *

## Contributing

To contribute array API data to this repository, add an `data/joins/XXXXX_numpy.json` file, where `XXXXX` is the lowercase name of the relevant array library (e.g., `cupy`). The JSON file should include a JSON array, where each array element has the following fields:

-   `name`: array library API name.
-   `numpy`: NumPy API equivalent.

For example,

```text
[
    {
        "name": "all",
        "numpy": "numpy.all"
    },
    {
        "name": "allclose",
        "numpy": "numpy.allclose"
    },
    ...
]
```

Once added, the CSV variant can be generated using internal tooling.

<!-- links -->

[cupy]: https://docs-cupy.chainer.org/en/stable/reference/comparison.html

[dask-array]: https://docs.dask.org/en/latest/array-api.html

[jax]: https://jax.readthedocs.io/en/latest/

[mxnet]: https://numpy.mxnet.io/api/deepnumpy

[numpy]: https://docs.scipy.org/doc/numpy

[pydata-sparse]: https://github.com/pydata/sparse

[pytorch]: https://pytorch.org/docs/stable/

[rnumpy]: https://github.com/Quansight-Labs/rnumpy

[tensorflow]: https://www.tensorflow.org/api_docs/python

<!-- /.links -->
