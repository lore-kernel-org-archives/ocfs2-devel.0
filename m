Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A047240604
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 05:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765516904; cv=none; b=oZvPqCYQU+NU9i4N5QHAx3KN7qs8ToatDsK9Rd2Ojaq/z5hGbJDM8UiNG2MpsPe8UR2RpthUIYnxmscEGbdFxDCfrce2YwXnvMPx/WwLwdb+KVoQjNFr/dibEkYFuwLMZtPnAoQS53FClobim7I6Z8r9NwyqQVFuB2EdZManbuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765516904; c=relaxed/simple;
	bh=S1DBotLlYvk9k0AmyT3FE9+aD8AH8zQWJA8o4UHqmTI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xt+W9Sa4BOQUkXCf+2ycJLZFYyRTZrFM/uOhoJEVyasVIsxBzGfL4/iCIdI1oYtA+OC+e0zE81V/6RTYDAP0L6z1TGTqIkESsiz4Lb2V56lAU2WA2Z7QrUiEYM28iA30uJL/CYVW54jsdOZOC4Vi8iIndIkglh4nkioPJDP8oSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fS3WfJdm; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fS3WfJdm"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2984dfae043so8870105ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 21:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765516902; x=1766121702; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v+Ija+pI/LjKCThcAVpVF5sRX9mTT5SVCKMoQmCEL8w=;
        b=fS3WfJdmzPJPeReUaeNCK1ot0sb5ZyrsRpurTwv13g2B/twOnUOfcB7jf4ZQ5xZY8b
         fm6Sf+pGecT7SeHcNpw0rgHegIK2fq9OUhgJS5paCrqUqL01A9BWj3gdpDqHGMlNN7UB
         rLm/bXQASNOSF00oja0nbwffPPxix6eZuqxGojV6SqMVjnPE1AoLbuT+o2AnaOOljl+k
         23S/zVX7vnIbejRMU0zuiOCWD9/BNQH6tliI4eFaTIa6egoS6eCNYDqc80f9crD8ks5m
         kr9fAx6ppaVGzolGNSuaP2ZIP4guqVmXKAUd5t8/wvPNbM6W+mX/rCrrfRMIOAlvpyA+
         otQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765516902; x=1766121702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v+Ija+pI/LjKCThcAVpVF5sRX9mTT5SVCKMoQmCEL8w=;
        b=iVMLWCf90HEZjKCpqUuuwayBxkpXG8hSxQkXk/FgWvneRoNaqo1kiulWvVCOLbZBuS
         uWiKkd4PL6+6HttBQq/8GQ1w1QxxSmdj55B6EVzbrG2QWXhZb/Owl3d828ZmZ97yYAdk
         s+pgX9OZGOcuEVKkh/rFijln92/ELpM+Tra2Y0Fayr2mSrgdTiN/4jkzz8B9Q7Frz8BJ
         9itVX6Pe4CAkrGuZJyMwUrufV8wceB45cW/ZuQMNWU/tEoGbkKD/ychd1c9eS6OtVkP9
         PGdf+iT7IqDYqqmfzE+jjxC8xcXa9YhT3CYFuwiKMpPbQWAs0FhDv+8La7bL8j6uxm3e
         pVSQ==
X-Gm-Message-State: AOJu0YwyNUl1m9K8URvFKPBwJ1LpkZDXdRZaPf/NFLZsj1+uLDcQdkQJ
	cAUCU17qgMVgTJEukLrf0fZTFBzsSfKTlQA7pXzE2cEzN7vvb77ADcddorjG7F3s
X-Gm-Gg: AY/fxX5VD7Pu8n0DnBWzgqIDTLZb7BzJD+eaJ9C5Sbrm7Vq/0SOVRMuQnVPV19/u7sU
	t9Ju0ZkikbIfC6QOSYKHkm2lYSTiBNWoh8T53+fi/Uhfrq1WAkJt5pJhwWwU1qTKbc906swJ+/Y
	PBiKqQLKoGUcQlkrmDcFlSnNbIGxp7j/nh8iPJ6glK8jsfOOsAwE7awoXr1LLOQXUt74GZ1xmPU
	KPsscDa6C1w+XFwtLHb+ysuvj0c/P7Yt633fpujS1jUrE0Wig8l7tixr5pwyI1yORj6M4cQSae8
	WQRSEeP+oV1PIff3x0xvYqXZlruoAb4hwUT5stZE8ZaoSvnZWilOsw7E3o5wKncO+yA5L4vYIq1
	Tc7rZStN6MdUZwzWdZW6nffHSFVZGPE8r/hDDCJPfcPQmvpqzUl0ZBEER/eFAm0AQFaCmbpE2Pg
	wszT49nD7Td14s4D/cfFfxENAmFOL5x11j6VvAiObH275z8IgXsHYD7teaB8n0sur4ki8=
X-Google-Smtp-Source: AGHT+IFYcspdGY3KrYZFsnEAJjmaELuSHQEgRKd8drqhsWxwvdRTL/m1yYypBnXAlV7bm7MWBKsspw==
X-Received: by 2002:a17:902:c402:b0:294:f1fa:9097 with SMTP id d9443c01a7336-29f2403930emr12009795ad.34.1765516901730;
        Thu, 11 Dec 2025 21:21:41 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:aae7:653e:9526:17a4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea03fa70sm41291565ad.69.2025.12.11.21.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 21:21:41 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Subject: [PATCH v3] ocfs2: validate inline data i_size during inode read
Date: Fri, 12 Dec 2025 10:51:32 +0530
Message-ID: <20251212052132.16750-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When reading an inode from disk, ocfs2_validate_inode_block() performs
various sanity checks but does not validate the size of inline data.
If the filesystem is corrupted, an inode's i_size can exceed the actual
inline data capacity (id_count).

This causes ocfs2_dir_foreach_blk_id() to iterate beyond the inline
data buffer, triggering a use-after-free when accessing directory
entries from freed memory.

In the syzbot report:
  - i_size was 1099511627576 bytes (~1TB)
  - Actual inline data capacity (id_count) is typically <256 bytes
  - A garbage rec_len (54648) caused ctx->pos to jump out of bounds
  - This triggered a UAF in ocfs2_check_dir_entry()

Fix by adding a validation check in ocfs2_validate_inode_block() to
ensure inodes with inline data have i_size <= id_count. This catches
the corruption early during inode read and prevents all downstream
code from operating on invalid data.

Reported-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c897823f699449cc3eb4
Tested-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251211115231.3560028-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20251212040400.6377-1-kartikey406@gmail.com/T/ [v2]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v3:
  - Folded new check into existing OCFS2_INLINE_DATA_FL block (Joseph Qi)

v2:
  - Removed unnecessary S_ISDIR() check since OCFS2_INLINE_DATA_FL
    applies to both directories and regular files (Heming Zhao)
  - Fixed checkpatch.pl warnings
---
 fs/ocfs2/inode.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8340525e5589..77f73fa663b7 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1486,12 +1486,25 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
-	    le32_to_cpu(di->i_clusters)) {
-		rc = ocfs2_error(sb, "Invalid dinode %llu: %u clusters\n",
-				 (unsigned long long)bh->b_blocknr,
-				 le32_to_cpu(di->i_clusters));
-		goto bail;
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
+		struct ocfs2_inline_data *data = &di->id2.i_data;
+
+		if (le32_to_cpu(di->i_clusters)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: %u clusters\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le32_to_cpu(di->i_clusters));
+			goto bail;
+		}
+
+		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size),
+					 le16_to_cpu(data->id_count));
+			goto bail;
+		}
 	}
 
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
-- 
2.43.0

