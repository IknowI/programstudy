#include <iostream>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <ostream>

using namespace std;

#define MAX_N 10 //��󶥵���

//ʵ����С�������Ľṹ����
typedef struct {
    int n;
    int e;
    int arcw[MAX_N][MAX_N];
}Graph;

//closedge�ṹ����
typedef struct {
    double lowcost;
    int vex;
}CostTp;



void crtGraph(Graph &G){
    int i,j,k;
    int w;

    ifstream fin("input.txt");

    if(!fin ){
        return ;
    }

    fin >> G.n >> G.e;

    //��ʼ��ȫ��Ϊ333����ʾ������
    for(i = 0; i < G.n;i++){
        for(j = 0; j < G.n; j++){
            G.arcw[i][j] = 333;
        }
    }

    //������Ӧ��Ȩֵ
    for(i = 0; i < G.e; i++){
        fin >> j >> k >> w;
        G.arcw[j][k] = G.arcw[k][j] = w;
    }

    fin.close();
}

void prim(Graph &G,int k){

    CostTp *closedge = new CostTp[G.n];
    int *saveroad = new int[G.n];
    int si = 0;
    int maxload = 0;//��Ȩ��

    ofstream fout("output.txt");
    if(!fout)
        return;

    //��ʼ��closedge
    for(int i = 0; i < G.n; i++){
        closedge[i].vex = k;
        closedge[i].lowcost = G.arcw[i][k];
    }

    closedge[k].lowcost = 0;

    cout << "���α����Ľ�����£�"<< endl;
    cout <<k;
    saveroad[si++] = k;
    int m;
    int i,j;

    for(m = 0; m < G.n - 1; m++){

        for( i = 0; i< G.n; i++){
            if(closedge[i].lowcost > 0)
                break;
        }

        for(j = i + 1; j < G.n; j++){
            if(closedge[j].lowcost > 0 && closedge[j].lowcost < closedge[i].lowcost)
                i = j;
        }

        cout << "," << i;//���i�Ŷ���
        saveroad[si++] = i;

        closedge[i].lowcost = 0;

        for(j = 0; j< G.n; j++){
            if(closedge[j].lowcost > 0 && closedge[j].lowcost > G.arcw[j][i]){
                closedge[j].lowcost = G.arcw[j][i];
                closedge[j].vex = i;
            }
        }
    }

    //forѭ������
    cout << endl;
    cout << "���������������Լ�Ȩ�طֱ��ǣ�" << endl;
    fout << "�������������߷ֱ��ǣ�" << endl;
    for(i = 0; i< G.n;i++){
        if(i != k){
            cout << "(" << i << ","<< closedge[i].vex << ")";
            maxload +=  G.arcw[i][closedge[i].vex];
            fout << "(" << i << ","<< closedge[i].vex << ")";
            cout << "--" << G.arcw[i][closedge[i].vex] << endl;

        }
    }

    fout << endl;
    cout << "��С������Ȩ�غ�Ϊ�� " << maxload << endl;
    fout << "��С������Ȩ�غ�Ϊ�� " << maxload << endl;
    fout.close();

    delete []closedge;

}

int main(){

    Graph G;
    crtGraph(G);
    prim(G,0);

    return 0;


}
