
/* three subnodes and three sides */

/* Copyright 2007 United States Government as represented by the
 * Administrator of the National Aeronautics and Space
 * Administration. No copyright is claimed in the United States under
 * Title 17, U.S. Code.  All Other Rights Reserved.
 *
 * The knife platform is licensed under the Apache License, Version
 * 2.0 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#ifndef SUBTRI_H
#define SUBTRI_H

#include <stdlib.h>
#include <stdio.h>
#include "knife_definitions.h"

BEGIN_C_DECLORATION
typedef struct SubtriStruct SubtriStruct;
typedef SubtriStruct * Subtri;
END_C_DECLORATION

#include "subnode.h"

BEGIN_C_DECLORATION

struct SubtriStruct {
  Subnode n0, n1, n2;
};

Subtri subtri_create( Subnode n0, Subnode n1, Subnode n2 );
Subtri subtri_shallow_copy( Subtri );
void subtri_free( Subtri );

#define subtri_n0(subtri) ((subtri)->n0)
#define subtri_n1(subtri) ((subtri)->n1)
#define subtri_n2(subtri) ((subtri)->n2)

#define subtri_has2(subtri,node0,node1)		    \
  ( ( ((subtri)->n0==(node0)) && ((subtri)->n1==(node1)) ) ||	\
    ( ((subtri)->n1==(node0)) && ((subtri)->n2==(node1)) ) ||	\
    ( ((subtri)->n2==(node0)) && ((subtri)->n0==(node1)) ) )

#define subtri_has1(subtri,n)						\
  ( ((subtri)->n0==(n)) || ((subtri)->n1==(n)) || ((subtri)->n2==(n)) )

Subnode subtri_subnode( Subtri, int index );

KNIFE_STATUS subtri_replace_node( Subtri, Subnode old_node, Subnode new_node );

KNIFE_STATUS subtri_orient( Subtri, Subnode, 
			    Subnode *n0, Subnode *n1, Subnode *n2 );

KNIFE_STATUS subtri_bary( Subtri, Subnode, double *bary );
double subtri_reference_area( Subtri );

KNIFE_STATUS subtri_contained_volume6( Subtri, Subtri, double *volume6 );

KNIFE_STATUS subtri_dump_geom( Subtri subtri, 
			       KnifeBool reverse, int region, FILE *f );
KNIFE_STATUS subtri_echo_uvw( Subtri subtri );
KNIFE_STATUS subtri_echo( Subtri subtri );

KNIFE_STATUS subtri_center( Subtri subtri, double *center );

END_C_DECLORATION

#endif /* SUBTRI_H */
