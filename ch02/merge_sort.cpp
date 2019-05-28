#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <random>

#define RMIN    -0x8000
#define RMAX    0x7FFF

using std::cout;
using std::string; using std::vector;
using std::ifstream; using std::ofstream;


void makeRandomNumbers(string, int);
void lookRandomNumbers(string, int pos = 0, int n = 100);
template <class T> void sortRandomNumbers(T, string, string);
template <typename T> void mergeSort(vector<T>&, int, int);


int main()
{
    makeRandomNumbers("test", 1024 * 1024);
    sortRandomNumbers(mergeSort<int>, "test", "out-test");
    lookRandomNumbers("out-test", 512 * 1024, 512 * 1024);
    // takes about 3 seconds
}


void makeRandomNumbers(string filename, int n)
{
    std::random_device rd;
    std::mt19937_64 gen(rd());
    std::uniform_int_distribution<long> dis(RMIN, RMAX);

    ofstream output(filename,
            std::ios::out | std::ios::trunc | std::ios::binary);
    do {
        int buffer = dis(gen);
        output.write(reinterpret_cast<char*>(&buffer), sizeof(int));
    } while (--n != 0);
    output.close();
}


void lookRandomNumbers(string filename, int pos, int n)
{
    int buffer = 0;
    ifstream input(filename, std::ios::in);
    input.seekg(pos * 4);
    while (input.read(reinterpret_cast<char*>(&buffer), sizeof(int))
           && n--) {
        cout << buffer << '\n';
    }
    input.close();
}


template <class T>
void sortRandomNumbers(T sort, string in_file, string out_file)
{
    int buffer = 0;
    vector<int> v(0);

    // read random numbers
    ifstream input(in_file, std::ios::in);
    while (input.read(reinterpret_cast<char*>(&buffer), sizeof(int))) {
        v.push_back(buffer);
    }
    input.close();

    // sort random numbers
    sort(v, 0, v.size() - 1);

    // write random numbers
    ofstream output(out_file,
            std::ios::out | std::ios::trunc | std::ios::binary);
    for (auto i = v.begin(); i != v.end(); ++i) {
        buffer = v[i - v.begin()];
        output.write(reinterpret_cast<char*>(&buffer), sizeof(int));
    }
    output.close();
}


template <typename T>
void mergeSort(vector<T>& v, int left, int right)
{
    if (left < right) {
        int mid = (left + right) / 2;
        mergeSort(v, left, mid);
        mergeSort(v, mid + 1, right);

        vector<T> Lv(v.begin() + left, v.begin() + mid + 1);
        vector<T> Rv(v.begin() + mid + 1, v.begin() + right + 1);

        for (int i = 0, j = 0; left <= right; ++left) {
            if (i == Lv.size()) {
                v[left] = Rv[j];
                ++j;
            } else if (j == Rv.size()) {
                v[left] = Lv[i];
                ++i;
            } else {
                if (Lv[i] < Rv[j]) {
                    v[left] = Lv[i];
                    ++i;
                } else {
                    v[left] = Rv[j];
                    ++j;
                }
            }
        }
    }
}
