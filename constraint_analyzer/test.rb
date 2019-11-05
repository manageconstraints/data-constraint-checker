class Test
  def test
    validates_each :to_person_id, allow_nil: true do |record, attribute, value|
      if attribute.to_s == "to_person_id" && value && record.to && record.to.email.nil?
        record.errors.add attribute, :invalid
      end
    end
  end
end
