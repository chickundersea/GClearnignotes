

def myFunc():
  yield "Hello"
  yield 51
  yield "Good Bye"

x = myFunc()

## Build an array
for z in x:
  print(z)

import numpy as np

readings = [12, 7, 19, 3, 25]

# turn the list into a NumPy array
arr = np.array(readings)

count = len(arr)
print("count =", count)