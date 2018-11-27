import tensorflow as tf
import numpy as np
from sklearn.datasets import fetch_california_housing


housing = fetch_california_housing()
m, n = housing.data.shape
print('Shape = ', m, ', ', n)
housing_data_plus_bias = np.c_[np.ones((m, 1)), housing.data]


# Using gradient descent
n_epochs = 1000
learning_rate = 0.1

X = tf.constant(housing_data_plus_bias, dtype=tf.float32, name='X')
y = tf.constant(housing.target.reshape(-1, 1), dtype=tf.float32, name='y')
theta = tf.Variable(tf.random_normal([n+1, 1], -1.0, 1.0), name='theta')
y_pred = tf.matmul(X, theta, name='predictions')
error = y_pred - y
mse = tf.reduce_mean(tf.square(error), name='mse')
gradients = 2/m * tf.matmul(tf.transpose(X), error)
optimizer = tf.train.GradientDescentOptimizer(learning_rate=learning_rate)
# training_op = tf.assign(theta, theta - learning_rate * gradients)
training_op = optimizer.minimize(mse)


def relu(X, threshold=0):
    w_shape = (int(X.get_shape()[1]), 1)
    w = tf.Variable(tf.random_normal(w_shape), name='weights')
    b = tf.Variable(0.0, name='bias')
    z = tf.add(tf.matmul(X, w), b, name='z')
    return tf.maximum(z, threshold, name='relu')


init = tf.global_variables_initializer()


with tf.Session() as sess:
    sess.run(init)
    print('theta = ', theta)
    for epoch in range(n_epochs):
        if epoch % 100 == 0:
            print('Epoch ', epoch, '  MSE = ', mse.eval())
        sess.run(training_op)
    best_theta = theta.eval()
    print('X = \n', X.eval())
    print('y = \n', y.eval())

print(best_theta)
