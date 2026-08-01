Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCAA3D25B6
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621697; cv=none; b=uxEk1L+kpP3Pt0ezZre9a0zdnrtioPwJgGytr8ImVNoV6nuaZ/k5h/YpONZ5s61bvwtIJOxgYVcswRR8aa9T4gVDE4wXRfiG8wqK6ebBdUewgUE7emJlbV0xqGF/6sp2Tc8l9+q7jN8pjk8rPE+eNMW+u6gbmOqvQqyNgTECiCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621697; c=relaxed/simple;
	bh=11/QTy2yfnrD1wjLL3sT4kKYG83gGCLz7L/Upg/VVro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKD6P+9smg3co/9QZQfP34Q7LluFG1bRe/lKchIwYwRkc8z6TxcVEb3rM7uR3aZzaMr01te25APFfDRIop73ndcvycwg1WxIOKAhEFbKxmV7xrLfXuyPt1rCOQSm3nGKVjxh+A5d54+55ekgDK6gvJriDlswSrRSN5uv9Nuz548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k1tLX1t9; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1tLX1t9"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8114a4542b2so33657787b3.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621692; x=1786226492; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6crITnQf0AA10KnjmQzAxCPQHRm39qApxGuVVNfjYZs=;
        b=k1tLX1t9+e8HgN7BK+zILr+RuMVSxwLwvkTroyP3hqtX6bhDkypCYtdOVIqINL/uAM
         VkEF3zia+CV2BVN+9B1iH1ysbf2NvhcuTtB5Vmgfr0BgL7n3hAHPH9GVh47wBhjX0BUS
         YcU8oWnpF9R8Ziye2CZRGUWMWmc1CdumttIrK3BM96Lkqa3L1t8MY6LcFsHzHx/08mxu
         ooQ5/cTiG3FfBukAsIpmle/QPGqOD2GUdlHH63GIjFSmXMyenQI6CsFTTSF1eH2Z21xM
         bN0ebIvwDGM5IY4YrdnqVQxUytMRVjIcQoeWgUQkkVhdM2ISH5XfgXXU/Ga6mn7zOng3
         bJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621692; x=1786226492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6crITnQf0AA10KnjmQzAxCPQHRm39qApxGuVVNfjYZs=;
        b=nIf1bQgsq6FpTpUq6rcldZzNhHQA+oKGae/x96gZFzqboiZbLUe8fb5skjVD1jOhD1
         AKurFhJxZPrUg2ufWS9rzfJZRR41cXZmE+ddpwIjAtpW/GWwk4kIZPgY+wwpbzbQPv1z
         mYHP+fHHeS3rVZJAv+jXWiwUpA01Ft1GpcZsTvqQYPfDV4a2Nvh74q4q2x5vxLWCkAR3
         m/+Ar/p9n22SouGJsd5zZroQtMYLQIfD4AJkfz+ojLmBoB+4lXn3kkmfscnPfPLOpd8E
         7YY7jJeSZ6T07aC1qY2W5I46Qha2oqa62OLBPpyqQk0VnwsOXD0QzVfzTm4wzytymEvG
         X6CQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro89+FkZJJ+NLKfOQqpdNfUOj0l4HA1QFHMLPbJMrpWnB+IwCmDmwIpHO1f6XwfzIWndKDjPZny+C3A7Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxfxFVrqq9Uxw+C9xeyt1VnkdlywNHq/RGC0UJVMMahRszZ5QpV
	X+CBVjHPVlZLA/P0lJffoaULbw0UlM1tM7cnC9vHJGuKrr9aYoSE3n1P
X-Gm-Gg: AR+sD10Np6IX4cwAzX+IsiTed7lPOI4c+PJ+EwItfaHDvCAN5ZRWLdB8m/GG5sCBrOR
	dc2bREm4diWHJ6zB1AQ9qS6bnMLjqY2nQdhp4QEeLy0vrIOd0s3EiFTbn75BWvNwW9GcS6zbiSe
	t5sYNGOI0pKYJAGAb4VosspBWWcmtW5NP1YzxI4DL4GB98k/65+vk4MlhG1a48a/SqtDZItjDaw
	lvb5PUDqKRp9PLZfK47Sw21ZmjE1DCmu7q+OTt+ZQFh31OZchLGievZwnBdsp0cpPJxHU4/anHW
	RYgxDAv7W/TSq/96ws4H7r7B0A92c5ctJ1m//xE2c6SGG7TFYq4wOGXhGiwyMnWVYJRAGSP7H7M
	dPwcBjNzPU0xUNhXlT51nTyOu/q4ndWLm53Hx7lBdCUE/taHdFwjBJxQ0oMzbMRZGRDKfd8UWTC
	CQh6+/vXKKVZIntrD3ckX/sDoheQxL6cuFPnhGL96dceJlY7RFvqTO4cfqwL5e9I4ouhSOvDH8r
	7P/Nc8=
X-Received: by 2002:a05:690c:450a:b0:809:9422:8c47 with SMTP id 00721157ae682-81fd4b5a2e1mr70880997b3.22.1785621692499;
        Sat, 01 Aug 2026 15:01:32 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:31 -0700 (PDT)
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
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 16/19] jbd2: report journal write errors with BH_Write_EIO
Date: Sat,  1 Aug 2026 18:01:00 -0400
Message-ID: <f0e0fd8516487b774d8cf1384949a0c616921fbd.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The journal's own write completion handler,
journal_end_buffer_io_sync(), reports a failed write by clearing
BH_Uptodate, and the three places that wait for journal writes look for
that.  This series is removing that convention: a buffer whose write failed
still holds the data that was supposed to reach the disk, and saying it is
not up to date makes callers rewrite, re-read or WARN over data that was
never wrong.

Set BH_Write_EIO instead, with mark_buffer_write_io_error(), and test it in
journal_wait_on_commit_record() and in the two commit-phase waits.

The two changes have to go together, because commit phase 4 waits on a
mixed list: descriptor blocks are submitted with
journal_end_buffer_io_sync(), while revoke blocks go through
write_dirty_buffer() and land in bh_end_write().  bh_end_write() already
sets BH_Write_EIO, so converting the consumer alone would keep working for
revoke blocks and silently stop detecting failed descriptor writes.  With
the handler converted, both halves of the list report the same way.

mark_buffer_write_io_error() is safe on all of these buffers.  The shadow
buffers from jbd2_journal_write_metadata_buffer() have no folio and no
associated mapping, so it does nothing beyond setting the flag.  Descriptor
and commit blocks are ordinary buffers on the journal device, and marking
the journal's mapping with the error is what write_dirty_buffer() already
does for revoke blocks on the same device.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/jbd2/commit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 60273cddf434..8912786ebebb 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -39,7 +39,7 @@ static void journal_end_buffer_io_sync(struct bio *bio)
 	if (uptodate)
 		set_buffer_uptodate(bh);
 	else
-		clear_buffer_uptodate(bh);
+		mark_buffer_write_io_error(bh);
 	if (orig_bh) {
 		clear_and_wake_up_bit(BH_Shadow, &orig_bh->b_state);
 	}
@@ -169,7 +169,7 @@ static int journal_wait_on_commit_record(journal_t *journal,
 	clear_buffer_dirty(bh);
 	wait_on_buffer(bh);
 
-	if (unlikely(!buffer_uptodate(bh)))
+	if (unlikely(buffer_write_io_error(bh)))
 		ret = -EIO;
 	put_bh(bh);            /* One for getblk() */
 
@@ -840,7 +840,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		wait_on_buffer(bh);
 		cond_resched();
 
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			err = -EIO;
 		jbd2_unfile_log_bh(bh);
 		stats.run.rs_blocks_logged++;
@@ -883,7 +883,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		wait_on_buffer(bh);
 		cond_resched();
 
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			err = -EIO;
 
 		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
-- 
2.43.0

