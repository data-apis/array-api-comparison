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
-   [**TensorFlow**][tensorflow]

* * *

## Installation

Navigate to the directory into which you want to clone this repository

```bash
$ cd ./repository/destination/directory
```

Next, clone the repository

```bash
$ git clone https://github.com/data-apis/array-api-comparison.git
```

Once cloned, navigate to the repository directory


```bash
$ cd ./array-api-comparison
```

Create an Anaconda environment

```bash
$ conda create -n array-api-comparison -c conda-forge python=3.8 nodejs jupyterlab pandas matplotlib
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

```text
Usage: make <cmd>

  make help                              Print this message.

  make view-docs                         View all array API tables.

  make view-join                         View cross-library array API data.

  make view-intersection                 View the intersection of array library
                                         APIs.

  make view-intersection-ranks           View a table ranking the intersection
                                         of array library APIs.

  make view-common-apis                  View relatively common array library
                                         APIs.

  make view-common-apis-ranks            View a table ranking relatively common
                                         array library APIs.

  make view-complement                   View array library APIs which are not
                                         in the intersection.

  make view-common-complement            View array library APIs which are not
                                         among the list of relatively common
                                         APIs.

  make view-lib-top-k-common             View a table displaying the top `K`
                                         (relatively) common array library APIs
                                         across various libraries.

  make view-lib-top-k-complement         View a table displaying the top K array
                                         library APIs in the complement across
                                         various libraries.

  make view-lib-top-k-common-complement  View a table displaying the top `K`
                                         array library APIs in the complement of
                                         the list of (relatively) common APIs
                                         across various libraries.
```

To run the Jupyter notebooks, run

```bash
$ jupyter lab
```

* * *

## Organization

This repository contains the following directories:

-   **data**: array API data (e.g., array library APIs and their NumPy equivalents).
-   **docs**: browser-based documentation for viewing array API data.
-   **etc**: configuration files.
-   **notebooks**: Jupyter notebooks for analysis.
-   **scripts**: scripts for data manipulation and documentation generation.
-   **tools**: project tooling.

The `data` directory contains the following directories

-   **raw**: raw array library API data.
-   **joins**: array library APIs matched to their NumPy equivalents.
-   **vendor**: datasets acquired from third party sources, such as those found in the Python API Record [repository][python-api-record].

The **raw** data directory contains the following datasets:

-   `XXXXX.(csv|json)`: raw array library API data.

The **joins** data directory contains the following datasets:

-   `XXXXX_numpy.(csv|json)`: array library APIs and their NumPy equivalents.

Lastly, the root **data** directory contains the following additional datasets:

-   `join.(csv|json)`: array library API data combined in a single file.
-   `intersection.(csv|json)`: array library API intersection.
-   `common_apis.(csv|json)`: array library APIs which are (relatively) common across downstream libraries (`>67%`).
-   `complement.(csv|json)`: array library APIs which are not in the intersection.
-   `intersection_ranks.(csv|json)`: array library APIs which are in the intersection ranked according to relative usage in downstream libraries.
-   `common_apis_ranks.(csv|json)`: array library APIs which are in the list of (relatively) common APIs ranked according to relative usage in downstream libraries.
-   `lib_top_k_common.(csv|json)`: the top `K` array library API names in the list of relatively common APIs per downstream library according to relative usage.
-   `lib_top_k_common_complement.(csv|json)`: the top `K` array library API names not in the list of relatively common APIs per downstream library according to relative usage.
-   `lib_top_k_complement.(csv|json)`: the top `K` array library API names not in the list of API intersection per downstream library according to relative usage.
-   `lib_top_100_category_stats.(csv|json)`: categorization statistics for the top `100` NumPy APIs which are consumed for each downstream library.

**Note**: the datasets in the root **data** directory are generated.

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

[python-api-record]: https://github.com/data-apis/python-api-record

<!-- /.links -->
