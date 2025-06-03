import eslintPluginPrettier from 'eslint-plugin-prettier'
import prettier from 'eslint-config-prettier'
import tseslint from 'typescript-eslint'
import js from '@eslint/js'

export default [
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ['src/**/*.ts'],
    plugins: {
      prettier: eslintPluginPrettier,
    },
    rules: {
      'prettier/prettier': 'error',
    },
  },
  prettier,
]
