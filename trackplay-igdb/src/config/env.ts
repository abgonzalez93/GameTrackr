import { required, env as coreEnv } from '@trackplay/core/config'

/**
 * Environment configuration.
 *
 * Centralized access to all environment variables used in the application,
 * including runtime flags and required external service credentials.
 *
 * Each variable is either loaded directly from `process.env`, has a default fallback,
 * or is enforced as required using the `required` function.
 *
 * @module config/env
 */
export const env = {
  ...coreEnv,
  HOST: process.env.HOST || '0.0.0.0',
  PORT: parseInt(process.env.PORT || '3001', 10),

  IGDB_CLIENT_ID: required('IGDB_CLIENT_ID'),
  IGDB_CLIENT_SECRET: required('IGDB_CLIENT_SECRET'),
}
