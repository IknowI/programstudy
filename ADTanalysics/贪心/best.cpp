#include <iostream>
#include <ostream>
#include <istream>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <cstring>

using namespace std;
#define Size  10

typedef struct node{
    float avervalue;//��λ��ֵ
    float ww;//����
    float vv;//��ֵ
    float flag;//λ��
}Avervalue;

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

//��̰���㷨�����0-1�����ͱ�������
float knapsack(float c,float w[],float v[],float x[]){// w������ v:��ֵ x:0 or 1 c:�������װ������

    int n = Size;
    Avervalue *d = new Avervalue[n];//d��ŵ�����Ʒ�ĵ�λ��ֵ
    Avervalue swap;

    for(int i = 0; i < n; i++){
        d[i].avervalue = v[i] / w[i];
        d[i].flag = i;
        d[i].vv = v[i];
        d[i].ww = w[i];

    }

    //����λ��ֵ����ֵ�Ӵ�С���У���֤̰��ѡ��,ð������
    for(int i = 0; i < n;i++){
        for(int j = i+1; j < n; j++){
            if(d[i].avervalue < d[j].avervalue){

                    swap = d[i];
                    d[i] = d[j];
                    d[j] = swap;
            }
        }
    }

    int i;
    float opt = 0;//opt Ϊ����ļ�ֵ����

    //�����и����⣬�����������ô֪����Ӧ���Ǹ���X��W������Ӧ�ö���һ���ṹ�壬
    for(i = 0; i< n; i++)
        x[i] = 0;

    for( i = 0; i < n;i++){
        if(d[i].ww > c)
            break;

        x[(int)d[i].flag] = 1;//���������ǿ��ת�������ע�⣡����
        opt = d[i].vv;
        c -= d[i].ww;

    }

    //�ж��Ƿ�ȡ��������Ʒ
    if(i < n){
        x[(int)d[i].flag] = c/d[i].ww;
        opt += x[(int)d[i].flag] * d[i].vv;
    }


    return opt;


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
