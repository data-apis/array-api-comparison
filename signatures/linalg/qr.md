# qr

## NumPy

```
numpy.linalg.qr(a, mode='reduced') → Tuple[ ndarray, ... ]
```

Does not support stacks. Returns `q`, `r`, `h`, and `tau`.

## SciPy

```
scipy.linalg.qr(a, overwrite_a=False, lwork=None, mode='full', pivoting=False, check_finite=True) → Tuple[ ndarray, ... ]
```

Does not support stacks. Returns `q`, `r`, `p`.

## CuPy

```
cupy.linalg.qr(a, mode='reduced') → Tuple[ ndarray, ... ]
```

Does not support stacks. Returns `q`, `r`, `h`, and `tau`.

## dask.array

```
dask.array.linalg.qr(a) → Tuple[ ndarray, ... ]
```

Does not support stacks. Does not support modes. Returns `q` and `r`.

## JAX

```
jax.numpy.linalg.qr(a, mode='reduced') → Tuple[ ndarray, ... ]
```

Does not support stacks. Returns `q`, `r`, `h`, and `tau`.

## MXNet

```
np.linalg.qr(a, mode='reduced') → Tuple[ ndarray, ... ]
```

Returns `q` and `r`. Only supports `reduced` mode.

## PyTorch

```
torch.qr(input, some=True, *, out=None) → Tuple[ Tensor, ... ]
```

Returns `q` and `r`.

```
torch.linalg.qr(input, mode='reduced', *, out=None) → Tuple[ Tensor, ... ]
```

Returns `q` and `r`. Does not support `raw` mode. For `r` mode, returns `q` as an empty array, always returning a tuple of two tensors.

## TensorFlow

```
tf.linalg.qr(input, full_matrices=False, name=None) → Tuple[ Tensor, ... ]
```

Returns `q` and `r`. Effectively only supports `reduced` and `complete` modes.
