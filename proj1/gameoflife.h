//
// Created by 18813 on 2023/10/29.
//

#include "imageloader.h"

#ifndef PROJ1_GAMEOFLIFE_H
#define PROJ1_GAMEOFLIFE_H

typedef struct CalAlive {
    Color *colors; // Contain 8 surrounding colors.
    uint32_t *maskR; // 8 Mask bits for R, [0x0010] means there are 4 alive surrounding R.
    uint32_t *maskG;
    uint32_t *maskB;
} CalAlive;

extern Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule);
extern Image *life(Image *image, uint32_t rule);

extern void processCLI(int argc, char **argv, char **filename, uint32_t *rule);
extern void getColors(Color *pColor, Image *pImage, int row, int col);
extern void calAliveNumForBits(Color *pColor, uint32_t *pR, uint32_t *pG, uint32_t *pB);
extern void updateColor(CalAlive *pAlive, uint32_t alive, uint32_t dead, Color *pColor);

#endif //PROJ1_GAMEOFLIFE_H
