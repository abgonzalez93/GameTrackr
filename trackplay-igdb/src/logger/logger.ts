import { APP } from '@constants/index'
import winston from 'winston'

const { combine, timestamp, label, printf, colorize } = winston.format

/**
 * Custom format for console output.
 * Displays timestamp, label, log level, and message in a readable format.
 */
const consoleFormat = printf(({ level, message, label, timestamp }) => {
  return `[${timestamp}] [${label}] ${level}: ${message}`
})

/**
 * Winston logger configuration.
 *
 * @module logger
 */
export const logger = winston.createLogger({
  level: 'info',
  format: combine(
    label({ label: 'TrackPlay' }),
    timestamp({ format: 'HH:mm:ss' }),
    APP.IS_PRODUCTION ? winston.format.json() : combine(colorize(), consoleFormat),
  ),
  transports: [
    new winston.transports.Console(),
    ...(APP.IS_PRODUCTION
      ? [
          new winston.transports.File({
            filename: 'logs/error.log',
            level: 'error',
          }),
          new winston.transports.File({
            filename: 'logs/combined.log',
          }),
        ]
      : []),
  ],
  exceptionHandlers: [
    new winston.transports.File({
      filename: 'logs/exceptions.log',
    }),
  ],
  rejectionHandlers: [
    new winston.transports.File({
      filename: 'logs/rejections.log',
    }),
  ],
  exitOnError: false,
})
