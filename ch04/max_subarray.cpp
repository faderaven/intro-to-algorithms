#include <iostream>
#include <string>
#include <stdexcept>
#include <fstream>
#include <cctype>


using std::cout; using std::cerr;
using std::string; using std::ifstream;


template <typename T>
class array {
private:
    long max_size = 10;
    T* p = new T[max_size];
    long size = 0;

    void copy(T* new_ptr, T* old_ptr, long n)
    {
        --n;
        for (; n >= 0; --n) {
            new_ptr[n] = old_ptr[n];
        }
    }
public:
    array() = default;

    array(long n) : size(n)
    {
        if (n > max_size) {
            max_size = n;
            delete[] p;
            p = new int[max_size];
        }
    }

    array(long n, int e) : size(n)
    {
        if (n > max_size) {
            max_size = n;
            delete[] p;
            p = new T[max_size];
        }
        fill(n, e);
    }

    ~array() { delete[] p; }

    long length() { return size; }

    void append(int e)
    {
        if (size == max_size) {
            max_size = max_size + max_size / 2;
            T* new_p = new T[max_size];
            copy(new_p, p, size);
            delete[] p;
            p = new_p;
        }
        p[size] = e;
        ++size;
    }

    void fill(long n, int e)
    {
        --n;
        for (; n >= 0; --n) {
            p[n] = e;
        }
    }

    T ref(long i)
    {
        if (i >= size) {
            throw std::runtime_error("index must be less length");
        }
        return p[i];
    }

    void set(long i, int e)
    {
        if (i >= size) {
            throw std::runtime_error("index must be less length");
        }
        p[i] = e;
    }

    void print()
    {
        cout << "max_size: " << max_size << "\n{ ";
        for (int i = 0; i != size; ++i) {
            cout << p[i] << ", ";
        }
        cout << "}\n";
    }
};

struct SubArray {
    long start;
    long end;
    int  sum;
};

SubArray findCrossingMax(array<int>& v, long left, long mid, long right)
{
    SubArray max = {mid, mid + 1, 0};
    int max_left = v.ref(mid), max_right = v.ref(mid+1);

    for (int i = mid, sum = 0; i >= left; --i) {
        sum = sum + v.ref(i);
        if (sum > max_left) {
            max_left = sum;
            max.start = i;
        }
    }

    for (int j = mid + 1, sum = 0; j <= right; ++j) {
        sum = sum + v.ref(j);
        if (sum > max_right) {
            max_right = sum;
            max.end = j;
        }
    }

    max.sum = max_left + max_right;
    return max;
}

SubArray findMax(array<int>& v, long left, long right)
{
    if (left == right) {
        SubArray one;
        one.start = left;
        one.end = right;
        one.sum = v.ref(left);
        return one;
    }

    long mid = (left + right) / 2;
    SubArray max_left = findMax(v, left, mid);
    SubArray max_right = findMax(v, mid + 1, right);
    SubArray max_cross = findCrossingMax(v, left, mid, right);

    if (max_left.sum >= max_right.sum &&
        max_left.sum >= max_cross.sum) {
        return max_left;
    } else if (max_right.sum >= max_left.sum &&
               max_right.sum >= max_cross.sum) {
        return max_right;
    } else {
        return max_cross;
    }
}

void readStringData(string filename)
{
    array<int> v;

    ifstream read_f(filename);
    string word;
    int c = 0;
    while ((c = read_f.get()) != EOF) {
        if (std::isspace(c) && !word.empty()) {
            v.append(std::stoi(word));
            word = "";
        } else if (!isspace(c)) {
            word.push_back(c);
        }
    }
    read_f.close();
    if (!word.empty()) {
        v.append(std::stoi(word));
    }

    v.print();

    SubArray max = findMax(v, 0, v.length() - 1);
    cout << max.start << " " << max.end << " " << max.sum << '\n';
}

int main()
{
    readStringData("test");
}
