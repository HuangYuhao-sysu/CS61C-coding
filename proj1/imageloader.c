/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
    FILE *fp = fopen(filename, "r");
    
    Image *picture = (Image *) malloc(sizeof(Image));
    char p3[3];
    uint32_t width = 0;
    uint32_t height = 0;
    uint32_t depth = 0;
    uint32_t currR = 0;
    uint32_t currG = 0;
    uint32_t currB = 0;
    // Header scanf
    fscanf(fp, "%s\n", p3);
    if (strcmp(p3, "P3") != 0) {
        fclose(fp);
        return NULL;
    }
    fscanf(fp, "%d %d\n", &width, &height);
    fscanf(fp, "%d\n", &depth);
    picture->rows = height;
    picture->cols = width;
    picture->image = (Color**) malloc(height * sizeof(Color*));
    for (int i = 0; i < height; i++) {
        picture->image[i] = (Color*) malloc(width * sizeof(Color));
    }
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            fscanf(fp, "%d %d %d", &currR, &currG, &currB);
            ((picture->image[i]) + j)->R = currR;
            (*((picture->image[i]) + j)).G = currG;
            (picture->image)[i][j].B = currB;
        }
        fscanf(fp, "\n", NULL);
    }
    fclose(fp);
    return picture;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
    // Print header.
    printf("P3\n");
    printf("%d %d\n", image->rows, image->cols);
    printf("255\n");
    for (int i = 0; i < image->rows; i++) {
        Color currColor = (image->image)[i][0];
        printf("%3d %3d %3d", currColor.R, currColor.G, currColor.B);
        for (int j = 1; j < image->cols; j++) {
            Color currColor = (image->image)[i][j];
            printf("   %3d %3d %3d", currColor.R, currColor.G, currColor.B);
        }
        printf("\n");
    }
}

//Frees an image
void freeImage(Image *image)
{
    for (int i = 0; i < image->rows; i++) {
        free((image->image)[i]);
    }
    free(image->image);
    free(image);
}
