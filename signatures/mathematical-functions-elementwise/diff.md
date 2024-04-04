# diff

## NumPy

```
numpy.diff(a, n=1, axis=-1, prepend=<no value>, append=<no value>) → ndarray
```

## CuPy

```
cupy.diff(a, n=1, axis=-1, prepend=None, append=None) → ndarray
```

## dask.array

```
dask.array.diff(a, n=1, axis=- 1, prepend=None, append=None) → array
```

## JAX

```
jax.numpy.diff(a, n=1, axis=-1, prepend=None, append=None) → ndarray
```

`prepend` and `append` must be array-like.

## PyTorch

```
torch.diff(input, n=1, dim=-1, prepend=None, append=None) → Tensor
```

## TensorFlow

```
tf.experimental.numpy.diff(a, n=1, axis=-1) → Tensor
```

No support for `prepend` and `append` (as of v2.16.1).
