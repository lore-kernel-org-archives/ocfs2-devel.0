Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE2D35AC10
	for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 11:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779016237; cv=none; b=GYgWT0oWeo8SMxVi2h7DWEJ4hAjkR2FLbCfXdeHrq7kqx4rzfZclSPZsoCuIEYowAEXF0rKKoOdd301UZwuDBdcW2PF2zaNDK3uK3Zb5u6JAyXorFceRsdXwWblF9yYytgqLzSt0v/QP2tRkFIwVdOUbC3DwRiD4Eg6y3a3hd7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779016237; c=relaxed/simple;
	bh=KBKpFoApqVOYrZgt8hDeAf2QScaQBhG6btxplHe/0IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKJ6kN1Yn1hbSmtx3HQfo69VdrRC8X4+f9cCMqPEiAaz1KY+IXDlDLYtsAa85pJm75aAA5NmpAb8tQ+rs4hSBd2bKOx9X7x35e5bG/j4QklBy4VStBoOXRHiLdQjZFyCmbvDZAmQ2tn0Raeo42ncofrFkmZEFl1pNtMWRzS0ots=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UL5iK1Ry; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UL5iK1Ry"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50d876329bbso16751351cf.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 04:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779016234; x=1779621034; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYwK9wCTOrjldULnc69mQhALgu/e64LYTBbU5tr14QM=;
        b=UL5iK1Ryr9BuROR4HD0EeEbEGDV1bTdVfI6qeUJ8y6tL2CUp2qH+nrKMXcIygBU6eL
         6IIi5lyC+hXH/Tkg09KMSe4JZWff1KfbNBOJAvGe8A/C+IfXqGsFpMn0u7ZPuLia0HFx
         cGK86ti4m2woAiEvii1uZW+yerWIU+DWUXR81qKyo4fSq8z6roeunsmyR+HLtYovUkK6
         l484idYgQ6vhXf4yvdh913Q1bjjaGPClHiu65FgPt3B1aCf52uePP32XabpP9HnbxLHq
         XjQ0u//7dkyTkQhpRg4ZhzW7UHVA3Q/4N0H0XDsZ23xED+juBPZtkqDUSVkA5CR0one/
         QTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779016234; x=1779621034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lYwK9wCTOrjldULnc69mQhALgu/e64LYTBbU5tr14QM=;
        b=rCkwIykPGDtRdbSK2WbFAPe90JaDzNd3Gawk8OcFGsCj6xylfIx82+V80ddpJKJp8N
         8VqyEnP7zzqDez+RDkjnZRYywPM6oVI6XwMsov5xmuULSl0ulW99qnCsoe6exawLgcTC
         iow6NMdWvY+kKa3moXCmY4tMDdUqwDIB+lQCU/K6eT8bMQqzuAuoOft8KjeigV6Q8xwW
         P58vxyz0l30bJQnBtPzbU63soVj/mv2o7bBz8Vqj8uxENDqUpgBYWuzux0qPuSWZhEz1
         f9Wsdt2X2OY4qP2OTgYb0mJmJgFPudMpkQK3k8IYmi4J35A4tJFbaR5SzYgG+rdTTOzt
         NwpQ==
X-Forwarded-Encrypted: i=1; AFNElJ/VWnEXpBSat2ySlx3s1zhYTUTOpgmhfofr7Pq1JR3gIH8Z8nM3xEHcCviZI0878lUUxEC6G2OfeB2H+Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxafuLNtHYgEA2rG+HM0X3JVyJyIbaCUyej+ZfydECp2Mjp5w0S
	tpXY20fbIAuzhC0f7ZooxbZaXm6opOd/XwbJ7f8O27qqF7KhS3Te0zPvaUpRoPtm
X-Gm-Gg: Acq92OGwVco9wdRSDnzerisPRuTyDvCL5z+MfNTLuRmeMWhLqrVMvnkPkvUDADmNsyt
	nbdln0B9UXz8Aw3CzJ5+UYapBem5ySfPRIlwbjufaWq6SIeklKkyCWz5aBNKEFdUd/3SN8Cvn9i
	6V5wlZXMtaJCT0WbLbfgwOq1eYUJx9AxAPo7Eags2U06eIuGbkmB2iILQRKsJkmwxta7ImVCqXq
	47EHPx1J2KUIcnPr2vrQQlfdt0Y3LrYNK8Birwjd6GB0yQb4YOJ7l1ROtjtDtm6BWWPfzZMlYsX
	oNUvD9KBfvrbEGtuEelQ3SNNPHJsu5inUXjHIrK+Y0MMUiZ/YAlG8WrNCSiJxjEeIP9JZEhm7NI
	DbXm5TCo9h/HNKAzbvMehOA/RS1Ocydp5TA3iWrs8yl6OC4PSEPg/AifsYMz1eGASFc3592yBap
	1M5OqwWwkYRbjxMTtOvt4Fifxgb70+/BBQAi3oDpgg2AfS8sau02KGb5PWEA5tSJYwoB5rNiTZO
	OVy92YScyykJvqP5kZmRERrjeo/UEJ4ygdJQzyHMns=
X-Received: by 2002:ac8:57ce:0:b0:50f:340f:ff37 with SMTP id d75a77b69052e-5165a0df14dmr151793751cf.22.1779016233726;
        Sun, 17 May 2026 04:10:33 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456df09csm100306651cf.13.2026.05.17.04.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 04:10:33 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ZhengYuan Huang <gality369@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ocfs2: reject dinodes with non-canonical i_mode type or stray bits
Date: Sun, 17 May 2026 07:10:12 -0400
Message-ID: <20260517111015.3187935-2-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517111015.3187935-1-michael.bommarito@gmail.com>
References: <20260517111015.3187935-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

ocfs2_validate_inode_block() currently accepts any 16-bit i_mode
value as long as i_mode is non-zero.  ocfs2_populate_inode() then
copies that mode verbatim into inode->i_mode and dispatches on
i_mode & S_IFMT to the file/dir/symlink/special_file iops; any
unrecognised type falls through to ocfs2_special_file_iops and
init_special_inode(), which interprets id1.dev1.i_rdev as a
device number.

The result is that anything able to forge or corrupt an inode
block (a hostile cluster peer with raw write access to the
shared LUN, a privileged user mounting an attacker-supplied
image, on-disk corruption) can publish an in-core inode whose
type bits do not name a POSIX file type, or whose permission
bits carry bytes outside S_IFMT|07777.  Both shapes propagate
into VFS-visible state that downstream code paths assume is
well-formed.

Reject early in the validator:

  - mode bits outside S_IFMT|07777
  - S_IFMT values that are not one of S_IFREG, S_IFDIR, S_IFLNK,
    S_IFCHR, S_IFBLK, S_IFIFO, S_IFSOCK

mkfs.ocfs2 and the kernel only ever produce these seven types
plus the standard permission, setuid/setgid/sticky bits; an
on-disk i_mode outside this envelope is structurally malformed
regardless of how it got there.

Validated against the existing inline_data, refcount, and
chain-list checks: this hardening fires before any of them and
does not perturb their behaviour for well-formed inodes.

Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/ocfs2/inode.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index a510a0eb1adcc..fb592bf3e5f31 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1494,6 +1494,45 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	/*
+	 * Reject dinodes whose i_mode does not name one of the seven
+	 * canonical POSIX file types, or whose mode carries bits outside
+	 * S_IFMT | 07777.  ocfs2_populate_inode() copies i_mode verbatim
+	 * into inode->i_mode and then dispatches via switch (mode & S_IFMT)
+	 * to file/dir/symlink/special_file iops; an unrecognised type
+	 * falls into ocfs2_special_file_iops with init_special_inode(),
+	 * which interprets i_rdev.  Constrain the type byte here so the
+	 * dispatch only ever sees a value mkfs.ocfs2 / VFS can produce.
+	 */
+	{
+		u16 mode = le16_to_cpu(di->i_mode);
+
+		if (mode & ~(S_IFMT | 07777)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: mode 0%o has bits outside S_IFMT|07777\n",
+					 (unsigned long long)bh->b_blocknr,
+					 mode);
+			goto bail;
+		}
+
+		switch (mode & S_IFMT) {
+		case S_IFREG:
+		case S_IFDIR:
+		case S_IFLNK:
+		case S_IFCHR:
+		case S_IFBLK:
+		case S_IFIFO:
+		case S_IFSOCK:
+			break;
+		default:
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: mode 0%o has unknown file type\n",
+					 (unsigned long long)bh->b_blocknr,
+					 mode);
+			goto bail;
+		}
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
-- 
2.53.0

