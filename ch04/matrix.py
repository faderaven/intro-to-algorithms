
import random
import sys

print(sys.getrecursionlimit())
#sys.setrecursionlimit(5000)

class Coor:
  def __init__(self, row, col):
    self.row = row
    self.col = col

  def copy(self):
    return Coor(self.row, self.col)

class Matrix:
  def __init__(self, size):
    self.size = Coor(size.row, size.col)
    self.v = [None] * size.row * size.col;

  def isNull(self):
    if self.size.row == 0 or \
       self.size.col == 0:
      return True
    return False

  def validCoor(self, pos):
    if pos.row >= 0 and \
       pos.col >= 0 and \
       pos.row < self.size.row and \
       pos.col < self.size.col:
      return True
    return False

  def ref(self, pos):
    return self.v[pos.row * self.size.col + pos.col]

  def set(self, pos, e):
    self.v[pos.row * self.size.col + pos.col] = e

  def setM(self, top, bot, B):
    right_bot = Coor(min(bot.row, self.size.row - 1), \
                     min(bot.col, self.size.col - 1))
    posB = Coor(0, 0)
    for rA in range(top.row, right_bot.row + 1):
      for cA in range(top.col, right_bot.col + 1):
        self.set(Coor(rA, cA), B.ref(posB))
        posB.col += 1
      posB.col = 0
      posB.row += 1

  def setRandom(self, _max):
    for r in range(self.size.row):
      for c in range(self.size.col):
        self.set(Coor(r, c), random.randrange(_max))

  def print(self):
    print("Matrix:")
    for r in range(self.size.row):
      for c in range(self.size.col):
        print(' ', self.ref(Coor(r, c)), end='')
      print()

  def __sonof(self, top, bot):
    size = Coor(bot.row - top.row + 1, \
                bot.col - top.col + 1)
    B = Matrix(size)
    posA = top.copy()
    for r in range(size.row):
      for c in range(size.col):
        B.set(Coor(r, c), self.ref(posA))
        posA.col += 1
      posA.row += 1
      posA.col = top.col
    return B

  def getSon(self, top, bot):
    if (self.validCoor(top)):
      right_bot = Coor(min(bot.row, self.size.row - 1), \
                       min(bot.col, self.size.col - 1))
      return self.__sonof(top.copy(), right_bot)
    return Matrix(Coor(0, 0))


def Add(x, y):
  return x + y

def Sub(x, y):
  return x - y

def __matrixAS(p, A, B):
  size = Coor(A.size.row, B.size.col)
  C = Matrix(size)
  for r in range(size.row):
    for c in range(size.col):
      pos = Coor(r, c)
      C.set(pos, p(A.ref(pos), B.ref(pos)))
  return C

def matrixAddSub(p, A, B):
  if A.isNull():
    return B
  elif B.isNull():
    return A
  return __matrixAS(p, A, B)

def matrixMul(A, B):
  size = Coor(A.size.row, B.size.col)
  C = Matrix(size)
  for r in range(size.row):
    for c in range(size.col):
      Sum = 0
      for n in range(A.size.col):
        Sum += A.ref(Coor(r, n)) * B.ref(Coor(n, c))
      C.set(Coor(r, c), Sum)
  return C

def mid(n):
  if n % 2 == 1:
    return n // 2 + 1
  return n // 2

def matrixMulRecursive(A, B):
  n = max(max(A.size.row, A.size.col), \
          max(B.size.row, B.size.col))
  size = Coor(A.size.row, B.size.col)
  C = Matrix(size)

  top1 = Coor(0, 0)
  bot1 = Coor(mid(n)-1, mid(n)-1)
  top2 = Coor(0, mid(n))
  bot2 = Coor(mid(n)-1, n-1)
  top3 = Coor(mid(n), 0)
  bot3 = Coor(n-1, mid(n)-1)
  top4 = Coor(mid(n), mid(n))
  bot4 = Coor(n-1, n-1)

  if C.isNull():
    return C
  elif n == 1:
    C.set(top1, A.ref(top1) * B.ref(top1))
    return C
  C.setM(top1, bot1, \
      matrixAddSub(Add, \
        matrixMulRecursive(A.getSon(top1, bot1), B.getSon(top1, bot1)), \
        matrixMulRecursive(A.getSon(top2, bot2), B.getSon(top3, bot3))))
  if C.validCoor(top2):
    C.setM(top2, bot2, \
        matrixAddSub(Add, \
          matrixMulRecursive(A.getSon(top1, bot1), B.getSon(top2, bot2)), \
          matrixMulRecursive(A.getSon(top2, bot2), B.getSon(top4, bot4))))
  if C.validCoor(top3):
    C.setM(top3, bot3, \
        matrixAddSub(Add, \
          matrixMulRecursive(A.getSon(top3, bot3), B.getSon(top1, bot1)), \
          matrixMulRecursive(A.getSon(top4, bot4), B.getSon(top3, bot3))))
  if C.validCoor(top4):
    C.setM(top4, bot4, \
        matrixAddSub(Add, \
          matrixMulRecursive(A.getSon(top3, bot3), B.getSon(top2, bot2)), \
          matrixMulRecursive(A.getSon(top4, bot4), B.getSon(top4, bot4))))

  return C


A = Matrix(Coor(19, 19))
A.setRandom(10)
A.print()
B = Matrix(Coor(19, 19))
B.setRandom(10)
B.print()
matrixMul(A, B).print()
matrixMulRecursive(A, B).print()
