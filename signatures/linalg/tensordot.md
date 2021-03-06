# tensordot

## NumPy

```
numpy.tensordot(a, b, axes=2) → ndarray
```

## CuPy

```
cupy.tensordot(a, b, axes=2) → ndarray
```

## dask.array

```
dask.array.tensordot(lhs, rhs, axes=2) → ndarray
```

## JAX

```
jax.numpy.tensordot(a, b, axes=2, *, precision=None) → ndarray
```

## MXNet

```
np.tensordot(a, b, axes=2) → ndarray
```

## PyTorch

```
torch.tensordot(a, b, dims=2) → Tensor
```

## TensorFlow

```
tf.tensordot(a, b, axes, name=None) → Tensor
```

Allows providing `axes` as a `(2,K)` shaped array, in addition to an integer or tuple. Returned data type is that of `a`.
