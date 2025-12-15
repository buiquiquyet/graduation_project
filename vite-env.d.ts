/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_URL: string
  readonly VITE_FILE_URL: string
  readonly VITE_PUBLIC_URL: string
  // Thêm các biến khác nếu bạn có
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
