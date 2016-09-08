/*******************************************************************************
  Size library
********************************************************************************
  Alfredo Canziani, Sep 16
*******************************************************************************/

// Include TH library and printf
#include <TH/TH.h>
#include <stdio.h>

// Prints all sized of a given Tensor
void printSize(THFloatTensor* src) {
  printf("C says:\n");
  printf(" + Dimension: %d\n", src->nDimension);
  printf(" + Size: %ld", src->size[0]);
  for (int d = 1; d < src->nDimension; d++)
    printf(" x %ld", src->size[d]);
  printf("\n");
}
