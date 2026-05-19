Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548154921A6
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 11:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779188670; cv=none; b=o6G8vYeXPthKyAASihkd80Xj1P1frHkYE3+QaoOAtAw27PK5siVBuUtiDmCVWdllQzZ1Q5+Y09qajVyMX8YG/aGKhF6dDsi2uWsJkt21Tij85ullfijuEgZQStCKpeMvMUtXxLTPlgvsveCRiA4z1goqWa8n+mmixqyUxEdxNt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779188670; c=relaxed/simple;
	bh=qDrD2ZddrAheagdk3eIgrfALWmcsf4CIV39O7dRnNk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhK0DtGo6FSaAzMSq45+WEu8OttwSofWQYdRR6ZcUq+2zYsFExiE1Ajh1QpzlvATPRLm1TQA3owvlpHrDZOUTf2LJKBq6fhhxBxkgmuYTfeYHxFyVSDegBmP7AG3h2ImrN1lxFo7LNIb8ob7127dzPJP55tnGc2mUcRPMcmowuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHpd3o+H; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHpd3o+H"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7c52e49d978so28348877b3.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 04:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779188667; x=1779793467; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+1n624ktIAXNe/+aIK+Qahfn51hvIzEeSL35mTG/Bo=;
        b=kHpd3o+HuCYDbgohntOT/h7mFxA+VQT4CrwF+f73DMHUuKfcYXKXJEcKu7ptSaXalj
         P4a9EzNYXsHxKjhgivbpO5pb45fGqGS/4KiMdV3XdB2hVBmawz2rz+xW7TAFcltrpoim
         N3gjdr321/X4h2ggRuoYWJ+LL2QeRLwdTfJnrATlGj/xTWNKTSJgINM733dQlB2cFrQN
         iZy2lDcvW3fepDDy12cf2/VYdN3YSd2L3ADJn7M2zNZCsdjgMq4K20KZ6EF8JvdbQKg9
         eKZ2MNC1YkHpKx5Bx/xYWCODDM+Vg6i2Zax9elxiDUQaTWLj6JIT/Qw2W9AU49odhpwj
         uKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779188667; x=1779793467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d+1n624ktIAXNe/+aIK+Qahfn51hvIzEeSL35mTG/Bo=;
        b=DzrcYKkWcOAj6xRl2TxF17mpRYzJjuZKU93w4JkAjG1IDiwxVKIRcT/Q/EO8lzEtJc
         aQkz5ln8p6PUWPpNJc2yskUD5resgZgApvfoc4fPojAR0B5QaXzDeXLQyKWfwexJ9M4h
         ceayu23gxSfwOMszYA7qxZvM00WyHlGOtdS9IcN8vpAu18p/Os+CzcQ5mOqez6sfIonD
         6ldUoWlosLtZos+poJ2oujdi6IK7IxAYa5pChAA4UebkULb0El0ChuAMyNtjCr/gHTbn
         L9XUznBEpfdHIU17p3kfFsqVLAGvrEBorwrsCQDsn5GV6W1fPQxP5pytPJBDtcHr3jUC
         bTIg==
X-Forwarded-Encrypted: i=1; AFNElJ8E1YiQQ+xuIgpZbJumePh1yyNU+DHHEebEcLojwmweNAWGzUaztDv4fL2NWgmdiLGMMZ8VQ51AAdjHwQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzmjqz3y0mtC/dB2lVAMvt/vJkEPdYW+j3MgwKqFN7YpoWPMY64
	+vUFw5dRh5aNJOZ/utdw8Dycks6qNH3ffu46rhEb6OVDaVHZ0s2EnB8L
X-Gm-Gg: Acq92OEwi3MAPpzY1wzgneMuAUy3iNwbhbcgc+2XtUpFUiQWr+t9fliDJb3VfsdJMHU
	GvFqMf36fwml2MMQwQajTaTbOtoKkxvyo7VC5KNi3JPKMVhweil41TYMp1zCAkxxZK6Y7NlbRkk
	f7yCz5gxc9bL5s1vTWvpwfbKvVic1RhOeWB8KgUXTCNmp+pevwdPUE90mN424zrF2HieL9W5ASG
	2kBE3WSPiMRyhW1Fn3SvL8dp/ctsByHLhXPLQ/E9rTNwFo+TBY9j1E39yVbySPWJZd3l+UIrWw4
	d5hpU0SpHzoOM1A9wPRlAJ47BzxORGr2pNwGrzID6YSAEDragEx+HQHyKjIfEHJEtcEf4gthEvB
	e7F5hFfrfh7Ts7OxxriySy53ijWxDXLpQRYAYe3PYBeISxhpo7BUAdY6XDkjTXZ5BpKHJSFIqwh
	/7orliNe7PvZmV1uwqYFoZx2hNtP+P7fRpCOutrP3MfNg8AcFVzh9OZiVXDoAO7DAYLsvBps/hn
	NqCZga/IPathXXRI8nmI579HfrPxMY=
X-Received: by 2002:a05:690c:f15:b0:79f:3715:1980 with SMTP id 00721157ae682-7c95a37c674mr220804827b3.12.1779188667319;
        Tue, 19 May 2026 04:04:27 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9bc0ccf7sm35206827b3.25.2026.05.19.04.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:04:26 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ZhengYuan Huang <gality369@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] ocfs2: reject non-inline dinodes with i_size and zero i_clusters
Date: Tue, 19 May 2026 07:04:04 -0400
Message-ID: <20260519110404.1803902-4-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519110404.1803902-1-michael.bommarito@gmail.com>
References: <20260519110404.1803902-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On a volume mounted without OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC, a
non-inline regular file with non-zero i_size and zero i_clusters is
structurally malformed: the extent map declares no allocated clusters
yet the size header claims content exists.  Keep rejecting that shape,
but express it through a shared predicate so the same invariant is
available to normal inode reads and online filecheck.

The same zero-cluster shape is also malformed for non-inline directories.
ocfs2 directory growth allocates backing storage before advancing
i_size, and ocfs2_dir_foreach_blk_el() later walks until ctx->pos reaches
i_size_read(inode).  A forged directory dinode with a huge i_size and no
clusters would repeatedly fail on holes while advancing through the
claimed size.

Sparse regular files remain exempt: on sparse-alloc volumes, truncate can
legitimately grow i_size without allocating clusters.  System inodes and
inline-data dinodes also retain their separate storage rules.

Mirror the check in ocfs2_filecheck_validate_inode_block() as well.
filecheck reports through its own error namespace, so malformed
size/cluster state is logged as a filecheck invalid-inode result rather
than via ocfs2_error(), but it must not proceed into
ocfs2_populate_inode().

Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito%40gmail.com
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/ocfs2/inode.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 992980ea98046..432eac01c1763 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -82,6 +82,24 @@ static bool ocfs2_dinode_has_unexpected_rdev(struct ocfs2_dinode *di)
 	return !S_ISCHR(mode) && !S_ISBLK(mode) && di->id1.dev1.i_rdev != 0;
 }
 
+static bool ocfs2_dinode_has_size_without_clusters(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	umode_t mode = le16_to_cpu(di->i_mode);
+
+	if (le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)
+		return false;
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)
+		return false;
+	if (!le64_to_cpu(di->i_size) || le32_to_cpu(di->i_clusters))
+		return false;
+
+	if (S_ISDIR(mode))
+		return true;
+
+	return !ocfs2_sparse_alloc(OCFS2_SB(sb)) && S_ISREG(mode);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1563,6 +1581,33 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	/*
+	 * Non-inline directories must not have i_size without allocated
+	 * clusters: directory growth adds storage before advancing i_size,
+	 * and readdir walks i_size block-by-block.  A forged directory
+	 * with zero clusters and a huge i_size would repeatedly fault on
+	 * holes while advancing through the claimed size.
+	 *
+	 * Non-inline regular files have the same invariant on non-sparse
+	 * volumes.  Sparse regular files are different: truncate can
+	 * legitimately grow i_size without allocating clusters, so keep
+	 * the sparse-alloc carveout for S_IFREG only.  System inodes and
+	 * inline-data dinodes have their own storage rules.
+	 */
+	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
+		if (S_ISDIR(le16_to_cpu(di->i_mode)))
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: directory i_size %llu with i_clusters 0 and no inline-data flag\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size));
+		else
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
@@ -1712,6 +1757,21 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		     le16_to_cpu(di->i_mode),
 		     (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
+		if (S_ISDIR(le16_to_cpu(di->i_mode)))
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: directory i_size %llu with i_clusters 0 and no inline-data flag\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)le64_to_cpu(di->i_size));
+		else
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)le64_to_cpu(di->i_size));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
 bail:
-- 
2.53.0
