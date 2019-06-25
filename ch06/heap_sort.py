
import random


def setRandom(v, _b, end):
  for i in range(1, len(v)):
    v[i] = random.randint(_b, end)

def printV(v):
  print('(Heap: #', end='')
  print(len(v) - 1, end='')
  print(' [', end='')
  for i in range(1, len(v)):
    print(v[i], end='')
    print(' ', end='')
  print('])')

#-----------------------------------

def left(i):
  return i*2

def right(i):
  return i*2+1

def parent(i):
  return i//2

# v: numbers list
# i: index
# j: index
def exchange(v, i, j):
  temp = v[i]
  v[i] = v[j]
  v[j] = temp

def heapifyMax(v, _b, _e):
  l = left(_b)
  r = right(_b)
  largest = _b

  if l <= _e and v[l] > v[_b]:
    largest = l
  if r <= _e and v[r] > v[largest]:
    largest = r
  if largest != _b:
    exchange(v, largest, _b)
    heapifyMax(v, largest, _e)

def buildMax(v):
  for i in range(parent(len(v) - 1), 0, -1):
    heapifyMax(v, i, len(v) - 1)

def isMax(v):
  for i in range(len(v) - 1, 1, -1):
    if v[parent(i)] < v[i]:
      return False
  return True

def heapSort(v):
  buildMax(v)

  for _e in range(len(v) - 1, 0, -1):
    exchange(v, 1, _e)
    heapifyMax(v, 1, _e - 1)

#-----------------------------------

v = [None] * (100 + 1)
setRandom(v, 0, 999)
printV(v)
buildMax(v)
printV(v)
print(isMax(v))
heapSort(v)
printV(v)
