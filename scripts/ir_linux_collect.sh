#!/usr/bin/env bash
# Linux 应急响应一键取证收集: 登录痕迹/进程/网络/持久化/最近改动/可疑文件
# 用法: ./ir_linux_collect.sh [输出目录]   建议在可疑机器上尽快跑
set -u
OUT="${1:-ir_collect_$(date +%Y%m%d_%H%M%S)}"
mkdir -p "$OUT"

sec(){ printf '\n\033[1;31m== %s ==\033[0m\n' "$1"; tee "$OUT/summary.txt" >/dev/null; }
save(){ tee "$OUT/$1" ; }

sec "1/9 登录与用户"
{ echo "--- who/w ---"; w; echo "--- last 30 ---"; last -30;
  echo "--- /etc/passwd (UID=0) ---"; awk -F: '$3==0' /etc/passwd;
  echo "--- 空口令账号 ---"; awk -F: '($2==""){print $1}' /etc/shadow 2>/dev/null; } | save "01_users.txt"

sec "2/9 进程"
{ ps auxf; } | save "02_process.txt"

sec "3/9 网络连接"
{ ss -antlp; ss -unlp; } | save "03_netstat.txt"

sec "4/9 定时任务"
{ cat /etc/crontab; ls -la /etc/cron.d/ /etc/cron.daily/ 2>/dev/null;
  crontab -l 2>/dev/null; ls -la /var/spool/cron/ 2>/dev/null; } | save "04_cron.txt"

sec "5/9 开机启动/持久化"
{ cat /etc/rc.local 2>/dev/null; systemctl list-unit-files --state=enabled 2>/dev/null | head -40; } | save "05_startup.txt"

sec "6/9 SSH 相关"
{ cat /root/.ssh/authorized_keys 2>/dev/null; ls -la /root/.ssh/ 2>/dev/null;
  grep -E "Accepted|Failed" /var/log/secure /var/log/auth.log 2>/dev/null | tail -50; } | save "06_ssh.txt"

sec "7/9 最近 24h 改动文件 (/usr /etc /tmp /var/www)"
find /usr /etc /tmp /var/www /home -xdev -mtime -1 -type f 2>/dev/null | save "07_recent_files.txt"

sec "8/9 可疑位置扫描 (/tmp /dev/shm 可执行文件)"
{ find /tmp /dev/shm /var/tmp -type f -executable 2>/dev/null; } | save "08_suspicious_exec.txt"

sec "9/9 历史命令"
{ cat /root/.bash_history 2>/dev/null | tail -100;
  for h in /home/*/.bash_history; do echo "--- $h ---"; tail -50 "$h" 2>/dev/null; done; } | save "09_history.txt"

printf '\n\033[1;32m✔ 收集完成: %s\n后续: 离线分析, 重点关注 04/05/06/08\033[0m\n' "$OUT"
