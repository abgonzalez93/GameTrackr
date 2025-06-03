import { APP as coreApp } from '@trackplay/core/constants'
import { env } from '@config/index'

/**
 * Application-level constants and environment flags.
 *
 * @module constants
 */
export const APP = {
  ...coreApp,
  HOST: env.HOST,
  PORT: env.PORT,
}
