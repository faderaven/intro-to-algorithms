
import java.util.ArrayList;
import java.util.Random;

class Sort {
  private static <T> void exchange(ArrayList<T> v, int i, int j) {
    T temp = v.get(i);
    v.set(i, v.get(j));
    v.set(j, temp);
  }

  private static void insertion(ArrayList<Double> v) {
    int n = v.size();
    if (n > 0) {
      for (int i = 1; i != n; i += 1) {
        for (int p = i - 1, q = i;
            p >= 0 && v.get(p) > v.get(q); p -= 1, q -= 1) {
          exchange(v, p, q);
        }
      }
    }
  }

  public static void bucket(ArrayList<Double> v) {

    int n = v.size();
    ArrayList<ArrayList<Double>> buk =
      new ArrayList<ArrayList<Double>>(n);
    for (int i = 0; i != n; i += 1) {
      buk.add(new ArrayList<>());
    }

    for (int i = 0; i != n; i += 1) {
      int index = (int)(n * v.get(i));
      buk.get(index).add(v.get(i));
    }

    for (int i = 0; i != n; i += 1) {
      insertion(buk.get(i));
    }

    int k = 0;
    for (int i = 0; i != n; i += 1) {
      int len = buk.get(i).size();
      for (int j = 0; j != len; j += 1) {
        v.set(k, buk.get(i).get(j));
        k += 1;
      }
    }
  }
}

//--------------------------------------

class Main {

  static void setRandomArray(
      ArrayList<Integer> v, int size, int min, int max) {
    Random rand = new Random();
    int bound = max - min;
    for (int i = 0; i < size; i += 1) {
      v.add(rand.nextInt(bound) + min);
    }
  }

  static void setRandomArray(
      ArrayList<Double> v, int size) {
    Random rand = new Random();
    for (int i = 0; i < size; i += 1) {
      v.add(rand.nextDouble());
    }
  }

  static <T> void printArray(ArrayList<T> v) {
    System.out.print("(ArrayList #");
    System.out.print(v.size() + " [");
    for (int i = 0; i < v.size(); i += 1) {
      System.out.print(v.get(i) + " ");
    }
    System.out.println("])");
  }

  public static void main(String[] args) {

    ArrayList<Double> A = new ArrayList<>();
    setRandomArray(A, 100);
    printArray(A);
    Sort.bucket(A);
    printArray(A);
  }
}
