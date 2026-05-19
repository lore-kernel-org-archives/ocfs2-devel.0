Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49089481FD7
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 11:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779188668; cv=none; b=Iw0tx9ESlm9J4/f33yApKQffj49Eg6SUS5VFtarkAbKbdV3uIzeYChrobL6k1ez1TaWszVKSxQSnNXBLqM00NYt0UsH8a/pxe8XW21U9JLJayKd7BWtrVP68w2aRtG1zIh6YNXuPWtbIE3r/CRdOoAnA85nby5bUfe15PX4h35Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779188668; c=relaxed/simple;
	bh=FA07lT6C4tTEVDxKP6sBgKRYzFaomS+7kWG4YIRtUto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWMaZF6f/sd+LdultcwHv96KH8/ZSyRPCHYt8TczDY23LpvwOGDlNGvYVJ12yqpHni4yHJNOiVWItowZ7M7qCDGtrCiHgj46biGnh2yZnRgA+X8S2jiHHJbfXVYrRICjp3F0tnzHM0iJ6Nmq9lKIiHt1tyzFiPArQdtvzM11FIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IYsXCQmY; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IYsXCQmY"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7cd35604a95so21932597b3.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 04:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779188666; x=1779793466; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuiWRQBqdRLNOxJ2VaNl5btGp2aiulYiXmdelCaoF30=;
        b=IYsXCQmYn3Ocyt0SBxJXXZVsZhIdoW0JMNFppVbCwSSY+BzRC4YmAD7sOrqFwlqIpX
         TMe1hYgj+tGLSdFqvEFOiHJXO3uR00gkC36xCtHJ1J/aI/+NPZTQ8yI0uw+we41h0qNR
         AY3dpLrFVaYWAed3mYws+Dq9XuZu4PuNUttvHkSBTcDqgQSE60WPhHc8mbRHHhnAAWjA
         peLFOrEWXetgeycmOP3kE000o9NkZlXw2fpI9HRiCIilOZdYtcFyKQy4gvTpaoQlBkRr
         qhx1hNplcf63NTO71H+vYA3tXo8uEKhWUaoUw2lJoeQooJcH5J3Q/ch60sEKIDLTpSgU
         vv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779188666; x=1779793466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PuiWRQBqdRLNOxJ2VaNl5btGp2aiulYiXmdelCaoF30=;
        b=S1/Ne8rA411xnIE+nS0/g7MnMM8sOsKrPy8Px+TdLcuvTAJFvsprHXbkr+99gbNjoE
         YKSL9C9C46vMA1Wq66r53AOzyiSjg2IB/Yd8WhJBAGXPmpzacRpuemTshgmFf7iKW+BD
         D9QGFv9NP+rLI+zmkkkJJ39RTFXgvPsDOXPV31c5qH0bqJmBi40uBQd2spYaq0+DvHlj
         3kd1mmuw4JhW5mGugz7rNKoDoOuZS/xYNsA8aGnyTISIf9Yb8sFMF1a76YE8jZRSv3r1
         5sOqsWEALzTQsLDaZU3Q78iZDvWKTf98Gz2uchIFSQOy/+tpmIN1Rg8J5/pVKNZJGHcC
         jnzA==
X-Forwarded-Encrypted: i=1; AFNElJ9vtKT4qOndnHnDQcLNsvgFowS4QHOblsaRuhURmxXgXWdKHps4ee/lb80D01e2vwZ2UH9JHZEypPY7rQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxJvI4RKu39TjQCoMT93/ZfifYoIKpCckzQoOx0Pdwxan2/7XTZ
	HG2I9GPjfgWNIv7V8NDoEUY/vTKeJa3o/jtRxaaYBr0awSxhhN/rbu5w
X-Gm-Gg: Acq92OEoIk9J38Ctnn/bVz2mvuBGKl9Qa27hxs/r9DJFYOx5BrYkd/iQD6e1vZcTm8j
	xnF73DkRVZMBX7HdVhBVxlJD+2BymHZZ4v34iSO0Oj1oNYNI8TxoXEX63PeDYwhMISFzH5dpoRr
	hHs9OvUlPFc9N+vq1cyBZCqHklL+XlEyiC7pjZeWfnDK/TT9QdEm7uj6pfaMii1Pls/QrajnXxk
	UQMTvw79ols0b/lyC5lTCPadpDMx/R4iMCjv5l0UWp2Z8ruaprWFlxE9xEam3sNujvYV11ByIub
	d3+W1OpaOltZTyexNygfRACXuug3ysFb785+VkM3MUx1tsw/FMm1G4Glb3qvLmJmUKhrMRN/4bW
	3+wSvyOsGmCT2sHPy4M3TcJyo7w7I5FmAgm5T86tX4/ptnJSwJ0bprBD30wObGuwSpBFBFJ8M3y
	f/UIcynQyEPI62csS4CLtKgGfu6Vd8VHmj/OT1FJkh4X9ZgMvZxwPp/hGE9l3SDfiYt+q4kRou/
	IR0VbuMzaPlTmJcUUSW
X-Received: by 2002:a05:690c:e1cc:20b0:7c7:df46:3e2b with SMTP id 00721157ae682-7c7e7e1c3c2mr143911227b3.16.1779188666185;
        Tue, 19 May 2026 04:04:26 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9bc0ccf7sm35206827b3.25.2026.05.19.04.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:04:25 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ZhengYuan Huang <gality369@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] ocfs2: reject dinodes whose i_rdev disagrees with the file type
Date: Tue, 19 May 2026 07:04:03 -0400
Message-ID: <20260519110404.1803902-3-michael.bommarito@gmail.com>
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

id1.dev1.i_rdev is the device-number arm of the ocfs2_dinode id1 union.
It is only meaningful for character and block device inodes. For any
other user-visible file type the on-disk value must be zero.

ocfs2_populate_inode() currently copies id1.dev1.i_rdev into
inode->i_rdev before the S_IFMT switch decides whether the inode is a
special file. A non-device inode with a non-zero i_rdev can therefore
publish stale or attacker-controlled device state into the in-core inode.

System inodes legitimately use other arms of the same union, so keep
the cross-check restricted to non-system inodes. Factor that predicate
into a helper and use it in both the normal validator and online
filecheck path; filecheck reports the malformed dinode through
OCFS2_FILECHECK_ERR_INVALIDINO instead of ocfs2_error().

Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/ocfs2/inode.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index e149ccbdc03ce..992980ea98046 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -72,6 +72,16 @@ static bool ocfs2_valid_inode_mode(umode_t mode)
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
 }
 
+static bool ocfs2_dinode_has_unexpected_rdev(struct ocfs2_dinode *di)
+{
+	umode_t mode = le16_to_cpu(di->i_mode);
+
+	if (le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)
+		return false;
+
+	return !S_ISCHR(mode) && !S_ISBLK(mode) && di->id1.dev1.i_rdev != 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1518,6 +1528,41 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	/*
+	 * id1.dev1.i_rdev is the device-number arm of the id1 union and
+	 * is only meaningful for character and block device inodes.  For
+	 * any other regular user-visible file type the on-disk value
+	 * must be zero.  ocfs2_populate_inode() currently runs
+	 *
+	 *     inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
+	 *
+	 * unconditionally, before the S_IFMT switch decides whether the
+	 * inode is a special file.  As a result, an i_rdev value present
+	 * on a non-device inode is silently published into the in-core
+	 * inode; a subsequent forced re-read or in-core mode mutation
+	 * (cluster peer with raw write access to the shared LUN,
+	 * on-disk corruption, or a separately forged dinode) can then
+	 * expose the attacker-controlled device number to
+	 * init_special_inode() without ever showing an unusual i_mode
+	 * at validation time.
+	 *
+	 * System inodes (OCFS2_SYSTEM_FL) legitimately use the bitmap1
+	 * and journal1 arms of the same union (allocator i_used /
+	 * i_total counters and the journal ij_flags /
+	 * ij_recovery_generation pair); those bytes are not an i_rdev
+	 * and must not be checked here.  Restrict the cross-check to
+	 * non-system inodes, which is the full attacker-controllable
+	 * surface.
+	 */
+	if (ocfs2_dinode_has_unexpected_rdev(di)) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_mode),
+				 (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
@@ -1657,6 +1702,16 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		     (unsigned long long)bh->b_blocknr,
 		     le16_to_cpu(di->i_mode));
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_unexpected_rdev(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_mode),
+		     (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
 bail:
-- 
2.53.0
