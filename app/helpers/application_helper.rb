module ApplicationHelper
  def page_title(page_title = '')
    base_title = 'MyGuiltyPet'

    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def default_meta_tags
    {
      site: Settings.meta.site,
      title: Settings.meta.title,
      reverse: false,
      charset: Settings.meta.charset,
      description: Settings.meta.description,
      keywords: Settings.meta.keywords,
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :full_title,
        description: :description,
        type: Settings.meta.og.type,
        url: request.original_url,
        image: "#{request.base_url}#{asset_pack_path(Settings.meta.og.image_path)}",
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
      }
    }
  end
end
