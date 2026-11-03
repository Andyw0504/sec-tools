# Nmap Cheatsheet

## 扫描策略速选

| 场景 | 命令 |
|---|---|
| 快速摸底 | `nmap -sS -Pn --top-ports 1000 -T4 <target>` |
| 全端口 | `nmap -sS -Pn -p- --min-rate 5000 <target>` |
| 服务版本+系统 | `nmap -sV -O --top-ports 1000 <target>` |
| 脚本扫描 | `nmap -sV --script=default <target>` |
| UDP 服务（snmp/dns） | `nmap -sU --top-ports 50 <target>` |
| Web 专项 | `nmap -p80,443 --script=http-enum,http-title <target>` |

## 常用参数记忆

- `-sS` SYN 半开扫描（默认，需 root）
- `-sT` 全连接（无 root 时用）
- `-Pn` 跳过 ping（防 icmp 拦截导致漏扫）
- `-T0~T5` 速度（实战 T4 平衡，T5 易丢结果/触发风控）
- `-oN file` / `-oX file` / `-oG file` 输出（oG 便于 grep）
- `--min-rate 5000` 限速下限，大网段提速
- `--open` 只显示开放端口
- `--script vuln` 全套漏洞脚本（慢，仅小范围）

## 高频 NSE 脚本

```bash
nmap --script smb-vuln-ms17-010 -p445 <target>     # 永恒之蓝检测
nmap --script ftp-anon -p21 <target>                # FTP 匿名
nmap --script mysql-empty-password -p3306 <target>  # MySQL 空密码
nmap --script redis-info -p6379 <target>            # Redis 信息
nmap --script http-title,http-enum -p80,443 <ip范围> # 批量 Web 摸底
```

## 实战注意

- 先 `-Pn --top-ports 1000` 摸底再 `-p-`，省时间
- 大网段先 `-sL` 列出目标，或直接交给 fscan
- 结果留档：渗透报告要用 `-oN/-oA`
