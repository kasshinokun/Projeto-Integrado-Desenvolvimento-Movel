import java.util.*;
import java.util.stream.Collectors;

public class StringToBinaryExample1 {

    public static void StringToBinaryExample1(String input) {
      
        String result = convertStringToBinary(input);

        System.out.println(result);

        // pretty print the binary format
        System.out.println(prettyBinary(result, 8, " "));

    }

    public static String convertStringToBinary(String input) {

        StringBuilder result = new StringBuilder();
        char[] chars = input.toCharArray();
        for (char aChar : chars) {
            result.append(
                    String.format("%8s", Integer.toBinaryString(aChar))   // char -> int, auto-cast
                            .replaceAll(" ", "0")                         // zero pads
            );
        }
        return result.toString();

    }

    public static String prettyBinary(String binary, int blockSize, String separator) {

        List<String> result = new ArrayList<>();
        int index = 0;
        while (index < binary.length()) {
            result.add(binary.substring(index, Math.min(index + blockSize, binary.length())));
            index += blockSize;
        }

        return result.stream().collect(Collectors.joining(separator));
    }
}

/*
Source-base developed by Tutorialspoint
https://www.tutorialspoint.com/how-to-convert-a-string-to-hexadecimal-and-vice-versa-format-in-java
*/

public class StringToHexadecimal {
  public static void main(String args[]) {
        
    String str = "Tutorialspoint";
    HexadecimalToString(StringToHexadecimal(str)); 
    
  }
  public static String StringToHexadecimal(String str) {
      
    System.out.println("The choiced String value is \n"+str);
    StringBuffer sb = new StringBuffer();
    //Converting string to character array
    char ch[] = str.toCharArray();
    for(int i = 0; i < ch.length; i++) {
      String hexString = Integer.toHexString(ch[i]);
      sb.append(hexString);
    }
    String result = sb.toString();
    System.out.println("\nHex String: "+result+"\n");
    
    return result;
  }
 
  public static void HexadecimalToString(String str) {
    
    System.out.println("The Received Hexadecimal \nString value is\n"+str);
    String result = new String();
    char[] charArray = str.toCharArray();
    for(int i = 0; i < charArray.length; i=i+2) {
      String st = ""+charArray[i]+""+charArray[i+1];
      char ch = (char)Integer.parseInt(st, 16);
      result = result + ch;
    }
    System.out.println("\nThe rebuilded String is "+result);
  }

}
