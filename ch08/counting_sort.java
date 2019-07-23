
import java.util.ArrayList;
import java.util.Random;

class Sort {
  public static ArrayList<Integer> counting_sort(
      ArrayList<Integer> v, Integer n_max) {

    ArrayList<Integer> record = new ArrayList<>();
    for (int i = 0; i != n_max; i += 1) {
      record.add(0);
    }

    for (int i = 0; i != v.size(); i += 1) {
      int e = v.get(i);
      record.set(e, record.get(e) + 1);
    }

    for (int i = 1; i != record.size(); i += 1) {
      record.set(i, record.get(i) + record.get(i - 1));
    }

    ArrayList<Integer> out = new ArrayList<>();
    for (int i = 0; i != v.size(); i += 1) {
      out.add(0);
    }
    for (int i = 0; i != v.size(); i += 1) {
      int e = v.get(i);
      int index = record.get(e) - 1;
      out.set(index, e);
      record.set(e, index);
    }

    return out;
  }
}

//--------------------------------------

class Main {

  static void setRandomArray(ArrayList<Integer> v, int size, int bound) {
    Random rand = new Random();
    for (Integer i = 0; i < size; i = i+1) {
      v.add(rand.nextInt(bound));
    }
  }

  static void printArray(ArrayList<Integer> v) {
    System.out.print("(ArrayList #");
    System.out.print(v.size() + " [");
    for (int i = 0; i < v.size(); i = i+1) {
      System.out.print(v.get(i) + " ");
    }
    System.out.println("])");
  }


  public static void main(String[] args) {

    Integer count = 100;
    Integer n_max = 100;

    ArrayList<Integer> A = new ArrayList<>();
    setRandomArray(A, count, n_max);
    ArrayList<Integer> B = Sort.counting_sort(A, n_max);
    printArray(A);
    printArray(B);
  }
}
