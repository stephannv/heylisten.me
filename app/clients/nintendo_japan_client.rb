class NintendoJapanClient
  include HTTParty

  base_uri 'https://search.nintendo.jp/nintendo_soft'
  default_params(
    opt_hard: '1_HAC',
    opt_osale: '1',
    sort: 'sodate desc',
    fq: %{
      ssitu_s:onsale
      OR ssitu_s:preorder
      OR (
        id:3347
        OR id:70010000013978
        OR id:70010000005986
        OR id:70010000004356
        OR id:ef5bf7785c3eca1ab4f3d46a121c1709
        OR id:3252
        OR id:3082
        OR id:20010000019167
      )
    }.squish
  )

  def fetch(page:, limit:)
    result = self.class.get('/search.json', query: { page: page, limit: limit })
    result.parsed_response.with_indifferent_access
  end
end
