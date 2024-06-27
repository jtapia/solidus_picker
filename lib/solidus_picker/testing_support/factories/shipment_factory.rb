# frozen_string_literal: true

FactoryBot.modify do
  factory :shipment do
    transient do
      inventory_units { 1 }
    end

    after(:create) do |shipment, e|
      create_list(:inventory_unit, e.inventory_units, shipment: shipment)
    end

    trait :with_picker do
      transient do
        picker_shipment_id { 'sh_test' }
        picker_rate_id { 'rt_test' }
      end

      after(:create) do |shipment, evaluator|
        create(
          :shipping_rate,
          shipment: shipment,
          selected: true,
          picker_shipment_id: evaluator.picker_shipment_id,
          picker_rate_id: evaluator.picker_rate_id,
        )
      end
    end
  end
end
