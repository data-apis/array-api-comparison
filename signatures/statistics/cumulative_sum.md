# cumulative_sum

## NumPy

```
numpy.cumsum(a, axis=None, dtype=None, out=None) → ndarray
```

## CuPy

```
cupy.cumsum(a, axis=None, dtype=None, out=None) → ndarray
```

## dask.array

```
dask.array.cumsum(x, axis=None, dtype=None, out=None, method='sequential') → ndarray
```

## JAX

```
jax.numpy.cumsum(a, axis=None, dtype=None, out=None) → ndarray
```

## MXNet

```
np.cumsum(a, axis=None, dtype=None, out=None) → ndarray
```

## PyTorch

```
torch.cumsum(input, dim, *, dtype=None, out=None) → Tensor
```

`dim` positional/kwarg argument is required.

## TensorFlow

```
tf.math.cumsum(x, axis=0, exclusive=False, reverse=False, name=None) → Tensor
```

Uses `exclusive` kwarg to indicate whether to include the starting value and exclude the ending value
