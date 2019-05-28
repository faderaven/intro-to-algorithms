
#include <iostream>
#include <vector>
#include <string>

using std::cout; using std::vector; using std::string;

class BOX {
public:
    int a;
    int b;
    BOX() = default;
    BOX(int x, int y, vector<string> z) :
        a(x), b(y), S(z) {}

    void set(long pos, string s) {
        S.at(pos) = s;
    }

    void print() {
        cout << "a: " << a << "\n";
        cout << "b: " << b << "\n";
        cout << "the V:\n";
        for (string s : S) {
            cout << s << " ";
        }
        cout << "\n";
    }

private:
    vector<string> S;
};

BOX changed(BOX A) {
    ++A.a;
    ++A.b;
    A.set(0, "changed");
    return A;
}

BOX newObject(BOX A) {
    BOX B = A;
    ++B.a;
    ++B.b;
    B.set(0, "new changed");
    return B;
}

int main()
{
    BOX A = BOX(5, 6, vector<string>(2, "unchanged"));
    BOX B = changed(A);
    A.print();
    B.print();
    BOX C = newObject(A);
    A.print();
    C.print();
    return 0;
}
