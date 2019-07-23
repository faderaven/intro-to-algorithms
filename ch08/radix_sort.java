
import java.util.ArrayList;
import java.util.Random;

class Sort {

  private static int power(int base, int times) {
    if (times == 0) {
      return 1;
    } else {
      return base * power(base, times - 1);
    }
  }

  private static int extract_b(int n, int digit) {
    int p1 = power(10, digit);
    int p2 = power(10, digit - 1);
    return ((n % p1) - (n % p2)) / p2;
  }

  private static int extract(int n, int digit) {
    if (n < 0) {
      throw new IllegalArgumentException(
          "extract: n must be a positive integer");
    } else if (digit < 1) {
      throw new IllegalArgumentException(
          "extract: digit at least 1");
    } else {
      return extract_b(n, digit);
    }
  }

  private static ArrayList<Integer> counting_stable(
      ArrayList<Integer> in, int d) {

    ArrayList<Integer> record = new ArrayList<>();
    for (int i = 0; i != 10; i += 1) {
      record.add(0);
    }
    for (int i = 0; i != in.size(); i += 1) {
      int n = extract(in.get(i), d);
      record.set(n, record.get(n) + 1);
    }

    for (int i = 1; i != record.size(); i += 1) {
      Integer cur = record.get(i);
      Integer pre = record.get(i - 1);
      record.set(i, cur + pre);
    }

    ArrayList<Integer> out = new ArrayList<>();
    for (int i = 0; i != in.size(); i += 1) {
      out.add(0);
    }
    for (int i = in.size() - 1; i >= 0; i -= 1) {
      int n = extract(in.get(i), d);
      int index = record.get(n) - 1;
      out.set(index, in.get(i));
      record.set(n, index);
    }

    return out;
  }

  public static ArrayList<Integer> radix_sort(ArrayList<Integer> in, int digits) {
    for (int i = 1; i <= digits; i += 1) {
      in = counting_stable(in, i);
    }
    return in;
  }
}

//--------------------------------------

class Main {

  static void setRandomArray(
      ArrayList<Integer> v, int size, int n_min, int n_max) {
    Random rand = new Random();
    int bound = n_max - n_min;
    for (int i = 0; i < size; i += 1) {
      v.add(rand.nextInt(bound) + n_min);
    }
  }

  static void printArray(ArrayList<Integer> v) {
    System.out.print("(ArrayList #");
    System.out.print(v.size() + " [");
    for (int i = 0; i < v.size(); i += 1) {
      System.out.print(v.get(i) + " ");
    }
    System.out.println("])");
  }

  public static void main(String[] args) {
    int n_min = 100;
    int n_max = 10000;
    int count = 100;
    int digits = 4;

    ArrayList<Integer> A = new ArrayList<>();
    setRandomArray(A, count, n_min, n_max);
    printArray(A);
    ArrayList<Integer> B = Sort.radix_sort(A, digits);
    printArray(B);
  }
}
