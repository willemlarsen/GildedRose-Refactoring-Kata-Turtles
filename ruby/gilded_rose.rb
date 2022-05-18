class GildedRose

  def initialize(items)
    @items = items
  end

  NAMED_ITEMS = {
    Sulfuras: 'Sulfuras, Hand of Ragnaros',
    Aged_brie: 'Aged Brie',
    Backstage_passes: 'Backstage passes to a TAFKAL80ETC concert'
  }.freeze

  def update_quality()
    @items.each do |item|
      modify_quality(item)
      decrease_sellin_for_items_other_than_sulfuras(item)
      decrease_quality_for_expired_normal_items(item)
      set_item_quality_to_zero_for_expired_backstage_passes(item)
      set_quality_when_item_is_expired_for_aged_brie(item)
    end
  end

  private

  # nonsense: strawberry
  # honest: does_a_thing
  # honest and complete: does_a_thing_and_does_another_thing
  # does_the_right_thing: does_one_thing
  # intent: do_this_business_thing
  # domain_abstraction: this_is_business_thing_that_helps_everywhere_ish

  def set_quality_when_item_is_expired_for_aged_brie(item)
    if item_is_expired?(item)
      when_aged_brie_increase_quality(item)
    end
  end

  def item_is_expired?(item)
    item.sell_in < 0
  end

  def decrease_quality_for_expired_normal_items(item)
    if is_a_normal_item(item) and item_is_expired?(item)
      decrease_quality_by_one_when_greater_than_zero(item)
    end
  end

  def when_aged_brie_increase_quality(item)
    increase_quality_by_one_when_quality_is_below_fifty(item) if is_aged_brie?(item)
  end

  def is_aged_brie?(item)
    item.name == NAMED_ITEMS[:Aged_brie]
  end

  def set_item_quality_to_zero_for_expired_backstage_passes(item)
    set_item_quality_to_zero(item) if is_backstage_pass?(item) and item_is_expired?(item)
  end

  def is_backstage_pass?(item)
    item.name == NAMED_ITEMS[:Backstage_passes]
  end

  def decrease_quality_by_one_when_greater_than_zero(item)
    if item.quality > 0
      decrease_item_quality_by_one(item)
    end
  end



  def decrease_sellin_for_items_other_than_sulfuras(item)
    if is_not_sulfuras(item)
      decrease_item_sellin_by_one(item)
    end
  end

  def set_item_quality_to_zero(item)
    item.quality = item.quality - item.quality
  end

  def decrease_item_sellin_by_one(item)
    item.sell_in = item.sell_in - 1
  end

  def modify_quality(item)
    increase_quality_for_unnamed_items(item)
    increase_quality_for_named_items(item)
  end

  def increase_quality_for_named_items(item)
    if is_not_a_normal_item(item)
      increase_quality_for_items_that_are_not_normal_when_quality_below_fifty(item)
    end
  end

  def increase_quality_for_unnamed_items(item)
    if is_a_normal_item(item)
      decrease_item_quality_when_quality_above_zero(item)
    end
  end

  def is_a_normal_item(item)
    is_not_aged_brie(item) and is_not_backstage_passes(item) and is_not_sulfuras(item)
  end

  def is_not_a_normal_item(item)
    NAMED_ITEMS.value?(item.name)
  end

  def is_not_backstage_passes(item)
    item.name != NAMED_ITEMS[:Backstage_passes]
  end

  def is_not_aged_brie(item)
    item.name != NAMED_ITEMS[:Aged_brie]
  end

  def increase_quality_for_items_that_are_not_normal_when_quality_below_fifty(item)
    if item.quality < 50
      increase_quality_for_items_that_are_not_normal(item)
    end
  end

  def increase_quality_for_items_that_are_not_normal(item)
    increase_quality_for_brie_and_backstage_passes_and_sulfuras(item)
    increase_quality_for_backstage_passes(item)
  end

  def increase_quality_for_brie_and_backstage_passes_and_sulfuras(item)
    item.quality = item.quality + 1
  end

  def increase_quality_for_backstage_passes(item)
    if item.name == NAMED_ITEMS[:Backstage_passes]
      increase_quality_when_item_sellin_below_eleven_and_six(item)
    end
  end

  def increase_quality_when_item_sellin_below_eleven_and_six(item)
    increase_quality_when_sell_in_below_eleven(item)
    increase_quality_when_sell_in_below_six(item)
  end

  def increase_quality_when_sell_in_below_eleven(item)
    if item.sell_in < 11
      increase_quality_by_one_when_quality_is_below_fifty(item)
    end
  end

  def increase_quality_when_sell_in_below_six(item)
    if item.sell_in < 6
      increase_quality_by_one_when_quality_is_below_fifty(item)
    end
  end

  def increase_quality_by_one_when_quality_is_below_fifty(item)
    if item.quality < 50
      increase_quality_for_brie_and_backstage_passes_and_sulfuras(item)
    end
  end

  def decrease_item_quality_when_quality_above_zero(item)
    if item_is_not_worthless(item)
      decrease_item_quality_by_one(item)
    end
  end

  def item_is_not_worthless(item)
    item.quality > 0
  end

  def decrease_item_quality_by_one(item)
    item.quality = item.quality - 1
  end

  def is_not_sulfuras(item)
    item.name != NAMED_ITEMS[:Sulfuras]
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
