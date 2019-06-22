
import java.util.ArrayList;

class Heap {
  ArrayList<Number> v;
  int tail;
  Heap(int len) {
    if(len < 1) {
      System.out.println("Warning: heap need length at least 1");
    }
    v = new ArrayList<>(len + 1);
    tail = len;
  }

  void setRandom() {

  }
}

class Main {
  public static void main(String[] args) {
    new Heap(5);
  }
}
