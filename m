Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F17F30147E
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 06:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764657594; cv=none; b=cnpqhGlUdePUgkm6O7XM8m5TcH3Hr0ojEFzunbpNM/WrYyRwgUzpX3BN0rKUXIyAYfjCHc43SraAwVPyyj7WuCQ8s5En8uPD0mvD0spScdtXRuPNZSJWFCU+D1/P7gmoHN8hEYCImPL4K6lSFGdKbt107LoOTVUzANCNBguJRv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764657594; c=relaxed/simple;
	bh=u3tF8zKd7NcYJDtduBDGjGpk5WLn+y3aUQFW19+tjRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foHpm7WkcjGxfQwczsNKOHKp+NNxMPTJSGUXj3zZ7oKZEZW6OUMBvMetyS+Cks15mw3WV9V+C4URj98Mu0VU5iIOMUZx2iLWoX6nyh0qMzOHpLuaYhaKJyXUvkCoQgfwI241Nt7K4tOiRi4eOFEnnXieDrGODOp1ChK+MjabMqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XMX/aLgO; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XMX/aLgO"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477985aea2bso6208485e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 22:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764657591; x=1765262391; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9MWQEkUmssQH7h8+ZJJJrAiWh1kVuLIvHyNZDUo2Ps=;
        b=XMX/aLgO4XuQtI0pu2joyWwXB5XdHPVPs+oKW8r3RKcbBNp11IkqRa/0qz6VoFzQKZ
         izjI+qhwm/2sgGNFvknL3KpPaj7Cr5Whf8S6aLOMNbtUBjbW10iQJCLNXExLSR7dNK6z
         yWQZFiUz51iE1KBLwyaNsa1K2Xn2kp5MylhAME2NxALwSZD+wEv2r2Mz/AV4K8Eey6NC
         +4oQU9nFoowORvRKYbIz1Nq7JoygCA+FfBKbHkeIDmmaeVpv1SWhL/uBFO8lnkebBmOf
         yb6VJVuznyUmg49mzD6TYEK0wt8ThlK1icIIU/wboKc0GOe3Ssudu3oNPbA7tJ9J/agY
         3pLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764657591; x=1765262391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W9MWQEkUmssQH7h8+ZJJJrAiWh1kVuLIvHyNZDUo2Ps=;
        b=A4j/9Wfr6e2eMZEx04gCrkW+r8DyX6mDpCJ/ieFmihG/nx4Ld6PtktT1PlwBsncuBU
         sIpYtsTMgvzo9dVpmObE0ASwes0BKAYIxEHWWB674A4BZ9S4rNyFUA2fJgFshSeCCNSK
         bl65XdTenuOoLVhvECz2z/IGbbrFR8aoLquD+nmqJQnk99ztVZOz9L7n3U2AOCidhC6/
         KdZYqMI6miY2bCK1LCIJ9L/7VrOSJFmWt+nWDaKawO+hjBt+bdOK4+cEHqw0w4Cx9gZk
         6pUdIn1ZWz5BMSW1ywR8Lyrp9q/S5wDVwv4Ti+fKUdbkP6lVG+RpaarYIzhG5ECtlAfL
         cM/w==
X-Forwarded-Encrypted: i=1; AJvYcCUv9ySfjxZ8WDaj2t0cs+kApCPoVREFbvYZcpxk7tfE56ZgRopgoIhkH6rzpX9gOX+36xrgWYIVPljg8w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzfyXmYnTtq8Jjnvd5+CFXrTdpTOvHEHhohkE+zy6xMZA95FS1N
	b4J6NrMFkwcUDXUuWq6tVWqJz5stPk9xVfdSaluAA5ehK7D+YFwe31gD6RzTvItNBco=
X-Gm-Gg: ASbGncvDyQDdAd0O4KEpCSluJZpm8jfL/NmkN0qYCV5Z69BmZTzRpm9IDtspAT1Pj4C
	CxM8lrhItKDIuRWViIoqPTBHcODUh40WpG+GcavHnXGixnQDgfhWEci6MQ7gd8zCLiwW1dUePhe
	4KEqaOcQIlU5tqNlXwJOcxu1W/WuYxKc5bLmRvAUO+1WuWJR96Tq2mZHyXUKfbbEoydba41hvsB
	4LYAsgnnUSQOFmcd1DReRzxFWEpH46FVbJQgiOLuQ8w18/BfekE70T0XgFtrWmar9QNbM/7ddTX
	M5XrivqUtIT6JevsdqnStrz3fSBkQCsKuAAl2twe8Q9ZjgDU27VTYWDnKEbeuEQX2FkXkKTkTyn
	WWyTQWLErnRIsplAfcBI4vrZrW3KeCFdvsBmzW0msHDInzDAeLEcP4Pt92N7o7NLDDhYsBnA/0t
	OuNBXHkLfXVXzbKeb+I4Z3newi
X-Google-Smtp-Source: AGHT+IGcvlur8Vqc4wFxgxESgRnhWsQQrDI7/x3WxwuMsMU9z1qtT26y4pxkHScpmQTRAOTFgs7e9g==
X-Received: by 2002:a05:600c:b96:b0:477:9fd6:7a53 with SMTP id 5b1f17b1804b1-477c2ef91demr217790445e9.2.1764657590643;
        Mon, 01 Dec 2025 22:39:50 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15fb1430csm15702796b3a.59.2025.12.01.22.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 22:39:49 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH RESEND v4 2/2] ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
Date: Tue,  2 Dec 2025 14:39:35 +0800
Message-ID: <20251202063938.9046-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251202063938.9046-1-heming.zhao@suse.com>
References: <20251202063938.9046-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After ocfs2 gained the ability to reclaim suballocator free block
group (BGs), a suballocator block group may be released. This change
causes the xfstest case generic/426 to fail.

generic/426 expects return value -ENOENT or -ESTALE, but the current
code triggers -EROFS.

Call stack before ocfs2 gained the ability to reclaim bg:

ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
 ocfs2_get_dentry
  + ocfs2_test_inode_bit
  |  ocfs2_test_suballoc_bit
  |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
  |   |                             //the bg block was always found.
  |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
  |
  + if (!set) //because the above *res is 0
     status = -ESTALE //the generic/426 expected return value

Current call stack that triggers -EROFS:

ocfs2_get_dentry
 ocfs2_test_inode_bit
  ocfs2_test_suballoc_bit
   ocfs2_read_group_descriptor
    + if reading a released bg, validation fails and triggers -EROFS

How to fix:
Since the read BG is already released, we must avoid triggering -EROFS.
With this commit, we use ocfs2_read_hint_group_descriptor() to detect
the released BG block. This approach quietly handles this type of error
and returns -EINVAL, which triggers the caller's existing conversion
path to -ESTALE.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index de2f09217142..a126d83ddb1c 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -3152,7 +3152,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	struct ocfs2_group_desc *group;
 	struct buffer_head *group_bh = NULL;
 	u64 bg_blkno;
-	int status;
+	int status, quiet = 0, released;
 
 	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
 				      (unsigned int)bit);
@@ -3168,11 +3168,15 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 
 	bg_blkno = group_blkno ? group_blkno :
 		   ocfs2_which_suballoc_group(blkno, bit);
-	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
-					     &group_bh);
-	if (status < 0) {
+	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
+					     &group_bh, &released);
+	if (released) {
+		quiet = 1;
+		status = -EINVAL;
+		goto bail;
+	} else if (status < 0) {
 		mlog(ML_ERROR, "read group %llu failed %d\n",
-		     (unsigned long long)bg_blkno, status);
+				(unsigned long long)bg_blkno, status);
 		goto bail;
 	}
 
@@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 bail:
 	brelse(group_bh);
 
-	if (status)
+	if (status && (!quiet))
 		mlog_errno(status);
 	return status;
 }
@@ -3202,7 +3206,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
  */
 int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 {
-	int status;
+	int status, quiet = 0;
 	u64 group_blkno = 0;
 	u16 suballoc_bit = 0, suballoc_slot = 0;
 	struct inode *inode_alloc_inode;
@@ -3244,8 +3248,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 
 	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
 					 group_blkno, blkno, suballoc_bit, res);
-	if (status < 0)
-		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
+	if (status < 0) {
+		if (status == -EINVAL)
+			quiet = 1;
+		else
+			mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
+	}
 
 	ocfs2_inode_unlock(inode_alloc_inode, 0);
 	inode_unlock(inode_alloc_inode);
@@ -3253,7 +3261,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	iput(inode_alloc_inode);
 	brelse(alloc_bh);
 bail:
-	if (status)
+	if (status && !quiet)
 		mlog_errno(status);
 	return status;
 }
-- 
2.43.0

