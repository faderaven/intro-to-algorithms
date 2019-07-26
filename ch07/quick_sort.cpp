
#include <iostream>
#include <vector>
#include <random>

using std::cout;
using std::vector; using std::string;

struct CMP {
    virtual bool compare(int, int) = 0;
};

struct Greater : CMP {
    virtual bool compare(int n, int m) {
        return n > m;
    }
};

struct Less : CMP {
    virtual bool compare(int n, int m) {
        return n < m;
    }
};

void exchange(vector<int>& v, int i, int j) {
    int temp = v[i];
    v[i] = v[j];
    v[j] = temp;
}

int partition(CMP* c,
        vector<int>& v, int l, int r) {
    int i = l - 1;
    for (int j = l; j < r; j = j+1) {
        if (c->compare(v[j], v[r])) {
            i = i + 1;
            exchange(v, i, j);
        }
    }
    exchange(v, i + 1, r);
    return i + 1;
}

int random(int min, int max) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> dis(min, max);

    return dis(gen);
}

int random_partition(CMP* c,
        vector<int>& v, int l, int r) {
    int p = random(l, r);
    exchange(v, p, r);
    return partition(c, v, l, r);
}

void quick_sort(CMP* c,
        vector<int>& v, int l, int r) {
    if (l < r) {
        int q = partition(c, v, l, r);
        quick_sort(c, v, l, q - 1);
        quick_sort(c, v, q + 1, r);
    }
}

void r_quick_sort(CMP* c,
        vector<int>& v, int l, int r) {
    if (l < r) {
        int q = random_partition(c, v, l, r);
        r_quick_sort(c, v, l, q - 1);
        r_quick_sort(c, v, q + 1, r);
    }
}

void quick_sort_asc(vector<int>& v) {
    CMP* greater = new Greater();
    quick_sort(greater, v, 0, v.size() - 1);
}

void quick_sort_desc(vector<int>& v) {
    CMP* less = new Less();
    quick_sort(less, v, 0, v.size() - 1);
}

void random_quick_sort_asc(vector<int>& v) {
    CMP* greater = new Greater();
    quick_sort(greater, v, 0, v.size() - 1);
}

void random_quick_sort_desc(vector<int>& v) {
    CMP* less = new Less();
    quick_sort(less, v, 0, v.size() - 1);
}

//-----------------------------------

void set_vector(vector<int>& v, int size, int min, int max) {
    for (int i = 0; i < size; i = i+1) {
        v.push_back(random(min, max));
    }
}

void print_vector(vector<int>& v) {
    cout << "(vector #";
    cout << v.size() << " [";
    for (int i = 0; i < (int)v.size(); i = i+1) {
        cout << v[i] << " ";
    }
    cout << "])\n";
}

int main() {
    vector<int> v;
    set_vector(v, 100, 0, 999);
    print_vector(v);
    quick_sort_asc(v);
    print_vector(v);
    quick_sort_desc(v);
    print_vector(v);
    random_quick_sort_asc(v);
    print_vector(v);
    random_quick_sort_desc(v);
    print_vector(v);
    return 0;
}
