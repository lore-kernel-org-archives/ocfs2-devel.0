Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5D31C984E
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726680062; cv=none; b=WQ0DlYHwm+QXMWJkMhoutOCfzRdl6OnIQ0jZOSJH/ADOJ9+WuAuJ2S+8EkVjtv2JpEtSDzgLMYrHul2pj1AqOK826jExLbEzX9HkqXHzJSc3xehxsD8JqzDepYwyXyYwCtdMOMMbFfFj+BDgnTgBKl0+Ww5TewnOe2s4D2Pov4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726680062; c=relaxed/simple;
	bh=dLW7yMaZUHwvr8OqyqLXlmiSaDlBdSZjSstzHtIjIaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAryid4yFqxPJS+oHmj+kT/JD/tRjIwGE9kOtq6SlIZSu1Z0wcQi8oaK2Zw2POK8VE3ZfF/5PiTZODW+gHNa5ISy48pMohBJZV4/xxxNkQMLfR3U0QFyY4gjCJXi+GctKw0/5JMvUULD/lXKDEeSBHG/Lvnw4lStKLEtktEQG7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KiZ7oGb1; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KiZ7oGb1"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-718e2855479so5257582b3a.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 10:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726680060; x=1727284860; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8x33SOcOiQLrcjzIwPJ+0Uf+LjyFv78ehpo58zIPVY=;
        b=KiZ7oGb1ehwPWMrsLfq5bFCk2ufgSAWh0s+saJU+EzUrrvo1NamCLZYiSZvEN/lL//
         9Hr8bfNdBPL1dOk9bE9BjcaYXVF5ZYjc3VOCWNd5rCzNyRZY0U2E7Psi2tQ1prXkpUPJ
         oPJGsfH+XyE5uOP64HZvKCoq24S3hC/bCx5Ieu/fe2+iJblp1APGDFk96fLzamqJukbx
         1aWVMmfOL2U28ryLSMbHU4y9k5gAhAKrsfo3NVhT2b1KMdN18jTrgMcOgMtR5ptu7jyp
         tqrrv8bD7M6iffA66V5/jUAwfTdWBMz7Atpn0pyPmg7dLQ7JAC9aAyt8Dxa0ofp+LWjB
         RhWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726680060; x=1727284860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X8x33SOcOiQLrcjzIwPJ+0Uf+LjyFv78ehpo58zIPVY=;
        b=eBKGf7vsWK7mAgIVZmWVAOfixCIDhGmJYZr48bh2gyTt9wdI6tePOM1FebsT2juJv5
         zEBg7311asm4bTFGK5IKTWgbzsaXk4Eta92eMg0tGJB7c9aQTF6MV0ohTIt3ySgHewPK
         ZO3tmUjB48Q9wgVdF28izhTwv8d2pHUnU4bhZwMkIxwST/sm10Mkvo2gjuObJ2I73m/t
         jklM4fvPJqgRLorCB5as5G8QkbF6hcaFx+nBZE4ZCBhc3lm+rPuoNa2mxubutgFSdkBQ
         cImSzoXkKJmxan9GfxAHPDp5yslcTWho/FLIPUr8FQRwUZAyHwK69jp63EbsXu+JeDoS
         Kx3w==
X-Gm-Message-State: AOJu0Yy8wo0Jh/emzlahfqc6oel757A1rsJiW4Z9CisbJQkCoWEwWaGG
	SK74rJcjlJwvRS9bq2JZGQxR+aHpcsnWmHwWOqNTaicNx6PdHkuQ+kA21s5V
X-Google-Smtp-Source: AGHT+IHPfFq2ebm0eN6ynBUnxXkvTYH9W9Sr+at5r786BHZM1dzVPHVDEIKanFJrN6wz1+6c++K+Gg==
X-Received: by 2002:a05:6a00:1703:b0:706:6c38:31f3 with SMTP id d2e1a72fcca58-71926080509mr33181259b3a.8.1726680059568;
        Wed, 18 Sep 2024 10:20:59 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-71944b7aeafsm7186476b3a.99.2024.09.18.10.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 10:20:58 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
Subject: [PATCH 1/2] ocfs2: Fix deadlock in ocfs2_read_virt_blocks
Date: Wed, 18 Sep 2024 17:20:25 +0000
Message-ID: <20240918172026.2532-2-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240918172026.2532-1-pvmohammedanees2003@gmail.com>
References: <20240918172026.2532-1-pvmohammedanees2003@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot has found a kernel BUG in ocfs2_write_cluster_by_desc,
while the next patch in the series resolves this, another
bug has been detected due to a potential deadlock [1].

The scenario is depicted here,

	CPU0					CPU1
lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&osb->system_file_mutex);
                               lock(&ocfs2_file_ip_alloc_sem_key);
lock(&osb->system_file_mutex);

The function calls which could lead to this are:

CPU0
ocfs2_write_begin - lock(&ocfs2_file_ip_alloc_sem_key);
.
.
.
ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);

CPU1 -
ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);
.
.
.
ocfs2_read_virt_blocks - lock(&ocfs2_file_ip_alloc_sem_key);

This issue can be resolved by making the down_read -> down_read_try
in the ocfs2_read_virt_blocks.

[1] https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6

Reported-and-tested-by: syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
---
 fs/ocfs2/extent_map.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 70a768b62..f83d0a3b6 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/fiemap.h>
+#include <linux/delay.h>
 
 #include <cluster/masklog.h>
 
@@ -961,6 +962,8 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	int rc = 0;
 	u64 p_block, p_count;
 	int i, count, done = 0;
+	int retries, max_retries = 5;
+	int retry_delay_ms = 30;
 
 	trace_ocfs2_read_virt_blocks(
 	     inode, (unsigned long long)v_block, nr, bhs, flags,
@@ -973,7 +976,18 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	}
 
 	while (done < nr) {
-		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+		retries = 0;
+		while (retries < max_retries) {
+			if (down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem))
+				break; // Lock acquired
+			msleep(retry_delay_ms);
+			retries++;
+		}
+		if (retries == max_retries) {
+			rc = -EAGAIN;
+			mlog(ML_ERROR, "Cannot acquire lock\n");
+			break;
+		}
 		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
 						 &p_block, &p_count, NULL);
 		up_read(&OCFS2_I(inode)->ip_alloc_sem);
-- 
2.46.0

