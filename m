Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F8648A2A1
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035607; cv=none; b=shECRgUakN3DR3B3Vmjnd6zwlfgfSy0PdNb9rCOVMiu5YLuq4pP9ozoLc3lw0OQkXwJfsO9ncrl0GzOY+ICVCifGPF32nVsFq7MMg8xrvGktodaRzGMqUi93iBD1wkUdKi33eVcxVQBJIR6yMTM0smzPVbD4deq1djnQjNebejA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035607; c=relaxed/simple;
	bh=0Xc44NcsBrwibOoz0erVurOyZIpK7szMhrJzMbzCwzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKA7miswqN2RLf3MEnrL37K0ZgOFWrdKCjDqOQYvELmZ5stTzShXL+39KfabEMya9kkO7OSvwJD2NkJND2GgGShJavkFRySMUukiboC4/nMZtVcsH0TJy16gVWOgrp9XiqIuqeAhG8Caqmp6vC2x1ztmdaIM6ZNknJzjJDwCblo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=feanFQJZ; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="feanFQJZ"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5bfa4c51c2aso775237e0c.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 10:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035604; x=1786640404; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=strVwQ0MT1DlcADT982qPWz3+mjqKycZhsT3ISgkZz8=;
        b=feanFQJZKtdBdibOzUDN/5VX+9cHcK6MRRxiteAtSp+jdmhGsBUW8gogQKa4OWbCN0
         9rGGl9lWAZoaEztzZdVdcxCL9f9rdK/GZbeGqZH2GjNfq5gqAxbDfSvTHWwwiplQdS2Q
         c5TxvKFZCNpzsaCFp2dSsVqmKQHaWCCjIpjw0l1ubetFCFqfnaQSEiG/5e00S/riau51
         1m6HsoV6TkBOylYhNrDvMxZaU/QmbG8804ya87c2AJo652ij4G8TCz/mTi4AiMFattW8
         PMnHHqshMCaYTzjhT/GLUtxFoMy3OHHOBgL3hHu7rJriP4EkZiHHmj2/CN0SjrkotVFI
         Oh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035604; x=1786640404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=strVwQ0MT1DlcADT982qPWz3+mjqKycZhsT3ISgkZz8=;
        b=YQRBkrbIK9BZD1KuIZfQMC4Gv54R+KJ4gsMvh4Kkfa/UuVFY2SmNOndgTFPlqqbV9x
         v8lzYv5mNbPoC4P2P0RLHJmgxJ+w+8Y3cF363l283cpuYxNXF9XnC+I1Fy/RTj14H3ve
         kQcuEDEDej+GKvNRRo/452moayh5oyX9GnoxDMQgbsony5/UOygA6HNbcHLODE5zhGEy
         X/MvtpHGaNaPQen95dZORMdNqthJWNs+iZRBgepUmn4dBcfoIPUcOlIL6sb9yoM2P/f4
         +X9dZB7bBlTuqVeiOnXd1nUV2VDSPPadLPOumhOA6vGp9tRYJFYfPP9IdvbftG/ZfGLe
         hv7A==
X-Forwarded-Encrypted: i=1; AHgh+RoFd+3/+PPPXbMX/3xOueHQKOWVCf+zaI48c2cQXU4lIQl1k8gV/2DPOpm1JbcRAeyHMHP1eQCA8V24Aw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwdjwuqDd8JehhfbaqmcRaGZ1IFNdjMqVRAhUTLeVx1EemDsRdr
	C/b2/iO/t1UWK6OxiIKQ2dA7zvfVWG7Dp7mdZ/jVJ2/RUjjbEjkHKuNB
X-Gm-Gg: AR+sD11A/roORMhiry7GekHPZc1mDt/i7yDPWP5RgcyTmmRAAfTUK8+t/WQqt7NAz+m
	SgNRSpdFibHqQs+/LKsym1c4WIKDRMOz3DXFxgnu177hkVuVVRDmGsH0+A+CCF18A8u/sXi76oN
	38olg3Q0zmSdRPIeYEtKc0Uf/Kkjdc6gYlPXZNnY1oIjS7JvVD4cyCfUDPZ7kilVrqVKmgIeyzB
	lRmcpd1CzSDWnfnMbZScRq2gxSjuHDBajhcRwz/bpILZvHx2YNtKgm/zVTkQc9raYrlAO/mBM1m
	bGGQTkDhNaxWWeMk5zzRgLotWSrHH3ipKE0T32fniQPIMX3rPpdCBJfK8tDGNp5FpoSiVPOWDld
	j53Yra+lOe9JiZtaXaLW2FIPY177viDqiCMhjT2f6jUgzvsbL4EvGHFGt/pUDmTlBEsyKE3Y4V7
	dlEl/dsAszanP+9Hc9RdpXeX2gizGl0u8CgVsb82TVyd4nwA5VQ/9IFMQNIfssJPYDz+iL93goJ
	sve+8s=
X-Received: by 2002:a05:6123:2c7:b0:5bd:faa8:74e1 with SMTP id 71dfb90a1353d-5c3d92900f0mr2225801e0c.13.1786035603729;
        Thu, 06 Aug 2026 10:00:03 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.10.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:03 -0700 (PDT)
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
Subject: [PATCH v2 17/21] jbd2: report journal write errors with BH_Write_EIO
Date: Thu,  6 Aug 2026 12:58:40 -0400
Message-ID: <c700983eea955429d927791fe5fb9ffe6cf11056.1785951556.git.coshi036@gmail.com>
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

The journal's own write completion handler,
journal_end_buffer_io_sync(), reports a failed write by clearing
BH_Uptodate, and the three places that wait for journal writes look for
that.  This series is removing that convention: a buffer whose write failed
still holds the data that was supposed to reach the disk, and saying it is
not up to date makes callers rewrite, re-read or WARN over data that was
never wrong.

Set BH_Write_EIO instead, with mark_buffer_write_io_error(), and test it in
journal_wait_on_commit_record() and in the two commit-phase waits.

The handler stops touching BH_Uptodate in either direction.  Setting it on
success was never needed: every caller marks the buffer up to date before
submitting the write, because a buffer with no valid data is not something
you can write out.  The local flag is renamed to match what it now means.

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

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/jbd2/commit.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 0c85af91f9b2..cd7ef783bd36 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -32,14 +32,12 @@
 static void journal_end_buffer_io_sync(struct bio *bio)
 {
 	struct buffer_head *bh;
-	bool uptodate = bio_endio_bh(bio, &bh);
+	bool success = bio_endio_bh(bio, &bh);
 	struct buffer_head *orig_bh = bh->b_private;
 
 	BUFFER_TRACE(bh, "");
-	if (uptodate)
-		set_buffer_uptodate(bh);
-	else
-		clear_buffer_uptodate(bh);
+	if (!success)
+		mark_buffer_write_io_error(bh);
 	if (orig_bh) {
 		clear_and_wake_up_bit(BH_Shadow, &orig_bh->b_state);
 	}
@@ -169,7 +167,7 @@ static int journal_wait_on_commit_record(journal_t *journal,
 	clear_buffer_dirty(bh);
 	wait_on_buffer(bh);
 
-	if (unlikely(!buffer_uptodate(bh)))
+	if (unlikely(buffer_write_io_error(bh)))
 		ret = -EIO;
 	put_bh(bh);            /* One for getblk() */
 
@@ -834,7 +832,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		wait_on_buffer(bh);
 		cond_resched();
 
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			err = -EIO;
 		jbd2_unfile_log_bh(bh);
 		stats.run.rs_blocks_logged++;
@@ -877,7 +875,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		wait_on_buffer(bh);
 		cond_resched();
 
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			err = -EIO;
 
 		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
-- 
2.43.0

