
import java.util.ArrayList;
import java.io.*;
import java.nio.charset.Charset;
import java.lang.String;
import java.lang.Character;

class SubArray {
    public class MaxSub
    {
        public int start;
        public int end;
        public int sum;

        public MaxSub(int b, int e, int s) {
            start = b;
            end = e;
            sum = s;
        }
    }

    public MaxSub
    findCrossingMax(ArrayList<Integer> v, int left, int mid, int right)
    {
        MaxSub max = new MaxSub(mid, mid + 1, 0);
        int sum_left = v.get(mid);
        int sum_right = v.get(mid + 1);

        for (int i = mid, sum = 0; i >= left; --i) {
            sum = sum + v.get(i);
            if (sum > sum_left) {
                sum_left = sum;
                max.start = i;
            }
        }

        for (int j = mid + 1, sum = 0; j <= right; ++j) {
            sum = sum + v.get(j);
            if (sum > sum_right) {
                sum_right = sum;
                max.end = j;
            }
        }

        max.sum = sum_left + sum_right;
        return max;
    }

    public MaxSub
    findMax(ArrayList<Integer> v, int left, int right)
    {
        if (left == right) {
            MaxSub one = new MaxSub(left, right, v.get(left));
            return one;
        }

        int mid = (left + right) / 2;
        MaxSub max_left = findMax(v, left, mid);
        MaxSub max_right = findMax(v, mid + 1, right);
        MaxSub max_cross = findCrossingMax(v, left, mid, right);
        if (max_left.sum >= max_right.sum &&
                max_left.sum >= max_cross.sum) {
            return max_left;
        } else if (max_right.sum >= max_left.sum &&
                max_right.sum >= max_cross.sum) {
            return max_right;
        } else {
            return max_cross;
        }
    }

    public void readStringData(String filename)
    {
        ArrayList<Integer> v = new ArrayList<Integer>();

        try {
            InputStreamReader read_f = new
                InputStreamReader(new FileInputStream(filename),
                Charset.forName("utf-8"));
            String number = "";
            int c = 0;
            while ((c = read_f.read()) != -1) {
                if (Character.isWhitespace(c) && !number.isEmpty()) {
                    v.add(Integer.valueOf(number));
                    number = "";
                } else if (!Character.isWhitespace(c)) {
                    number = number + (char)c;
                }
            }
            read_f.close();
        } catch (IOException e) {
            System.err.println("IOException: " + e.getMessage());
        }

        MaxSub max = findMax(v, 0, v.size() - 1);
        System.out.println(max.start + " " + max.end + " " + max.sum);
    }

    public static void main(String[] args) {
        SubArray s = new SubArray();
        s.readStringData("test");
    }
}
