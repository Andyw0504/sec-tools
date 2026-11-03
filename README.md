# 🧰 sec-tools

> 渗透测试常用工具清单 + 高频命令速查。自己常用，随查随用，持续补充。

## 📂 信息收集

| 工具 | 用途 | 备注 |
|---|---|---|
| [subfinder](https://github.com/projectdiscovery/subfinder) | 子域名枚举 | 快，可接 API |
| [httpx](https://github.com/projectdiscovery/httpx) | 存活探测 | 配合 subfinder 管道使用 |
| [Nmap](https://nmap.org/) | 端口扫描 | 必会 |
| [ffuf](https://github.com/ffuf/ffuf) | 目录/参数爆破 | 比 dirsearch 快 |
| [EHole](https://github.com/EdgeSecurityTeam/EHole) | 指纹识别 | 常见 CMS 指纹 |
| [OneForAll](https://github.com/shmilylty/OneForAll) | 综合子域收集 | 一把梭 |

### 常用命令

```bash
# 子域名收集 → 存活探测 → 指纹识别 一条龙
subfinder -d target.com -silent | httpx -title -tech-detect -status-code

# 端口扫描（快速）
nmap -sS -Pn --top-ports 1000 -T4 target.com

# 全端口 + 服务版本
nmap -sV -p- --min-rate 5000 target.com

# 目录爆破
ffuf -u https://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt -mc 200,301,302,403
```

## 🎯 Web 渗透

| 工具 | 用途 |
|---|---|
| Burp Suite | 抓包 / Intruder / 越权测试，装上 [Autorize]、[HaE] 插件 |
| [sqlmap](https://github.com/sqlmapproject/sqlmap) | SQL 注入自动化 |
| [AntSword](https://github.com/AntSwordProject/AntSword) | WebShell 管理 |
| [nuclei](https://github.com/projectdiscovery/nuclei) | POC 批量验证 |
| [gobuster](https://github.com/OJ/gobuster) | 目录 / vhost 爆破 |

### 常用命令

```bash
# sqlmap 常规流程
sqlmap -u "http://target.com/x?id=1" --batch --dbs
sqlmap -r request.txt --batch --level 3 --risk 2

# nuclei 批量打 POC
nuclei -l urls.txt -severity critical,high -es info,low,medium
```

## 🔓 密码攻击

| 工具 | 用途 |
|---|---|
| [hashcat](https://hashcat.net/hashcat/) | GPU 跑哈希 |
| [John](https://github.com/openwall/john) | CPU 跑哈希 |
| [hydra](https://github.com/vanhauser-thc/thc-hydra) | 在线爆破 |
| [SecLists](https://github.com/danielmiessler/SecLists) | 字典全家桶 |

```bash
# 常见哈希识别与破解
hashcat -m 0 hash.txt rockyou.txt            # MD5
hashcat -m 1000 hash.txt rockyou.txt         # NTLM
hashcat -m 3200 hash.txt rockyou.txt         # bcrypt

# SSH 爆破
hydra -L users.txt -P pass.txt target.com ssh
```

## 🕸️ 内网渗透

| 工具 | 用途 |
|---|---|
| [Metasploit](https://github.com/rapid7/metasploit-framework) | 漏洞利用框架 |
| [Impacket](https://github.com/fortra/impacket) | Windows 协议工具集 |
| [frp](https://github.com/fatedier/frp) | 内网穿透 |
| [fscan](https://github.com/shadow1ng/fscan) | 内网综合扫描 |

```bash
# fscan 一把梭
fscan -h 192.168.1.0/24

# Impacket PTH
impacket-wmiexec -hashes :NTLM_HASH domain/user@10.0.0.5

# frp 反向代理（服务端）
./frps -c frps.toml
```

## 🛡️ 防守 & 应急

| 工具 | 用途 |
|---|---|
| [YARA](https://github.com/VirusTotal/yara) | 恶意样本规则匹配 |
| [Volatility](https://github.com/volatilityfoundation/volatility) | 内存取证 |
| [LiME](https://github.com/504ensicsLabs/LiME) | Linux 内存采集 |

```bash
# Linux 应急排查常用
history / last / w                        # 登录与历史
ps aux | grep -v "]"                      # 可疑进程
cat /etc/crontab / ls /etc/cron*          # 定时任务
find / -mtime -1 -type f 2>/dev/null      # 最近改动文件
ss -antlp / lsof -i                       # 网络连接
```

## 📚 学习资源

- [HackTricks](https://book.hacktricks.xyz/) — 渗透技巧百科
- [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/) — 官方速查
- [GTFOBins](https://gtfobins.github.io/) / [LOLBAS](https://lolbas-project.github.io/) — 提权二进制
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings) — Payload 宝典

---

> ⚠️ 仅用于合法授权测试，遵守《网络安全法》。
