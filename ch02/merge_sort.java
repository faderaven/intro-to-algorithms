
import java.io.*;
import java.lang.Integer;
import java.security.SecureRandom;
import java.util.ArrayList;

class MergeSort {
    public static void main(String[] args) {
        sortTest t = new sortTest();
        t.makeRandomNumbers("test", 1024 * 1024);
        t.sortRandomNumbers(t::mergeSort, "test", "out-test");
        t.lookRandomNumbers("out-test", 512 * 1024);
        // take about 33 seconds
    }

}

class sortTest {
    public static int iMin = -0x8000;
    public static int iMax = 0x7FFF;

    public int newRandom(int min, int max)
    {
        SecureRandom gen = new SecureRandom();
        return gen.nextInt(max - min + 1) + min;
    }

    public void makeRandomNumbers(String filename, int n)
    {
        try {
            DataOutputStream os =
                new DataOutputStream(new FileOutputStream(filename));
            while (n != 0) {
                os.writeInt(newRandom(iMin, iMax));
                --n;
            }
            os.close();
        } catch (FileNotFoundException e) {
            System.err.println("FileNotFoundException: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("IOException: " + e.getMessage());
        }
    }

    public void lookRandomNumbers(String filename, int pos, int n)
    {
        try {
            DataInputStream is =
                new DataInputStream(new FileInputStream(filename));
            is.skipBytes(pos * 4);
            long len = new File(filename).length() / 4;
            for (; len != 0 && n != 0; --len, --n) {
                System.out.println(is.readInt());
            }
            is.close();
        } catch (FileNotFoundException e) {
            System.err.println("FileNotFoundException: " + e.getMessage());
        } catch (EOFException e) {
            System.err.println("EOFException: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("IOException: " + e.getMessage());
        }
    }

    public void lookRandomNumbers(String filename, int pos)
    {
        long len = new File(filename).length() / 4;
        lookRandomNumbers(filename, pos, (int)len);
    }

    public void lookRandomNumbers(String filename)
    {
        long len = new File(filename).length() / 4;
        lookRandomNumbers(filename, 0, (int)len);
    }

    public <T> ArrayList<T> arrayCopy(ArrayList<T> v, int start, int n)
    {
        ArrayList<T> tmp = new ArrayList<>();
        for (; start != v.size() && n != 0; ++start, --n) {
            tmp.add(v.get(start));
        }
        return tmp;
    }

    public <T> void printAL(ArrayList<T> v)
    {
        for (int i = 0; i != v.size(); ++i) {
            System.out.print(" " + v.get(i));
        }
        System.out.print('\n');
    }

    public void mergeSort(ArrayList<Integer> v, int left, int right)
    {
        if (left < right) {
            int mid = (left + right) / 2;
            mergeSort(v, left, mid);
            mergeSort(v, mid + 1, right);

            ArrayList<Integer> La = arrayCopy(v, left, (mid - left + 1));
            ArrayList<Integer> Ra = arrayCopy(v, mid + 1, (right - mid));

            for (int i = 0, j = 0; left <= right; ++left) {
                if (i == La.size()) {
                    v.set(left, Ra.get(j));
                    ++j;
                } else if (j == Ra.size()) {
                    v.set(left, La.get(i));
                    ++i;
                } else {
                    if (La.get(i) < Ra.get(j)) {
                        v.set(left, La.get(i));
                        ++i;
                    } else {
                        v.set(left, Ra.get(j));
                        ++j;
                    }
                }
            }
        }
    }

    protected interface refSort<T>
    {
        void sort(ArrayList<T> s, int left, int rigt);
    }

    public void sortRandomNumbers(refSort<Integer> s, String input, String output)
    {
        ArrayList<Integer> v = new ArrayList<Integer>();

        // read random numbers
        try {
            DataInputStream is =
                new DataInputStream(new FileInputStream(input));
            long len = new File(input).length() / 4;
            for (; len != 0; --len) {
                v.add(is.readInt());
            }
            is.close();
        } catch (FileNotFoundException e) {
            System.err.println("FileNotFoundException: " + e.getMessage());
        } catch (EOFException e) {
            System.err.println("EOFException: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("IOException: " + e.getMessage());
        }

        // sort random numbers
        s.sort(v, 0, v.size() - 1);

        // write random numbers
        try {
            DataOutputStream os =
                new DataOutputStream(new FileOutputStream(output));
            for (int i = 0; i != v.size(); ++i) {
                os.writeInt(v.get(i));
            }
            os.close();
        } catch (FileNotFoundException e) {
            System.err.println("FileNotFoundException: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("IOException: " + e.getMessage());
        }
    }
}
