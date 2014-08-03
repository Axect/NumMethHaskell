% Fun with (Kalman) Filters Part I
% Dominic Steinitz
% 21st July 2014

---
bibliography: Kalman.bib
---

\newcommand{\condprob} [3] {#1 \left( #2 \,\vert\, #3 \right)}
\newcommand{\normal} [2] {{\cal{N}}\big( #1 , #2\big)}

Suppose we have particle moving in 1 dimension, where the initial
velocity is sampled from a distribution. We can observe the position
of the particle at fixed intervals and we wish to estimate its initial
velocity. For generality, let us assume that the positions and the
velocities can be perturbed at each interval and that our measurements
are noisy.

$$
\begin{aligned}
x_i &= x_{i-1} + \Delta T v_{i-1} + \epsilon^{(x)}_i \\
v_i &= v_{i-1} + \epsilon^{(v)}_i \\
y_i &= a_i x_i + \upsilon_i
\end{aligned}
$$

where $\epsilon^{(x)}_i, \epsilon^{(v)_i}$ and $\upsilon_i$ are all IID
normal with means of 0 and variances of $\sigma^2_x,
\sigma^2_v$ and $\sigma^2_y$

We can re-write this as

$$
\begin{aligned}
\boldsymbol{x}_i &= \boldsymbol{A}_{i-1}\boldsymbol{x}_{i-1} + \boldsymbol{\epsilon}_{i-1} \\
\boldsymbol{y}_i &= \boldsymbol{H}_i\boldsymbol{x}_i + \boldsymbol{\upsilon}_i
\end{aligned}
$$

where

$$
\boldsymbol{A}_i =
  \begin{bmatrix}
    1 & \Delta T\\
    0 & 1\\
  \end{bmatrix}
,\quad
\boldsymbol{H}_i =
  \begin{bmatrix}
    1\\
  \end{bmatrix}
,\quad
\boldsymbol{\epsilon}_i \sim {\cal{N}}\big(0,\boldsymbol{\Sigma}^{(x)}_i\big)
,\quad
\boldsymbol{\Sigma}^{(x)}_i =
  \begin{bmatrix}
    \sigma^2_{x} & 0\\
    0 & \sigma^2_{v} \\
  \end{bmatrix}
,\quad
\boldsymbol{\upsilon}_i \sim {\cal{N}}\big(0,\boldsymbol{\Sigma}^{(y)}_i\big)
,\quad
\boldsymbol{\Sigma}^{(y)}_i =
  \begin{bmatrix}
    \sigma^2_{z} \\
  \end{bmatrix}
$$

TBD

$$
\begin{aligned}
{\boldsymbol{Y}_i}\,\vert\,{\boldsymbol{Y}_{i-1}} =
{\boldsymbol{H}_i\boldsymbol{X}_i\,\vert\,{\boldsymbol{Y}_{i-1}} + \boldsymbol{\Upsilon}_i}\,\vert\,{\boldsymbol{Y}_{i-1}} =
{\boldsymbol{H}_i\boldsymbol{X}_i\,\vert\,{\boldsymbol{Y}_{i-1}} + \boldsymbol{\Upsilon}_i}
\end{aligned}
$$

Since ${\boldsymbol{X}_i}\,\vert\,{\boldsymbol{Y}_{i-1}}$ and
${\boldsymbol{Y}_i}\,\vert\,{\boldsymbol{Y}_{i-1}}$ are jointly
Gaussian and noting that ${\hat{\boldsymbol{\Sigma}}^\flat_i}^\top =
\hat{\boldsymbol{\Sigma}}^\flat_i$ as covariance matrices are
symmetric, we can calculate their mean and covariance matrix as

$$
\begin{bmatrix}
    \hat{\boldsymbol{x}}^\flat_i \\
    \boldsymbol{H}\hat{\boldsymbol{x}}^\flat_i
\end{bmatrix}
,\quad
\begin{bmatrix}
    \hat{\boldsymbol{\Sigma}}^\flat_i & \hat{\boldsymbol{\Sigma}}^\flat_i \boldsymbol{H}^\top \\
     \boldsymbol{H} \hat{\boldsymbol{\Sigma}}^\flat_i & \boldsymbol{H} \hat{\boldsymbol{\Sigma}}^\flat_i \boldsymbol{H}^\top + \boldsymbol{\Sigma}^{(y)}_i \\
\end{bmatrix}
$$

We can now use [standard formul&aelig;](http://en.wikipedia.org/wiki/Multivariate_normal_distribution#Conditional_distributions)


The Kalman filter then gives the prediction step:

$$
\begin{aligned}
\hat{\boldsymbol{x}}^\flat_i &=
\boldsymbol{A}_{i-1}\hat{\boldsymbol{x}}_{i-1} \\
\hat{\boldsymbol{\Sigma}}^\flat_i &= \boldsymbol{A}_{i-1}
                                     \hat{\boldsymbol{\Sigma}}_{i-1}
                                     \boldsymbol{A}_{i-1}^\top
                                   + \boldsymbol{\Sigma}^{(x)}_{i-1}
\end{aligned}
$$

By Bayes, we have

$$
\condprob{p}{\boldsymbol{x}_i, \boldsymbol{x}_{i-1}}{\boldsymbol{y}_1,\ldots,\boldsymbol{y}_{i-1}} =
\condprob{p}{\boldsymbol{x}_i}{\boldsymbol{x}_{i-1}, \boldsymbol{y}_1,\ldots,\boldsymbol{y}_{i-1}}
\condprob{p}{\boldsymbol{x}_{i-1}}{\boldsymbol{y}_1,\ldots,\boldsymbol{y}_{i-1}}
$$

By the Markov property of the model we have

$$
\condprob{p}{\boldsymbol{x}_i}{\boldsymbol{x}_{i-1}, \boldsymbol{y}_1,\ldots,\boldsymbol{y}_{i-1}}
=
\condprob{p}{\boldsymbol{x}_i}{\boldsymbol{x}_{i-1}}
$$

And by the inducton hypothesis we have

$$
\condprob{p}{\boldsymbol{x}_{i-1}}{\boldsymbol{y}_{1}, \ldots, \boldsymbol{y}_{i-1}} =
{\cal{N}}\big(\boldsymbol{x}_{i-1}; \hat{\boldsymbol{x}}_{i-1}, \hat{\boldsymbol{\Sigma}}_{i-1}\big)
$$

We thus have that

$$
\begin{aligned}
\condprob{p}{\boldsymbol{x}_i, \boldsymbol{x}_{i-1}}{\boldsymbol{y}_1,\ldots,\boldsymbol{y}_{i-1}} &=
\condprob{p}{\boldsymbol{x}_i}{\boldsymbol{x}_{i-1}}
\condprob{p}{\boldsymbol{x}_{i-1}}{\boldsymbol{y}_1,\ldots,\boldsymbol{y}_{i-1}} \\
&=
{\cal{N}}\big(\boldsymbol{x}_i; \boldsymbol{A}_{i-1}\boldsymbol{x}_{i-1}, \boldsymbol{\Sigma}^{(\boldsymbol{x})}_{i-1}\big){\cal{N}}\big(\boldsymbol{x}_{i-1}; \hat{\boldsymbol{x}}_{i-1}, \hat{\boldsymbol{\Sigma}}_{i-1}\big)
\end{aligned}
$$


Bibliography
============