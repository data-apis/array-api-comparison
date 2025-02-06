# broadcast_shapes

## NumPy

```
numpy.broadcast_shapes(*args) → Tuple
```

## CuPy

CuPy borrows `broadcast_shapes` from NumPy (see https://github.com/cupy/cupy/blob/a888cc94c79729cf24ebb808d15b9702c0342392/cupy/__init__.py#L302)

```
cupy.broadcast_shapes(*args) → Tuple
```

## dask.array

Appears to support but not in docs: <https://github.com/dask/dask/issues/11433>

```
dask.array.broadcast_shapes(*args) → Tuple
```

## JAX

```
jax.numpy.broadcast_shapes(*shapes) → Tuple
```

## PyTorch

```
torch.broadcast_shapes(*shapes) → Size
```

## TensorFlow

```
tf.broadcast_static_shape(shape_x, shape_y) → TensorShape
```

```
tf.broadcast_dynamic_shape(shape_x, shape_y) → Tensor
```
