import { IGDBGameSchema, IGDBGame, IGDBGameFilters, IGDBToken, IGDBTokenSchema } from '@trackplay/core/schemas'
import { apiFetch, assertExists, assertValid } from '@trackplay/core/utils'
import { HTTP_STATUS, IGDB } from '@trackplay/core/constants'
import { buildIGDBQuery, postToIGDB } from '@utils/index'
import { ApiError } from '@trackplay/core/errors'
import { config } from '@config/index'

let accessToken: string | null = null
let tokenExpiresAt: number | null = null

/**
 * Service for authenticating and retrieving game data from IGDB.
 *
 * @module services
 */
export const igdbService = {
  /**
   * Retrieves and caches a valid OAuth token from the Twitch/IGDB API.
   * If a cached token is still valid, it is reused.
   *
   * @returns A valid bearer token for IGDB requests
   * @throws ApiError if the token cannot be obtained
   */
  async getAccessToken(): Promise<string> {
    const now = Date.now()

    if (accessToken && tokenExpiresAt && now < tokenExpiresAt) {
      return accessToken
    }

    const params = new URLSearchParams({
      client_id: config.IGDB_CLIENT_ID,
      client_secret: config.IGDB_CLIENT_SECRET,
      grant_type: 'client_credentials',
    })

    try {
      const data = await apiFetch.post<IGDBToken>(IGDB.TOKEN_URL, {
        body: params,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      })

      const token = assertValid<IGDBToken>(IGDBTokenSchema, data, 'Invalid IGDB token response')

      accessToken = token.access_token
      tokenExpiresAt = now + data.expires_in * 1000

      return accessToken
    } catch (error: unknown) {
      throw new ApiError('IGDB authentication failed', HTTP_STATUS.UNAUTHORIZED, error)
    }
  },

  /**
   * Executes a search query against the IGDB API using filter options,
   * and returns a validated list of games.
   *
   * Internally builds a query string using the `buildIGDBQuery` utility based on
   * the provided filters (search term, rating, genres, platforms, etc.).
   *
   * @param filters - Filtering and sorting options to apply to the IGDB API query.
   * @returns A validated array of `IGDBGame` objects.
   * @throws ApiError - If the API request fails or the response is invalid.
   */
  async searchGames(filters: IGDBGameFilters): Promise<IGDBGame[]> {
    try {
      const token = await igdbService.getAccessToken()
      const query = buildIGDBQuery(filters)
      const games = await postToIGDB<IGDBGame[]>(query, token)

      return assertValid<IGDBGame[]>(IGDBGameSchema.array(), games, 'Invalid IGDB response')
    } catch (error: unknown) {
      throw new ApiError('Error searching games', HTTP_STATUS.BAD_GATEWAY, error)
    }
  },

  /**
   * Fetches and validates a single game by its IGDB numeric ID.
   *
   * Builds a query using `buildIGDBQuery` with a custom `where` clause to
   * request a single game. Validates the response structure using Zod.
   *
   * @param igdbId - The numeric IGDB ID of the game to retrieve.
   * @returns A validated `IGDBGame` object.
   * @throws ApiError - If the game is not found or the response is invalid.
   */
  async getGameById(igdbId: number): Promise<IGDBGame> {
    try {
      const token = await igdbService.getAccessToken()
      const query = buildIGDBQuery({ where: `id = ${igdbId}`, limit: 1 })
      const games = await postToIGDB<IGDBGame[]>(query, token)

      const game = assertExists<IGDBGame>(games?.[0], `Game with ID ${igdbId} not found`)

      return assertValid<IGDBGame>(IGDBGameSchema, game, 'Invalid game structure')
    } catch (error: unknown) {
      throw new ApiError('Error fetching game by ID', HTTP_STATUS.BAD_GATEWAY, error)
    }
  },
}
