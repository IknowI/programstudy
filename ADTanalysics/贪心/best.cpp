#include <iostream>
#include <ostream>
#include <istream>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <cstring>

using namespace std;


//̰���㷨�Ļ��������ʵ��
int greedySelector(int s[],int f[],bool a[]){

    int s_length = 11;
    int i;
    int count = 1;//����ŵļ�����,��ǰѡ���˻һ

    //cout << "the length of s is " << s_length << endl;

    a[0] = true;

    int j = 0;

    for( i = 1; i < s_length; i++)
    {
        if(s[i] >=  f[j]){
            a[i] = true;
            j = i;
            count++;
        }
        else
            a[i] = false;
    }

    return count;
}

int main(){

    int s[] = { 1,3,0,5,3,5,6,8,8,2,12};//��ʼʱ��
    int f[] = {4,5,6,7,8,9,10,11,12,13,14};//����ʱ��,����
    bool a[11];

    int count = greedySelector(s,f,a);
    cout << "the count of activity is " << count << endl;

    cout << "the followings are activity selected : \n";
    //�����ǰѡ��Ļ
    for(int i = 0; i < 11; i++){
        if(a[i] == true){
            cout << "select activity :" << i << " from " << s[i] << " to " << f[i] << endl;
        }
    }
    return 0;
}
