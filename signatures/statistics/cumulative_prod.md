# cumulative_prod

## NumPy

```
numpy.cumprod(a, axis=None, dtype=None, out=None) → ndarray
```

## CuPy

```
cupy.cumprod(a, axis=None, dtype=None, out=None) → ndarray
```

## dask.array

```
dask.array.cumprod(x, axis=None, dtype=None, out=None, method='sequential') → ndarray
```

## JAX

```
jax.numpy.cumprod(a, axis=None, dtype=None, out=None) → ndarray
```

## MXNet

```
np.cumprod(a, axis=None, dtype=None, out=None) → ndarray
```

## PyTorch

```
torch.cumprod(input, dim, *, dtype=None, out=None) → Tensor
```

`dim` positional/kwarg argument is required.

## TensorFlow

```
tf.math.cumprod(x, axis=0, exclusive=False, reverse=False, name=None) → Tensor
```

Uses `exclusive` kwarg to indicate whether to include the starting value and exclude the ending value
