# searchsorted

## NumPy

```
numpy.searchsorted(a, v, side='left', sorter=None) → ndarray
```

Supports 1D.

## CuPy

```
cupy.searchsorted(a, v, side='left', sorter=None) → ndarray
```

Supports 1D.

## dask.array

```
dask.array.searchsorted(a, v, side='left', sorter=None) → ndarray
```

## JAX

```
jax.numpy.searchsorted(a, v, side='left', sorter=None, *, method='scan') → ndarray
```

`method` controls device and array size performance optimizations.

## MXNet

```
np.searchsorted(a, v, side='left', sorter=None) → ndarray
```

## PyTorch

```
torch.searchsorted(sorted_sequence, values, *, out_int32=False, right=False, side='left', out=None, sorter=None) → Tensor
```

`side` is preferred over `right`. Supports N-D (supports stacking).

## TensorFlow

```
tf.searchsorted(sorted_sequence, values, side='left', out_type=tf.dtypes.int32, name=None) → Tensor
```

Does not support `sorter`.
