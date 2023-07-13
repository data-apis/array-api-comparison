# repeat

## NumPy

```
numpy.repeat(a, repeats, axis=None) → ndarray
```

## CuPy

```
cupy.repeat(a, repeats, axis=None) → ndarray
```

## dask.array

```
dask.array.repeat(a, repeats, axis=None) → ndarray
```

## JAX

```
jax.numpy.repeat(a, repeats, axis=None, *, total_repeat_length=None) → ndarray
```

Note: requires `total_repeat_length` to be provided in order to be compilable.

## MXNet

```
np.repeat(a, repeats, axis=None) → ndarray
```

## PyTorch

```
torch.repeat_interleave(input, repeats, dim=None, *, output_size=None) → Tensor
```

Note: `torch.Tensor.repeat` behaves similar to NumPy `tile`.

## TensorFlow

```
tf.repeat(input, repeats, axis=None, name=None) → Tensor
```
