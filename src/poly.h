
/* volume defined by a watertight collection of masks */

/* $Id$ */

/* Michael A. Park (Mike Park)
 * Computational AeroSciences Branch
 * NASA Langley Research Center
 * Hampton, VA 23681
 * Phone:(757) 864-6604
 * Email: Mike.Park@NASA.Gov
 */

#ifndef POLY_H
#define POLY_H

#include <stdlib.h>
#include <stdio.h>
#include "knife_definitions.h"

BEGIN_C_DECLORATION
typedef struct PolyStruct PolyStruct;
typedef PolyStruct * Poly;
END_C_DECLORATION

#include "array.h"
#include "triangle.h"
#include "mask.h"

BEGIN_C_DECLORATION

struct PolyStruct {
  Array mask;
  Array surf;
};

Poly poly_create( void );
KNIFE_STATUS poly_initialize( Poly );
void poly_free( Poly );

KNIFE_STATUS poly_add_triangle( Poly, Triangle, 
				KnifeBool inward_pointing_normal );

KnifeBool poly_has_surf_triangle( Poly, Triangle );

KNIFE_STATUS poly_mask_with_triangle( Poly, Triangle, Mask * );

KNIFE_STATUS poly_gather_surf( Poly );

KNIFE_STATUS poly_determine_active_subtri( Poly );

KNIFE_STATUS poly_activate_subtri_at_cuts( Poly );
KNIFE_STATUS poly_paint( Poly );

KnifeBool poly_active_mask_with_nodes( Poly, Node n0, Node n1, Node n2 );

#define poly_add_mask( poly, new_mask )			\
  array_add( (poly)->mask, (ArrayItem)(new_mask) )
#define poly_nmask( poly )			\
  array_size( (poly)->mask )
#define poly_mask( poly, mask_index )			\
  ((Mask)array_item( (poly)->mask, (mask_index) ))

#define poly_add_surf( poly, new_surf )			\
  array_add( (poly)->surf, (ArrayItem)(new_surf) )
#define poly_nsurf( poly )			\
  array_size( (poly)->surf )
#define poly_surf( poly, surf_index )			\
  ((Mask)array_item( (poly)->surf, (surf_index) ))

KNIFE_STATUS poly_tecplot_zone( Poly, FILE * );


END_C_DECLORATION

#endif /* POLY_H */
