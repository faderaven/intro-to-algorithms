
import random
import math

def insertion_sort(v):
  n = len(v)
  if n > 0:
    for i in range(1, n):
      p = i - 1
      q = i
      while p >= 0 and v[p] > v[q]:
        exchange(v, p, q)
        p -= 1
        q -= 1

def bucket_sort(v):
  n = len(v)
  buk = []
  for i in range(0, n):
    buk.append([])

  for element in v:
    index = math.floor(n * element)
    buk[index].append(element)

  for B in buk:
    insertion_sort(B)

  k = 0
  for B in buk:
    for element in B:
      v[k] = element
      k += 1

#---------------------------------------

def exchange(v, i, j):
  temp = v[i]
  v[i] = v[j]
  v[j] = temp

def mkRandomList(size, n_min, n_max):
  bound = n_max - n_min
  v = []
  for i in range(0, size):
    v.append(random.randint(0, bound) + n_min)
  return v

def mkRandomList(size):
  v = []
  for i in range(0, size):
    v.append(random.random())
  return v

def printList(v):
  print('(List: #', end='')
  print(len(v), end='')
  print(' [', end='')
  for i in range(0, len(v)):
    print(v[i], end='')
    print(' ', end='')
  print('])')

A = mkRandomList(100)
printList(A)
bucket_sort(A)
printList(A)
