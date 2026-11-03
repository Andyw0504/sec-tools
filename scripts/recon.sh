#!/usr/bin/env bash
# 信息收集一条龙: 子域名 → 存活探测 → 指纹 → 目录 → 漏洞验证
# 依赖: subfinder httpx nuclei (go install 项目)
# 用法: ./recon.sh example.com [输出目录]

set -u
DOMAIN="${1:?用法: $0 <域名> [输出目录]}"
OUT="${2:-recon_${DOMAIN}_$(date +%m%d)}"
mkdir -p "$OUT"

step(){ printf '\n\033[1;36m[%s] %s\033[0m\n' "$(date +%H:%M:%S)" "$1"; }

step "1/5 子域名收集"
subfinder -d "$DOMAIN" -silent -o "$OUT/subdomains.txt" || echo "(subfinder 不可用, 跳过)"

step "2/5 存活探测"
if [ -s "$OUT/subdomains.txt" ]; then
    httpx -l "$OUT/subdomains.txt" -title -tech-detect -status-code \
          -silent -o "$OUT/alive.txt" || true
fi

step "3/5 主站指纹与目录"
nmap -sT -Pn --top-ports 100 -T4 "$DOMAIN" -oN "$OUT/nmap_top100.txt" || true

step "4/5 nuclei 漏洞验证"
if [ -s "$OUT/alive.txt" ]; then
    nuclei -l "$OUT/alive.txt" -severity critical,high -es info,low,medium \
           -o "$OUT/nuclei_high.txt" -silent || true
fi

step "5/5 汇总"
cat <<EOF

========== 结果汇总 (${OUT}) ==========
子域名:    $(wc -l < "$OUT/subdomains.txt" 2>/dev/null || echo 0) 条
存活站点:  $(wc -l < "$OUT/alive.txt" 2>/dev/null || echo 0) 条
高危发现:  $(wc -l < "$OUT/nuclei_high.txt" 2>/dev/null || echo 0) 条
======================================
⚠️  仅供授权测试使用
EOF
