# matrix_rank

## NumPy

```
numpy.linalg.matrix_rank(M, tol=None, hermitian=False) → ndarray
```

tol: `S.max() * max(M.shape) * eps`

## CuPy

```
cupy.linalg.matrix_rank(M, tol=None) → ndarray
```

`tol` can only be float, not array-like. Does not support stacks.

## dask.array

```

```

## JAX

```
jax.numpy.linalg.matrix_rank(M, tol=None) → ndarray
```

## MXNet

```
np.linalg.matrix_rank(M, tol=None, hermitian=False) → ndarray
```

## PyTorch

```
torch.matrix_rank(input, tol=None, symmetric=False) → Tensor
```

Does not support stacks.

```
torch.linalg.matrix_rank(input, tol=None, hermitian=False, *, out=None) → Tensor
```

`tol` can only be a float, not array-like.

## TensorFlow

```
tf.linalg.matrix_rank(a, tol=None, validate_args=False, name=None) → Tensor
```

tol: ` eps * max(rows, cols) * max(singular_val)`
