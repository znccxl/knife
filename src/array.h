
/* growable list of objects (void pointers) */

/* $Id$ */

/* Michael A. Park (Mike Park)
 * Computational AeroSciences Branch
 * NASA Langley Research Center
 * Hampton, VA 23681
 * Phone:(757) 864-6604
 * Email: Mike.Park@NASA.Gov
 */

#ifndef ARRAY_H
#define ARRAY_H

#include "knife_definitions.h"

BEGIN_C_DECLORATION

typedef void * ArrayItem;

typedef struct ArrayStruct ArrayStruct;
struct ArrayStruct {
  int actual, allocated, chunk;
  ArrayItem *data;
};
typedef ArrayStruct * Array;

Array array_from( ArrayItem *data, int size );
Array array_create( int guess, int chunk );
void array_free( Array );

#define array_size(array) (array->actual)

KNIFE_STATUS array_add( Array, ArrayItem );

#define array_item( array,indx ) \
  ((indx>=0 && indx < array->actual)?array->data[indx]:NULL)

KnifeBool array_contains_int( Array, int traget );

END_C_DECLORATION

#endif /* ARRAY_H */
