
---

## 1-Holat: Secret faqat **LOCAL** repoda (Hali `push` qilinmagan)

Agar secret faqat o'zingizning kompyuteringizda bo'lsa va hali serverga (`remote`) yuklanmagan bo'lsa:

### 1-qadam: Commit-ni bekor qilish
Oxirgi commit-larni bekor qilib, o'zgarishlarni qaytarish:
```bash
git reset HEAD~<number>
```
> **Eslatma:** `<number>` o'rniga nechta commit ortga qaytarmoqchi bo'lsangiz o'sha sonni yozing (masalan, `git reset HEAD~1`).

### 2-qadam: Secret-ni to'g'rilash va qayta commit qilish
1. `.env` yoki maxfiy faylni `.gitignore` fayliga qo'shing.
2. Kod ichidagi leak bo'lgan secret-larni o'chiring.
3. Yangi xavfsiz commit yarating:
```bash
git add .
git commit -m "fix: remove sensitive data"
```

### 3-qadam: Git Reflog va xotirani tozalash
Mahalliy Git tarixidan barcha izlarni butunlay o'chirish:
```bash
# Reflog tarixini tozalash
git reflog expire --expire=now --all
---

## 2-Holat: Secret **REMOTE** repoga yuklangan (`push` qilingan)

>  **MUHIM:** Remote-ga push qilingan secret-ni **darhol buzilgan (xaf ostida qolgan)** deb hisoblash kerak.

### 1-qadam: Oqib turgan secret-larni faoliyatini to'xtatish (Revoke)
* **Darhol** sizib chiqqan API key, token yoki parollarni tegishli servis panelidan **revoke** (bekor) qiling.

### 2-qadam: Yangi secret yaratish va almashtirish
1. Servisda yangi secret key yaratib oling.
2. Mahalliy muhitingizdagi (`.env`) eski key-ni yangisiga almashtiring.
3. Kod va loyihangiz to'g'ri ishlayotganini tekshiring.

### 3-qadam: Yangilangan xavfsiz holatni Git-ga push qilish
1. Yangi o'zgarishlarni push qiling:
```bash
git add .
git commit -m "chore: rotate compromised secrets"
git push origin <branch-name>
```

---
