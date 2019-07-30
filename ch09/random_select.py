
import random


def partition(v, left, right):
  i = left - 1
  for j in range(left, right):
    if v[j] < v[right]:
      i += 1
      exchange(v, i, j)
  i += 1
  exchange(v, i, right)
  return i


def random_partition(v, left, right):
  p = random.randint(left, right)
  exchange(v, p, right)
  return partition(v, left, right)


def random_select_b(index, v, left, right):
  def rs_help(l, r):
    if l < r:
      p = random_partition(v, l, r)
      if index < p:
        rs_help(l, p - 1)
      elif index > p:
        rs_help(p + 1, r)
      #else:
      return v[index]
    else:
      return v[index]

  return rs_help(left, right)


def random_select(index, v, left, right):
  if left < 0:
    raise ValueError("left")
  elif right >= len(v):
    raise ValueError("right")
  elif index < left or index > right:
    raise ValueError("index")
  else:
    return random_select_b(index, v, left, right)


#---------------------------------------

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


def exchange(v, i, j):
  temp = v[i]
  v[i] = v[j]
  v[j] = temp


def mkRandomList(size, n_min, n_max):
  v = []
  for i in range(0, size):
    v.append(random.randint(n_min, n_max - 1))
  return v


def printList(v):
  print('(List: #', end='')
  print(len(v), end='')
  print(' [', end='')
  for i in range(0, len(v)):
    print(v[i], end='')
    print(' ', end='')
  print('])')


A = mkRandomList(100, 0, 100)
printList(A)
print(random_select(5, A, 0, 99))
insertion_sort(A)
printList(A)
