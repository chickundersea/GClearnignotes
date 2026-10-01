

## Build an array

```py
import numpy as np

readings = [12, 7, 19, 3, 25]

# turn the list into a NumPy array
arr = np.array(readings)

count = len(arr)
print("count =", count)
```

```bash 
#output
count = 5
```

- len(arr) counts how many values an array holds — the same len() you already know from a Python list.
- np.array() takes a plain Python list and gives you back an array.
