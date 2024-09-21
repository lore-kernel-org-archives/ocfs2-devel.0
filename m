Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B412E657
	for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726941051; cv=none; b=BdElkJXEB7Ghj7MbZlf2O52ZY0ebLmqWcnNPD0CZK+1dRZLMbraMDufw/nN6q4H/vsL6Yc9og245csLi6Kf2dTSUrVGhjE3YNMiWzDGq1hqVQfxGwECdMv7D3bP+63ESYHmIHusYL25aH6vl6xr9c8pFIt94qeX6UfHLzw3Nd/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726941051; c=relaxed/simple;
	bh=AU0UdK29D6BvJgW5d2bqOz88BkcXagg3fHDkdBY9foE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rzg7OW2hrk+1ILgx+dZi9R7WIYrgyJzurJC+A5FN9AKubduO43T4RDwfwl1126GnfVLb3KfITNTH/vw9GHlPv4MuSZ8MjjEDAdzxqtRfvwwNba82QwrKPsRxsIrs5U1tLtsRU3kcm1IL9PYSlAINM8oglmEI1h7gkETl5ALq8WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DOQnemT3; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DOQnemT3"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-207397d1000so32272715ad.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 10:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726941048; x=1727545848; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wCNDt44G/ty2Nasp9vA9S62MfgwzCrwqOwsKSwf0Km8=;
        b=DOQnemT3Gz+wyFMLLPBQPUjUBNSrb8Uv3B8rnbU7rzjEW7zrwo1FcnGGmKQ7hi75Sp
         vZrkiprE4dYP4AdutiOK3W5Nx20VWjH1RFeeM8/Py0j6U8uLu3B7JA25HS4eosQ/jMv2
         8IoZ1lCpPeYTKnKSUfP97JgkT23xBQ5kU1KDJSh1m/e7oaRu85tXnYnfP2N+ezRh4buC
         U9qhd4XsKtVfGbrWa7hjHjlkpy2mfEj/BnslzW7JXMCr9Wf8x3ghUNTp3SNJ0ZRsEDku
         +3S0vmKaTmPB1O0T/EAdruzm8H66vyuIYzdsNpWvE10jpuLvYkQWtGws5MOWna3WSM/f
         imdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726941048; x=1727545848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wCNDt44G/ty2Nasp9vA9S62MfgwzCrwqOwsKSwf0Km8=;
        b=hbM2Rq4XobU5SYX3+8hCDFYnmzjSUbex+5koSZvqb1nGnL6u+3Pt3pFoX6pRRPOhD3
         DsLRjsaYw/PZKDAJm1kJVlUCuF9QbMA7pPNEPs4E038T9FD0vnKAGmQPfLVyNHSPwJvm
         6LwfwGfyzemnlEclzEm+OPofdgnAkQrTW4nfJN5g+VDKC755wjDjyPtSwCmY/5giPUwp
         lkHhkXDsWRQ14J+nf838k0/OipLRWCFX4v5g04TlSJf7A+pJsS4RezYyRLBWKr+cjw7W
         DhwcfQL8COfoEJSLtPo4MOcos6dN7kBwcimN+bI8HuVRKvb8efvoEn9v41i8qw12wDuw
         eY2A==
X-Gm-Message-State: AOJu0YxH2KYIWZzOO8T4/vdI6RzqjG+p9kGPuiTUa8VIPLyazKU0LF2L
	Y1ta+sJKGdO/9Z4um8PKrz1JlW93Ul17Q4CoHMObFfCmthNengRWhO62ABOX
X-Google-Smtp-Source: AGHT+IERYuWYmz+RC9gPwWAf+YZZBIXnpy25ZgMeed3AxVbMtv8WfbeSHO2mNX2pCgvtRjbS7MiVvQ==
X-Received: by 2002:a17:903:2287:b0:1fd:96c7:24f5 with SMTP id d9443c01a7336-208cb895e67mr165322165ad.5.1726941048464;
        Sat, 21 Sep 2024 10:50:48 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-207945da56esm111181055ad.3.2024.09.21.10.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 10:50:47 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: Fix deadlock in ocfs2_get_system_file_inode
Date: Sat, 21 Sep 2024 17:50:34 +0000
Message-ID: <20240921175034.11222-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot has found a possible deadlock in ocfs2_get_system_file_inode [1].

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

[1] https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd

Reported-and-tested-by: syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
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

