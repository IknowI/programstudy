public class People {
  int height;
  String ear;
  void speak(String s){
      System.out.println(s);
  }
}

class A {
  public static void main(String args[]) {
      People Bajie;
      Bajie = new People();
      Bajie.height = 80;
      Bajie.ear = "��ֻ�����";
      System.out.println("���: "  + Bajie.height);
      System.out.println(Bajie.ear);
      Bajie.speak("��ʦ�����۱�ȥ�����ˣ�ȥ�¹���");
   }
} 