Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5CE8F6A
	for <ocfs2-devel@lists.linux.dev>; Sun, 26 May 2024 11:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716721621; cv=none; b=Dk3MkUdN9avk7PIPrzhO91ykGMkyidkMeAe77e/aIkpxzhSeatQqm1US21UYQ/NwEQ9uvpjrvv6huGvSG57QcHEgAmh1zRFziid99HYr6aft/Meh/RfsRSi8bHtRM5JtJDGjZ+QZ82xxDHqVNewGmALZtD97yayJLD1N9Jlw7ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716721621; c=relaxed/simple;
	bh=6qySknidgYbN9p8yrqJqox9SATznP7Wv/o0t+BTcdGE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JHiWcanammP5ezXg4fRr5bww0BE3IcQR5Bz9TxFAtx8PW85i/F1sQIHUEYjXf2cXf2e02o3EPxNGQNDpiw9ndSDiMmpmvgXd2FRg+1qse5Mvl0YY5CsKLuhR4oMqoEh9ul0k17FEphAmQ46twkicS8PloYITqJxKuI8hQ27fBnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrXzfS1M; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrXzfS1M"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2bf5ee192b1so1417587a91.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 26 May 2024 04:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716721619; x=1717326419; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zsopJubrIo6ssHFmT3PDqM84cG1UNN8QfQpbHfTCJTw=;
        b=nrXzfS1MRhD0kOOqAAgGciwVjQs1Uk/mTSoM48IWFCH5JzG32oP1uueYB+thfuZ5w8
         HTUdATPS1xwjsSWdCNf/yrIsd/yeaOpTdBxhPj16Tg7sUnFTnWUAnOa75t0aFZ9ne/gf
         G6SoCgruVKajs6V3xz1g08N94Y9tLDKggfXDiUFZY+Qvmb5k2TenSvZ0yNEm0rn4DnN+
         84f+OyjNXJoWpYpAnI3/7mD6zWllEC4OK8fJLRaBWaxqGwikOZz1QiJQkygOjojw4dBm
         g7lzF0zksaTXVdd1YmLaNQprKbfLotlfLIMJgvPF0Lv0B7de2t3BijSguKlgQu27+CCI
         /32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716721619; x=1717326419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zsopJubrIo6ssHFmT3PDqM84cG1UNN8QfQpbHfTCJTw=;
        b=u9z1Vjpv9qi5ge0ZYi+wwWCFqLeXuLZtEPLBYv/xBDt90BLzv81NzQJEucv6lI3py7
         u5Zadqf1E20QdVBlLM0OduE4hM9NlNCrDIkmjI2+ZpadW02YyKA6pWPX2Wn5zWtMltp1
         J83OksnDM8+LEJ+BbGsCVFmPH/dDIpuAq9/O2XEcCHoLhGYjcBJKBbMw2ZvZz9nHaI5O
         gesY+ECLr0zoGDkDWNCr8zXHJEOwCnw6/kgFGBrQDb9rF0mWZD/QSeDSzVjS3mZZ5yvN
         oPPV2rohk7+Zho5j47JDRiKAiZ2e0OgPYHwThwK/SM0qUbzljXphxjbHseJk9WYdDQ8v
         Lbjg==
X-Forwarded-Encrypted: i=1; AJvYcCU85pJkVd/FLA2YyRcXlc6MUYsWC9iYw76M2lDgAFpp9EHfwFH/HLtYkU+1Wcyp+0etClsIduDeO5qQxh7LFhcLQO7eaNLIQ1HqYNU=
X-Gm-Message-State: AOJu0YxrTZgV+syv/DdrP9UbK4mbMIfoz2gIAnEhV7wwUOsrHBllgim3
	9i9woxWaiWC9ckMX1xqFf5iNY0svZNz8zTb9JgvOp1Xfj9h4imzr
X-Google-Smtp-Source: AGHT+IFDQqld7ooAbqoQAVuqB2sBiSzsV6Yx8Fatcz+qjfifXOKRVcw9jOQw50jrd2IcpmrQDz0b3g==
X-Received: by 2002:a17:90a:b117:b0:2bf:7cf1:f55f with SMTP id 98e67ed59e1d1-2bf7cf1f613mr6735404a91.15.1716721619415;
        Sun, 26 May 2024 04:06:59 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bde008a188sm5723666a91.53.2024.05.26.04.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 May 2024 04:06:59 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: joseph.qi@linux.alibaba.com
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev,
	lei lu <llfamsec@gmail.com>
Subject: [PATCH] ocfs2: add bounds checking to ocfs2_search_dirblock()
Date: Sun, 26 May 2024 19:06:31 +0800
Message-Id: <20240526110631.10618-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check to make sure all members of the ocfs2_dir_entry
don't stray beyond valid memory region.

Signed-off-by: lei lu <llfamsec@gmail.com>
---
 fs/ocfs2/dir.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d620d4c53c6f..385576d86983 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -358,6 +358,17 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
 
 		de = (struct ocfs2_dir_entry *) de_buf;
 
+		if (unlikely(de_buf + OCFS2_DIR_MEMBER_LEN > dlimit)) {
+			ret = -1;
+			goto bail;
+		}
+		de_len = le16_to_cpu(de->rec_len);
+		if (unlikely(de_buf + de_len > dlimit) ||
+		    unlikely(de_len < OCFS2_DIR_REC_LEN(de->name_len))) {
+			ret = -1;
+			goto bail;
+		}
+
 		if (de_buf + namelen <= dlimit &&
 		    ocfs2_match(namelen, name, de)) {
 			/* found a match - just to be sure, do a full check */
@@ -371,7 +382,6 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
 		}
 
 		/* prevent looping on a bad block */
-		de_len = le16_to_cpu(de->rec_len);
 		if (de_len <= 0) {
 			ret = -1;
 			goto bail;
-- 
2.34.1

