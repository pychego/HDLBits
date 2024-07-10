#include<iostream>
#include"steback.h"

using namespace std;

void accusteBack(double cosine[3], double sine[3], double trans[3], double ret[6]);

int main(){
	INT_TYPE cos[3] = {9847,7584,9992};
	INT_TYPE sin[3] = {1741,-1518,391};
	INT_TYPE trans[3] = {142000,159100,-87700};
	INT_TYPE ret[6] = {0, 0, 0, 0, 0, 0};

	double accucos[3] = {0.9847,0.7584,0.9992};
	double accusin[3] = {0.1741,-0.1518,0.0391};
	double accutrans[3] = {14.2,15.91,-8.77};
	double accuret[6] = {0, 0, 0, 0, 0, 0};

	steBack(cos,sin,trans,ret);
	accusteBack(accucos,accusin,accutrans,accuret);

	double diff = 0;

//	for(int i=0;i<6;i++) diff += ((double)ret[i] - accuret[i])*((double)ret[i] - accuret[i]);
//	cout<<sqrt(diff)<<endl;
//	cout<<sizeof((float)1234.2345)<<endl;
	for(int i=0;i<6;i++){
		cout<<ret[i]<<"\t"<<sqrt(accuret[i])<<endl;
	}
	return 0;
}


void accusteBack(double cosine[3], double sine[3], double trans[3], double ret[6]){

	double platpos[6][3] = {
			{491.4635,-631.2398,0},
			{491.4635,631.2398,0},
			{300.9379,741.2398,0},
			{-792.4014,110.0000,0},
			{-792.4014,-110.0000,0},
			{300.9379,-741.2398,0}
	};
	double basepos[6][3] = {
			{990.1515,-140.0000,0},
			{990.1515,140.0000,0},
			{-373.8322,927.4964,0},
			{-616.3193,787.4964,0},
			{-616.3193,-787.4964,0},
			{-373.8322,-927.4964,0}
	};
	double rx[3][3] = {
			{1,0,0},
			{0,cosine[0],-1*sine[0]},
			{0,sine[0],cosine[0]}
	};
	double ry[3][3] = {
			{cosine[1],0,sine[1]},
			{0,1,0},
			{-1*sine[1],0,cosine[1]}
	};
	double rz[3][3] = {
			{cosine[2],-1*sine[2],0},
			{sine[2],cosine[2],0},
			{0,0,1}
	};
	double tmp[3][3] = {{0,0,0},{0,0,0},{0,0,0}};
	double r[3][3] = {{0,0,0},{0,0,0},{0,0,0}};
	double legpoint[3] = {0,0,0};
	double homepos = 1600;

	matmul0:
	for(int i=0;i<3;i++){
		for(int j=0;j<3;j++){
			for(int k=0;k<3;k++){
				tmp[i][j] += rz[i][k] * ry[k][j];
			}
		}
	}

	matmul1:
	for(int i=0;i<3;i++){
		for(int j=0;j<3;j++){
			for(int k=0;k<3;k++){
				r[i][j] += tmp[i][k] * rx[k][j];
			}
		}
	}

	getlength:
	for(int i=0;i<6;i++){
		getLengthInner:
		for(int j=0;j<3;j++){
			legpoint[j] = 0;
			for(int k=0;k<3;k++){
				legpoint[j] += r[j][k] * platpos[i][k];
			}
			if(j==2) {
				legpoint[j] += trans[j] + homepos - basepos[i][j];
				ret[i] = (legpoint[0]*legpoint[0] + legpoint[1]*legpoint[1] +legpoint[2]*legpoint[2]);
			}
			else legpoint[j] += trans[j] - basepos[i][j];
		}
	}
}
