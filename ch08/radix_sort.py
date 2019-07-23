
import random


def extract_b(n, digit):
  p1 = 10 ** digit
  p2 = 10 ** (digit - 1)
  return ((n % p1) - (n % p2)) // p2


def extract(n, digit):
  if (n < 0):
    raise ValueError("extract: n must be a positive integer")
  elif (digit < 1):
    raise ValueError("extract: digit at least 1")
  else:
    return extract_b(n, digit)


def counting_stable(l, d):
  record = []
  for i in range(0, 10):
    record.append(0)
  for i in range(0, len(l)):
    n = extract(l[i], d)
    record[n] += 1

  for i in range(1, len(record)):
    record[i] = record[i] + record[i - 1]

  out = []
  for i in range(0, len(l)):
    out.append(0)
  for i in range(len(l) - 1, -1, -1):
    n = extract(l[i], d)
    index = record[n] - 1
    out[index] = l[i]
    record[n] = index

  return out


def radix_sort(l, digits):
  temp = l
  for i in range(1, digits + 1):
    temp = counting_stable(temp, i)

  list_copy(temp, l)


def list_copy(src, des):
  for i in range(0, len(src)):
    des[i] = src[i]

#---------------------------------------

def setRandomList(size, n_min, n_max):
  bound = n_max - n_min
  v = []
  for i in range(0, size):
    v.append(random.randint(0, bound) + n_min)
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
n_min = 10
n_max = 100000
digits = 5

A = setRandomList(count, n_min, n_max)
printList(A)
radix_sort(A, digits)
printList(A)
