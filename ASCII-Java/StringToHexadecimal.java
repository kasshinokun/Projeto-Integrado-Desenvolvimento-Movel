import java.util.*;
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
