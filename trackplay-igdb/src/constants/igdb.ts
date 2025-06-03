import { IGDB as coreIGDB } from '@trackplay/core/constants'
import { env } from '@config/index'

/**
 * All available fields for an IGDB Game query, expanded for nested objects like cover, genres, etc.
 *
 * @module constants
 */
export const IGDB = {
  ...coreIGDB,
  CLIENT_ID: env.IGDB_CLIENT_ID,
  CLIENT_SECRET: env.IGDB_CLIENT_SECRET,
}
