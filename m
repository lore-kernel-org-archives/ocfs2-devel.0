Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792858808;
	b=jVTZpmZ8y1yPSc0mR3fiUPBKhxl5GdplfYuV0C+ZUH6rpaONh6UyU75HgKHjdczB2GD7
	 0e3pVw0FlN5GH2KnXaQ4lV+QiqMjEqq52lvgd9FQvxSxhCfxswH/AO/sFoKd5R9zSj91f
	 8uMhG7j9z6Zm/sZEQ2zZZ2MBAe5uftoFsj1sAhF9KSoE5amShkKQpwGSTDWBn7edAWaC8
	 nqL5sS/6tU55oA5In3CVNY3k9+yXDK1Aofny3D63roX7DPB2XFyOaNfH7eyUbr31dJly/
	 QuzvPBzgB2g83mPHIUZjpnjo6Y2qxXSMbs2c2N1pxu+WsKA5j4xFoVO/JwQBpYftHSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792858808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xwmLnAa6b4VIfgYdyaQibjdMJAMiidZmgGGch02/UIc=;
	b=rn/QEoqoleaJrgOQ6bgX6c70bXEhh+vx9P2F1uiH7RYmHybk/gslWPol6Eyp+1UABkD5
	 BDKtqqCKU3jguwHYXB1/6vjdpGNOsjiJ9mIO/jz4vbxqMlLYVC8Y1OKesmq/Fu6RCvEp/
	 NPrTprhjHBt8a5rPxv2FSVa8PUyD1ohSGCI5A8b1nPrZ2ecudIlO4lwqrL0liCgXh0x6d
	 m4pTkigeWg+KGwkmasApiUosq2/EmakH1Kn7m2qcib3u11wECCt1P25faal5NAAMPsn7N
	 oFJfBE1wyuJu8azWpb36zEHQp5m2yF7MT+xqDtL5myGTwp1BplATkelKD+g2X8rWE5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=L44EX3Dr;
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1910C606A31D
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 16:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1910C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=L44EX3Dr
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3acb11973c3so1233231a91.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 09:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792858807; x=1793463607; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xwmLnAa6b4VIfgYdyaQibjdMJAMiidZmgGGch02/UIc=;
        b=L44EX3Dra/ZdWA2His7yoLD039CDgxPta94FnfsZXHlL0Va/SlWZ7V/Y6K43ZCc+p3
         1xZdsGUZxzLNeMdDPjHEEtsG+Hkno6IHyzPSytU1k/GRCu6hgzrpwK1rDAXvgZJOOo0r
         jklFeBW54wk+JBpDWyUVEe3ryCkSbR3Ow77Md8peNO7j+cGbtvmqSQt3yxdfkw0qPdcK
         qOXjOmM0I2yj8JCoAI/ukuJSfLOv6AZFguyUrCLjqCwyO908TRfLdNv1oomFUizvP11a
         aO/eZ18pdxEPJSQkfKuZSC0Kldco0KQAeVezF9c9xAvzc2T2C6eM7w5KqBuXo7BQBOrO
         x0Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792858807; x=1793463607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xwmLnAa6b4VIfgYdyaQibjdMJAMiidZmgGGch02/UIc=;
        b=giCzdK218KjAqOuGlz4mM6d1IblUA7xjdDwBlhagoif6ibM5wflyYnRAFWNW4sDt06
         p2snKj3lOiyJdXAQ1CRGH3/5bAR1Cj/T+nsPKn0IVcgvvPLXkqp4HzReT6NRFFh9g0Kd
         gWYZDCn4sJrKiGEq44h8Q3H8Lk0YsT0GxEpus981r/DvO7yFVhbGYiP5WhFs8GdleSJt
         DZZBHj1ribNSRPQyZNC8eCx/RSZBZ4nDXFEr3blNgypqXoAJhc1Lcz5VLio5yRvKPZLh
         WScQvY4x8HGcMnP16h6UKowuw0Y89JxlmpxwAmcqGySHqAE/K7VlvLgITBgzpCMRK7FU
         AU3g==
X-Forwarded-Encrypted: i=1; AKwUvBx2AsIO9fA60cG5zendlde/AxRSmCCfAKBN8T4H5OZ7ROqlYFrqdpf5oUj3DogNNqPzeG0uq22twyEwXg==@lists.linux.dev
X-Gm-Message-State: AFq9FYJLEmAMaIll9dx63VyIxxly5+/sFi5aZH8S1BmnHHVZzTtOvOIy
	nLCW7n8uSvbDAf9dLJAqwrvevZrgBF+qHdYE4EYyHMZTstCodvC0SRnr
X-Gm-Gg: AYBFou0yQ8h4b2ZyCVf/hhRc67XAmrOn/Uz3YUmFY6RPz9ZLG1hoPNVHbIqIWgfJpHb
	LRBkQ4FhWIamK6JDME5h0dQjGd++smE0Tu4SPkyJbKCkpu+HtK4oJ++aO6YWcMPgdP4Abf/ANOG
	eYZGMx6sQKVXDmohaZRrQUvB/PypUoPQGOWofKPJPeSh/nmoQ4l2M1S2OHgNDjs8cxKkdP4HQCc
	KWbr1D5bEujDbETgJho43ZZex1S9USM8hreupnpYlUVb52Ut6vCyoZ2IWKavbvr08HYnPJjaqHK
	5EshuHL7oP65019uo7u74l8BN9aoIIarxpq4evQO5Rg6ghXxtbQlQ8/kVwvsizA0PsSo2IgNrlw
	wE8hwVpFzrLNJLR2Ph+4NrRPUuBrj3jVSira2nWa0QajkcHquu1UsGnr62ZlxHiRfpbijULGvuD
	UDwJ5pS6VvCtwsGHeTG25CanSIgHUUj/h1vStaSMsrmEJyTVgR5GVNKXUqjpYoxVdoZrbcqdWYI
	iEGwTlotwH8/cTK+BYyH4EoroXX5giijfj5ZokLzMKzzvhvpkc=
X-Received: by 2002:a17:90b:1645:b0:3ac:9c37:9418 with SMTP id 98e67ed59e1d1-3adead50acfmr2166488a91.19.1792858807236;
        Sat, 24 Oct 2026 09:20:07 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeb8240b5sm2180033a91.0.2026.10.24.09.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:20:06 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v2] ocfs2: validate move extents against a stable EOF
Date: Sun, 25 Oct 2026 00:20:00 +0800
Message-Id: <pm-ocfs2-move-extents-isize-rrw-v4-d4b80ed0748f84dc3f8e@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The move-extents range must be bounded by the inode size used for extent
movement. ocfs2_ioctl_move_extents() checks and clamps the request before
taking the local inode and cluster locks in ocfs2_move_extents(). It also
uses separate i_size_read() calls for the range check and subtraction.

A concurrent truncate can invalidate the first check and make the later
unsigned subtraction underflow:

  Move-extents ioctl                  Truncate
  ------------------                  --------
  check me_start <= i_size
                                      take inode and cluster locks
                                      shrink EOF below me_start
                                      release locks
  compare me_start + me_len with EOF
  set me_len = EOF - me_start
    [unsigned underflow]
  acquire inode and cluster locks
  select extents using the bad range

A truncate after clamping can also leave the range extending beyond EOF.
Conversely, the cached size may be smaller than the size refreshed when
the cluster inode lock is acquired. Early validation can then reject a
valid start or permanently shorten the requested length and threshold.
The me_start + me_len comparison can also wrap for a large input length.

Validate and adjust the original request once, after inode_lock(), the
exclusive rw lock and ocfs2_inode_lock() have stabilized and refreshed
the size. Read EOF once, reject a start beyond it, and bound the length
by EOF minus start. Normalize the threshold using the same EOF snapshot.
This keeps zero as the default-threshold sentinel until validation uses
the size that will govern extent movement.

Move goal validation after range adjustment as well. Its allocation-group
capacity check uses me_len and must see the EOF-clamped length. Both
validation failures use the existing inode-lock unwind path before any
extent movement or transaction starts.

Fixes: 53069d4e7695 ("Ocfs2/move_extents: move/defrag extents within a certain range.")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
Changes in v2:
- Validate and normalize the original range only once, after inode and
  cluster locking have stabilized and refreshed EOF.
- Move goal validation after range adjustment because its allocation-group
  capacity check depends on me_len.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-move-extents-isize-rrw-v3-b2a7508c41108cc2d00b@gmail.com

 fs/ocfs2/move_extents.c | 68 ++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index ad1678ee7cc4..f2682ef6bf2b 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -907,6 +907,30 @@ out:
 	return ret;
 }
 
+static int ocfs2_validate_and_adjust_move_range(struct inode *inode,
+						struct ocfs2_move_extents *range)
+{
+	u64 i_size = i_size_read(inode);
+
+	if (range->me_start > i_size)
+		return -EINVAL;
+
+	if (range->me_len > i_size - range->me_start)
+		range->me_len = i_size - range->me_start;
+
+	/*
+	 * The default threshold for defragmentation is 1 MiB, which
+	 * matches the maximum OCFS2 cluster size.
+	 */
+	if (!range->me_threshold)
+		range->me_threshold = 1024 * 1024;
+
+	if (range->me_threshold > i_size)
+		range->me_threshold = i_size;
+
+	return 0;
+}
+
 static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 {
 	int status;
@@ -936,6 +960,19 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 		goto out_rw_unlock;
 	}
 
+	status = ocfs2_validate_and_adjust_move_range(inode, context->range);
+	if (status) {
+		mlog_errno(status);
+		goto out_inode_unlock;
+	}
+
+	/* The goal check depends on the adjusted range length. */
+	if (!context->auto_defrag) {
+		status = ocfs2_validate_and_adjust_move_goal(inode, context->range);
+		if (status)
+			goto out_inode_unlock;
+	}
+
 	/*
 	 * remember ip_xattr_sem also needs to be held if necessary
 	 */
@@ -1028,27 +1065,8 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 		goto out_free;
 	}
 
-	if (range.me_start > i_size_read(inode)) {
-		status = -EINVAL;
-		goto out_free;
-	}
-
-	if (range.me_start + range.me_len > i_size_read(inode))
-			range.me_len = i_size_read(inode) - range.me_start;
-
 	context->range = &range;
 
-	/*
-	 * ok, the default threshold for the defragmentation
-	 * is 1M, since our maximum clustersize was 1M also.
-	 * any thought?
-	 */
-	if (!range.me_threshold)
-		range.me_threshold = 1024 * 1024;
-
-	if (range.me_threshold > i_size_read(inode))
-		range.me_threshold = i_size_read(inode);
-
 	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
 			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
 		status = -EINVAL;
@@ -1060,23 +1078,11 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
 		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
 			context->partial = 1;
-	} else {
-		/*
-		 * first best-effort attempt to validate and adjust the goal
-		 * (physical address in block), while it can't guarantee later
-		 * operation can succeed all the time since global_bitmap may
-		 * change a bit over time.
-		 */
-
-		status = ocfs2_validate_and_adjust_move_goal(inode, &range);
-		if (status)
-			goto out_copy;
 	}
 
 	status = ocfs2_move_extents(context);
 	if (status)
 		mlog_errno(status);
-out_copy:
 	/*
 	 * movement/defragmentation may end up being partially completed,
 	 * that's the reason why we need to return userspace the finished
