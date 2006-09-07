#!/usr/bin/env ruby

refine_path = File.expand_path("~/GRIDEX/refine/src")

$:.push refine_path

require 'node'
require 'segment'
require 'triangle'
require 'polyhedron'
require 'cut'
require 'cut_surface'

# for Grid...
require 'Adj/Adj'
require 'Line/Line'
require 'Sort/Sort'
require 'Grid/Grid'
require 'GridMath/GridMath'
require 'Near/Near'

initial_time = Time.now

# read in the grid
fast_filename = File.expand_path("~/GRIDEX/refine/test/om6_inv08.fgrid")
active_bcs = [1,2]
cut_surface = CutSurface.from_FAST( fast_filename, active_bcs )

#load up volume to cut
volume_grid = Grid.from_FAST File.expand_path("~/GRIDEX/refine/test/om6box.fgrid")

#make volume nodes
volume_node = Array.new(volume_grid.nnode)

volume_grid.nnode.times do |node_index|
 xyz = volume_grid.nodeXYZ(node_index)
 volume_node[node_index] = Node.new(xyz[0],xyz[1],xyz[2])
end
puts "#{volume_grid.nnode} volume nodes created"

#make volume segments
volume_grid.createConn

segment = Array.new(volume_grid.nconn)

volume_grid.nconn.times do |conn_index|
 nodes = volume_grid.conn2Node(conn_index)
 segment[conn_index] = Segment.new(volume_node[nodes.min],
                                   volume_node[nodes.max])
end
puts "#{volume_grid.nconn} volume segments created"

def cell2face(face)
 case face
 when 0; [1,3,2]
 when 1; [0,2,3]
 when 2; [0,3,1]
 when 3; [0,1,2]
 else; nil; end
end

def cell_face_index(cell,face)
 return 0 if cell.values_at(1,2,3).sort == face.sort
 return 1 if cell.values_at(0,2,3).sort == face.sort
 return 2 if cell.values_at(0,1,3).sort == face.sort
 return 3 if cell.values_at(0,1,2).sort == face.sort
 nil
end

cell2tri = Array.new(4*volume_grid.ncell)
volume_triangles = Array.new

volume_poly = Array.new(volume_grid.ncell)

volume_grid.ncell.times do |cell_index|
 poly = Polyhedron.new
 volume_poly[cell_index] = poly
 cell_nodes = volume_grid.cell(cell_index)
 4.times do |face_index|
  if cell2tri[face_index+4*cell_index]
   poly.add_reversed_triangle cell2tri[face_index+4*cell_index]
  else
   tri_index = cell2face(face_index)
   tri_nodes = cell_nodes.values_at(tri_index[0],tri_index[1],tri_index[2])
   segment0 = segment[volume_grid.findConn(tri_nodes[1],tri_nodes[2])]
   segment1 = segment[volume_grid.findConn(tri_nodes[2],tri_nodes[0])]
   segment2 = segment[volume_grid.findConn(tri_nodes[0],tri_nodes[1])]
   tri = Triangle.new( segment0, segment1, segment2)
   volume_triangles << tri
   cell2tri[face_index+4*cell_index] = tri
   poly.add_triangle tri
   other_cell = volume_grid.findOtherCellWith3Nodes(tri_nodes[0],tri_nodes[1],
                                                    tri_nodes[2],cell_index)
   if other_cell >= 0
    indx = cell_face_index(volume_grid.cell(other_cell),tri_nodes)+4*other_cell
    cell2tri[indx] = tri
   end
  end
 end  
end

puts "volume has #{volume_triangles.size} unique tetrahedral sides"

start_time = Time.now
count = 0
volume_triangles.each do |triangle|
 count += 1 
 printf("%6d of %6d\n",count,volume_triangles.size) if count.divmod(1000)[1]==0
 center = triangle.center
 diameter = triangle.diameter
 probe = Near.new(-1,center[0],center[1],center[2],diameter)
 cut_surface.near_tree.first.touched(probe).each do |index|
  tool = cut_surface.triangles[index]
  begin
  Cut.between(triangle,tool)
  rescue RuntimeError
   puts "#{count} raised `#$!' at "+triangle.center.join(',')
  end
 end
end
puts "the cuts required #{Time.now-start_time} sec"

start_time = Time.now
cut_surface.triangulate
puts "the cut triangulation required #{Time.now-start_time} sec"

cut_surface.write_tecplot

start_time = Time.now
count = 0
volume_triangles.each do |triangle|
 count += 1 
 printf("%6d of %6d\n",count,volume_triangles.size) if count.divmod(1000)[1]==0
 begin
  triangle.triangulate_cuts
 rescue RuntimeError
  triangle.eps( sprintf('vol%04d.eps',count))
  triangle.dump(sprintf('vol%04d.t',  count))
  puts "#{count} raised `#$!' at "+triangle.center.join(',')
 end
 if triangle.min_subtri_area < 1.0e-15
  puts triangle.min_subtri_area 
  triangle.eps( sprintf('vol%04d.eps',count))
  triangle.dump(sprintf('vol%04d.t',  count))
 end
end
puts "the volume triangulation required #{Time.now-start_time} sec"

start_time = Time.now
ncut = 0
volume_poly.each do |poly|
 poly.gather_cutters
 if poly.cutters.size > 0
  ncut += 1 
  poly.trim_external_subtri
  poly.paint
 end
end
puts "the painting required #{Time.now-start_time} sec"

puts "#{ncut} of #{volume_poly.size} ployhedra cut"

start_time = Time.now
ncut = 0
volume_poly.each do |poly|
 if poly.cutters.size > 0
  ncut += 1 
  poly.section
  #printf "zone %6d sections #{poly.unique_marks.join(' ')}\n", ncut
  poly.triangles.each do |tri|
   puts "null tri" if tri.subtris.empty?
  end
 end
end
puts "the sectioning required #{Time.now-start_time} sec"

File.open('om6_cut_poly.t','w') do |f|
 f.print volume_poly.first.tecplot_header
 volume_poly.each do |poly|
  f.print poly.tecplot_zone unless poly.cutters.empty?
 end
end

puts "the entire process required #{Time.now-initial_time} sec"
