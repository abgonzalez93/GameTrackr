import { ApiErrorResponseSchema } from '@trackplay/core/schemas'
import { HTTP_STATUS } from '@trackplay/core/constants'
import { ApiError } from '@trackplay/core/errors'

type Method = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE'

type FetchParams = {
  headers?: Record<string, string>
  body?: BodyInit | null
  filters?: Record<string, unknown>
  timeoutMs?: number
}

/**
 * Converts an object of filters to a query string.
 *
 * @param filters - Query parameters as key-value pairs
 * @returns A query string starting with "?" or an empty string
 */
const buildQueryParams = (filters: Record<string, unknown>): string => {
  const params = new URLSearchParams()

  for (const [key, value] of Object.entries(filters)) {
    if (value === undefined || value === null || value === '') continue
    if (Array.isArray(value)) {
      value.forEach((v) => {
        if (v !== undefined && v !== null && v !== '') {
          params.append(key, String(v))
        }
      })
    } else {
      params.set(key, String(value))
    }
  }

  const query = params.toString()
  return query ? `?${query}` : ''
}

/**
 * Prepares the final request URL and options by appending query parameters
 * and stripping internal-only fields like `query`.
 *
 * @param endpoint - Base endpoint path (e.g., "/games")
 * @param options - Fetch options, possibly including a `query` object
 * @returns An object with the final endpoint string and cleaned options
 */
const prepareRequestInput = (
  endpoint: string,
  options?: FetchParams,
): { endpoint: string; options: Omit<FetchParams, 'filters'> } => {
  const { filters, ...rest } = options ?? {}
  const queryString = filters ? buildQueryParams(filters) : ''
  return {
    endpoint: `${endpoint}${queryString}`,
    options: rest,
  }
}

/**
 * Sends an HTTP request using the Fetch API with predefined configuration.
 *
 * @param method - HTTP method (GET, POST, etc.)
 * @param endpoint - Relative API endpoint (e.g., "/games")
 * @param options - Optional fetch configuration
 * @returns The raw Response object
 */
const performRequest = async (
  method: Method,
  endpoint: string,
  options: Omit<FetchParams, 'filters'>,
): Promise<Response> => {
  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), options.timeoutMs ?? 8000)

  try {
    return await fetch(endpoint, {
      method,
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      body: options.body ?? null,
      signal: controller.signal,
    })
  } finally {
    clearTimeout(timeout)
  }
}

/**
 * Parses the response body from the API as either JSON or plain text.
 *
 * @param res - The Response object
 * @returns Parsed body as `unknown`
 */
const parseResponseBody = async (res: Response): Promise<unknown> => {
  if (res.status === HTTP_STATUS.NO_CONTENT) return null
  const contentType = res.headers.get('content-type')
  if (contentType?.includes('application/json')) return await res.json()
  return await res.text()
}

/**
 * Handles failed HTTP responses by parsing and validating error content.
 *
 * @param res - The Response object
 * @param parsed - The already parsed body
 * @throws ApiError - If the response represents an API error
 */
const handleErrorResponse = (res: Response, parsed: unknown): never => {
  const result = ApiErrorResponseSchema.safeParse(parsed)

  if (result.success) {
    throw new ApiError(result.data.error, res.status, result.data.details)
  }

  const fallbackMessage =
    typeof parsed === 'object' && parsed !== null && 'error' in parsed
      ? String((parsed as { error: unknown }).error)
      : `[${res.status}] ${res.statusText}`

  throw new ApiError(fallbackMessage, res.status, parsed)
}

/**
 * Makes an HTTP request to the external API using the specified method.
 *
 * @template T - The expected response type
 * @param method - HTTP method (GET, POST, etc.)
 * @param endpoint - Relative path to the API endpoint (e.g., "/games")
 * @param options - Optional fetch configuration (headers, body, etc.)
 * @returns A promise resolving to the parsed JSON response as type T
 * @throws ApiError if the request fails or the response is not OK
 */
const request = async <T>(method: Method, endpoint: string, options: FetchParams = {}): Promise<T> => {
  const res = await performRequest(method, endpoint, options)
  const parsed = await parseResponseBody(res)
  if (!res.ok) handleErrorResponse(res, parsed)
  return parsed as T
}

/**
 * Executes a typed HTTP request using a dynamic method.
 *
 * @template T - The expected response type
 * @param method - HTTP method (GET, POST, etc.)
 * @param endpoint - API endpoint (e.g., "/games")
 * @param options - Optional fetch configuration
 * @returns A promise resolving to the typed response
 */
const method = <T>(method: Method, endpoint: string, options?: FetchParams): Promise<T> => {
  const { endpoint: fullUrl, options: cleanOptions } = prepareRequestInput(endpoint, options)
  return request<T>(method, fullUrl, cleanOptions)
}

/**
 * Typed API client for external HTTP requests.
 * Provides method shortcuts with consistent base URL, query string handling, and error processing.
 */
export const apiFetch = {
  get: <T>(endpoint: string, options?: FetchParams) => method<T>('GET', endpoint, options),
  post: <T>(endpoint: string, options?: FetchParams) => method<T>('POST', endpoint, options),
  put: <T>(endpoint: string, options?: FetchParams) => method<T>('PUT', endpoint, options),
  patch: <T>(endpoint: string, options?: FetchParams) => method<T>('PATCH', endpoint, options),
  delete: <T = void>(endpoint: string, options?: FetchParams) => method<T>('DELETE', endpoint, options),
}
