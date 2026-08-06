Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA9548C411
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 17:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035610; cv=none; b=eHjXqUo3FJD+9G06Q8DHt3vEuR16ZGTruRH7vrHOtWdAQmkOvzUj9VVDs+AMK0sqrpqyeqqBGC6GnwQeuljPofPToja/ROG57r6UP+C8Tq09UFKj75eVVwYFwVUf3aeBFfjzAeTPb12aWMZrgmPuPECP98s/liZomaUuUtORyTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035610; c=relaxed/simple;
	bh=92j6zzfTbfyHLTwkDGD6bYfpfzSkLDZ7TK79qat2c7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=my+oHhLtfOo/rziXvcC6SZ52XzYUYQsabgQ/3Rf3/pvvQC+RtFnCw8NuFQgrqISQqUuw5vDwRJMrFNUQRV/BKEP4qEDyKaJCcdVGt9adxqs6Avx2j+i9ftQrl001Wy6bbAvTtq2xPVfvhqF3laQDLJxXenL5xyCDROuY4g788/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WFG3fuUv; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WFG3fuUv"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5c2c0e261aeso700401e0c.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 10:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035608; x=1786640408; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y0IvqThbFa3F9XFl8mEQfcRObacw4VhqXeJ5e5/Q63c=;
        b=WFG3fuUvMyaPAEhG6xKwhp5nfXSIC/lJTdNICdsZPkWkFLY3G1r1g5y/d9G31KxW0n
         QUuzvg3K30oc7n/A93ohanUhzvfduXK6FNoiPvzS+oYHu+hzv/iiPfSGxOCDEhfgY1Nr
         t6OuLTOTOjyiFyvNIEu8tU5ylGl5O8Fd75dwitSjrdyZjUUAYHQZ7mcatzbzZvVaG9DD
         EZ3HzOR5uypXgLL6JlY2DQ2mdF0j2Th3hOZ1HDe/EF2U3edlhlHENOTm5y5ycgCMK4lZ
         md1DxEwVd6qAPxRZ4HUZ+2kVy6DJtUycWGjlTpXDZvQ2ULAkgCG8Ff8oEOalOYvRgdmA
         TyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035608; x=1786640408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y0IvqThbFa3F9XFl8mEQfcRObacw4VhqXeJ5e5/Q63c=;
        b=ltnSF9lZ026WGEyqq8e3fmsuAqZ85LNVDY1d6BCG/CHBfdoR6zyLAl3DPTz1BBPPUk
         xkaGhDbyqzuPnOhbNWYlQoM+UxW01jsDZcy0xDKqmRs2qXWzutFdIC+s23XzYzkFlBmY
         nRiH2U0aibX6PrsrHW4ra8AXAuLxo0vhpfIUDBoQSzLegNe+I/qFWGcjFKn60rWQ9YFg
         OhECfyUfLLq2Cytb+++/gU853tGLutqDo992kh2zE+2GcqWampg6/jGXvtHpqlcjO4uq
         9uS3uyHLfCkdt+iJnxp4VMBctgKKq9OC3+wLYhs9Gi7FjEcy+Mlk4VucaUWsy8bLchI9
         Gw6w==
X-Forwarded-Encrypted: i=1; AHgh+Rr0g04haOxwOrgPgtibtE3aPiAlmACaahfVAxp7mWilwpceu+KVKIRStUN4PxJZMukX3BaLJU2DQfjr1g==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywkyu9zQjApEymmmt2KKrlMO0reb9CGew9Fvkq8IORFGs+0nwiX
	16e+0kfO4vt8bUXWvr6RpdLWBKhlCT8fv14dCTPqp6Grl7U+s4CpEeJL
X-Gm-Gg: AR+sD10/ljmV0FFgEYrFqfTgy73CR/2RqOfhuToDhFAN9v/5E6Slpw9rqpV6wwCugNk
	B1cDw0ac143RhsuuU6XT8GSMr9tErJgg5fjWjiBMTK+CARAXz17iRJ2UNFby/NBFZFYycQwA8vh
	/wEwzp0jyouYqYJ+YsyCIjONG5hB9XkSE79DS2sR+5xY45zFM0BAjlon/acMp8tUiC/1/5c9Gy+
	L3dyFQZw04MXJURZBpa+GckxEn9PopT9Ar6U1iFbp8nVKXxuOxPKrtuZObgCg4ZRW1F5umDaciX
	3KNhZOM9d+65k190Z3yoK2hL+5u9WTPSONNKOcdsZ4eM3JST006MDI0+vntRQXaYIBlcp+giLLb
	zJhqwAn6bSDKVCaVQOXK0h1uDSP/Q+vljDpbkaSg2ampWFd1YqJpW2DnS47m+mnYn+GAuD6NdRy
	3MZ7SRMH5W3+0qdKpOENdMjEywSDDgyn2iKVZVE9gwwjS/o5G23J3FZk3YVTVs3bm5Dd43LGNNI
	QTqaCU=
X-Received: by 2002:a05:6122:390a:b0:5a2:5c65:850f with SMTP id 71dfb90a1353d-5c3d91f3c3cmr1985318e0c.10.1786035608151;
        Thu, 06 Aug 2026 10:00:08 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.10.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:07 -0700 (PDT)
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
Subject: [PATCH v2 19/21] ext4, jbd2: report fast commit write errors with BH_Write_EIO
Date: Thu,  6 Aug 2026 12:58:42 -0400
Message-ID: <970d8b9603d4620ab73038f49bc36831e37e00a0.1785951556.git.coshi036@gmail.com>
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

ext4_end_buffer_io_sync() is the third completion handler in this
series that reports a failed write by clearing BH_Uptodate, and
jbd2_fc_wait_bufs() is the only thing that looks at the result.
Convert both.

Like the jbd2 handler, this one stops touching BH_Uptodate at all.
ext4_fc_submit_bh() marks the buffer up to date before submitting, so
setting it again on completion said nothing.  The local flag and the debug
messages are reworded to describe the write rather than the buffer's
contents, which the write does not change.

They have to move in the same patch.  The handler lives in ext4 and
the wait in jbd2, but neither is used by anything else: the buffers
are ext4's fast commit blocks, submitted by ext4_fc_submit_bh() and
waited for by jbd2_fc_wait_bufs().  Converting one without the other
silently disables fast commit write error reporting.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/ext4/fast_commit.c | 11 +++++------
 fs/jbd2/journal.c     |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 8e2259799614..a2028fbd4540 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -203,17 +203,16 @@ static inline void ext4_fc_set_snap_err(int *snap_err, int err)
 static void ext4_end_buffer_io_sync(struct bio *bio)
 {
 	struct buffer_head *bh;
-	bool uptodate = bio_endio_bh(bio, &bh);
+	bool success = bio_endio_bh(bio, &bh);
 
 	BUFFER_TRACE(bh, "");
-	if (uptodate) {
-		ext4_debug("%s: Block %lld up-to-date",
+	if (success) {
+		ext4_debug("%s: Block %lld written",
 			   __func__, bh->b_blocknr);
-		set_buffer_uptodate(bh);
 	} else {
-		ext4_debug("%s: Block %lld not up-to-date",
+		ext4_debug("%s: Block %lld write failed",
 			   __func__, bh->b_blocknr);
-		clear_buffer_uptodate(bh);
+		mark_buffer_write_io_error(bh);
 	}
 
 	unlock_buffer(bh);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 6e05dc47e20a..72e8ccbf7de4 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -886,7 +886,7 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_blks)
 		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
 		 * buffer head.
 		 */
-		if (unlikely(!buffer_uptodate(bh))) {
+		if (unlikely(buffer_write_io_error(bh))) {
 			journal->j_fc_off = i + 1;
 			return -EIO;
 		}
-- 
2.43.0

