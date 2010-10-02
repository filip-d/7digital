module Sevendigital

  class DownloadUrlDigestor < Digestor

    def default_element_name; :download_url end
    def default_list_element_name; :download_urls end

    def from_proxy(download_url_proxy)
        make_sure_not_eating_nil (download_url_proxy)
        download_url = DownloadUrl.new()
        download_url.url = download_url_proxy.url.value.to_s
        download_url.format = @api_client.format_digestor.from_proxy(download_url_proxy.format)

        return download_url
    end

  end

end
