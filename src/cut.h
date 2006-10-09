
/* cut between two Triangles of two Intersections */

/* $Id$ */

/* Michael A. Park (Mike Park)
 * Computational AeroSciences Branch
 * NASA Langley Research Center
 * Hampton, VA 23681
 * Phone:(757) 864-6604
 * Email: Mike.Park@NASA.Gov
 */

#ifndef CUT_H
#define CUT_H

#include "knife_definitions.h"
#include "triangle.h"
#include "intersection.h"

BEGIN_C_DECLORATION

typedef struct CutStruct CutStruct;
struct CutStruct {
  Triangle triangle0, triangle1;
  Intersection intersection0, intersection1;
};
typedef CutStruct * Cut;

Cut cut_between( Triangle, Triangle );
void cut_free( Cut );

END_C_DECLORATION

#endif /* CUT_H */