select genre_tag
from {{ ref('mart_genre_tags') }}
where genre_tag is null
   or trim(genre_tag) = ''
