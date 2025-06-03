import { getBaseURL } from '@utils/index'
import { logger } from '@logger/index'
import { APP } from '@constants/index'
import app from './app'

/**
 * Entry point for the application.
 * Starts the HTTP server and logs startup info.
 *
 * @module server
 */
app.listen(APP.PORT, APP.HOST, () => {
  logger.info(`🚀 Server running at ${getBaseURL()}`)
})
