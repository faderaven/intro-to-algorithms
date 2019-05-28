
import io
import random
import os
import sys

# some golbal consts
CONST = dict(rmin=-0x8000, rmax=0x7FFF, bytes=4)

# set maximum recursion depth to 1G
sys.setrecursionlimit(1024 * 1024 * 1024)

def makeRandomNumbers(filename, n):
  out = io.open(filename, "wb")
  while n != 0:
    rd = random.randrange(CONST['rmin'], CONST['rmax'])
    rdbytes = int(rd).to_bytes(CONST['bytes'], byteorder="little", signed=True)
    out.write(rdbytes)
    n = n - 1
  out.close()


def lookRandomNumbers(filename, pos = 0, n = 1024):
  inf = io.open(filename, "rb")
  inf.seek(pos * CONST['bytes'])
  size = os.stat(filename).st_size
  while inf.tell() != size and n != 0:
    rdbytes = inf.read(CONST['bytes'])
    rd = int.from_bytes(rdbytes, byteorder="little", signed=True)
    print(rd)
    n = n - 1
  inf.close()


def sortRandomNumbers(sort, in_file, out_file):
  v = list()

  # read random numbers
  inf = io.open(in_file, "rb")
  size = os.stat(in_file).st_size
  while inf.tell() != size:
    rdbytes = inf.read(CONST['bytes'])
    rd = int.from_bytes(rdbytes, byteorder="little", signed=True)
    v.append(rd)
  inf.close()

  # sort random numbers
  sort(v, 0, len(v) - 1)

  # write random numbers
  out = io.open(out_file, "wb")
  for e in v:
    rdbytes = e.to_bytes(CONST['bytes'], byteorder="little", signed=True)
    out.write(rdbytes)
  out.close()


def mergSort(v, left, right):
  if left < right:
    mid = (left + right) // 2
    mergSort(v, left, mid)
    mergSort(v, mid + 1, right)

    Lv = v[left : mid+1]
    Rv = v[mid+1 : right+1]

    i = 0
    j = 0
    for k in range(left,right + 1):
      if i == len(Lv):
        v[k] = Rv[j]
        j = j + 1
      elif j == len(Rv):
        v[k] = Lv[i]
        i = i + 1
      else:
        if Lv[i] < Rv[j]:
          v[k] = Lv[i]
          i = i + 1
        else:
          v[k] = Rv[j]
          j = j + 1


makeRandomNumbers("test", 1024 * 1024)
sortRandomNumbers(mergSort, "test", "out-test")
lookRandomNumbers("out-test", 512 * 1024, 512 * 1024)
# take about 32 seconds
