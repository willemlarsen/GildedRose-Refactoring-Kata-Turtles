require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  def test_foo
    items = [Item.new("foo", 0, 0)]
    GildedRose.new(items).update_quality()
    assert_equal "foo", items[0].name
  end

  def test_quality_degrades_normally_before_sell_by
    items = [Item.new("foo", 1, 1)]
    GildedRose.new(items).update_quality()
    assert_equal 0, items[0].quality
    assert_equal 0, items[0].sell_in
  end

  def test_quality_degrades_twice_as_fast_after_sell_in
    items = [Item.new("foo", 0, 2)]
    GildedRose.new(items).update_quality()
    assert_equal 0, items[0].quality
  end

  def test_quality_is_never_negative
    items = [Item.new("foo", 0, 1)]
    GildedRose.new(items).update_quality()
    assert_equal 0, items[0].quality
  end

  def test_aged_brie_quality_increases_with_age
    items = [Item.new("Aged Brie", 2, 1)]
    GildedRose.new(items).update_quality()
    assert_equal 2, items[0].quality
  end

  def test_item_quality_wont_increase_past_fifty
    items = [Item.new("Aged Brie", 2, 50)]
    GildedRose.new(items).update_quality()
    assert_equal 50, items[0].quality
  end

  def test_sulfuras_never_decreases_in_quality
    items = [Item.new("Sulfuras, Hand of Ragnaros", 1, 50)]
    GildedRose.new(items).update_quality()
    assert_equal 50, items[0].quality
  end

  def test_backstage_passes_quality_increases_with_age
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 1)]
    GildedRose.new(items).update_quality()
    assert_equal 2, items[0].quality
  end

  def test_backstage_passes_supposedly_increases_with_age_by_two_when_sellin_ten_days_or_less
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 2)]
    GildedRose.new(items).update_quality()
    assert_equal 4, items[0].quality
    GildedRose.new(items).update_quality()
    assert_equal 6, items[0].quality
  end

  def test_backstage_passes_quality_increases_with_age_by_three_when_sellin_five_days_or_less
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 2)]
    GildedRose.new(items).update_quality()
    assert_equal 5, items[0].quality
    GildedRose.new(items).update_quality()
    assert_equal 8, items[0].quality
  end

  def test_backstage_passes_quality_drops_to_zero_after_the_concert
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 2)]
    GildedRose.new(items).update_quality()
    assert_equal 0, items[0].quality
  end
end