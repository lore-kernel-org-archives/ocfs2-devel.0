Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2BA183CC2
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 05:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734068814; cv=none; b=hUSHt1GIS8mX5S6T+PYfXe0N7WesuyfndCPvGc4z358UhvdbQqIvedsD+GoVyFtlfyfNhoN0mwDlNZfTe3hJmAJ4mtushJxV2kPj3vQwpYeXXQxPKISNPun8TdukqlCCkaja9Cp/9fXr4/V8LdoxMSg0UM+e3xpf2ysBfgLNbT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734068814; c=relaxed/simple;
	bh=Dbl6IM9eDg62zjXvaePP45Yh+mymlhXe9Q+BwlJcMGk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J45isa2279jpkkneUXslWrzuXUnu8I8FNphSAxI6eJYdhEht5I417dMHaDedKRtasgur9F8yKyfYe+8sSHkSo6JwUDBMUbbYdpjMCMWpkyhO9CPdM4GV/+IoSDkUxWZXV6cfD1K/qfs6qaca9Ie2JcwfKjr14MRIEp/MoNRsKuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EHIbehak; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHIbehak"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2161eb95317so12934835ad.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 21:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734068812; x=1734673612; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yq/q3oQ+1coBzSyYiu7PIQ9YY0FE8S8wlVnD6GFmf1s=;
        b=EHIbehaktVKYvCA9CyJ+TsytAWFOjfQpXWsWzwptANdwtZdlbOuYqW8weBcQmEEMwd
         OGQLPasU6MRJ39VqEE59crfPoDo44ryzQgmjCV+AltBmwzWY5D2MgelrYC+V0D47fcM3
         Pmwb5KbgbFBvz1exBxbEcZLpRULsZSme5Q9w23QLrFEJeCSUTSu4bxmep/1Tmpz9d/ww
         37ZhttB285ibGwQ095hIu+glgyOiUvKDuL/w3FI9asl1hsWbl8bg9yDdgrcgYmoMEm6V
         Y3/iVYEavi9xtAPcNv2rm0oE7nHTOhFlmsUWkBaqjQZtsPpmM+ALy0pvyXtzpilrxgu3
         MmHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734068812; x=1734673612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yq/q3oQ+1coBzSyYiu7PIQ9YY0FE8S8wlVnD6GFmf1s=;
        b=WpVI+letrD7e76ARbt8Kkry3lSHH+S64mh2JzlcuvU8//vRpvgu+3P4OTgezsX59jG
         4KhJxl7mnQ6CZhwqZTEn/EaoduG2Lrxh/loiS5sPSFuYrNaV+j0DxeT+7rgtw97ZyVv/
         cxBNVlF/WEbDyZchEWuuta2qVxFX7H/R8EENO/7tDndRXxCwROsTcgflTFF/Y1zT7fRh
         itgHStIHSPHhT0uxI2MBpw/xzU0I/ze8fgdpI4T77JdS0dRm0pvP7zOt8Ff9OOsdcWli
         o+elfWBzN1sY9WoUZyeLgnvuRSymQ5qzeb+2FF7/pd2aVcTebFVHwkT4EGXpGCpjj3Oj
         nbtg==
X-Forwarded-Encrypted: i=1; AJvYcCVhTfEve4vELq4DfwexdNZ8KS2S7hl7GcuDMMI0WDKgPSPtZlFLNlZJG3C5V7M7+vwgHLLfkjRea3scBA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/HW8TJqvDv2jTKOlt9DL0uktI9YMLaj8yAlAa6HqaE4CEi3ld
	v4c+8pW8/hBOpVujhS1msk/gQn6Xr5F36GCES5BC21e7o2HEUc2F
X-Gm-Gg: ASbGnctXxU0cYiaRslVNQ9xbBv2VkS8s6bPnXgMIH5r/mjcXVBj+8Nm6kCRqZqTBVJo
	9Gbbj48xXEW07IvOXJjjvE4ektyuqfXOwb8wejuI/qNQt855IK4YWd/u3qYq72EjxZxbsa9hy6d
	iBqDkZ4BoQ2yirYkkhjz4ZRFX39PAVJYbQ+MroWsrPpa4bDsSKLVH3rcU9nGni/DS8kXz0fXQaK
	OYjqzIyddwzkKftf/aeo+0ctAkPPS05LMEz1wWIZ4nAFYeqhfQvD34AdmwIlZQqvy+DYhjmDM1t
	Br1pxhs=
X-Google-Smtp-Source: AGHT+IFWBnsyszL3fKLErMwBwi/nv5YJk8bNHSLutoorKV6bDApMEi8hBMM4652Yq5VqnH7LBX6qQg==
X-Received: by 2002:a17:903:2a8d:b0:215:a3e4:d251 with SMTP id d9443c01a7336-2189298bb21mr20543965ad.6.1734068811964;
        Thu, 12 Dec 2024 21:46:51 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216483dd292sm82564985ad.226.2024.12.12.21.46.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Dec 2024 21:46:51 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: torvalds@linux-foundation.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	x86@kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	ocfs2-devel@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andy Whitcroft <apw@canonical.com>,
	Joe Perches <joe@perches.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 1/7] vsprintf: Add %pTN to print task name
Date: Fri, 13 Dec 2024 13:46:04 +0800
Message-Id: <20241213054610.55843-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241213054610.55843-1-laoar.shao@gmail.com>
References: <20241213054610.55843-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the task->comm is guaranteed to be NUL-ternimated, we can print it
directly. Add a new vsnprintf format specifier "%pTN" to print task comm,
where 'p' represents the task Pointer, 'T' stands for Task, and 'N' denots
Name. With this abstraction, the user no longer needs to care about
retrieving task name.

checkpatch.pl is updated accordingly.

Link: https://lore.kernel.org/bpf/CAHk-=wgqrwFXK-CO8-V4fwUh5ymnUZ=wJnFyufV1dM9rC1t3Lg@mail.gmail.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 lib/vsprintf.c        | 18 ++++++++++++++++++
 scripts/checkpatch.pl |  6 ++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6ac02bbb7df1..bb1018d79655 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2273,6 +2273,17 @@ char *resource_or_range(const char *fmt, char *buf, char *end, void *ptr,
 	return resource_string(buf, end, ptr, spec, fmt);
 }
 
+static noinline_for_stack
+char *task_name_string(char *buf, char *end, struct task_struct *p,
+		       struct printf_spec spec)
+{
+	if (check_pointer(&buf, end, p, spec))
+		return buf;
+
+	buf = string(buf, end, p->comm, spec);
+	return buf;
+}
+
 int __init no_hash_pointers_enable(char *str)
 {
 	if (no_hash_pointers)
@@ -2525,6 +2536,13 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		default:
 			return error_string(buf, end, "(einval)", spec);
 		}
+	case 'T':
+		switch (fmt[1]) {
+		case 'N':
+			return task_name_string(buf, end, ptr, spec);
+		default:
+			return error_string(buf, end, "(einval)", spec);
+		}
 	default:
 		return default_pointer(buf, end, ptr, spec);
 	}
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9eed3683ad76..fe0d80f55ce8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6908,11 +6908,13 @@ sub process {
 					$specifier = $1;
 					$extension = $2;
 					$qualifier = $3;
-					if ($extension !~ /[4SsBKRraEehMmIiUDdgVCbGNOxtf]/ ||
+					if ($extension !~ /[4SsBKRraEehMmIiUDdgVCbGNOxtfT]/ ||
 					    ($extension eq "f" &&
 					     defined $qualifier && $qualifier !~ /^w/) ||
 					    ($extension eq "4" &&
-					     defined $qualifier && $qualifier !~ /^cc/)) {
+					     defined $qualifier && $qualifier !~ /^cc/) ||
+					    ($extension eq "T" &&
+					     defined $qualifier && $qualifier ne "N")) {
 						$bad_specifier = $specifier;
 						last;
 					}
-- 
2.43.5

