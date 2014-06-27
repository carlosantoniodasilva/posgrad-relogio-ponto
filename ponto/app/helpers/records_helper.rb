module RecordsHelper
  def display_record_times(times)
    times.map { |time| l time }.to_sentence
  end

  def inconsistency_kind(inconsistency)
    t inconsistency.kind, scope: [:records, :inconsistencies, :kind]
  end

  def inconsistency_status(inconsistency)
    t inconsistency.status, scope: [:records, :inconsistencies, :status]
  end

  def inconsistency_status_icon(status)
    icon = {
      'pending' => 'flag',
      'granted' => 'ok-circle',
      'verified' => 'ban-circle'
    }[status.to_s]

    icon_tag(icon)
  end

  def inconsistency_status_icon_tooltip(inconsistency)
    content_tag :span, inconsistency_status_icon(inconsistency.status), data: {
      toggle: 'tooltip', title: inconsistency_status(inconsistency) }
  end
end
