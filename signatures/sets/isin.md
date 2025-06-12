# isin

## NumPy

```
numpy.isin(element, test_elements, assume_unique=False, invert=False, *, kind=None) → ndarray
```

Supported options for kind: None, sort, table.

## CuPy

```
cupy.isin(element, test_elements, assume_unique=False, invert=False) → ndarray
```

**assume_unique** is ignored.

## dask.array

```
dask.array.isin(element, test_elements, assume_unique=False, invert=False, *, kind=None) → ndarray
```

## JAX

```
jax.numpy.isin(element, test_elements, assume_unique=False, invert=False, *, method='auto') → ndarray
```

Supported options for kind: 'compare_all', 'binary_search', 'sort', and 'auto'.

## PyTorch

```
torch.isin(elements, test_elements, *, assume_unique=False, invert=False) → Tensor
```

## TensorFlow

```

```

## ndonnx

```
ndonnx.extensions.isin(x: Array, /, items: Sequence[SCALAR])→ Array
```

## MLX

```

```
