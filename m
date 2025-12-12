Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBDC1FDA
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 04:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765512251; cv=none; b=DPPBj5raLCNoCsEJ1gvTP9TNNfs2PWbOOrb635KesMyggmMoIq89kqv9pK9nRABdacElXW+4v/zQePBff21Rg7+WOErfxV0ruSj4Nhgh74oKk8/1f3V59LNeb+pCwIdKqrge+r7pF0plKYbQ+HKOLFHfv93b3urpwr6VKOmUy94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765512251; c=relaxed/simple;
	bh=KdDZ6W3VRrAwMnJ2DhTgc8C7kWnotA8raPuWE0OaeRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gkuJOK4fJtyxlVdrcHcJgACQPtd6Q2xGDnU9EwZrpgiS44CQiUNjtl8CIZXklkovZB+AF5QibND+FDKAHypLvMN4V3WF+2BsXtCzar/CsZ0Jcz2h0UGNg2eQY7Y37mpYGOZ6Dar2OQz/aw7Y2eZfaCSPxQdHhyLocDQB2yJ2L1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nds3ysX+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nds3ysX+"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-297ec50477aso3361995ad.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 20:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765512249; x=1766117049; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ya6S7/tWoBQ5tlm6IYlGn88u04M1bv/FGjazh0al2U=;
        b=nds3ysX+P2U0Ejtt9qO3sBVqenHtuckmi0+SLN5MhgAUhS7bplLUhg68HVBxuRYjKJ
         1XrOAi4plEz03WmH3pZzp/HFsw8Dveyo8nXEXd8hIRfBKC3b5xdPjAI860d1ww5E3nQz
         IkflznaYselTmVijMuCWvTNYcrMv2e7UU/9DE4VYBsNWjtVD7+fs6cLdhjWMogLv7PZN
         OPJdZz0ys5TORpKtNpzx/CsvzOlwcZs5vEfNcVwgcVx5wJpvgsTrkOnCKizqERSE6zyd
         fJku3UKapq7Y9O7niJShpQGNmnHW5jbIxJH0k3olaW1n6yt/heKQ+JddcPiaQKyK5vfR
         m7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765512249; x=1766117049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Ya6S7/tWoBQ5tlm6IYlGn88u04M1bv/FGjazh0al2U=;
        b=btedMopm3CKoBk5ecq3QbQ83jsVcXb9odH94umDWOPkRZfRNkDE9xAgHG+q2qT60Se
         e8BhIwUm0tVq6in+yUP9tU1pNALvFs/vmELHzfvjyE+hNLH8sZptiIkUTFgGDeDHunrh
         ZEGbAeUm+3v9ycUKW9gzNbi0Lk8vWnnIPKbRS5a/zXIMXYwiVbjZD8GqeRX+fmslpRVT
         DTmd/qJQJwiM1ZBXt21VWa2Qy5g6UPdcUg0deYH/00MuykZ+kzmuj/kqpQaJPaImzB0P
         HPfFMF5i7is3+9iPLBUU0byTGndtT6lkBZkvwuvm9Nf+ho4wqsML3NP4/q51C9VlUb4e
         fDGw==
X-Gm-Message-State: AOJu0YyuwbUlF8NEUCkX1YMi6YqrfspnPAZJw88eoTAhpQIYHFsPpPfD
	tadWogieNdmvohbnFD/zN0tMcXwEC2r7EpGOBof2KCyzPLb4xtA0dAIC
X-Gm-Gg: AY/fxX4l3MstSmn93/kPsIFCyFzIQLhTchxyiVXXrjiW9X+GJA25pw+aCOM5w/tLn7L
	T0v6XsabGII45RZ5odA88ftFdoBebwFKgTUE5Bg74KPra2XdF9vLh0W/gQn000Nonjns7a8TM4w
	Ni9BZBVafnfbmzVnJ/NPiJfvWreSnFvy82LGHG4rhfufMA3bgC12b3LHqVH1xacuvGFy+MUfdqI
	WqivM3s9CLCP8rpFBOqljTBEr2pz21JSuOHZgpHInZvplKMQ5Q9xUOzJz53u4J9iD/DkbWg+0xp
	ZrEigtA5JGPxWy+Js45f1APfKBuLDuY7s773HRy/PdaMOmGkoinn9i68Vqh33ECqAXsUXrIDl3K
	cXDw2ACJBc5LxbQo1jFJnF+7q1zb4JflQ6XABPYtvR+HDwGFqHoIcvYecQGooLrqQ2n8J95ewUc
	Co/MmLP7H3H7rHTLnIII3ZbOEmtDYnYzVOfhnz1D8lJc08XdsRrCsJueGWgPKiJDLong==
X-Google-Smtp-Source: AGHT+IFfW5AV/DoTBRTZbv83eJQ4iRTeVwQvR1CH731mPh4G85inpcR/toLkcas9Z6gZklPDTYFTGQ==
X-Received: by 2002:a17:902:f60a:b0:297:e1f5:190b with SMTP id d9443c01a7336-29eeebf3167mr45838765ad.22.1765512249300;
        Thu, 11 Dec 2025 20:04:09 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:754:daba:87be:a6b2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b376e2sm39346985ad.14.2025.12.11.20.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 20:04:08 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: validate inline data i_size during inode read
Date: Fri, 12 Dec 2025 09:34:00 +0530
Message-ID: <20251212040400.6377-1-kartikey406@gmail.com>
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
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v2:
  - Removed unnecessary S_ISDIR() check since OCFS2_INLINE_DATA_FL
    applies to both directories and regular files (Heming Zhao)
  - Fixed checkpatch.pl warnings
  - Updated commit message to say "inline data" instead of
    "inline directory"
---
 fs/ocfs2/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8340525e5589..1fac457cb04a 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1521,6 +1521,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	/*
+	 * Validate inline data size. If the inode has inline data,
+	 * i_size must not exceed the inline data capacity.
+	 */
+	if (di->i_dyn_features & cpu_to_le16(OCFS2_INLINE_DATA_FL)) {
+		struct ocfs2_inline_data *data = &di->id2.i_data;
+
+		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size),
+					 le16_to_cpu(data->id_count));
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
-- 
2.43.0

