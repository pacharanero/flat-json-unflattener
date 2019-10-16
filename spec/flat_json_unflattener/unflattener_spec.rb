RSpec.describe Unflattener do
  it "has a version number" do
    expect(Unflattener::VERSION).not_to be nil
  end

  it "correctly unflattens the test flat JSON templates" do
    test_flat_json = File.read("spec/flat_json_unflattener/fixtures/test_flat_json.json")
    unflattened_test_flat_json = File.read("spec/flat_json_unflattener/fixtures/unflattened_test_flat_json.json")
    expect(unflattener(test_flat_json))
      .to eq(unflattened_test_flat_json)
  end
end
