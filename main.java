import java.util.ArrayList;


class Foo {
  private int a;
  private String state;

  Foo(int a, String state) {
    this.a = a;
    this.state = state;
  }

  public int get_a() {
    return this.a;
  }
  public String get_s() {
    return this.state;
  }

  public void set_a(int a) {
    this.a = a;
  }
  public void set_s(String s) {
    this.state = s;
  }
  public void print() {
    System.out.println("Foo:" + this.a + " " + this.state);
  }
}

class Run {
  static void parameter(Foo A) {
    A.set_a(5);
    A.set_s("Change as parameter");
  }

  public static void main(String[] args) {
    Foo A = new Foo(4, "OK");
    Foo B = new Foo(5, "NO");
    Foo C = A;
    C.set_a(14);
    A.print();
    B = A;
    B.set_a(15);
    A.print();
  }
}
