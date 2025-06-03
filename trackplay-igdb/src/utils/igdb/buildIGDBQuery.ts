import { IGDBGameFilters } from '@trackplay/core/schemas'
import { IGDB } from '@constants/index'

type BuildQueryOptions = IGDBGameFilters & {
  where?: string
}

/**
 * Builds a dynamic IGDB query string from provided filters or a custom condition.
 *
 * @param filters - The filtering, sorting and pagination options
 * @returns A string query compatible with IGDB API
 *
 * @module utils/igdb
 */
export const buildIGDBQuery = (filters: BuildQueryOptions): string => {
  const {
    q,
    limit = 5,
    offset = 0,
    sortBy,
    sortOrder = 'desc',
    minRating,
    minAggregatedRating,
    minFollows,
    minHypes,
    platforms,
    genres,
    themes,
    where,
  } = filters

  const queryParts: string[] = []
  const whereParts: string[] = []

  queryParts.push(`fields ${IGDB.GAME_FIELDS.trim()};`)

  if (q) {
    if (sortBy) {
      whereParts.push(`name ~ *"${q}"*`)
    } else {
      queryParts.push(`search "${q}";`)
    }
  }

  if (minRating !== undefined) whereParts.push(`rating >= ${minRating}`)
  if (minAggregatedRating !== undefined) whereParts.push(`aggregated_rating >= ${minAggregatedRating}`)
  if (minFollows !== undefined) whereParts.push(`follows >= ${minFollows}`)
  if (minHypes !== undefined) whereParts.push(`hypes >= ${minHypes}`)

  if (platforms?.length) whereParts.push(`platforms = (${platforms.join(',')})`)
  if (genres?.length) whereParts.push(`genres = (${genres.join(',')})`)
  if (themes?.length) whereParts.push(`themes = (${themes.join(',')})`)

  if (where) {
    queryParts.push(`where ${where};`)
  } else if (whereParts.length > 0) {
    queryParts.push(`where ${whereParts.join(' & ')};`)
  }

  if (sortBy) {
    queryParts.push(`sort ${sortBy} ${sortOrder};`)
  }

  queryParts.push(`limit ${limit};`)
  queryParts.push(`offset ${offset};`)

  return queryParts.join('\n')
}
