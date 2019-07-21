
import random

def counting_sort(v, n_max):
  record = []
  for i in range(0, n_max):
    record.append(0)

  for i in range(0, len(v)):
    e = v[i]
    record[e] = record[e] + 1

  for i in range(1, len(record)):
    record[i] = record[i] + record[i - 1]

  out = []
  for i in range(0, len(v)):
    out.append(0)
  for i in range(0, len(v)):
    e = v[i]
    index = record[e] - 1
    out[index] = e
    record[e] = index

  return out

#---------------------------------------

def setRandomList(size, bound):
  v = []
  for i in range(0, size):
    v.append(random.randint(0, bound))
  return v

def printList(v):
  print('(List: #', end='')
  print(len(v), end='')
  print(' [', end='')
  for i in range(0, len(v)):
    print(v[i], end='')
    print(' ', end='')
  print('])')

count = 100
n_max = 100

A = setRandomList(count, n_max - 1)
printList(A)
B = counting_sort(A, n_max)
printList(B)
