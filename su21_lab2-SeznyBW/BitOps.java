public class BitOps{
    public static int isOdd(int x){
        return x & 1;
    }

    public static int DivBy4(int x){
        return x >> 2;
    }

    public static int nearestOdd(int x){
        return x | 1;
    }

    public static int flipParity(int x){
        return x ^ 1;
    }

    public static int isNegative(int x){
        return x >>> 31;
    }

    public static int clearBits(int x){
        return x & 240;
    }

    public static int setBits(int x){
        return (x & -145) | 96;
    }


}