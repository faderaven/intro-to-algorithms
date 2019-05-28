
#include <iostream>
#include <vector>
#include <string>
#include <random>

using std::cout;
using std::vector; using std::string;
using SIZE = long;


struct Coor {
    SIZE row;
    SIZE col;

    Coor() = default;
    Coor(SIZE r, SIZE c) : row(r), col(c) {}
};


class Matrix {
public:
    const Coor point;
private:
    vector<long> v;

    Matrix son(Coor top, Coor bot) {
        Coor size;
        size.row = bot.row - top.row + 1;
        size.col = bot.col - top.col + 1;

        Matrix B = Matrix(size);
        Coor posA = top;
        Coor posB = Coor(0, 0);
        for (; posB.row != size.row; ++posA.row, ++posB.row) {
            for (posA.col = top.col, posB.col = 0;
                    posB.col != size.col; ++posA.col, ++posB.col) {
                B.set(posB, this->ref(posA));
            }
        }

        return B;
    }

public:
    Matrix(Coor p) : point(p) { v = vector<long>(p.row * p.col, 0); }
    Matrix() : Matrix(Coor(0, 0)) {}
    bool null();
    bool valid(Coor);
    long ref(Coor);
    void set(Coor, long);
    void set(Coor, Coor, Matrix);
    void setRandom(long, long);
    Matrix scale(int);
    Matrix getSon(Coor, Coor);
    void print();
};


bool Matrix::null() {
    if (this->point.row == 0 || this->point.col == 0) {
        return true;
    }

    return false;
}

bool Matrix::valid(Coor pos) {
    if (pos.row >= 0 && pos.row < this->point.row &&
            pos.col >= 0 && pos.col < this->point.col) {
        return true;
    }

    return false;
}

long Matrix::ref(Coor pos) {
    return this->v.at(pos.row * this->point.col + pos.col);
}

void Matrix::set(Coor pos, long e) {
    this->v.at(pos.row * this->point.col + pos.col) = e;
}

void Matrix::set(Coor top, Coor bot, Matrix B) {
    Coor size;
    bot.row = std::min(bot.row, this->point.row - 1);
    bot.col = std::min(bot.col, this->point.col - 1);
    size.row = std::min(bot.row - top.row + 1, B.point.row);
    size.col = std::min(bot.col - top.col + 1, B.point.col);

    Coor posA = top;
    Coor posB = Coor(0, 0);
    for (; posB.row != size.row; ++posA.row, ++posB.row) {
        for (posA.col = top.col, posB.col = 0;
                posB.col != size.col; ++posA.col, ++posB.col) {
            this->set(posA, B.ref(posB));
        }
    }
}

void Matrix::setRandom(long rmin, long rmax) {
    std::random_device rd;
    std::mt19937_64 gen(rd());
    std::uniform_int_distribution<long> dis(rmin, rmax);

    Coor pos = Coor(0, 0);
    for (; pos.row != this->point.row; ++pos.row) {
        for (pos.col = 0; pos.col != this->point.col; ++pos.col) {
            this->set(pos, dis(gen));
        }
    }
}

Matrix Matrix::scale(int n) {
    Matrix C = Matrix(this->point);

    Coor pos = Coor(0, 0);
    for (;pos.row != C.point.row; ++pos.row) {
        for (pos.col = 0; pos.col != C.point.col; ++pos.col) {
            C.set(pos, n * this->ref(pos));
        }
    }

    return C;
}

Matrix Matrix::getSon(Coor top, Coor bot) {
    if (this->valid(top)) {
        Coor valid_bot;
        valid_bot.row = std::min(bot.row, this->point.row - 1);
        valid_bot.col = std::min(bot.col, this->point.col - 1);
        return this->son(top, valid_bot);
    }
    return Matrix();
}

void Matrix::print() {
    Coor pos = Coor(0, 0);
    cout << "matrix:\n";
    for (; pos.row != this->point.row; ++pos.row) {
        for (pos.col = 0; pos.col != this->point.col; ++pos.col) {
            cout << " " << this->ref(pos);
        }
        cout << "\n";
    }
}

template<typename T> T mid(T n) {
    if (n % 2 == 1) {
        return n / 2 + 1;
    }
    return n / 2;
}

Matrix matrix_Add_Sub(string p, Matrix A, Matrix B) {
    Coor size;
    size.row = std::max(A.point.row, B.point.row);
    size.col = std::max(A.point.col, B.point.col);

    Matrix C = Matrix(size);

    Coor pos = Coor(0, 0);
    for (; pos.row != size.row; ++pos.row) {
        for (pos.col = 0; pos.col != size.col; ++pos.col) {
            if (A.valid(pos) && B.valid(pos)) {
                if (p == "+") {
                    C.set(pos, A.ref(pos) + B.ref(pos));
                } else if (p == "-") {
                    C.set(pos, A.ref(pos) - B.ref(pos));
                }
            } else if (A.valid(pos)) {
                C.set(pos, A.ref(pos));
            } else if (B.valid(pos)) {
                C.set(pos, B.ref(pos));
            }
        }
    }

    return C;
}

Matrix matrixAddSub (string p, Matrix A, Matrix B) {
    if (A.null()) {
        if (p == "-") {
            return B.scale(-1);
        } else if (p == "+") {
            return B;
        }
    } else if (B.null()) {
        return A;
    }
    return matrix_Add_Sub(p, A, B);
}

Matrix matrixMulStrassen(Matrix A, Matrix B) {
    SIZE n = std::max(std::max(A.point.row, A.point.col),
                      std::max(B.point.row, B.point.col));
    Matrix C = Matrix(Coor(A.point.row, B.point.col));

    Coor top1 = Coor(0, 0);
    Coor bot1 = Coor(mid(n) - 1, mid(n) - 1);
    Coor top2 = Coor(0, mid(n));
    Coor bot2 = Coor(mid(n) - 1, n - 1);
    Coor top3 = Coor(mid(n), 0);
    Coor bot3 = Coor(n - 1, mid(n) - 1);
    Coor top4 = Coor(mid(n), mid(n));
    Coor bot4 = Coor(n - 1, n - 1);

    if (C.null()) {
        return C;
    } else if (1 == n) {
        C.set(top1, A.ref(top1) * B.ref(top1));
        return C;
    }

    Matrix A1 = A.getSon(top1, bot1);
    Matrix A2 = A.getSon(top2, bot2);
    Matrix A3 = A.getSon(top3, bot3);
    Matrix A4 = A.getSon(top4, bot4);
    Matrix B1 = B.getSon(top1, bot1);
    Matrix B2 = B.getSon(top2, bot2);
    Matrix B3 = B.getSon(top3, bot3);
    Matrix B4 = B.getSon(top4, bot4);

    Matrix S1 = matrixAddSub("-", B2, B4);
    Matrix S2 = matrixAddSub("+", A1, A2);
    Matrix S3 = matrixAddSub("+", A3, A4);
    Matrix S4 = matrixAddSub("-", B3, B1);
    Matrix S5 = matrixAddSub("+", A1, A4);
    Matrix S6 = matrixAddSub("+", B1, B4);
    Matrix S7 = matrixAddSub("-", A2, A4);
    Matrix S8 = matrixAddSub("+", B3, B4);
    Matrix S9 = matrixAddSub("-", A1, A3);
    Matrix S10 = matrixAddSub("+", B1, B2);

    Matrix P1 = matrixMulStrassen(A1, S1);
    Matrix P2 = matrixMulStrassen(S2, B4);
    Matrix P3 = matrixMulStrassen(S3, B1);
    Matrix P4 = matrixMulStrassen(A4, S4);
    Matrix P5 = matrixMulStrassen(S5, S6);
    Matrix P6 = matrixMulStrassen(S7, S8);
    Matrix P7 = matrixMulStrassen(S9, S10);

    C.set(top1, bot1,
          matrixAddSub("+",
              matrixAddSub("-",
                  matrixAddSub("+", P5, P4), P2), P6));

    if (C.valid(top2)) {
        C.set(top2, bot2,
              matrixAddSub("+", P1, P2));
    }

    if (C.valid(top3)) {
        C.set(top3, bot3,
              matrixAddSub("+", P3, P4));
    }

    if (C.valid(top4)) {
        C.set(top4, bot4,
              matrixAddSub("-",
                  matrixAddSub("-",
                      matrixAddSub("+", P5, P1), P3), P7));
    }

    return C;
}

int main()
{
    Matrix A = Matrix(Coor(10, 15));
    A.setRandom(0, 9);
    Matrix B = Matrix(Coor(15, 20));
    B.setRandom(0, 9);
    A.print();
    B.print();
    matrixMulStrassen(A, B).print();

    return 0;
}
