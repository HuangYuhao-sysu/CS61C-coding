/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
    Color *returnColor = (Color *) malloc(sizeof (Color));
    returnColor->R = (image->image)[row][col].B & 0x01 ? 0xff : 0x00;
    returnColor->G = (image->image)[row][col].B & 0x01 ? 0xff : 0x00;
    returnColor->B = (image->image)[row][col].B & 0x01 ? 0xff : 0x00;
    return returnColor;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	// New an image
    Image *returnImage = (Image *) malloc(sizeof (Image));
    returnImage->rows = image->rows;
    returnImage->cols = image->cols;
    returnImage->image = (Color **) malloc(sizeof (Color *) * returnImage->rows);
    for (int i = 0; i < returnImage->rows; ++i) {
        (returnImage->image)[i] = (Color *) malloc(sizeof (Color) * returnImage->cols);
    }
    for (int i = 0; i < returnImage->rows; ++i) {
        for (int j = 0; j < returnImage->cols; ++j) {
            Color *returnColor = evaluateOnePixel(image, i, j);
            (returnImage->image)[i][j] = *returnColor;
            free(returnColor);
        }
    }
    return returnImage;
}

/*
Loads a .ppm from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
void processCLI(int argc, char **argv, char **filename)
{
    if (argc != 2) {
        printf("usage: %s filename\n",argv[0]);
        printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
        exit(-1);
    }
    *filename = argv[1];
}

int main(int argc, char **argv)
{
	Image *image, *hidden;
    char *filename;
    processCLI(argc, argv, &filename);
    image = readData(filename);
    hidden = steganography(image);
    writeData(hidden);
    freeImage(image);
    freeImage(hidden);
}
