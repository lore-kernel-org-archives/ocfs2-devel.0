Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4909A48422E
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035596; cv=none; b=cg0ap7S2iOmGJSPjGYo7a+u5RA+imLn6ImeCXkExxldeGjV9ozC0ThGCKlHYZCENBu6NV44oMOqXRw5hcVUmOFEyI6Uk5U+mr8z4WrLV0Jp2A/AN5odmHfUDnnd7GKTqxc+UFWVSfxKy7pAgU1q6cZh6Yy4qRgfob0jBzX4WX3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035596; c=relaxed/simple;
	bh=PhUfiLl4o8/gnM5dBdAr9/CI3mtr8neFPCeerCnHCbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXB5pTG4bHskYbvW66AMyJN4lfaI6i+jdnJHLs+9aEleNmb/yDKExrqYKtluAPsSl8CBeiIV7ob7IuHC9Omg2XC3oSJTP7O4IcMpB290zZNhg/owADQdnfCoMAn8D40lboXCY9WhoQFu/R3jfut1JMd0FLcT1Hxmaq/bff9vsOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CLAyIKmv; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CLAyIKmv"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5c3a1d005c5so1364826e0c.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035594; x=1786640394; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a0eDfGNL18OJWRoQDXpl4mokl45SZAvTsQakbJs+ewI=;
        b=CLAyIKmvOV2XXqJdLpEnq0fDDbE2hSOret8qGL16aV410NLNGbGDH+sEFvEfgicn6f
         mzVCf7eiHm6hJEfs+ZdvGUw8PbipWFpN3Ux6/xL4+9U/MHlPSm97vUuTAyRBo9UqSedm
         lsCQol47nWtTvf09O0h3t0JOsDclgVzTRj2qpw9/FNQPley0titH/yl3gEvANUlvkwmb
         mt9QsN55XfAMDBWtsTmscA82yD7LFVzagxQLRDl4coSlraWJJxeo5LXI+p4Mf9T4gDET
         VFdqHZ8QUSRTGZlc9rlSG9zrYlNWvNjFJ++Rq2lETzsZc1xYQK4fUDrOp2+l4ZJJBc4h
         PRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035594; x=1786640394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a0eDfGNL18OJWRoQDXpl4mokl45SZAvTsQakbJs+ewI=;
        b=MVeeBH8bOXQfepMXJpBKiBA4cJIuLvs+RCpVO2syWaTlmbR2NjRFONscnejLes80z2
         dKLGK6zi1aboZ62SgVk9LOEgdbvJcG9zK56ObVzU7tZh9uLKXO/JNITtLJp07flksEMR
         FYhYmjcUSL249ZfSnuo9N5JYBC/GOIpLNYFqIeQtW8WwKUDY8vjLhQkhEYlwW3ut3T7i
         cVwpNqAD3EpCMbyrAGvqUckRn64n2pmtH6gNDffanIpqCSjjgpDU06l5XYyawNwg2cU9
         +Fztl4IFyaddxIP+JeazC2Uq0YJLr4TwJ2kAWVf69Mzhmn4bYkvZJ2hWkrlcn0vg4Q/o
         ZSDw==
X-Forwarded-Encrypted: i=1; AHgh+RoItPcotI8MfJbYngDFeWY7v9X3gnrd83sYGiKddOaxTD+wS8gf2kDxqaU/jKTsdiVuAl5o7ocQxPKMHQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3+939oO1WBKTe30jH+WKSdj/BtBk2VXWxEKYGPEZ+eMI4uNdH
	q48wdar4z1v1K1aS+G8f0HYLbf32sBZ0mSkCvSTYrLbZ1uCZO0KtB5Wf
X-Gm-Gg: AR+sD12vfmPlfeo7eGO0Zuw3mKEarglqLkbW0ES63oCOST/A/XK5KnO/Z2fd4SqE+aJ
	8vxjBpDfjK/hNUDim3drw3n1poNVaJUnEPvqyDUhnPHpQQ9EM/RfkG8z1ZiCns9dt6XLscprlVX
	uohMeuInGVuBq0FA94s10bTESA65h6B1FksdhYq47aq7IoBwGdJND/GqvhQqsAdLA1dGa6U29em
	Uw58AyK5GKhPOAkwVRmS7Hia/OG7jFHfj7kQYXmgjBvO0RFhc209FO0TNsCNrJ2jXCHf896SNIa
	Dext6sjY68zWOutiH1mGj9czKIxDgD4adJ5HglA2pNfmq4pDqdta/VjeZYsv38Ic7PrtWch5hZp
	8qy5BaVdUKKsIacQSm8/EVKShHuuOza5xWMKGKTqrlnfI1FKn5NIqQWvWZVnLytNO1XreGA9j/e
	dp1JXZNVH/WLgPFnMOt9kMv+RCKR64W2JlaSw435bj6sAzoPMuTvijlet4EJtl6i0T8FMtQ/Elh
	o981XU=
X-Received: by 2002:a05:6122:8b8d:b0:5bd:ecad:8f80 with SMTP id 71dfb90a1353d-5c3f9e68046mr593995e0c.2.1786035594156;
        Thu, 06 Aug 2026 09:59:54 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:53 -0700 (PDT)
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
Subject: [PATCH v2 13/21] ext4: check for a metadata write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:36 -0400
Message-ID: <568e57d184da17041872fd4b498f31dd6259a4c1.1785951556.git.coshi036@gmail.com>
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

Two places detect a failed metadata write by testing !buffer_uptodate()
after waiting for it.  That relies on the write completion handler clearing
BH_Uptodate on error, which this series removes: a buffer whose write
failed still holds the data the filesystem asked to be written, so
declaring it not up to date is wrong and makes callers re-read it.

ext4 already does this correctly for the superblock - see
ext4_commit_super(), which tests buffer_write_io_error() - so this brings
the other two into line.

In __ext4_handle_dirty_metadata() the old test also required BH_Req.
BH_Write_EIO implies it, so the pair collapses into one test.  The new test
is also strictly stronger than consuming sync_dirty_buffer()'s return
value, because it still fires when the buffer was written by background
writeback and that write hit an error, which sync_dirty_buffer() does not
report.

Note that the failing write does not clear BH_Write_EIO, so an unrepaired
itable block now reports on every subsequent sync of that inode rather than
only on the write that failed.  That is the intended behaviour, and matches
what ocfs2 has always done with this flag.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.c | 2 +-
 fs/ext4/mmp.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 02b066299164..f338d6e3c29f 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -413,7 +413,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 		}
 		if (inode && inode_needs_sync(inode)) {
 			sync_dirty_buffer(bh);
-			if (buffer_req(bh) && !buffer_uptodate(bh)) {
+			if (buffer_write_io_error(bh)) {
 				ext4_error_inode_err(inode, where, line,
 						     bh->b_blocknr, EIO,
 					"IO error syncing itable block");
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 7ce361484b38..4b18ddef468d 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -49,7 +49,7 @@ static int write_mmp_block_thawed(struct super_block *sb,
 	bh_submit(bh, REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO,
 			bh_end_write);
 	wait_on_buffer(bh);
-	if (unlikely(!buffer_uptodate(bh)))
+	if (unlikely(buffer_write_io_error(bh)))
 		return -EIO;
 	return 0;
 }
-- 
2.43.0

