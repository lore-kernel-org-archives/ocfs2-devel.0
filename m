Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793012651;
	b=p8VJQBXHMxRyTPeEozKZcMCbAHr1aAx2ceCTmY+OB1tPYpwCSjUg98c/LGv/ICza0Gt6
	 jHWwvYuO/wYymV0DKw4QgD3HzT83S+AqMI/qXoyUBK6hLNoV7nalpy4rP8N29aRED+pR3
	 oOczLZlxUhombroV0SCC0PawwU1ijHwA+FhB2hNHTZNcdOWAyDY+EytZ53t6IP3F4O5eZ
	 jhV8drSw1yNxtHqrQnPkWd+j4IkM+uzkA9toN9QnT41XbDxxoSs3+JdyfUQhekN8/9mGo
	 VcJqm/b54gm5h9v0Bn3a10vvvckMRQjXLyDxe4DrbagF/Ux/Kz9LsRIpzWyKmql3t5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793012651;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yc3GxhcVwYHF7pcFhLDs2JFITUiR3kBKiUR6rOxi4q4=;
	b=oxIE0XjTFw+vFVsBIYZl5g4QRTJm6ft+/zQaS+v63IRWfKwr5G2Bd54cWxVogM+K//Yz
	 QJTh8liGzhey8xx+jdxrZ4fDF1bd2CYnspxprsMoX38h54ktidNriP379qJpKT8o4zsbl
	 YHvq81weD63Dc4Q3ytkreNPhJfozlwmm0HbMvoqgGeqHaBeiVbuNvCAoGGMTa5rImEtWq
	 pALUc9kaBYsmcZe/5Xz2E0A4mR6mvCB2AMgEQx86QWdCIis5/5Caa9HilKGDf1fCS9oQ4
	 87UJ1F3yQziwad4/JEyC2+trG/Urd68pJ1b9x1l6Xc4IycCNgKYYHitO6U4AbYIknXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GJpWlQTL;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0BD606A31B
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 11:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B0BD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GJpWlQTL
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3acb11973c3so1862807a91.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 04:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793012650; x=1793617450; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yc3GxhcVwYHF7pcFhLDs2JFITUiR3kBKiUR6rOxi4q4=;
        b=GJpWlQTLp2tSfyrbdTWSGHjGMkBCqcpBf8zQKQCHwOM/tYkC29gPLNUG2wxvOiOP7G
         zhb74IoYkaqdYqvr7Gsz3nzQfjuG9iNoPYxlY/2L0t76cLbRzACd7zwYvlvf7HFlPMHw
         JMp85G4fCjKIs2PV2ygfw5WRyxs2ImEUxJuCFY0TijleOA0CWIXDgzH87aCN3UFbo5ez
         QivXlls0vvn0pS67svwnATXxMfBUmuioRTnVjSZGsHcMZ4c3BeenHt7H9dBKJRQQQDhA
         93NigJDScv08ENiH5moDc8rfGc5BeIbdC5ItNkarpLT2KMa+9kLGleB3ahjRyZsYbAcu
         gpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793012650; x=1793617450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yc3GxhcVwYHF7pcFhLDs2JFITUiR3kBKiUR6rOxi4q4=;
        b=X1DHLe6Lk2YCRj/93SRD5AEbOB17IV6XDJh/mequS2US+VRbCiJzWNU9sdw7r4UG/S
         TituZVl/KN5epoHQewiad2NB2ecIULkDdUyEUif9MbNjxFOEo4gEt2YsJUuNO+M65WxN
         f5gGXk0XI9LTCbBzW1eIQZKH1PoXq97B4SubJIPJ4Oxs+zA21yN/jR3vcSW4RdqUL3+S
         01xwChlkWePvlwCJ/Lcha3UnwImDnHyoaUZCpOHUzrADwg5d8p2LRy+gerjs+Esyo6W7
         q3p+rEFEtxxd6bOMDRyxA8bFDwqAPAJDW1h1n0eN5mBJo9+skF6dlBXsyMPCDC/f6qgt
         YfJA==
X-Forwarded-Encrypted: i=1; AKwUvBxoUH2vNB8Dg0y47ehMCilZLhokQeJbOYTCyxvY9YrTG19C0tWI8fqqKpTpIpLD188zhFL3BDLmQNK62g==@lists.linux.dev
X-Gm-Message-State: AFq9FYJ0qnDaXh4CGcik7SkJyStlc1XURbXni4Em3gKR0VZ4Ckv9ZGI1
	VDNMFw1KOAflgan0/YEGHXPZV9xbzSC2jnvFc/TDFH2E162mW6x5ZME2
X-Gm-Gg: AYBFou33Tv5o+ONmzdZfY7HXaTwNPN3qRLbprfikeM+StrJklM1QWQdTm2V3a2L2COF
	irTZkYq64LNHeb6jwdLvK8umyZj5Fqtr+e4RpAcmzQeXu3sN34Fn4urpkAYM32eulTlHk3jMuMX
	rmfjMuT9G/u47EbsNCVogO8W0hn0iRUIFYbkMRWzXky6cCoXbLjm2N6d2crdCYJg/TqUbAu/W0j
	sVs76FhsIW8WicK3wsNQ9IxaXc+kxhl+fA1XxRLB1MD5zCR7Z1DwGGoruwb2HGUpRnvDomy1APE
	gIRx8o639UvJFyFd+/Yv4mAPo7zJGDBt1RX1XCMRSjd50XmEjLyaTo+nZt7MJsLCyCXKNCX8woU
	LraV3w4j/wOg1KnkoSPf9qWwFYpE8slS+ChjhIZW9M+6dU/8TWRGl+GaQLLc8gVwbcROK3fmIOR
	mWdRW5naQbjTtrBQfT0wtTVEVuExJKsM4skfeQCJemkAjMrR9dQP7PRLkZlTeG0NtrHxbwQkSV8
	NwQ2RQA6khrQRGzgEqeauDW9bhiFhuJxaPlqH20rxNd2gfirnE=
X-Received: by 2002:a17:90b:58e8:b0:3ac:9706:7739 with SMTP id 98e67ed59e1d1-3adead57cf0mr5711908a91.17.1793012649819;
        Mon, 26 Oct 2026 04:04:09 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebbb2fb2sm8024223a91.1.2026.10.26.04.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:04:09 -0700 (PDT)
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
Subject: [PATCH v3] ocfs2: validate move extents against a stable EOF
Date: Mon, 26 Oct 2026 19:04:00 +0800
Message-Id: <pm-ocfs2-move-extents-isize-rrw-v6-395bdee84ea81149068e@gmail.com>
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

Range errors now reach the ioctl's normal copyout path, as goal errors
already did. Unlike the old early rejection, a failed copyout can
therefore override -EINVAL with -EFAULT.

Fixes: 53069d4e7695 ("Ocfs2/move_extents: move/defrag extents within a certain range.")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

---
Changes in v3:
- Log goal validation failures with mlog_errno(), matching range validation
  failures.
- Document that range errors now reach copyout and that a copyout failure
  can override -EINVAL with -EFAULT, as for goal errors.

Changes in v2:
- Validate and normalize the original range only once, after inode and
  cluster locking have stabilized and refreshed EOF.
- Move goal validation after range adjustment because its allocation-group
  capacity check depends on me_len.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-move-extents-isize-rrw-v3-b2a7508c41108cc2d00b@gmail.com
Link to v2: https://lore.kernel.org/r/pm-ocfs2-move-extents-isize-rrw-v4-d4b80ed0748f84dc3f8e@gmail.com

 fs/ocfs2/move_extents.c | 70 +++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index ad1678ee7cc4..93b45531bf7d 100644
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
@@ -936,6 +960,21 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
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
+		if (status) {
+			mlog_errno(status);
+			goto out_inode_unlock;
+		}
+	}
+
 	/*
 	 * remember ip_xattr_sem also needs to be held if necessary
 	 */
@@ -1028,27 +1067,8 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
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
@@ -1060,23 +1080,11 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
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
