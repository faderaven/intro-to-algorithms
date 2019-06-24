
import random


def setRandom(v, start, end):
  for i in range(1, len(v)):
    v[i] = random.randint(start, end)

def printV(v):
  print('(Heap: #', end='')
  print(len(v) - 1, end='')
  print(' [', end='')
  for i in range(1, len(v)):
    print(v[i], end='')
    print(' ', end='')
  print('])')

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

def heapifyMax(v, i):
  l = left(i)
  r = right(i)
  largest = i

  if l < len(v) and v[l] > v[i]:
    largest = l
  if r < len(v) and v[r] > v[largest]:
    largest = r
  if largest != i:
    exchange(v, largest, i)
    heapifyMax(v, largest)

def buildMax(v):
  for i in range(parent(len(v) - 1), 0, -1):
    heapifyMax(v, i)

def isMax(v):
  for i in range(len(v) - 1, 1, -1):
    if v[parent(i)] < v[i]:
      return False
  return True

def heapSort(v):
  buildMax(v)



#-----------------------------------

v = [None] * (10 + 1)
setRandom(v, 0, 99)
printV(v)
buildMax(v)
print(isMax(v))
printV(v)
