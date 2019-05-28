import java.util.ArrayList;
import java.util.Random;
import java.lang.Math;

class Coor {
    public int row;
    public int col;

    Coor(int row, int col) {
        this.row = row;
        this.col = col;
    }

    public Coor copy() {
      return new Coor(this.row, this.col);
    }
}

class Matrix {
    private Coor point;
    private ArrayList<Integer> v;

    Matrix() {
        point = new Coor(0, 0);
    }

    Matrix(Coor size) {
        point = size.copy();
        v = new ArrayList<Integer>();

        for (int row = 0; row < point.row; ++row) {
          for (int col = 0; col < point.col; ++col) {
            v.add(0);
          }
        }
    }

    public int getRow() {
        return this.point.row;
    }

    public int getCol() {
        return this.point.col;
    }

    public boolean isNull() {
        if (this.point.row == 0 || this.point.col == 0) {
            return true;
        }
        return false;
    }

    public boolean isSame(Matrix B) {
      if (this.point.row == B.getRow() &&
          this.point.col == B.getCol()) {
        return true;
      }
      return false;
    }

    public Integer ref(Coor pos) {
        return this.v.get(pos.row * this.point.col + pos.col);
    }

    public void set(Coor pos, Integer e) {
      this.v.set(pos.row * this.point.col + pos.col, e);
    }

    public void set(Coor top, Coor bot, Matrix B) {
      Coor valid_bot = new Coor(Math.min(bot.row, this.point.row - 1),
                                Math.min(bot.col, this.point.col - 1));
      Coor size = new Coor(Math.min(valid_bot.row - top.row + 1, B.getRow()),
                           Math.min(valid_bot.col - top.col + 1, B.getCol()));
      Coor posA = top.copy();
      Coor posB = new Coor(0, 0);
      for (; posB.row != size.row; ++posA.row, ++posB.row) {
        for (posA.col = top.col, posB.col = 0;
            posB.col != size.col; ++posA.col, ++posB.col) {
          this.set(posA, B.ref(posB));
        }
      }
    }

    public void setRandom(int max) {
      Random rand = new Random();

      Coor pos = new Coor(0, 0);
      for (; pos.row != this.getRow(); ++pos.row) {
        for (pos.col = 0; pos.col < this.getCol(); ++pos.col) {
          this.set(pos, rand.nextInt(max));
        }
      }
    }

    public boolean validCoor(Coor pos) {
        if (pos.row >= 0 &&
              pos.col >= 0 &&
              pos.row < this.point.row &&
              pos.col < this.point.col) {
            return true;
            }
        return false;
    }

  private Matrix sonof(Coor top, Coor bot) {
    Coor size = new Coor(bot.row - top.row + 1,
                         bot.col - top.col + 1);
    Matrix B = new Matrix(size);

    Coor posA = top.copy();
    Coor posB = new Coor(0, 0);
    for (; posB.row != size.row; ++posA.row, ++posB.row) {
      for (posA.col = top.col, posB.col = 0;
           posB.col != size.col; ++posA.col, ++posB.col) {
        B.set(posB, this.ref(posA));
      }
    }
    return B;
  }

  public Matrix getSon(Coor top, Coor bot) {
    if (this.validCoor(top)) {
      int r_bot = Math.min(bot.row, this.point.row - 1);
      int c_bot = Math.min(bot.col, this.point.col - 1);
      return this.sonof(top, new Coor(r_bot, c_bot));
    }
    return new Matrix(new Coor(0, 0));
  }

  public void print() {
    System.out.println("Matrix:");

    Coor pos = new Coor(0, 0);
    for (; pos.row != this.getRow(); ++pos.row) {
      for (pos.col = 0; pos.col != this.getCol(); ++pos.col) {
        System.out.format(" %d", this.ref(pos));
      }
      System.out.println();
    }
  }
}

class MatrixRun {

    static int mid(int n) {
        if (n % 2 == 1) {
            return n / 2 + 1;
        }
        return n / 2;
    }

    public static Matrix matrixAddDetail(Matrix A, Matrix B) {
      Matrix C = new Matrix(new Coor(A.getRow(),
                                     B.getCol()));

      Coor pos = new Coor(0, 0);
      for (; pos.row < A.getRow(); ++pos.row) {
        for (pos.col = 0; pos.col < A.getCol(); ++pos.col) {
          C.set(pos, A.ref(pos) + B.ref(pos));
        }
      }
      return C;
    }

    public static Matrix matrixAdd(Matrix A, Matrix B) {
      if (A.isNull()) {
        return B;
      } else if (B.isNull()) {
        return A;
      } else if (!A.isSame(B)) {
        System.out.println("not same size matrix cannot add");
        return new Matrix();
      }
      return matrixAddDetail(A, B);
    }

    public static Matrix matrixMulRecursive (Matrix A, Matrix B) {
        int n = Math.max(Math.max(A.getRow(), A.getCol()),
                         Math.max(B.getRow(), B.getCol()));
        Matrix C = new Matrix(new Coor(A.getRow(), B.getCol()));

        Coor top1 = new Coor(0, 0);
        Coor bot1 = new Coor(mid(n) - 1, mid(n) - 1);
        Coor top2 = new Coor(0, mid(n));
        Coor bot2 = new Coor(mid(n) - 1, n - 1);
        Coor top3 = new Coor(mid(n), 0);
        Coor bot3 = new Coor(n - 1, mid(n) - 1);
        Coor top4 = new Coor(mid(n), mid(n));
        Coor bot4 = new Coor(n - 1, n - 1);

        if (C.isNull()) {
            return C;
        } else if (n == 1) {
            C.set(top1, A.ref(top1) * B.ref(top1));
            return C;
        }

        C.set(top1, bot1,
                matrixAdd(matrixMulRecursive(A.getSon(top1, bot1),
                                             B.getSon(top1, bot1)),
                          matrixMulRecursive(A.getSon(top2, bot2),
                                             B.getSon(top3, bot3))));
        if (C.validCoor(top2)) {
          C.set(top2, bot2,
                matrixAdd(matrixMulRecursive(A.getSon(top1, bot1),
                                             B.getSon(top2, bot2)),
                          matrixMulRecursive(A.getSon(top2, bot2),
                                             B.getSon(top4, bot4))));
        }
        if (C.validCoor(top3)) {
          C.set(top3, bot3,
                matrixAdd(matrixMulRecursive(A.getSon(top3, bot3),
                                             B.getSon(top1, bot1)),
                          matrixMulRecursive(A.getSon(top4, bot4),
                                             B.getSon(top3, bot3))));
        }
        if (C.validCoor(top4)) {
          C.set(top4, bot4,
                matrixAdd(matrixMulRecursive(A.getSon(top3, bot3),
                                             B.getSon(top2, bot2)),
                          matrixMulRecursive(A.getSon(top4, bot4),
                                             B.getSon(top4, bot4))));
        }
        return C;
    }

  public static Matrix matrixMul (Matrix A, Matrix B) {
    Coor size = new Coor(A.getRow(), B.getCol());
    Matrix C = new Matrix(size);

    for (int r = 0; r < size.row; ++r) {
      for (int c = 0; c < size.col; ++c) {
        Integer sum = 0;
        for (int n = 0; n < A.getCol(); ++n) {
          sum += A.ref(new Coor(r, n)) * B.ref(new Coor(n, c));
        }
        C.set(new Coor(r, c), sum);
      }
    }

    return C;
  }

  public static void main(String[] args) {
    Matrix A = new Matrix(new Coor(19, 19));
    A.setRandom(10);
    A.print();

    Matrix B = new Matrix(new Coor(19, 19));
    B.setRandom(10);
    B.print();

    Matrix C = matrixMul(A, B);
    C.print();
    Matrix D = matrixMulRecursive(A, B);
    D.print();
  }
}
