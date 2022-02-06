// MyXfloat.java
//   sample Xfloat program

public class MyXfloat extends Xfloat {

  public MyXfloat(){super();}
  public MyXfloat(float f){super(f);}
  public MyXfloat(byte sign, byte exp, int man){super(sign, exp, man);}

  public Xfloat xadd(Xfloat y){
    // check if one of the nums is 0
    if (this.man==0 && this.exp==0){
      return y;
    }
    if (y.man==0 && y.exp==0){
      return this;
    }
    long xman=(long) (BMASK | this.man);
    long yman=(long) (BMASK | y.man);
    byte xsign = this.sign;
    byte ysign = y.sign;
    int xexp = (int) this.exp;
    int yexp = (int) y.exp;
    xexp = xexp & 0xFF;
    yexp= yexp & 0xFF;
    int expdif = xexp-yexp;
    int exp;
    byte sign;
    long man;

    // make the exponents match
    if (expdif>0){
      exp=xexp;
      yman=yman >>> expdif;
    }
    else {
      exp=yexp;
      expdif=expdif*-1;
      xman = xman >>> expdif;
    }

    //add the mans
    if (xsign==ysign){
      man=xman+yman;
      sign=xsign;
    }
    else if (xman > yman) {
      sign=xsign;
      man=xman-yman;
    }
    else if (yman > xman){
      sign=ysign;
      man=yman-xman;
    }
    else {
      return new MyXfloat((byte)0, (byte)0, 0);
    }

    //normalize
    int shift2=0;
    if (man < BMASK){
      while (((man >>> (23-shift2)) & 1) == 0){
        shift2=shift2+1;
      }
      man=man << shift2;
      exp=exp-shift2;
    }
    else {
      while((man >>> shift2) > (BMASK | MMASK)){
        shift2=shift2+1;
      }
      man=man >>> shift2;
      exp=exp+shift2;
    }

    man = (long)(man & MMASK);

    return new MyXfloat(sign, (byte)exp, (int)man);
  }
  
  
  //{return new MyXfloat((byte)0,(byte)0,0);}
  public Xfloat xmult(Xfloat y){
    //check if one of the nums is 0
    if ((this.man==0 && this.exp==0) || (y.man==0 && y.exp==0)){
      return new MyXfloat((byte)0, (byte)0, 0);
    }

    //determine sign
    byte sign;
    if (this.sign==y.sign){
      sign=0;
    }
    else {
      sign=1;
    }

    //add exponents together
    int exp = (int)this.exp + (int) y.exp - 127;

    //multiply fractions together
    long man =(long) (BMASK | this.man) * (long) (BMASK | y.man);

    man=man >>> 23;

    //normalize
    int shift2=0;
    while((man >>> shift2) > (BMASK | MMASK)){
      shift2=shift2+1;
    }
    man=man >>> shift2;
    exp=exp+shift2;

    man = (long)(man & MMASK);



    return new MyXfloat(sign, (byte) exp, (int) man);
  }

  public static void main(String arg[]) {
    if (arg.length < 2) return;
    float x = Float.valueOf(arg[0]).floatValue(),
          y = Float.valueOf(arg[1]).floatValue();
    Xfloat xf, yf, zf, wf;
    xf = new MyXfloat(x);
    yf = new MyXfloat(y);    
    zf = xf.xmult(yf);
    wf = xf.xadd(yf);
    System.out.println("x:   "+xf+" "+x);
    System.out.println("y:   "+yf+" "+y);
    System.out.println("x*y: "+zf+" "+zf.toFloat());
    System.out.println("x+y: "+wf+" "+wf.toFloat());
  }
}
