#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <cmath>
#include <fstream>
#include <ostream>

using namespace std;

//quick sort for array
int partition(int arr[],int low,int high){

    int key;
    key = arr[low];

    while(low < high){
        while(low < high && arr[high]>= key){
            high--;
        }
        if(low < high){
            arr[low++] = arr[high];
        }

        while(low < high && arr[low] <= key){
            low++;
        }

        if(low < high){
            arr[high--] = arr[low];
        }
    }

    arr[low] = key;
    return low;


}
void quicksort(int *arr,int left,int right){

    int pos;
    if(left < right){
        pos = partition(arr,left,right);

        quicksort(arr,left,pos-1);
        quicksort(arr,pos+ 1,right);
    }
}




//�������㷨ʵ��
void HeapAdjust(int *a,int i,int size)  //������
{
    int lchild=2*i+1;
    int rchild=2*i+2;
    int max=i;
    if(i<=size/2)
    {
        if(lchild<=size&&a[lchild]>a[max])
        {
            max=lchild;
        }
        if(rchild<=size&&a[rchild]>a[max])
        {
            max=rchild;
        }
        if(max!=i)
        {
            swap(a[i],a[max]);
            HeapAdjust(a,max,size);
        }
    }
}

void BuildHeap(int *a,int size)    //������
{
    int i;
    for(i=size/2;i>=0;i--)
    {
        HeapAdjust(a,i,size);
    }
}

void HeapSort(int *a,int size)
{
    int i;
    BuildHeap(a,size);
    for(i=size;i>=0;i--)
    {

        swap(a[0],a[i]);          //�����Ѷ������һ��Ԫ�أ���ÿ�ν�ʣ��Ԫ���е�����߷ŵ������
        HeapAdjust(a,0,i-1);      //���µ����Ѷ��ڵ��Ϊ�󶥶�
    }
}


//2·�鲢ʵ��
void merge(int *m1, int *m2, int x, int y, int z)
{
    int i,j,k;
    i=x;
    j=y+1;

    for(k=x;k<=z && i<=y && j<=z; k++)
    {
        if(m2[i]<m2[j])
            m1[k]=m2[i++];
        else
            m1[k]=m2[j++];
    }

    while(i<=y)
        m1[k++]=m2[i++];
    while(j<=z)
        m1[k++]=m2[j++];
}

void MergePass(int *m1, int *m2, int len, int n)
{
    int begin=0;
    while(begin+2*len-1<n)
    {
        merge(m1, m2, begin, begin+len-1, begin+2*len-1);
        begin=begin+2*len;
    }

    if(begin+len-1<n)
        merge(m1, m2, begin, begin+len-1, n-1);
    else
        while(begin<n)
        {
            m1[begin]=m2[begin];
            begin++;
        }
/*
        for(int t=0;t<10;t++)
            printf("%d ",m1[t]);
        printf("\n");
        */
}


void MergeSort(int *m,int n)
{
    int len=1;
    int *tm=(int *)malloc(sizeof(int)*n);
    while(len<n)
    {
        MergePass(tm, m, len, n);
        len*=2;
        MergePass(m, tm, len, n);
        len*=2;
    }
    free(tm);
}



int main(){

    ifstream fin("input.txt");
    if(!fin)
        return 0;
    int n;
    fin>> n;
    int *a = new int[n];
    int *aquicksort = new int[n];

    for(int i = 0; i < n;i++){
        fin>>a[i];
    }

    cout << "����Ԫ��������ʾ��"<<endl;
    for(int i = 0; i< n;i++){
        cout << a[i]<< " ";
    }
    cout << endl;

    for(int i = 0;i< n;i++){
        aquicksort[i] = a[i];
    }

    quicksort(a,0,7);
    cout << "�������������Ԫ��������ʾ��"<<endl;
    for(int i = 0; i< n;i++){
        cout << a[i]<< " ";
    }
    cout << endl;
*/
    MergeSort(aquicksort,n);
    cout << "2·�鲢�����aquicksort����Ԫ��������ʾ��"<<endl;
    for(int i = 0; i< n;i++){
        cout << aquicksort[i]<< " ";
    }
    cout << endl;

    cout << "��������������ʾ�� "<< endl;
    HeapSort(a,n);
    for(int i = 0;i < n;i++){
        cout << a[i] << " ";
    }
    cout << endl;

    return 0;

}
