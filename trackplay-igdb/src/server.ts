import { getBaseURL } from '@trackplay/core/utils'
import { logger } from '@trackplay/core/logger'
import { config } from '@config/index'
import app from './app'

/**
 * Entry point for the application.
 * Starts the HTTP server and logs startup info.
 *
 * @module server
 */
app.listen(config.PORT, config.HOST, () => {
  logger.info(`🚀 Server running at ${getBaseURL()}`)
})
