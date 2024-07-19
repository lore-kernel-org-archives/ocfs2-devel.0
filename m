Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A86B6F30D
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Jul 2024 11:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721389399; cv=none; b=D8+7lFuU/TDMX6BdaNn6Z+2o6/girqzEZaRBB0K5gq4BFodmcEbOHIkylqVQWKJRqF5R/Nh8ASKyBv4oDA6rRRLi7siVHGHEF3nuNUuFgECdhKMIAip4E4F/xAmDCf5vaz+J0hpIt/rKdoat44Ygoq++ENxWt9nqkRzJLAnmlC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721389399; c=relaxed/simple;
	bh=V4XTVRvNV4cH4R+SZZtUre2UvQGSaCZhpCMh3DtRb0k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WDvc4opsa8moFx0LVsTaFS4HsN5mexREDoj0PTPMonGjPW+gRqAl5Z2wYT5EMTaMC/Um0FBilkZCoC3kzI0vJ2IZqQa0ecGagyu1Sw1Wv+d1tnQnBbDdLIMS4tN4FYYgJWmcfxsNq6Qnq8W1ofh/XY1t8RvlqxBUs0qJjlNSeKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=blcrImUr; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="blcrImUr"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a22f09d976so1318119a12.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 19 Jul 2024 04:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721389396; x=1721994196; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1xVNZl/BlvWyTa811/W0loWBw4s+U/ToGYmMkFWQMVo=;
        b=blcrImUrKc9td6/d1HFfHk1041ins21eMRoyUtdFRQK1SXKcORG1Xk3PSx2p2/Vmgt
         M0EFW1bg8lWSRBGbJ0otH/pOx8Xjaw0zc9mqPUxPt6Vt+yPjb01RDM9//ZLrRVFFEfXV
         tefLSntlP+VKc/sPSnP74hut8nKFrGi6RFCCI129mhz+KyEkofLOGrM2FREAVEtOFq4R
         zf38u1v8U+//tqBA438IRjqj6LGzWnLm+2/9rFLZlJ4gRU8Dn4S+Gvk7WnAzH7utzlSZ
         r3lH2IifTbgRUn5F/OeN82kdyBUb0bwTcZEZN8i+6WFCrE5VgF3cP3RVqHQ11+2o/ins
         jCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721389396; x=1721994196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1xVNZl/BlvWyTa811/W0loWBw4s+U/ToGYmMkFWQMVo=;
        b=Smw37tFHUazF3gg1W1utMCrtzYELe3lcvL88wMRDQELCFukrd9qCRlZpy8QjFCz5FA
         hGkT5angqUuZk/qLwe3yb9KrHG+zfBzSWVqAw10RET0f84HII1KybABUt+ClWsmMKHVU
         /BaPSluc7b8pegvEv/vw90QmOsDOjTAlVg8n4aGGzfH9VXm0thLeT0UuSWp98vr/0/Xj
         Y4zHXaj7Slssuz9N8qB90Hnp4zviO2X8bHzY6Vr/cTBVH9/n6ZQ48fJXHTJgU41FBTJr
         Z7VS5g7wXIXuxbsxpP+/5m/ayfXtfPrNiViTfgbuwQb95g/PhaiuRWHwlYm5ByKv4Bw+
         2oFg==
X-Forwarded-Encrypted: i=1; AJvYcCXJPbXxIvLo/VjjLwCW5IYPihRB7ttHtOvoy7mCeKiM7KmFT1ipczPCYXEJ6VEjNIKSsuwSt7AyS6CaeSSYYQdilkXnpmdBNdgJV1k=
X-Gm-Message-State: AOJu0Yydl5KARstdznx6whHELn+kMtXttwytQ5q1zvhZzerZB83TRME1
	CAT+E88x2mwDhKSoJczsWt8KSXdCRzq518h2CerXq77ZyJnKmvc6M0U5f+R5dd4=
X-Google-Smtp-Source: AGHT+IHafXCTZEUMzeJlu4fsTJMzgmOEXIpP+scVFU+1eMTuO1nKTnN6YrfoY9WepczkaoGjVXcjiw==
X-Received: by 2002:a17:906:71d0:b0:a77:ca9d:1d46 with SMTP id a640c23a62f3a-a7a0f79c980mr610287566b.33.1721389395961;
        Fri, 19 Jul 2024 04:43:15 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f433f2asm2773375ad.199.2024.07.19.04.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 04:43:15 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	glass.su@suse.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v3] ocfs2: fix the la space leak when unmounting an ocfs2 volume
Date: Fri, 19 Jul 2024 19:43:10 +0800
Message-Id: <20240719114310.14245-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This bug has existed since the initial OCFS2 code. The code logic
in ocfs2_sync_local_to_main() is wrong, as it ignores the last
contiguous free bits, which causes an OCFS2 volume to lose the
last free clusters of LA window on each umount command.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
---
v2 -> v3: follow review comment, revise the commit log.
v1 -> v2: adjust 'if' condition to make the code logic more concise
---
 fs/ocfs2/localalloc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 5df34561c551..8ac42ea81a17 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 		start = bit_off + 1;
 	}
 
+	/* clear the contiguous bits until the end boundary */
+	if (count) {
+		blkno = la_start_blk +
+			ocfs2_clusters_to_blocks(osb->sb,
+					start - count);
+
+		trace_ocfs2_sync_local_to_main_free(
+				count, start - count,
+				(unsigned long long)la_start_blk,
+				(unsigned long long)blkno);
+
+		status = ocfs2_release_clusters(handle,
+				main_bm_inode,
+				main_bm_bh, blkno,
+				count);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
 bail:
 	if (status)
 		mlog_errno(status);
-- 
2.35.3

