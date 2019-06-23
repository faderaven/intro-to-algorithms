
#include <iostream>
#include <vector>
#include <string>
#include <random>

using std::cout;
using std::vector; using std::string;

class Heap {
private:
    vector<int> v;
    int tail;

    int parent(int i) {
        return i / 2;
    }

    int left(int i) {
        return i * 2;
    }

    int right(int i) {
        return i * 2 + 1;
    }

public:
    Heap(int length) {
        if(length < 1) {
            cout << "Heap constructor: heap need length at least 1\n";
        } else {
            v = vector<int>(length + 1);
            tail = length;
        }
    }

    int ref(int i);
    void set(int i, int value);
    void setRandom(int min, int max);
    void append(int value);
    void exchange(int i, int j);
    void heapifyMax(int i);
    void buildMax();
    bool isMax();
    int refMax();
    int extractPriorityQueue();
    void insertPriorityQueue(int value);
    void sort();
    void print();
};

int Heap::ref(int i) {
    if(i < 1) {
        cout << "Heap ref: heap index start at 1\n";
        return 0;
    } else {
        return v.at(i);
    }
}

void Heap::set(int i, int value) {
    if(i < 1) {
        cout << "Heap set: heap index start at 1\n";
    } else {
        v.at(i) = value;
    }
}

void Heap::setRandom(int min, int max) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> dis(min, max);

    for(int i = 1; i <= tail; i = i + 1) {
        set(i, dis(gen));
    }
}

void Heap::append(int value) {
    v.push_back(value);
    tail = tail + 1;
}

void Heap::exchange(int i , int j) {
    int tmp = ref(i);
    set(i, ref(j));
    set(j, tmp);
}

void Heap::heapifyMax(int i) {
    int largest = i;
    int l = left(i);
    int r = right(i);

    if(l <= tail && ref(l) > ref(i)) {
        largest = l;
    }
    if(r <= tail && ref(r) > ref(largest)) {
        largest = r;
    }
    if(largest != i) {
        exchange(i, largest);
        heapifyMax(largest);
    }
}

void Heap::buildMax() {
    for(int i = parent(tail); i >= 1; i = i - 1) {
       heapifyMax(i);
    }
}

bool Heap::isMax() {
    for(int i = 2; i <= tail; i = i + 1) {
        if(ref(parent(i)) < ref(i)) {
            return false;
        }
    }
    return true;
}

int Heap::refMax() {
    return ref(1);
}

int Heap::extractPriorityQueue() {
    exchange(1, tail);
    int tmp = ref(tail);
    tail = tail - 1;
    heapifyMax(1);
    return tmp;
}

void Heap::insertPriorityQueue(int value) {
    v.push_back(value);
    tail = tail + 1;
    for(int i = tail;
            i >= 2 && ref(parent(i)) < ref(i);
            i = parent(i)) {
        exchange(i, parent(i));
    }
}

void Heap::sort() {
    buildMax();
    int tail_bk = tail;
    for(tail = tail - 1; tail >= 1; tail = tail - 1) {
        exchange(1, tail + 1);
        heapifyMax(1);
    }
    tail = tail_bk;
}

void Heap::print() {
    cout << "[heap " << v.size() << " " << tail << " #(";
    for(int i = 1; i <= tail; i = i+1) {
        cout << ref(i) << " ";
    }
    cout << ")]\n";
}

int main() {
    Heap A = Heap(100);
    A.setRandom(0, 999);
    A.print();

    A.buildMax();
    A.print();
    A.insertPriorityQueue(1564);
    A.print();

    A.sort();
    A.print();

    return 0;
}
