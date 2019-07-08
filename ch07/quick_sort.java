
import java.util.ArrayList;
import java.util.Random;

abstract class Compare {
  abstract boolean apply(Object n, Object m);
}

class Greater extends Compare {
  boolean apply(Object n, Object m) {
    if (n instanceof Long &&
        m instanceof Long) {
      return ((Long)n).compareTo((Long) m) > 0;
    }
    else if ( n instanceof Double &&
              m instanceof Double) {
      return ((Double)n).compareTo((Double) m) > 0;
    }
    else if ( n instanceof String &&
              m instanceof String) {
      return ((String)n).compareTo((String) m) > 0;
    }
    else {
      throw new IllegalArgumentException
        ("Greater.apply : wrong argument types");
    }
  }
}

class Less extends Compare {
  boolean apply(Object n, Object m) {
    if (n instanceof Long &&
        m instanceof Long) {
      return ((Long)n).compareTo((Long) m) < 0;
    }
    else if ( n instanceof Double &&
              m instanceof Double) {
      return ((Double)n).compareTo((Double) m) < 0;
    }
    else if ( n instanceof String &&
              m instanceof String) {
      return ((String)n).compareTo((String) m) < 0;
    }
    else {
      throw new IllegalArgumentException
        ("Less.apply : wrong argument types");
    }
  }
}

class Sort {
  private abstract class Partition {
    abstract int partition(Compare cmp, ArrayList<Object> v, int l, int r);
  }

  private class Normal_Part extends Partition {
    int partition(Compare cmp, ArrayList<Object> v, int l, int r) {
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
    int partition(Compare cmp, ArrayList<Object> v, int l, int r) {
      return new Normal_Part().partition(cmp, v, l, r);
    }
  }

  void quick_sort(Partition part, ArrayList<Object> v,
                         int l, int r) {
    if (l < r) {
      int q = part.partition(v, l, r);
      quick_sort(part, v, l, q - 1);
      quick_sort(part, v, q + 1, r);
    }
  }
}

//-----------------------------------

class Main {
  public static void main(String[] args) {
    Long k = 5L;
    String a = "abc";
    String b = "abd";
    System.out.println(new Greater(b, a).apply());
  }
}
