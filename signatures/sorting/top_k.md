# top_k

## NumPy

```
numpy.topk(a, k, axis=-1, largest=True, sorted=True) → [ndarray, ndarray]
```

**Note**: this is not present in NumPy, but is proposed in <https://github.com/numpy/numpy/pull/19117>.

```
numpy.partition(a, kth, axis=-1, kind='introselect', order=None) → ndarray
```

**Note**: returns an array of the same shape as `a` and requires sorting the return value to get the top `k` values in order.

```
numpy.argpartition(a, kth, axis=-1, kind='introselect', order=None) → ndarray
```

**Note**: returns an array of the same shape as `a` and requires sorting after using the return value to get the top `k` values.

## CuPy

```
cupy.argpartition(a, kth, axis=-1) → ndarray
```

**Note**: performs a full sort.

## dask.array

```
dask.array.topk(a, k, axis=-1, split_every=None) → ndarray
```

**Note**: only returns values. If `k` is negative, returns the smallest `k` values. Returned values are sorted.

```
dask.array.argtopk(a, k, axis=-1, split_every=None)
```

**Note**: only returns indices. If `k` is negative, returns the indices for the smallest `k` values. Returned indices correspond to sorted values.

## JAX

```
jax.lax.top_k(operand, k) → ndarray
```

**Note**: only returns values.

```
jax.numpy.partition(a, kth, axis=-1) → ndarray
```

**Note**: implemented via two calls to `jax.lax.top_k`. Differs from NumPy in handling of NaN values, where NaN values which have negative sign bits are sorted to the beginning of the array.

```
jax.numpy.argpartition(a, kth, axis=-1) → ndarray
```

**Note**: implemented via two calls to `jax.lax.top_k`. Differs from NumPy in handling of NaN values, where NaN values which have negative sign bits are sorted to the beginning of the array.

## MXNet

```
npx.topk(data, axis=-1, k=1, ret_typ='indices', is_ascend=False, dtype='float32') → ndarray | tuple[ndarray, ndarray]
```

**Note**: whether a single ndarray or a list of ndarrays is returned is determined by `ret_type`. Differs from NumPy et al in providing a default value for `k`.

## PyTorch

```
torch.topk(input, k, dim=None, largest=True, sorted=True, *, out=None) → tuple[Tensor, LongTensor]
```

**Note**: returns a named tuple containing values and indices. Differs from NumPy et al for default `dim`.

## TensorFlow

```
tf.math.top_k(input, k=1, sorted=True, index_type=tf.dtypes.int32, name=None
) → tuple[Tensor, Tensor]
```

**Note**: returns a `(values, indices)` tuple. Only supports last axis. Provides a default for `k`.
