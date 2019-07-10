
import java.util.ArrayList;
import java.util.Random;

abstract class Compare {
  abstract boolean apply(BaseData n, BaseData m);
}

class Greater extends Compare {
  boolean apply(BaseData n, BaseData m) {
    return n.greater(m);
  }
}

class Less extends Compare {
  boolean apply(BaseData n, BaseData m) {
    return n.less(m);
  }
}

class Sort {
  private abstract class Partition {
    abstract int partition(Compare cmp, ArrayList<BaseData> v, int l, int r);
  }

  private class Normal_Part extends Partition {
    int partition(Compare cmp, ArrayList<BaseData> v, int l, int r) {
      int i = l - 1;
      for (int j = l; j <= r; j = j+1) {
        if (cmp.apply(v.get(j), v.get(r))) {
          i = i + 1;
          exchange(v, i, j);
        }
      }
      exchange(v, i + 1, r);
      return i + 1;
    }
  }

  private class Random_Part extends Partition {
    int partition(Compare cmp, ArrayList<BaseData> v, int l, int r) {
      int q = new Random().nextInt(r - l + 1) + l;
      exchange(v, q, r);
      return new Normal_Part().partition(cmp, v, l, r);
    }
  }

  private void exchange(ArrayList<BaseData> v, int i, int j) {
    BaseData temp = v.get(i);
    v.set(i, v.get(j));
    v.set(j, temp);
  }

  private void quick_sort(Compare cmp, Partition part,
      ArrayList<BaseData> v, int l, int r) {
    if (l < r) {
      int q = part.partition(cmp, v, l, r);
      quick_sort(cmp, part, v, l, q - 1);
      quick_sort(cmp, part, v, q + 1, r);
    }
  }

  public void quick_sort_desc(ArrayList<BaseData> v) {
    quick_sort(new Greater(), new Normal_Part(), v, 0, v.size() - 1);
  }

  public void quick_sort_asc(ArrayList<BaseData> v) {
    quick_sort(new Less(), new Normal_Part(), v, 0, v.size() - 1);
  }

  public void random_quick_sort_desc(ArrayList<BaseData> v) {
    quick_sort(new Greater(), new Random_Part(), v, 0, v.size() - 1);
  }

  public void random_quick_sort_asc(ArrayList<BaseData> v) {
    quick_sort(new Less(), new Random_Part(), v, 0, v.size() - 1);
  }
}

abstract class BaseData {
  Object o;
  BaseData (Object _o) {
    o = _o;
  }

  abstract boolean equal(BaseData second);
  abstract boolean greater(BaseData second);
  abstract boolean less(BaseData second);
  abstract void display();
}

class Exact32 extends BaseData {
  Exact32(Object _o) {
    super(_o);
  }

  int value() {
    return ((Integer)o).intValue();
  }

  int compareTo(Exact32 second) {
    return this.value() - second.value();
  }

  boolean equal(BaseData second) {
    return this.compareTo((Exact32) second) == 0;
  }

  boolean greater(BaseData second) {
    return this.compareTo((Exact32) second) > 0;
  }

  boolean less(BaseData second) {
    return this.compareTo((Exact32) second) < 0;
  }

  void display() {
    System.out.print(this.value());
  }
}

class Inexact64 extends BaseData {
  Inexact64(Object _o) {
    super(_o);
  }

  double value() {
    return ((Double) o).doubleValue();
  }

  double compareTo(Inexact64 second) {
    return this.value() - second.value();
  }

  boolean equal(BaseData second) {
    return this.compareTo((Inexact64) second) == 0;
  }

  boolean greater(BaseData second) {
    return this.compareTo((Inexact64) second) > 0;
  }

  boolean less(BaseData second) {
    return this.compareTo((Inexact64) second) < 0;
  }

  void display() {
    System.out.print(this.value());
  }
}

class STR extends BaseData {
  STR(Object _o) {
    super(_o);
  }

  String value() {
    return (String) o;
  }

  int compareTo(STR second) {
    return this.value().compareTo(second.value());
  }

  boolean equal(BaseData second) {
    return this.compareTo((STR) second) == 0;
  }

  boolean greater(BaseData second) {
    return this.compareTo((STR) second) > 0;
  }

  boolean less(BaseData second) {
    return this.compareTo((STR) second) < 0;
  }

  void display() {
    System.out.print(this.value());
  }
}

//-----------------------------------

class Main {
  static void setArray(ArrayList<BaseData> v,
      int size, int bound) {
    Random rand = new Random();
    for (int i = 0; i < size; i = i+1) {
      v.add(new Exact32(rand.nextInt(bound)));
    }
  }

  static void printArray(ArrayList<BaseData> v) {
    System.out.print("(ArrayList #");
    System.out.print(v.size() + " [");
    for (int i = 0; i < v.size(); i = i+1) {
      v.get(i).display();
      System.out.print(" ");
    }
    System.out.println("])");
  }

  public static void main(String[] args) {
    ArrayList<BaseData> v = new ArrayList<>();

    setArray(v, 100, 1000);
    printArray(v);

    Sort s = new Sort();
    s.quick_sort_asc(v);
    printArray(v);
    s.quick_sort_desc(v);
    printArray(v);
    s.random_quick_sort_asc(v);
    printArray(v);
    s.random_quick_sort_desc(v);
    printArray(v);
  }
}
