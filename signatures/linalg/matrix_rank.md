# matrix_rank

## NumPy

```
numpy.linalg.matrix_rank(M, tol=None, hermitian=False) → ndarray
```

tol: `S.max() * max(M.shape) * eps`

## CuPy

```
cupy.linalg.matrix_rank(M, tol=None)) → ndarray
```

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

```
torch.linalg.matrix_rank(input, tol=None, hermitian=False, *, out=None) → Tensor
```

## TensorFlow

```
tf.linalg.matrix_rank(a, tol=None, validate_args=False, name=None) → Tensor
```

tol: ` eps * max(rows, cols) * max(singular_val)`
