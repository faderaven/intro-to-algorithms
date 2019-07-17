
import random

def quick_sort(compare, part, v, l, r):
  if l < r:
    q = part(compare, v, l, r)
    quick_sort(compare, part, v, l, q - 1)
    quick_sort(compare, part, v, q + 1, r)

def partition(compare, v, l, r):
  i = l - 1
  for j in range(l, r):
    if compare(v[j], v[r]):
      i = i + 1
      exchange(v, i, j)
  exchange(v, i + 1, r)
  return i + 1

def random_partition(compare, v, l, r):
  q = random.randint(l, r)
  exchange(v, q, r)
  return partition(compare, v, l, r)

def exchange(v, i, j):
  temp = v[i]
  v[i] = v[j]
  v[j] = temp

def greater(n, m):
  return n > m

def less(n, m):
  return n < m

def quick_sort_asc(v):
  quick_sort(less, partition, v, 0, len(v) - 1)

def quick_sort_desc(v):
  quick_sort(greater, partition, v, 0, len(v) - 1)

def random_quick_sort_asc(v):
  quick_sort(less, random_partition, v, 0, len(v) - 1)

def random_quick_sort_desc(v):
  quick_sort(greater, random_partition, v, 0, len(v) - 1)

#-----------------------------------

def setList(size, bound):
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

v = setList(100, 1000)
printList(v)

quick_sort_asc(v)
printList(v)
quick_sort_desc(v)
printList(v)
random_quick_sort_asc(v)
printList(v)
random_quick_sort_desc(v)
printList(v)
