
import java.util.ArrayList;
import java.util.Random;

class Heap {
  ArrayList<Number> v;
  int tail;

  Heap(int len) {
    if(len < 1) {
      throw new IllegalArgumentException
        ("Heap constructor: heap need length at least 1");
    }
    v = new ArrayList<>();
    tail = len;
    for(int i = 1; i <= len + 1; i = i+1) {
      v.add(0); // int auto convert to Number?
    }
  }

  //------------------------------

  private int left(int i) { return i*2; }
  private int right(int i) { return i*2+1; }
  private int parent(int i) { return i/2; }

  private boolean greater(int i, int j) {
    if (v.get(i) instanceof Integer) {
      return v.get(i).intValue() > v.get(j).intValue();
    } else {
      return v.get(i).floatValue() > v.get(j).floatValue();
    }
  }

  private boolean less(int i, int j) {
    if (v.get(i) instanceof Integer) {
      return v.get(i).intValue() < v.get(j).intValue();
    } else {
      return v.get(i).floatValue() < v.get(j).floatValue();
    }
  }

  private void exchange(int i, int j) {
    Number temp = v.get(i);
    v.set(i, v.get(j));
    v.set(j, temp);
  }

  void heapifyMax(int i) {
    int l = left(i);
    int r = right(i);
    int largest = i;

    if(l <= tail && greater(l, i)) {
      largest = l;
    }
    if(r <= tail && greater(r, largest)) {
      largest = r;
    }
    if( largest != i ) {
      exchange(i, largest);
      heapifyMax(largest);
    }
  }

  void buildMax() {
    for(int i = parent(tail); i >= 1; i = i-1) {
      heapifyMax(i);
    }
  }

  boolean isMax() {
    for(int i = 2; i <= tail; i = i+1) {
      if(less(parent(i), i)) {
        return false;
      }
    }
    return true;
  }

  void sort() {
    int tail_BK = tail;
    buildMax();
    for(tail = tail-1; tail >= 1; tail = tail-1) {
      exchange(1, tail + 1);
      heapifyMax(1);
    }
    tail = tail_BK;
  }

  Number extractPriorityQueue() {
    Number temp = v.get(1);
    exchange(1, tail);
    v.remove(tail);
    tail = tail - 1;
    heapifyMax(1);
    return temp;
  }

  void insertPriorityQueue(Number value) {
    v.add(value);
    tail = tail + 1;
    for(int i = tail;
        i <= 2 && less(parent(i), i);
        i = parent(i)) {
      exchange(i, parent(i));
    }
  }

  //------------------------------

  private Random rand = new Random();

  void setRandom(int min, int max) {
    int bound = max - min + 1;
    for(int i = 1; i <= tail; i = i+1) {
      v.set(i, (Integer)rand.nextInt(bound) + min);
    }
  }

  void setRandom() {
    for(int i = 1; i <= tail; i = i+1) {
      v.set(i, (Float)rand.nextFloat());
    }
  }

  void print() {
    System.out.print("(Heap: #" + tail + " [");
    for(int i = 1; i <= tail; i = i+1) {
      System.out.print(v.get(i) + " ");
    }
    System.out.println("])");
  }
}

class Main {
  public static void main(String[] args) {
    Heap x = new Heap(100);
    x.setRandom(0, 999);
    x.print();
    x.sort();
    x.print();
  }
}
