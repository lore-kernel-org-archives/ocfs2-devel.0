Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F997485CC7
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035600; cv=none; b=lMJeaJcCFFIT9XdPtbBcZoa4nLICRsPbVX55li+D68fCXJs+mUKDVeWmn3NI7oLkjxpq0W2i5s2almFWhvimrzTLSw6GjBoSpx8P+Y9ewMdHihn4EySVHG9DTZ/3wnTE2JD+U+SOsklelf8tcJwFAsBGrVwKmiKayv5HGz8q8ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035600; c=relaxed/simple;
	bh=0neISYJFH5vf1iYeHnX8wDVudHaEvy72ntuqHszFLec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpiixXTVu8/MYYYhLxIovnJ5wujFHLuyDSh7XQpHSEmVBdBIil6KbgRuCtURpc5e+IsYYmLItYgr3AXHojgVN5I5d7ggPZGEznq2j7lZjJIXkVXa2Yji1fhTI9h/uQIVDYWO6z22vLRuSCMg+4tcCTZlxvZLakCI7Skdhq2XlQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QKt3fmSW; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKt3fmSW"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5bfa4c51c2aso775177e0c.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035596; x=1786640396; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DRJjTotyJT+hr0WWdtFL/ctkn8lHZ3M1r+YQr9eg6EA=;
        b=QKt3fmSWP8OddxFbxWcuOZ7zSdtBrbMW4vKhVThxevM7plpEkqC8tG6sI8KMj8dk1R
         21SowkcQen3HvcebWiD45R1YVAODx681YMBYrYm9Ivjc0u9bkn80AJaMqi25EAt5b14D
         G1vrPlFLG2uaZAavIVTPrLD/NeACbbCfAngdIaRAHmil4Ruc1tVkT47/rEBB7ZvbTxcA
         +AqxtPzb/kGFKzRvHgMH150MWiDDN70e255wFNmcciKGKS4R/Z60IXLiR7+HnylAhr6y
         hSGID5q3HY8vUML4x9L/XHK3p2V545cuMJqNSxYjrnCZdOCYXCmrmnyzC0lc1uuiUVOI
         eq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035596; x=1786640396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DRJjTotyJT+hr0WWdtFL/ctkn8lHZ3M1r+YQr9eg6EA=;
        b=ccy9kWtq/FFGJ6cu41qc2j1sF9yZeu/kBUbGk7NsxW7NLQ/XoRFEJoRol5OtO/XIqo
         l4yNt7mYI3BnlSuGDjTra2zKVhaJgRzDL9n9vJkYPK0pyDKWeqtk7RNj0qJLJPaBXQLH
         kKECvnSUwL4Spf8Kt3wTWLyo1kW4+CwIi4+rfPlzcEbtdRafQwE3PSl3usK2+pLa8CWk
         EAmtOhO9jpsBbEnbpn3zpZcg4mRzmbJu/2eXB17voE6YqJYbXhn3mvREWmY1w9I2QEp5
         xb8QS4/jocICz9JokEq1KTL5Qk4wGAo+l9UGTSjD+WRin1BMcLCxPDytduNFJzRxGDCu
         mxjQ==
X-Forwarded-Encrypted: i=1; AHgh+RpTRwD46WbhW9vpBg6vIYW/TGZ/zC/BkUSKal/vpslH1RHlq37R4xO+VjJpfLTQzke+kxK8Zrl84CtxVQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxJKs4/6FmsHjNIIB19jx48QkNq9/2W2OUIWqnpbsVNsoVluH25
	VmPaNqSmyurrIZ6upzus1Ze73YOD3oYjsQr5SJI9RBUtcHP9h9iebfUX
X-Gm-Gg: AR+sD11B0lik8EqH1+908HPFA9TWw+LUUgfwPrOGGowEp3qW3Ce1z/9L5ZrU3oNOR9s
	15AC1b0ncwsUMiB7vCW6PvzWZu8UKjxSJOO7ZbiS31/jwIi0bSqLL1GlUVycX2ov6Oh5zyYtFyr
	AhnzTbIWiaZl7L7Sz4Jc/cVfDkmq/KO/5vjcFoO4CFLlQlYS0TAhCa+3wVFdnXPOUui8eBk6lJT
	kcvkI3dm+2dzjcFz/QO6bUSbfJ/cO3ou0tc5V8YUOnHxtPdxBEvREcBFjW50Q4SmltsF7pGaDhk
	3iulrkFb+IBG1Mq68C8h+ermGKMOtYQp4WEFrLHAN2VWt4XLVo2va7Cwgap2p04pR1XcEfUjtck
	UyU5sf2UdwmrIBA/D4fzZi5sf63TukP+Rq96TF0n4gJW5T5dAy4YhRvyl4MBDtbhnUqDj8bF3tg
	CDGpQ/Ld1bLzFGFaU5MzTjP6PKqFFdHsyTUzqb6xAxu/BGE282joDBoug0TeuFa19D/CcFu4m3O
	UAW25A=
X-Received: by 2002:a05:6122:678b:b0:5c3:cbde:1bcf with SMTP id 71dfb90a1353d-5c3fe48e12dmr170712e0c.9.1786035596101;
        Thu, 06 Aug 2026 09:59:56 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:55 -0700 (PDT)
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
Subject: [PATCH v2 14/21] ocfs2: check for a metadata write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:37 -0400
Message-ID: <05cd3c34f2dc69b542db7baaef058cd75005d4cb.1785951556.git.coshi036@gmail.com>
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

ocfs2_write_block() and ocfs2_write_super_or_backup() detect a failed write
by looking at BH_Uptodate afterwards.  That relies on the write completion
handler clearing BH_Uptodate on error, which this series removes: a buffer
whose write failed still holds the data the filesystem asked to be written,
so declaring it not up to date is wrong and makes callers re-read it.

Test BH_Write_EIO instead.  Note that ocfs2_write_block()'s test is the
positive one, so the sense has to be inverted rather than the flag simply
swapped.

The comment in ocfs2_write_block()'s error arm needs updating for the same
reason.  It said the clustered uptodate information did not have to be
removed because the buffer was not marked locally uptodate; after this
series it is, so the reason no longer holds.  Not advertising the block to
the cluster is still the right thing to do - the data is in memory but not
on disk - so only the justification changes, not the behaviour.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/buffer_head_io.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 7bfe377af2df..733ceda79ca1 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -66,12 +66,14 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 
 	wait_on_buffer(bh);
 
-	if (buffer_uptodate(bh)) {
+	if (!buffer_write_io_error(bh)) {
 		ocfs2_set_buffer_uptodate(ci, bh);
 	} else {
-		/* We don't need to remove the clustered uptodate
-		 * information for this bh as it's not marked locally
-		 * uptodate. */
+		/*
+		 * The buffer still holds what we tried to write, but it did
+		 * not reach the disk, so don't advertise it to the cluster
+		 * as up to date.
+		 */
 		ret = -EIO;
 		mlog_errno(ret);
 	}
@@ -446,7 +448,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 
 	wait_on_buffer(bh);
 
-	if (!buffer_uptodate(bh)) {
+	if (buffer_write_io_error(bh)) {
 		ret = -EIO;
 		mlog_errno(ret);
 	}
-- 
2.43.0

