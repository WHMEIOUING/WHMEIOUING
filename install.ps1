# 安装 Node.js 和 Yarn
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "安装 Node.js..."
    Invoke-WebRequest -Uri https://nodejs.org/dist/v18.17.1/node-v18.17.1-x64.msi -OutFile node.msi
    Start-Process msiexec.exe -ArgumentList "/i node.msi /quiet" -Wait
    Remove-Item node.msi
}

if (-not (Get-Command yarn -ErrorAction SilentlyContinue)) {
    Write-Host "安装 Yarn..."
    npm install -g yarn
}

# 初始化 Docusaurus 项目
Write-Host "初始化 Docusaurus 项目..."
npx create-docusaurus@latest my-blog classic --typescript
cd my-blog

# 覆盖配置文件
@"
import type { Config } from '@docusaurus/types';

const config: Config = {
  title: '极简博客',
  themeConfig: {
    navbar: { title: '主页', items: [{ href: '/blog', label: '文章', position: 'left' }] },
    footer: { copyright: \`© \${new Date().getFullYear()} 极简博客\` },
  },
  presets: [['classic', { blog: { routeBasePath: '/' }, docs: false }]],
};

export default config;
"@ | Out-File -FilePath docusaurus.config.ts -Encoding utf8

# 创建第一篇博客
New-Item -ItemType Directory -Path blog -Force
@"
---
title: 我的第一篇文章
---

你好，这是极简博客的第一篇文章！
"@ | Out-File -FilePath blog/2024-01-01-first-post.md -Encoding utf8

# 启动博客
Write-Host "启动博客..."
yarn start
