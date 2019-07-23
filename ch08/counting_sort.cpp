
#include <iostream>
#include <vector>
#include <random>

using std::cout;
using std::vector; using std::string;

void counting_sort(vector<int>& v, vector<int>& out, int n_max) {
    vector<int> record;

    for (int i = 0; i <= n_max; i += 1) {
        record.push_back(0);
    }

    for (int i = 0; i != (int)v.size(); i += 1) {
        record[v[i]] = record[v[i]] + 1;
    }

    for (int i = 1; i != (int)record.size(); i += 1) {
        record[i] = record[i] + record[i - 1];
    }

    for (int i = 0; i != (int)v.size(); i += 1) {
        int index = record[v[i]] - 1;
        record[v[i]] = index;
        out[index] = v[i];
    }
}

//--------------------------------------

int random(int min, int max) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> dis(min, max);

    return dis(gen);
}

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
    int count = 100;
    int n_max = 99;

    vector<int> A;
    set_vector(A, count, 0, n_max);
    vector<int> B(count, 0);
    counting_sort(A, B, n_max);
    print_vector(A);
    print_vector(B);
    return 0;
}
