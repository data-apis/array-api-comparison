# bincount

## NumPy

```
numpy.bincount(x, /, weights=None, minlength=0) → ndarray
```

`x` must be one-dimensional.

## CuPy

```
cupy.bincount(x, weights=None, minlength=None) → ndarray
```

Warns that may synchronize device. Default for `minlength` is `None`.

## dask.array

```
dask.array.bincount(x, /, weights=None, minlength=0) → ndarray
```

Default for `minlength` is `0`.

## JAX

```
jax.numpy.bincount(x, weights=None, minlength=0, *, length=None) → ndarray
```

Supports n-dimensional `x`. Supports `length` parameter to allow use with `jax.jit()`.

## PyTorch

```
torch.bincount(input, weights=None, minlength=0) → Tensor
```

Default for `minlength` is `0`.

## TensorFlow

```
tf.math.bincount(arr, weights=None, minlength=None, maxlength=None, dtype=tf.dtypes.int32, name=None, axis=None, binary_output=False) → Tensor
```

`minlength` default is `None`.

## ndonnx

```

```

## MLX

```

```
