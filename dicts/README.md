# 字典使用说明

本目录不存放字典文件（体积大、更新频繁），推荐直接用权威字典源：

## 推荐

| 字典 | 用途 | 获取 |
|---|---|---|
| **SecLists** | 全家桶（目录/子域/密码/参数） | `git clone --depth=1 https://github.com/danielmiessler/SecLists` |
| fuzzdb | 模糊测试与异常输入 | GitHub: fuzzdb-project/fuzzdb |

## 放置路径约定

```bash
git clone --depth=1 https://github.com/danielmiessler/SecLists /usr/share/seclists
# 之后各工具统一引用:
#   ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt
#   hydra -P /usr/share/seclists/Passwords/rockyou.txt
```

Kali 自带位置：`/usr/share/wordlists/`（`rockyou.txt.gz` 需解压）

## 自制字典思路（社工字典）

公司/人名 + 年份 + 常见后缀规则，用 hashcat 规则或 crunch 生成：

```bash
crunch 8 10 -t base@@@ -o out.txt      # base+3位小写
# 或对已有字典应用规则
hashcat -r best64.rule base_words.txt --stdout > extended.txt
```

> ⚠️ 字典爆破仅用于授权测试。
