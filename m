Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D7C486B85
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035601; cv=none; b=mvS/TRFUV/JqfwaufqyNFHIZGdL/uL76EwcYWryzOPrNd7vXwMXHrgmLG0hR7MsKMV5K9NmknIIuxhAeEVqfBpmSW79gZNtmckWrmOGCal0WNlF2IMqGXM5ofFIXJ+oLvwwDqFPh1/DPr+ywKpO2BZXysDFFqzGEXVt93YgfpOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035601; c=relaxed/simple;
	bh=HkO8BGQDQ+F35lZWVjrmgSFoTizhXNL+tmvKt5ZHgXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMdjdpKh7uGVyo6KVJR+0jKMetx4Lwj6HdF8kbA2zlxxAxCF8SF3jQgaTjNhDpgzih4N9wmmofzOi7z2YMMa0v+LHpoDQ/AD+op9jIVYHCfbEeYKCxPa4hR7xQ4+S6nK3zaDXYx25WUwANHZmTC7zKepVS/GBkakeqzxIfcU9Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VzDhJIBZ; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VzDhJIBZ"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c2c96286f0so993856e0c.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035599; x=1786640399; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZCchMwHGHYssXWVL8RzH7mG+qMzuQy0Z9sJHAbSWGok=;
        b=VzDhJIBZ2z6GCfmQyL7FB3HZqg+aqCClAFJw3zUieu+qQ35WWmrGEQ/c+Cnrcaa+ck
         s+8OWDC1tfM4DaMrJ29Ll/cN3tjv4Pv3EryKo4uLVFXATL7F3JdiFZu9VM8ILsEB0uHc
         OGnPQ4vcpU8hEXIteWzhlo/K16xJ4kLb1xel+eY56ogANtuwPTwXVO4kkeW1TCp1YTvp
         ++k42lyyj+coLRZrfhaVOySayGqLKwT0Vu+Vgx9R1G9xuDoxqfuYBKYgPHjkxyxQWSEI
         Y08i60BW/EvHj9yIAVj3LcCz3C+HmUr2Eb7NGWzGagJSPUlID2QPQbKEtbxLIs+RFQTw
         NoFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035599; x=1786640399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZCchMwHGHYssXWVL8RzH7mG+qMzuQy0Z9sJHAbSWGok=;
        b=MnKUYz99ZHtdIc0A2mZCHj2zrIAy7dnTAk9LTOaBwV2RtNuTRk5FQ94Ofzqo1K7Zsd
         wF0Qdocv84WA1wOw244osOj45EWtXTvf4zKgsKQm0sHjirKaYUC9zI1ASIDixX9XYMow
         UclDckiuLqjEKdNh3NcX4rXTosnA2RHeX8Bvi1kZRFjMrTwvN7nDR8vvl/j/HFXOwRZx
         hZdEavlUqbIw05BDYYyKWHnreupHeXBheT/mKwIQxhetDaBB7UkaUm8fUMx+23odOtmV
         1D9+vI0eiBr1LJzyTR+RnpPOk9geq40oK87CLwsvLCb0yDh1rTiyUgBqYuf5A7A0Bm2s
         uVSw==
X-Forwarded-Encrypted: i=1; AHgh+Ro0dt/51JrgHyCcn3qLcEn/aPB8hlBOFPe1zAtWmGnrWQbdC72fUw0+eq/aNJOqod0HrGKpaT7mIlQxLg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzDu45TIZhITObyINUbOh9sTVrTUzWSCNSNHYb8imSY1AaNny7m
	xGzlk2tG105LWebf0ogzABaH/AcC14wRpJUVXYJdk5V0IUtdwsjXX+g3
X-Gm-Gg: AR+sD127HOJgIYESwQCxs+PS0WXWbbVUdfSoj2FR13CqLbRZpaJeo3LQFfdv0GqHmjt
	vJ077oh6Fh+JMKi/TGmbSI3JJQuE91cy94GOTpl1Jxaop1gSi+cQOQYh9KXL6sQJZdqAAQsEm9j
	8ZCAK9k59BENkjmREZ2L+qwas2U7K8i/wGPj3zZhHwRAXfWSz44X3kLJu02S8c0K91a20QOAjzq
	fbBDySOgUKHju3blOoqkbp+vcNSbdvQM71WtsOJVATcNmgzZXXWwgf7mhvoMt2HylBHkAJaRsS8
	q4D3orqzOMtGdylPvvEk7nekPY0UgAddaqgGL1FUVDxCcWgqHs7l/VSoRbFdb4hxlWJC21t5UP8
	H2qi3XbCQBOiBrKfJ8f3u08QqAy0HCfgn7Nk30qw317d/Xu/gMecjjk0WMpZ7rdYvzfhQR/tkxO
	WE4FLwKY9JPPX6YHmh4e+7B5QVbw93dB12nwnrWjML/utGdP8EYlnXT/Na0HN9VKN3cPB73kOk5
	naiGaI=
X-Received: by 2002:a05:6122:1310:b0:5a4:6680:64f0 with SMTP id 71dfb90a1353d-5c3d9120508mr2112740e0c.4.1786035598926;
        Thu, 06 Aug 2026 09:59:58 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:57 -0700 (PDT)
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
Subject: [PATCH v2 15/21] ocfs2: check for a stale write error before reusing a metadata buffer
Date: Thu,  6 Aug 2026 12:58:38 -0400
Message-ID: <ad75c40927060cafe5a8ac45ae71c02ae4dfba04.1785951556.git.coshi036@gmail.com>
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

__ocfs2_journal_access() refuses to journal a buffer whose previous write
failed, and turns the filesystem read-only rather than risk metadata
inconsistency.  That check sits inside an if (!buffer_uptodate(bh)) block,
because until now a failed write also cleared BH_Uptodate.

This series stops clearing BH_Uptodate on write error, so that outer test
would never fire again and ocfs2 would silently start reusing buffers whose
last write failed.  Hoist the check out of the debug block, where it does
not depend on BH_Uptodate any more, and drop the now dead second half of
its condition.

The mlog() pair keeps its own !buffer_uptodate() guard: it is a separate
"we can safely remove this assertion after testing" debug aid about being
handed a buffer with no valid contents, which is a different question from
whether the last write of that buffer failed.

The unlocked test followed by a locked retest is deliberate.  BH_Write_EIO
is cleared under the buffer lock, so taking the lock and looking a second
time avoids turning the
filesystem read-only over an error that a concurrent rewrite has already
cleared, while keeping the common case lock-free.

The code in this patch is Jan's, from the review discussion linked in the
cover letter.

Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index d8afbc1a76bb..ea6802d894c2 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -676,19 +676,20 @@ static int __ocfs2_journal_access(handle_t *handle,
 		mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
 		mlog(ML_ERROR, "b_blocknr=%llu, b_state=0x%lx\n",
 		     (unsigned long long)bh->b_blocknr, bh->b_state);
-
+	}
+	/*
+	 * A previous transaction with a couple of buffer heads fail
+	 * to checkpoint, so all the bhs are marked as BH_Write_EIO.
+	 * For current transaction, the bh is just among those error
+	 * bhs which previous transaction handle. We can't just clear
+	 * its BH_Write_EIO and reuse directly, since other bhs are
+	 * not written to disk yet and that will cause metadata
+	 * inconsistency. So we should set fs read-only to avoid
+	 * further damage.
+	 */
+	if (buffer_write_io_error(bh)) {
 		lock_buffer(bh);
-		/*
-		 * A previous transaction with a couple of buffer heads fail
-		 * to checkpoint, so all the bhs are marked as BH_Write_EIO.
-		 * For current transaction, the bh is just among those error
-		 * bhs which previous transaction handle. We can't just clear
-		 * its BH_Write_EIO and reuse directly, since other bhs are
-		 * not written to disk yet and that will cause metadata
-		 * inconsistency. So we should set fs read-only to avoid
-		 * further damage.
-		 */
-		if (buffer_write_io_error(bh) && !buffer_uptodate(bh)) {
+		if (buffer_write_io_error(bh)) {
 			unlock_buffer(bh);
 			return ocfs2_error(osb->sb, "A previous attempt to "
 					"write this buffer head failed\n");
-- 
2.43.0

