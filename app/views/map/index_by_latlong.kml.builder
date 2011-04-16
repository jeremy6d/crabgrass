xml.instruct! :xml
xml.kml(:xmlns => "http://earth.google.com/kml/2.2") {
  xml.Document {
    [(1..10).to_a, 25, 50, 100].flatten!.each do |count|
      xml.Style(:id => "#{count.to_s}Marker") { 
        xml.IconStyle {
          xml.Icon{
            xml.href('/images/png/map/map-marker_'+count.to_s+'.png')
          }
          xml.hotSpot(:x=>"0.5", :y=>"0.25", :xunits=>"fraction", :yunits=>"fraction")
        }
      }
    end

    @locations.each do |location|
      location.group_count = location.groups.count.to_i
      xml.Placemark {
        xml.styleUrl('#'+kml_style_for_place(location.group_count)+'Marker')
        xml.description(
          'ajax:/geo_locations/show/'+location.id.to_s 
        )
        xml.Point {
          xml.coordinates(location.geo_place.longlat)
        }
      }
    end
  }
}