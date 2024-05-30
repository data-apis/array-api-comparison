# take_along_axis

## NumPy

```
numpy.take_along_axis(arr, indices, axis) → ndarray
```

When `axis` is `None`, flatten for consistency with `sort` and `argsort`.

## CuPy

```
cupy.take_along_axis(a, indices, axis) → ndarray
```

## dask.array

```

```

- <https://github.com/dask/dask/issues/3663>
- <https://github.com/dask/dask/pull/11076>

## JAX

```
jax.numpy.take_along_axis(arr, indices, axis, mode=None, fill_value=None) → ndarray
```

- "mode" specifies how to handle out-of-bounds indices.
- "fill_value" specifies the value to use when "mode" is "fill"

## MXNet

```

```

## PyTorch

```
torch.take_along_dim(input, indices, dim=None, *, out=None) → Tensor
```

Supports flattening when `dim=None`.

## TensorFlow

```
tf.experimental.numpy.take_along_axis(arr, indices, axis) → Tensor
```
