// 极简本地静态服务器 —— 用于离线/本地运行 Minecraft Web 复刻
// 用法：双击 start.bat，或在命令行执行 `node server.js`
const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

const ROOT = __dirname;
const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.mjs': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.json': 'application/json; charset=utf-8',
  '.ico': 'image/x-icon',
};

let port = parseInt(process.env.PORT || '8080', 10);

function start(p) {
  const server = http.createServer((req, res) => {
    try {
      let urlPath = decodeURIComponent((req.url || '/').split('?')[0]);
      if (urlPath === '/') urlPath = '/index.html';
      const filePath = path.normalize(path.join(ROOT, urlPath));
      if (filePath !== ROOT && !filePath.startsWith(ROOT + path.sep)) {
        res.writeHead(403); res.end('forbidden'); return;
      }
      fs.readFile(filePath, (err, data) => {
        if (err) { res.writeHead(404); res.end('not found: ' + urlPath); return; }
        res.writeHead(200, { 'Content-Type': MIME[path.extname(filePath).toLowerCase()] || 'application/octet-stream' });
        res.end(data);
      });
    } catch (e) {
      res.writeHead(500); res.end('server error');
    }
  });

  server.on('error', (e) => {
    if (e.code === 'EADDRINUSE' && port < 8090) { port++; start(port); return; }
    console.error('启动失败:', e.message);
    process.exit(1);
  });

  server.listen(p, () => {
    const url = 'http://localhost:' + p + '/';
    console.log('');
    console.log('  Minecraft Web 复刻 已启动: ' + url);
    console.log('  （保持此窗口开启，关闭窗口即停止；按 Ctrl+C 也可停止）');
    console.log('');
    if (process.platform === 'win32') {
      try { exec('start "" "' + url + '"'); } catch (e) { /* 忽略 */ }
    }
  });
}

start(port);
