class Moving < ApplicationRecord
  belongs_to :event

  validates_presence_of :guest_id, :event_id, :nama, presence: { message: "must be given please" }

  def self.reset_by_id(id)
    ActiveRecord::Base.transaction do
      begin
        m = Moving.find(id)
        if m.update(
          :presence         => false,
          :presence_time    => nil,
          :presence2        => false,
          :presence_2_time  => nil,
          :presence3        => false,
          :presence_3_time  => nil,
          :presence4        => false,
          :presence_4_time  => nil,
          :presence5        => false,
          :presence_5_time  => nil,
          :presence6        => false,
          :presence_6_time  => nil,
          :presence7        => false,
          :presence_7_time  => nil,
          :presence8        => false,
          :presence_8_time  => nil,
          :presence9        => false,
          :presence_9_time  => nil,
          :presence10       => false,
          :presence_10_time => nil,
          :souvenir         => false,
          :souvenir2        => false,
          :souvenir3        => false,
          :souvenir4        => false,
          :souvenir5        => false,
          :souvenir6        => false,
          :souvenir7        => false,
          :souvenir8        => false,
          :souvenir9        => false,
          :souvenir10       => false
        )

          lm = Logmoving.where(guest_id: m.guest_id)
          lm.update_all(:status => false)

          return true
        else
          Rails.logger.error("Update failed: #{m.errors.full_messages}")
          return false
        end
      rescue => e
        Rails.logger.error("Reset failed: #{e.message}")
        raise ActiveRecord::Rollback # Ensures transaction is rolled back
      end
    end
    return false
  end

  def self.reset_all(event_id)
    Moving.where(event_id: event_id).update_all(
      :presence         => false,
      :presence_time    => nil,
      :presence2        => false,
      :presence_2_time  => nil,
      :presence3        => false,
      :presence_3_time  => nil,
      :presence4        => false,
      :presence_4_time  => nil,
      :presence5        => false,
      :presence_5_time  => nil,
      :presence6        => false,
      :presence_6_time  => nil,
      :presence7        => false,
      :presence_7_time  => nil,
      :presence8        => false,
      :presence_8_time  => nil,
      :presence9        => false,
      :presence_9_time  => nil,
      :presence10       => false,
      :presence_10_time => nil,
      :souvenir         => false,
      :souvenir2        => false,
      :souvenir3        => false,
      :souvenir4        => false,
      :souvenir5        => false,
      :souvenir6        => false,
      :souvenir7        => false,
      :souvenir8        => false,
      :souvenir9        => false,
      :souvenir10       => false
    )

    Logmoving.where(event_id: event_id).update_all(:status => false)
  end

  def self.import(file, event_id)
    return false if file.blank? || event_id.blank?

    ActiveRecord::Base.transaction do
      begin
        spreadsheet = Roo::Spreadsheet.open(file.path)
        header      = spreadsheet.row(1)

        (2..spreadsheet.last_row).each do |i|
          row                = Hash[[header, spreadsheet.row(i)].transpose]
          row["event_id"]    = event_id
          absensi            = find_by_id(row["id"]) || new
          absensi.attributes = row.to_hash
          absensi.save!
        end

        true # Return true if the entire operation succeeds
      rescue => e
        Rails.logger.error("Import failed: #{e.message}")
        raise ActiveRecord::Rollback # Ensures transaction is rolled back
      end
    end

    false # Return false if an exception occurs
  end

  def self.search(search, check)
    if search
      case check
        # nama
      when "0"
        where (["nama ilike ?", "%#{search}%"])
        # guest_id
      when "1"
        where (["guest_id ilike ?", "%#{search}%"])
      when "2"
        where (["instansi ilike ?", "%#{search}%"])
      when "3"
        where (["jabatan ilike ?", "%#{search}%"])
      else
        where (["unit_kerja ilike ?", "%#{search}%"])

      end
    end
  end

  def self.count_by_presence(event_id, group_by_category)
    additional_clause = group_by_category ? ", kategori" : ""
    query             = <<-SQL
SELECT
    'presence_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_time #{additional_clause}
UNION
SELECT
    'presence_2_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_2_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_2_time #{additional_clause}
UNION
SELECT
    'presence_3_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_3_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_3_time #{additional_clause}
UNION
SELECT
    'presence_4_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_4_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_4_time #{additional_clause}
UNION
SELECT
    'presence_5_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_5_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_5_time #{additional_clause}
UNION
SELECT
    'presence_6_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_6_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_6_time #{additional_clause}
UNION
SELECT
    'presence_7_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_7_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_7_time #{additional_clause}
UNION
SELECT
    'presence_8_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_8_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_8_time #{additional_clause}
UNION
SELECT
    'presence_9_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_9_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_9_time #{additional_clause}
UNION
SELECT
    'presence_10_time' AS presence_column,
    COUNT(*) AS presence_count
FROM movings
WHERE presence_10_time IS NOT NULL
AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
GROUP BY presence_10_time #{additional_clause};
    SQL

    ActiveRecord::Base.connection.execute(query).to_h { |row| [row['presence_column'], row['presence_count']] }
  end

  def self.count_by_presence_group_by_category(event_id)
    presence_columns = %w[
    presence_time presence_2_time presence_3_time presence_4_time
    presence_5_time presence_6_time presence_7_time presence_8_time
    presence_9_time presence_10_time
  ]

    unions = presence_columns.map do |col|
      <<-SQL
    SELECT
        kategori,
        '#{col}' AS presence_column,
        COUNT(*) AS presence_count
    FROM movings
    WHERE #{col} IS NOT NULL
      AND event_id = #{ActiveRecord::Base.connection.quote(event_id)}
    GROUP BY #{col}, kategori
      SQL
    end

    final_query = unions.join(" UNION ")

    # Execute the query
    results = ActiveRecord::Base.connection.execute(final_query).to_a

    # Transform results into the desired hash format
    categorized_counts = {}

    results.each do |row|
      kategori = row['kategori']
      column   = row['presence_column']
      count    = row['presence_count']

      # Initialize hash for this kategori if not already done
      categorized_counts[kategori] ||= {}

      # Populate the presence column with its count
      categorized_counts[kategori][column] = count
    end

    # Ensure all presence columns exist in each kategori, even with zero counts
    presence_columns.each do |col|
      categorized_counts.each_key do |kategori|
        categorized_counts[kategori][col] ||= 0
      end
    end

    categorized_counts
  end
end
