# -----------------------------------------------------------------------------
# 
# Tests for the GEOS line string implementation
# 
# -----------------------------------------------------------------------------
# Copyright 2010 Daniel Azuma
# 
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of the copyright holder, nor the names of any other
#   contributors to this software, may be used to endorse or promote products
#   derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# -----------------------------------------------------------------------------
;


require 'test/unit'
require 'rgeo'


module RGeo
  module Tests  # :nodoc:
    module Geos
      
      class TestLineString < ::Test::Unit::TestCase  # :nodoc:
        
        
        def setup
          @factory = ::RGeo::Geos.factory
        end
        
        
        def test_creation_success
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          point3_ = @factory.point(1, 0)
          line1_ = @factory.line_string([point1_, point2_])
          assert_not_nil(line1_)
          assert_kind_of(::RGeo::Geos::LineStringImpl, line1_)
          assert_equal(2, line1_.num_points)
          assert_equal(point1_, line1_.point_n(0))
          assert_equal(point2_, line1_.point_n(1))
          line2_ = @factory.line_string([point1_, point2_, point3_])
          assert_not_nil(line2_)
          assert_kind_of(::RGeo::Geos::LineStringImpl, line2_)
          assert_equal(3, line2_.num_points)
          assert_equal(point1_, line2_.point_n(0))
          assert_equal(point2_, line2_.point_n(1))
          assert_equal(point3_, line2_.point_n(2))
          line3_ = @factory.line_string([point1_, point1_])
          assert_not_nil(line3_)
          assert_kind_of(::RGeo::Geos::LineStringImpl, line3_)
          assert_equal(2, line3_.num_points)
          assert_equal(point1_, line3_.point_n(0))
          assert_equal(point1_, line3_.point_n(1))
          line4_ = @factory.line_string([])
          assert_not_nil(line4_)
          assert_kind_of(::RGeo::Geos::LineStringImpl, line4_)
          assert_equal(0, line4_.num_points)
        end
        
        
        def test_creation_line_string
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          point3_ = @factory.point(1, 1)
          line1_ = @factory.line_string([point1_, point2_, point3_])
          assert_not_nil(line1_)
          assert_kind_of(::RGeo::Geos::LineStringImpl, line1_)
          assert(::RGeo::Features::LineString === line1_)
          assert(!(::RGeo::Features::LinearRing === line1_))
          assert(!(::RGeo::Features::Line === line1_))
          assert_equal(::RGeo::Features::LineString, line1_.geometry_type)
        end
        
        
        def test_creation_linear_ring
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          point3_ = @factory.point(1, 0)
          line1_ = @factory.linear_ring([point1_, point2_, point3_, point1_])
          assert_not_nil(line1_)
          assert_kind_of(::RGeo::Geos::LinearRingImpl, line1_)
          assert(line1_.is_ring?)
          assert(::RGeo::Features::LinearRing === line1_)
          assert_equal(::RGeo::Features::LinearRing, line1_.geometry_type)
          line2_ = @factory.linear_ring([point1_, point2_, point3_])
          assert_not_nil(line2_)
          assert_kind_of(::RGeo::Geos::LinearRingImpl, line2_)
          assert(line2_.is_ring?)
          assert(::RGeo::Features::LinearRing === line2_)
          assert_equal(4, line2_.num_points)
          assert_equal(::RGeo::Features::LinearRing, line2_.geometry_type)
        end
        
        
        def test_creation_line
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          line1_ = @factory.line(point1_, point2_)
          assert_not_nil(line1_)
          assert_kind_of(::RGeo::Geos::LineImpl, line1_)
          assert(::RGeo::Features::Line === line1_)
          assert_equal(::RGeo::Features::Line, line1_.geometry_type)
        end
        
        
        def test_creation_errors
          point1_ = @factory.point(0, 0)
          collection_ = point1_.boundary
          line1_ = @factory.line_string([point1_])
          assert_nil(line1_)
          line2_ = @factory.line_string([point1_, collection_])
          assert_nil(line2_)
        end
        
        
        def test_fully_equal
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          point3_ = @factory.point(1, 0)
          line1_ = @factory.line_string([point1_, point2_, point3_])
          point4_ = @factory.point(0, 0)
          point5_ = @factory.point(0, 1)
          point6_ = @factory.point(1, 0)
          line2_ = @factory.line_string([point4_, point5_, point6_])
          assert(line1_.eql?(line2_))
          assert(line1_.equals?(line2_))
        end
        
        
        def test_geometrically_equal_but_different_type
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          line1_ = @factory.line_string([point1_, point2_])
          point4_ = @factory.point(0, 0)
          point5_ = @factory.point(0, 1)
          line2_ = @factory.line(point4_, point5_)
          assert(!line1_.eql?(line2_))
          assert(line1_.equals?(line2_))
        end
        
        
        def test_geometrically_equal_but_different_type2
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          point3_ = @factory.point(1, 0)
          line1_ = @factory.line_string([point1_, point2_, point3_, point1_])
          point4_ = @factory.point(0, 0)
          point5_ = @factory.point(0, 1)
          point6_ = @factory.point(1, 0)
          line2_ = @factory.linear_ring([point4_, point5_, point6_, point4_])
          assert(!line1_.eql?(line2_))
          assert(line1_.equals?(line2_))
        end
        
        
        def test_geometrically_equal_but_different_overlap
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          point3_ = @factory.point(1, 0)
          line1_ = @factory.line_string([point1_, point2_, point3_])
          point4_ = @factory.point(0, 0)
          point5_ = @factory.point(0, 1)
          point6_ = @factory.point(1, 0)
          line2_ = @factory.line_string([point4_, point5_, point6_, point5_])
          assert(!line1_.eql?(line2_))
          assert(line1_.equals?(line2_))
        end
        
        
        def test_empty_equal
          line1_ = @factory.line_string([])
          line2_ = @factory.line_string([])
          assert(line1_.eql?(line2_))
          assert(line1_.equals?(line2_))
        end
        
        
        def test_not_equal
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          line1_ = @factory.line_string([point1_, point2_])
          point4_ = @factory.point(0, 0)
          point5_ = @factory.point(0, 1)
          point6_ = @factory.point(1, 0)
          line2_ = @factory.line_string([point4_, point5_, point6_])
          assert(!line1_.eql?(line2_))
          assert(!line1_.equals?(line2_))
        end
        
        
        def test_wkt_creation
          line1_ = @factory.parse_wkt('LINESTRING(21 22, 11 12)')
          assert_equal(@factory.point(21, 22), line1_.point_n(0))
          assert_equal(@factory.point(11, 12), line1_.point_n(1))
          assert_equal(2, line1_.num_points)
          line2_ = @factory.parse_wkt('LINESTRING(-1 -1, 21 22, 11 12, -1 -1)')
          assert_equal(@factory.point(-1, -1), line2_.point_n(0))
          assert_equal(@factory.point(21, 22), line2_.point_n(1))
          assert_equal(@factory.point(11, 12), line2_.point_n(2))
          assert_equal(@factory.point(-1, -1), line2_.point_n(3))
          assert_equal(4, line2_.num_points)
        end
        
        
        def test_clone
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          line1_ = @factory.line_string([point1_, point2_])
          line2_ = line1_.clone
          assert_equal(line1_, line2_)
          assert_equal(2, line2_.num_points)
          assert_equal(point1_, line2_.point_n(0))
          assert_equal(point2_, line2_.point_n(1))
        end
        
        
        def test_type_check
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          line_ = @factory.line_string([point1_, point2_])
          assert(::RGeo::Features::Geometry.check_type(line_))
          assert(!::RGeo::Features::Point.check_type(line_))
          assert(!::RGeo::Features::GeometryCollection.check_type(line_))
          assert(::RGeo::Features::Curve.check_type(line_))
          assert(::RGeo::Features::LineString.check_type(line_))
          assert(!::RGeo::Features::LinearRing.check_type(line_))
        end
        
        
        def test_as_text_wkt_round_trip
          point1_ = @factory.point(0, 0)
          point2_ = @factory.point(0, 1)
          line1_ = @factory.line_string([point1_, point2_])
          text_ = line1_.as_text
          line2_ = @factory.parse_wkt(text_)
          assert_equal(line2_, line1_)
        end
        
        
        def test_as_binary_wkb_round_trip
          point1_ = @factory.point(-42, 0)
          point2_ = @factory.point(0, 193)
          line1_ = @factory.line_string([point1_, point2_])
          binary_ = line1_.as_binary
          line2_ = @factory.parse_wkb(binary_)
          assert_equal(line2_, line1_)
        end
        
        
        def test_empty_as_text_wkt_round_trip
          line1_ = @factory.line_string([])
          text_ = line1_.as_text
          line2_ = @factory.parse_wkt(text_)
          assert(line2_.is_empty?)
        end
        
        
        def test_empty_as_binary_wkb_round_trip
          line1_ = @factory.line_string([])
          binary_ = line1_.as_binary
          line2_ = @factory.parse_wkb(binary_)
          assert(line2_.is_empty?)
        end
        
        
        def test_dimension
          point1_ = @factory.point(-42, 0)
          point2_ = @factory.point(0, 193)
          line1_ = @factory.line_string([point1_, point2_])
          assert_equal(1, line1_.dimension)
        end
        
        
        def test_is_empty
          point1_ = @factory.point(-42, 0)
          point2_ = @factory.point(0, 193)
          line1_ = @factory.line_string([point1_, point2_])
          assert(!line1_.is_empty?)
          line2_ = @factory.line_string([])
          assert(line2_.is_empty?)
        end
        
        
      end
      
    end
  end
end
