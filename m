Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3553A13D503
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 07:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765522837; cv=none; b=PfXykVlvK9Y0WcEx3Wkh6FWfSC7P0UVqPvOJfOojxP6U/NmFdTTUPG6RRJ3cUF1idFBJb6GI3RpNDMpy5YR8pNH/cTx9I4GLTKnJIOTIrgqLApNo9NG7SP3k9bscKf3Klz1YvhtUBb5HJt1Bn8ivfxhW9mUCEPm+RcggtPxvbS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765522837; c=relaxed/simple;
	bh=Evs5QQATIk0sNsyehuiCaQOTsbxa/fjc0hXZd7wTlXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxFjltH8PUyPVGVgA0d/6nDjfp9/2lpooXjWwuzTU07bHJa9FKz9gbDj9WP3VcxOFhHjs3iMCPiIllzOT8famnqk4SUHzt+y8WSNqsczEAU0du+v53OFj1r4EJuxnaYPRBxOACyNSKJk/VEYLFuv1EUpZz2H/SGJsSaMFMGAti8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LOcjqqnh; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LOcjqqnh"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-429c844066fso95176f8f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 23:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765522833; x=1766127633; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxXUWWraavNZv54vBuFyK/VfBOztE6hI+jfRRJkFQFs=;
        b=LOcjqqnhXlt9uu4eHRiMyglSrEE6/ls92nHDwLv7n18hIwsFjd1DzjrfXdUb+b//w2
         5/KlTShq9aHwm7OK+OgsOq6kVTJllNf871QiBwgZlESnLs9P77lWHCGpbZz+1ppIpJj2
         x+hZ5Q8vv2S/XgOrnl+ngIL3PYixBmCd8LVQgcOO/jCFD+7QYFBtnnQJuicxnq5T/S0i
         M6kIKwX7kgtqxMtqiWq52v/ZHVJlU6L9WHS6OVvNYS6FO1+Ps9mw15YtxiheYU8mZ6gv
         baDrCxQ05ILwFPAMCwNM3Dz47pr1FQ2TvNNsNTndsy0RUo2JqaEZTGxNwkRWWOY++udw
         Gcqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765522833; x=1766127633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GxXUWWraavNZv54vBuFyK/VfBOztE6hI+jfRRJkFQFs=;
        b=OLmU+8eGgwch/Sn5GjqIywXCf4hdozxq3VtV0RX9m+R7CpWNAG0KeFASrACgM67Zrl
         oIDFhDNOx6pSVvfDY3i4xY/wsU6zXd4kFWoUjhCdCU0P/HlqI3RhgEdGFauYwqvnUJze
         /BehxLk+njUdpPIKxWJYXIHENsTTlB24ZkFM+nCKArkrg4HaiMg7dCcxRWXVzhgyBkDX
         cqdJQ8xS0HDanp0E3Bn65DtAbsNyiCihWCTlP7dLiO4Mn6kCHU+ZUwbJZNnjN/NuQsfr
         4I6MMrU3fEFCvjq0bCrbhycSapaju40OsdHX3pF0H3AigwYh5wjQ0BINpEyXhhU9cO9o
         1HnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLSBuvssovI/x08cwVtRQoV3seaBKPDpYjeSAoAS1rz56l2tg1V0mtpynz9N/yp7Ao8Qf9TJHSMXAmtw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/HmNuZ/a0mxg7S8OHsW1oAt9EOyHiK1PQ5G0WqM+Zet1PnN1/
	88La5iOsS6oyCuUNNO5E+nDZtlS67zCGAgqhkZtcnYqj907k2amQbOih1iFkfb2sGvo=
X-Gm-Gg: AY/fxX5xDcsYtxDa7BZJau5mFi0b/yhzY3Vj3z5C/b5U0y4XF5wh6rKVX/njmh74mR9
	tRBh2j1jrVmu8uzj22b9vOaWG7poQfP2RjDt0gtAS3iJcW1Quds4oH2IRyZK/Tk3lLBl/tTmiv3
	PM05dz855BJbQaKeKvTaHDvzR6OTabNEQItKNY5gkIJHXrTF+cp/9axGRVcpAQgMZGuJ9If2Op2
	4ireQYSVFXfK9d6mek+gRqvYVyxcjob+QL5WBzBH8B0KXFLskYh7tsczJCsDdZUej3sT0kJXPJw
	LYracluUGNmBETEQXZ0L7r2xTDAJ6xjxasQA7163EVTApbg+POs9TendP7C+ZBgHbvelXYnTWvv
	EM/lWuYEWWtpYuXB8tyUArnwP461ZR46P7wOkTLdYO17VfCDQu/x2izAtVaVzi0Q9N8wG+DU6DE
	9G0OTviFUZctqeLq6huSfpHA==
X-Google-Smtp-Source: AGHT+IFA53IyEiFb68nHZUn7/d0cwMWOehrqr8ylyNpy+E7MrSw8ju0jqjgEBSkU/GZW8iSGd9yb7A==
X-Received: by 2002:a05:600c:1992:b0:477:c5a9:33ce with SMTP id 5b1f17b1804b1-47a8f904696mr5013075e9.4.1765522833258;
        Thu, 11 Dec 2025 23:00:33 -0800 (PST)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d38c74sm44479145ad.31.2025.12.11.23.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 23:00:32 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v5 2/2] ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
Date: Fri, 12 Dec 2025 15:00:14 +0800
Message-ID: <20251212070016.24235-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251212070016.24235-1-heming.zhao@suse.com>
References: <20251212070016.24235-1-heming.zhao@suse.com>
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
 fs/ocfs2/export.c   |  6 ++++--
 fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index b95724b767e1..9c2665dd24e2 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -74,8 +74,9 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 			 * nice
 			 */
 			status = -ESTALE;
-		} else
+		} else if (status != -ESTALE) {
 			mlog(ML_ERROR, "test inode bit failed %d\n", status);
+		}
 		goto unlock_nfs_sync;
 	}
 
@@ -162,8 +163,9 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 	if (status < 0) {
 		if (status == -EINVAL) {
 			status = -ESTALE;
-		} else
+		} else if (status != -ESTALE) {
 			mlog(ML_ERROR, "test inode bit failed %d\n", status);
+		}
 		parent = ERR_PTR(status);
 		goto bail_unlock;
 	}
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 9a19f5230c8c..ddcfa6e001e8 100644
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
+		status = -ESTALE;
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
+		if (status == -ESTALE)
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

