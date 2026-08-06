Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF7E488742
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035603; cv=none; b=eNFgj5L9w2y1/jlqMbQzVQ8v1kvpAfHLt0TKqL4KlWWvhhomj1u5kFXKQyr4c0XKz4g3+qza77EFp/paUkXHrcC7Qltx/GSHtNB44TSqBTrosNI4/1XlEUcxTpqRgvLtcwYc5w/tTsKcg/NV3z1QOG4fo0xDpQrqblrJKlChqWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035603; c=relaxed/simple;
	bh=MXEWU902YGIdYxhsplvnnMAlAsOIW5B35iOVcX+SwuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p//QKl8FKMNcLeYqZEBS7Tv2u5QRKbDRE1tz2Bb4kZp60BW6HiNSpy8vrnqPYa4Kv6iagAI4I8bkAQFDxiVN/62C83urZuKJ2M/rs18+XC96e0aThxPEb7JwcH+mZTYxvpR/0rgSJQFxh7EIEkMAFfmAwlB4tE43XmXqXMDdmYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fU3IdtY9; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fU3IdtY9"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5c276bd3692so1788019e0c.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 10:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035601; x=1786640401; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dTojca6QcAoa5sJYmeZWsS9cCWtcJ0fPl4l3Xf8SOVQ=;
        b=fU3IdtY9few0ydXC16/8Q98a9uxbjMEiyb4qi4KfdQHxluSK7H7XDCYR+Y5XVw7zEM
         XMUUWxM81X4naUaXWSE9MqZ6PGg3wi0TP7iUSfxPALP8870d3yX3bn9Nf9Ojkb4skQm6
         XwArEAL0MT43kkFg6Tdoby8Ml/C/6En8JAukYHeiM4PzkoZlLV6jvf7qKAj3kIrGhs6Y
         i8hqy3Nd3gDT+tdOfQtkJOlsCUk1h4Mjf7yvxzTU0iLCEAzNKpm1PWuK443LYpko7ZfL
         LBrZD41XmvfpoOuoXh7jH5TNhX+49UARMNZ3w49eXXo6pEs6SOQNl6lV6dTdEEkinV89
         ZqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035601; x=1786640401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dTojca6QcAoa5sJYmeZWsS9cCWtcJ0fPl4l3Xf8SOVQ=;
        b=pz+ofCj3odRwSkAw2+F4tJXVn+k1Ak4u0G83F1a6XWvo1WqfBH0e/9psvbJqwQhSPl
         E0BQEGuQjiIEx5nmbJAeRksnyoU6/L05/+liCX4tJ+AdeQGtqcs1B9S7FHGtx+EwFwcB
         gYUN4N2QxnFV9myhUEqEOGQ+1p4U97ct8WzlSGVsLB+66N89nqeGfKyXUZ9RG/GXa10V
         chEkR/vfk0cRtdQ6ur4OVFo7eiJKkI6DFmDKMOgMMEKdwj4RMbe7CbKHgn0fnUwwKHPL
         ECpRz7x6JJgWeryMpOT5PQuj67Xm4lquYAE6ir13sZTEcYjD3ECqw6G3WgHNwparzVHn
         pUKQ==
X-Forwarded-Encrypted: i=1; AHgh+RpoKO9t8E4BwHxpvI1QN58ot+blYb/d5t+0+sqxSGrbit3m76KNPHX1g42f/9lz9J0dgW3r1FI2JvILrQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwIygb5eoSez5vAL0i1BT73ObW2/tVgANa6B7onqXfk16qV7Opu
	qF3kvFd98DKW6TLPqK64bV9F+d/ShU7f30HI3UPAXUFtdChEYQmQBjwX
X-Gm-Gg: AR+sD10X9mSeDy/FeXishPyXIulptnJj2AnxYhkJnHTKUEh4Cl0BjkLLhRQ2YnzWhYA
	jbtV9WYfadNF33D+7z8uW2+lAnljV7nqFo+rPT7Hu+oWAKdDXn+Lov1Csi0mfz3Ru8V8F5zVRao
	CQGUqH2tJYTc5lsO09zAmfKtkWrhKXNTnLMcEfJxcrx6kfvFI80ikvbGhP2HEy5/nRtE1d0Tz5L
	gPHAuXiUVC/7zxeE8eoCL1J/GMgSgf6JRTWKIRJo5nmF6AhsLFfQGUSTsXYgqZeuys0BWC6BN+l
	MK3jjBgjtDtOWMKlVsfStvqO7y9Ut5zGu/xV4/XU8WmsvZSZY7+liy7RvFuoxiI9sqYOBLlnANb
	btTQMezGSkSOL6C/xO7NOzW5/Rw1+DwJjGEMNuHv6vQZ3hbjo867EDSFYj/P6vn7GIy4J3RyH21
	HmQsmxvDnqJg6iX+42lWh6GWWenFFYjIQithWT4581kPZpu0RAJdtvO/HC3tabaiG4ux4YIV781
	B51Q8U=
X-Received: by 2002:a05:6122:178d:b0:5bd:9c71:11e with SMTP id 71dfb90a1353d-5c3f9eb0727mr555265e0c.4.1786035600948;
        Thu, 06 Aug 2026 10:00:00 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:00 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 16/21] gfs2: check for a metadata write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:39 -0400
Message-ID: <a09b6d08d31d24f69b833e4d855ed88875e87780.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

gfs2_ail1_start_one() and gfs2_ail1_empty_one() decide whether a buffer on
the ail reached the disk by looking at BH_Uptodate once it is no longer
busy.  That relies on the write completion handler clearing BH_Uptodate on
error, which this series removes: a buffer whose write failed still holds
the data the filesystem asked to be written, so declaring it not up to date
is wrong and makes callers re-read it.  Test BH_Write_EIO instead.  In
gfs2_ail1_start_one() the test is the positive one, so the sense has to be
inverted rather than the flag simply swapped.

This is not a pure conversion for gfs2, because gfs2 already has a private
write completion handler that behaves the way this series is heading:
gfs2_end_log_write_bh() calls mark_buffer_write_io_error() and leaves
BH_Uptodate alone.  Buffers completed through it are therefore invisible to
both tests today, and start being caught once they look at BH_Write_EIO.
That is a real behaviour change, and it is the one gfs2 wanted: a failed
log write now withdraws the filesystem instead of passing silently.

gfs2_pin() is a different case and gets a different treatment.  Its
!buffer_uptodate() test is not only a proxy for a failed write - a buffer
with no valid contents at all is equally a reason to withdraw before
pinning it into a transaction - so the write error test is added to it
rather than replacing it.

Left alone deliberately: the BUG_ON(!buffer_uptodate(bh)) in gfs2_unpin()
and the two WARN_ON()s in fs/gfs2/rgrp.c.  After this series they simply
stop firing for write errors, which is correct; turning them into
BUG_ON(buffer_write_io_error(bh)) would newly panic on an I/O error.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/gfs2/log.c  | 4 ++--
 fs/gfs2/lops.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 78bba8cc10b8..e3e0dcb1f567 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -107,7 +107,7 @@ __acquires(&sdp->sd_ail_lock)
 		gfs2_assert(sdp, bd->bd_tr == tr);
 
 		if (!buffer_busy(bh)) {
-			if (buffer_uptodate(bh)) {
+			if (!buffer_write_io_error(bh)) {
 				list_move(&bd->bd_ail_st_list,
 					  &tr->tr_ail2_list);
 				continue;
@@ -321,7 +321,7 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_trans *tr,
 			active_count++;
 			continue;
 		}
-		if (!buffer_uptodate(bh) &&
+		if (buffer_write_io_error(bh) &&
 		    !cmpxchg(&sdp->sd_log_error, 0, -EIO))
 			gfs2_io_error_bh(sdp, bh);
 		/*
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 6dabe73ad790..3df6e4b7e8b9 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -48,7 +48,7 @@ void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	clear_buffer_dirty(bh);
 	if (test_set_buffer_pinned(bh))
 		gfs2_assert_withdraw(sdp, 0);
-	if (!buffer_uptodate(bh))
+	if (!buffer_uptodate(bh) || buffer_write_io_error(bh))
 		gfs2_io_error_bh(sdp, bh);
 	bd = bh->b_private;
 	/* If this buffer is in the AIL and it has already been written
-- 
2.43.0

