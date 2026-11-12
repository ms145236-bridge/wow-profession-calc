// 上傳 dist 裡的 zip 到 CurseForge（Upload API）
// 需要：在 CurseForge 建好專案拿到專案 ID；到 https://legacy.curseforge.com/account/api-tokens 產生 API token，
//       自己設成環境變數 CF_API_TOKEN（不要寫進檔案或貼到聊天）。
// 用法：
//   node tools/cf-upload.mjs versions                       列出 CurseForge 的遊戲版本（找永恆的 ID）
//   node tools/cf-upload.mjs <專案ID> <zip> <遊戲版本ID> [release|beta|alpha] [更新說明檔.md]
import fs from 'fs';
import path from 'path';

const API = 'https://wow.curseforge.com/api';
const token = process.env.CF_API_TOKEN;
if (!token) { console.error('請先設定環境變數 CF_API_TOKEN'); process.exit(1); }
const headers = { 'X-Api-Token': token };
const [cmd, ...rest] = process.argv.slice(2);

if (cmd === 'versions') {
  const [vt, gv] = await Promise.all([
    fetch(`${API}/game/version-types`, { headers }).then(r => r.json()),
    fetch(`${API}/game/versions`, { headers }).then(r => r.json()),
  ]);
  const typeName = Object.fromEntries(vt.map(t => [t.id, t.name]));
  const q = (rest[0] || '').toLowerCase();
  for (const v of gv.sort((a, b) => b.id - a.id)) {
    const t = typeName[v.gameVersionTypeID] || v.gameVersionTypeID;
    const line = `${v.id}\t${v.name}\t${t}`;
    if (!q || line.toLowerCase().includes(q)) console.log(line);
  }
} else if (cmd && /^\d+$/.test(cmd)) {
  const [zip, verIds, type = 'release', changelogFile] = rest;
  if (!zip || !verIds) { console.error('用法：node tools/cf-upload.mjs <專案ID> <zip> <遊戲版本ID,可多個用逗號> [release|beta|alpha] [更新說明.md]'); process.exit(1); }
  const metadata = {
    changelog: changelogFile ? fs.readFileSync(changelogFile, 'utf8') : path.basename(zip, '.zip'),
    changelogType: 'markdown',
    displayName: path.basename(zip, '.zip'),
    gameVersions: verIds.split(',').map(Number),
    releaseType: type,
  };
  const form = new FormData();
  form.append('metadata', JSON.stringify(metadata));
  form.append('file', new Blob([fs.readFileSync(zip)]), path.basename(zip));
  const r = await fetch(`${API}/projects/${cmd}/upload-file`, { method: 'POST', headers, body: form });
  const text = await r.text();
  console.log(r.status, text);
  if (!r.ok) process.exit(1);
} else {
  console.log('用法：node tools/cf-upload.mjs versions [關鍵字]　或　node tools/cf-upload.mjs <專案ID> <zip> <遊戲版本ID> [release|beta|alpha] [更新說明.md]');
}
