#  a triangle mash that deactivates subtris

class Mask
 
 attr_reader :triangle, :reversed

 def initialize(triangle,reversed=false)
  @triangle = triangle
  @reversed = reversed
  @trimmed = nil
 end

 def method_missing(method, *arguments)
  @triangle.send(method, *arguments)
 end

 def deactivate_all_subtri
  @trimmed = Array.new(triangle.subtris.size,true)
 end

 def subtris
  if @trimmed
   out = Array.new
   triangle.subtris.size.times do |indx|
    out << triangle.subtris[indx] unless @trimmed[indx]
   end
   out
  else
   triangle.subtris
  end
 end

 def ==(other)
  (triangle == other)
 end

 def activate(intersection0,intersection1)
  subtri = find_subtri_with_parents(intersection0,intersection1)
  @trimmed[triangle.subtris.index(subtri)] = false
 end

end