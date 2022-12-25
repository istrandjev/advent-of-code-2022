import java.util.Scanner;

public class MyClass {
    public static int snafu_value(char c) {
        if (c == '-') {
            return -1;
        }
        if (c == '=') {
            return -2;
        }
        return c - '0';
    }
    public static long convert(String snafu) {
        long res = 0;
        for (int i = 0; i < snafu.length(); ++i) {
            res = res * 5 + snafu_value(snafu.charAt(i));
        }
        return res;
    }
    public static String to_snafu(long value) {
        if (value == 0) {
            return "";
        }
        long rem = value % 5;
        if (rem <= 2) {
            return to_snafu(value/5) + rem;
        }
        return to_snafu(value/5 + 1) + (rem == 3 ? "=" : "-");
    }
    public static void main(String args[]) {
      Scanner scanner = new Scanner(System.in);

      long total = 0;
      while (scanner.hasNextLine()) {
          String line = scanner.nextLine();
          total += convert(line);

      }
      System.out.println(to_snafu(total));
    }
}