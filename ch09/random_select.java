
import java.util.ArrayList;
import java.util.Random;

class Select {

  private static int partition(ArrayList<Integer> v, int left, int right) {
    int i = left - 1;
    for (int j = left; j != right; j += 1) {
      if (v.get(j) < v.get(right)) {
        i += 1;
        Main.exchange(v, i, j);
      }
    }
    i += 1;
    Main.exchange(v, i, right);
    return i;
  }

  private static int random_partition(ArrayList<Integer> v,
      int left, int right) {
    int p = new Random().nextInt(right - left + 1) + left;
    Main.exchange(v, p, right);
    return partition(v, left, right);
  }

  private static Integer random_select_b(int index,
      ArrayList<Integer> v, int left, int right) {

    class Help {
      Integer rs_help(int l, int r) {
        if (l < r) {
          int p = random_partition(v, l, r);
          if (index < p) {
            rs_help(l, p - 1);
          } else if (index > p) {
            rs_help(p + 1, r);
          } //else {
            return v.get(index);
          //}
        } else {
          return v.get(index);
        }
      }
    }

    return new Help().rs_help(left, right);
  }

  public static Integer random_select(int index,
      ArrayList<Integer> v, int left, int right) {

    if (left < 0) {
      throw new IllegalArgumentException("random_select: left");
    } else if (right >= v.size()) {
      throw new IllegalArgumentException("random_select: right");
    } else if (index < left || index > right) {
      throw new IllegalArgumentException("random_select: index");
    } else {
      return random_select_b(index, v, left, right);
    }
  }
}

//--------------------------------------

class Main {

  static void insertion_sort(ArrayList<Integer> v) {
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

  static <T> void exchange(ArrayList<T> v, int i, int j) {
    T temp = v.get(i);
    v.set(i, v.get(j));
    v.set(j, temp);
  }

  static void setRandomArray(
      ArrayList<Integer> v, int size, int min, int max) {
    Random rand = new Random();
    int bound = max - min;
    for (int i = 0; i < size; i += 1) {
      v.add(rand.nextInt(bound) + min);
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

    ArrayList<Integer> A = new ArrayList<>();
    setRandomArray(A, 100, 0, 100);
    printArray(A);
    System.out.println(Select.random_select(95, A, 0, 99));
    insertion_sort(A);
    printArray(A);
  }
}
