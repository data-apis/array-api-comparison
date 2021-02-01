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

Does not support stacks. Returns `q` and `r`.

## dask.array

```
dask.array.linalg.qr(a) → Tuple[ ndarray, ... ]
```

Does not support stacks. Returns `q` and `r`.

## JAX

```
jax.numpy.linalg.qr(a, mode='reduced') → Tuple[ ndarray, ... ]
```

Does not support stacks. Returns `q`, `r`, `h`, and `tau`.

## MXNet

```
np.linalg.qr(a, mode='reduced') → Tuple[ ndarray, ... ]
```

Returns `q` and `r`.

## PyTorch

```
torch.qr(input, some=True, *, out=None) → Tuple[ Tensor, ... ]
```

Returns `q` and `r`.

```
torch.linalg.qr(input, mode='reduced', *, out=None) → Tuple[ Tensor, ... ]
```

Returns `q` and `r`.

## TensorFlow

```
tf.linalg.qr(input, full_matrices=False, name=None) → Tuple[ Tensor, ... ]
```

Returns `q` and `r`.
