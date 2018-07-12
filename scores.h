#ifndef SCORES_H
#define SCORES_H

#include <time.h>
#include <fstream>

#include <iostream>

#include <string.h>

#include <iomanip>

#include <sstream>

#include <algorithm>


using namespace std;


class Score {
public:

    time_t timeStamp;
    char name[21];
    unsigned int replayNumber;

    unsigned short width,height;
    unsigned short mines;     
    unsigned int time;
    unsigned short val3BV;
    bool flagging;
    unsigned int effectiveClicks;
    unsigned int ineffectiveClicks;
    unsigned short squareSize;
    bool gameWon;

    Score();


    float getIOE();

    float get3BVs();

    void readFromFile(ifstream *f);
    
    void writeToFile(ofstream *f);
};


int compareByTime(const void *a,const void *b);

int compareBy3BVs(const void *a,const void *b);

int compareByIOE(const void *a,const void *b);

int filterScores(Score *scores, int count,Score **filteredScores,int fla, int fin, int w, int h, int m, int ss, char *pname);

void displayScores(Score *scores, int count,int limit,bool csv=false);

int loadScores(char *fname, Score **scores);

void appendScore(char *fname, Score score);

void evalScore(Score s, Score *scores, int count, int w, int h, int m, bool anyRank=0);

#endif

