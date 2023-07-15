module GatheringsHelper
  def tentukan_jenis_report(jenis_kategori, data_hadir, data_tidak_hadir,presence)
    data={}

    if jenis_kategori == 'all'
      guest = Gathering.all
    else
      guest = Gathering.find_by(category:jenis_kategori)
    end

    if jenis_kategori == "all"
      data[:color] = 'background-color: #FF8B17;'
      data[:report] = Gathering.joins(:event).where("events.name like '%#{params[:event][:event_id]}%'").page(params[:page]).per(100)
    else
      if presence == "hadir"
        data[:color] = 'background-color: #2ecc71;'
        data[:report] = data_hadir.page(params[:page]).per(100)
      elsif presence == "tidak_hadir"
        data[:color] = 'background-color: #e74c3c;'
        data[:report] = data_tidak_hadir.page(params[:page]).per(100)
      else
        data[:color] = 'background-color: #FF8B17;'
        data[:report] = Gathering.joins(:event).where("events.name like '%#{params[:event][:event_id]}%'").where(category:params[:jenis_kategori]).page(params[:page]).per(100)
      end
    end

    data[:data_hadir] = data_hadir.count
    data[:tidak_hadir] = data_tidak_hadir.count
    data[:header_custom] = custom_header_are_true
    return data
  end

  def custom_header_are_true
    header_active = Setting.all
    result = {}
    header_active.each do |ha|
      result[:custom_one_text] = ha.custom_one_text if ha.custom_one == true
      result[:custom_two_text] = ha.custom_two_text if ha.custom_two == true
      result[:custom_three_text] = ha.custom_three_text if ha.custom_three == true
      result[:custom_four_text] = ha.custom_four_text if ha.custom_four == true
      result[:custom_five_text] = ha.custom_five_text if ha.custom_five == true
    end
    return result
  end

  def delete_duplicate_value(value)
    data = []
    value.each do |v|
      data.push(v.unit_kerja)
    end
    return data.uniq
  end

  def search(name,alamat,kategori)
    name = name.present? ? "gatherings.name ilike '%#{name}%'" : ''
    alamat = alamat.present? ? "and gatherings.address ilike '%#{alamat}%'" : ''
    kategori = kategori.present? ? "and gatherings.category ilike '%#{kategori}%'" : ''

		Gathering.joins(event: :type_of_event).where("type_of_events.id = 1")
    .where("type_of_events.name ilike '%Gathering%'")
    .where("events.status = TRUE")
    .where("#{name} #{alamat} #{kategori}")
    .order(name: :asc)
    .page(params[:page]).page(1)
	end
end
