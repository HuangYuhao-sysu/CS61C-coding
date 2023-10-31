/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "gameoflife.h"
#include <unistd.h>



//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
    Color *colors = (Color *) malloc(sizeof (Color)*8);
    uint32_t ruleForAlive = rule >> 9;
    uint32_t ruleForDead = rule & 0x1ff;
    getColors(colors, image, row, col);
    CalAlive *calAlive = (CalAlive *) malloc(sizeof (CalAlive));
    calAlive->colors = colors;
    calAlive->maskR = (uint32_t *) malloc(sizeof (uint32_t)*8);
    calAlive->maskG = (uint32_t *) malloc(sizeof (uint32_t)*8);
    calAlive->maskB = (uint32_t *) malloc(sizeof (uint32_t)*8);
    calAliveNumForBits(calAlive->colors, calAlive->maskR, calAlive->maskG, calAlive->maskB);
    Color *newColor = (Color *) malloc(sizeof (Color));
    *newColor = image->image[row][col];
    updateColor(calAlive, ruleForAlive, ruleForDead, newColor);
    return newColor;
}

void updateColor(CalAlive *calAlive, uint32_t ruleForAlive, uint32_t ruleForDead, Color *srcColor) {
    Color *currColor = (Color *) malloc(sizeof (Color));
    currColor->R = 0;
    currColor->G = 0;
    currColor->B = 0;
    for (int i = 0; i < 3; ++i) { // for RGB
        for (int j = 0; j < 8; ++j) { // for every bit.
            if (i == 0) { // R
                currColor->R = currColor->R << 1;
                if (((srcColor->R >> (7 - j)) & 0x01) == 0x01) {
                    currColor->R += ((ruleForAlive & (calAlive->maskR)[j]) != 0) & 0x01;
                } else {
                    currColor->R += ((ruleForDead & (calAlive->maskR)[j]) != 0) & 0x01;
                }

            }
            if (i == 1) { // G
                currColor->G = currColor->G << 1;
                if (((srcColor->G >> (7 - j)) & 0x01) == 0x01) {
                    currColor->G += ((ruleForAlive & (calAlive->maskG)[j]) != 0) & 0x01;
                } else {
                    currColor->G += ((ruleForDead & (calAlive->maskG)[j]) != 0) & 0x01;
                }

            }
            if (i == 2) { // B
                currColor->B = currColor->B << 1;
                if (((srcColor->B >> (7 - j)) & 0x01) == 0x01) {
                    currColor->B += ((ruleForAlive & (calAlive->maskB)[j]) != 0) & 0x01;
                } else {
                    currColor->B += ((ruleForDead & (calAlive->maskB)[j]) != 0) & 0x01;
                }

            }
        }
    }
    *srcColor = *currColor;
    free(currColor);
}


void calAliveNumForBits(Color *pColor, uint32_t *pR, uint32_t *pG, uint32_t *pB) {
    for (int i = 0; i < 8; ++i) {
        pR[i] = 1;
        pG[i] = 1;
        pB[i] = 1;
    }
    for (int i = 0; i < 3; ++i) { // for RGB
        for (int j = 0; j < 8; ++j) { // for every bit.
            for (int k = 0; k < 8; ++k) { // for every color.
                if (i == 0) { // R
                    pR[j] = pR[j] << ((pColor[k].R >> (7 - j)) & 0x01); // MSB first
                }

                if (i == 1) { // G
                    pG[j] = pG[j] << ((pColor[k].G >> (7 - j)) & 0x01);
                }

                if (i == 2) { // B
                    pB[j] = pB[j] << ((pColor[k].B >> (7 - j)) & 0x01);
                }
            }
        }
    }
}


void getColors(Color *pColor, Image *pImage, int row, int col) {
    uint32_t index = 0;
    for (int i = row - 1; i < row + 2; ++i) {
        for (int j = col - 1; j < col + 2; ++j) {
            if ((0 <= i && i <= (pImage->rows - 1)) && (0 <= j && j <= (pImage->cols-1)) && (i != row || j != col)) {
                pColor[index].R = (pImage->image)[i][j].R;
                pColor[index].G = (pImage->image)[i][j].G;
                pColor[index].B = (pImage->image)[i][j].B;
            } else if (i == row && j == col) {
                continue;
            } else {
                pColor[index].R = 0xff;
                pColor[index].G = 0xff;
                pColor[index].B = 0xff;
            }
            index += 1;
        }
    }
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
    Image *returnImage = (Image *) malloc(sizeof (Image));
    returnImage->rows = image->rows;
    returnImage->cols = image->cols;
    returnImage->image = (Color **) malloc(sizeof (Color *) * returnImage->rows);
    for (int i = 0; i < returnImage->rows; ++i) {
        (returnImage->image)[i] = (Color *) malloc(sizeof (Color) * returnImage->cols);
    }
    for (int i = 0; i < returnImage->rows; ++i) {
        for (int j = 0; j < returnImage->cols; ++j) {
            Color *returnColor = evaluateOneCell(image, i, j, rule);
            (returnImage->image)[i][j] = *returnColor;
            free(returnColor);
        }
    }
    return returnImage;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
    Image *image, *new;
    char *filename;
    uint32_t rule;
    processCLI(argc, argv, &filename, &rule);
    image = readData(filename);
    new = life(image, rule);
    writeData(new);
    freeImage(image);
    freeImage(new);
}

void processCLI(int argc, char **argv, char **filename, uint32_t *rule) {
    if (argc == 3) {
        *filename = argv[1];
        char *ruleString = argv[2];
        sscanf(ruleString, "%x", rule);
        return;
    }
    printf("usage: %s filename rule\n",argv[0]);
    printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
    printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");
    exit(-1);
}