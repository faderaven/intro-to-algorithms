
import io

class MaxInfo:
  def __init__(self, begin, end, gross):
    self.begin = begin
    self.end = end
    self.gross = gross

def findCrossisgMax(v, low, mid, high):
  max_cross = MaxInfo(mid, mid + 1, 0)
  sum_left = v[mid]
  sum_right = v[mid + 1]

  gross = 0
  for i in range(mid, low - 1, -1):
    gross = gross + v[i]
    if gross > sum_left:
      sum_left = gross
      max_cross.begin = i

  gross = 0
  for j in range(mid+1, high+1):
    gross = gross + v[j]
    if gross > sum_right:
      sum_right = gross
      max_cross.end = j

  max_cross.gross = sum_left + sum_right
  return max_cross

def findMax(v, low, high):
  if low == high:
    one = MaxInfo(low, high, v[low])
    return one

  mid = (low + high) // 2
  max_low = findMax(v, low, mid)
  max_high = findMax(v, mid + 1, high)
  max_cross = findCrossisgMax(v, low, mid, high)

  if max_low.gross >= max_high.gross and \
     max_low.gross >= max_cross.gross:
    return max_low
  elif max_high.gross >= max_low.gross and \
       max_high.gross >= max_cross.gross:
    return max_high
  else:
    return max_cross

def readStringData(filename):
  v = []

  inf = io.open(filename, "r", encoding="utf-8")
  number = ""
  while True:
    line = inf.readline()
    if not line: break
    for c in line:
      if c.isspace() and number != "":
        v.append(int(number))
        number = ""
      elif not c.isspace():
        number = number + c
  inf.close()

  maxsub = findMax(v, 0, len(v) - 1)
  print(maxsub.begin, maxsub.end, maxsub.gross)


readStringData("test")
