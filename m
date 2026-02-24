Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B9C286A9
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Feb 2026 08:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771922960; cv=none; b=meG6uUxqrXP8Gks/x9R3AChbGo9Hrk9IhXArKdUGkZ8mAbvkDlgEzZOLydszKfXDGMlJbQLKWXA+1NiT6P6qOV/dQnYFW7imZudeoCZzHgvf/pFSqfHfFfsUwx/UynEvcNrf1g+vut7wzzfUPE1svo0l8y817h+Y0b0LDbdSg+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771922960; c=relaxed/simple;
	bh=CNBTjUv2xrwAGE4qlRwBo5cl6jo4JIStuJMs5MuLocM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WPL33JXebiu5gpH638HhLQ0WucLPEgPm03mPTWWWOCZnLz4de9mp8Oqh8MOJ0aZJFGcQgd4pHum6SSo0IvRmfxAyHFDz7FnC9VWz0GzlE8IfoLYquAvshaudz9ZXk1g1uHHp9Sj8EFxsZb/CTYzA+J0lialLLun/JSBHTMK7P68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E5JK3O1K; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E5JK3O1K"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4837991d1e1so6639415e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 24 Feb 2026 00:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771922958; x=1772527758; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjUYzArAmnEOIEwlqNfAVhWqoWtQkCGMPCKvsuXwxiE=;
        b=E5JK3O1KHtH0xGrHgMjcy72qi/4N3F13F3wIbcFOzVUH5qrBqzoMIyQlZQBVA5JVnM
         YTx0tH4pOThCl1R3hJk8S6wzzD0+UYXBs4UlptzP1WnL6eBZvtzO9078H4DtC/Lkico2
         5XFxFjDdDNPi6WOtwkFiUxM3eklWU66KXWrsfhdgC3R1s4KFoqm41AIKf5SLwyQWUBNE
         AN15HYpX88BHjTziKkz0PF2fdTwkWj+x6JxQDx3CRMmtWAHyJ72o7/1SHvQ3D/FET4aE
         oTqIWk+5LxoBMgfDrtmvpyf/A3R+WiIIu1jONriIRQ/1aGpsIwe4OSuUw9NXKZ4rL+d0
         8lGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771922958; x=1772527758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZjUYzArAmnEOIEwlqNfAVhWqoWtQkCGMPCKvsuXwxiE=;
        b=FSIQ8JikmsqQE3ryUlMYZ0+Ka2+Kn+cKf4OCrCCCIUiNc4QDB+EF4MjcAhMyr975aP
         9EGEO2NBODYMeyYGtCkKizgIEHSRYTZmnS3Z7Okqlu6IKdzqLUBnCW4iqb1vR2zyyMXe
         K4V6yC0DZXFA3inZ5E9SbkbA8X3YbtZc6MuvrxUyys6sicGlQ5wye1RvS3FfZdrA6QRq
         AfHcNhKE6+Fe+aRZwSoZC5ZSarRnYkuHWMFCnC8udA4oZOI9RnU92WobJzRNm4rz8bC4
         ESYUyVV8E0BT4RyyWUYYr/g5XBqbnM67sory0L1zsuhF8V6ZZvQe5/OHtWRsrS1DvWo1
         Z5kg==
X-Forwarded-Encrypted: i=1; AJvYcCVQV0RpW6MLe9h0zUCL6oWIRACKsYI+RA5qnzz0m7PTvZAYXpK3VeM0dLjYRMo4I94et6319sUjKJU7dw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzi0Dav/gsgkpa8yTeCNjU5brbYc0ejP78q+Zu+s10X+NXrI19R
	V/U+JtdrgDgeBu5R3wNSgZYPBNquCRWydNszTS+GgempnrtqXJ3CRJX+MxVSU0cljDg=
X-Gm-Gg: AZuq6aJAKFVrdnNZVaJPzH7fievR60WavCXwvWXr2s3YOVNPubZVDv9in8bHEn+mDKg
	SBBxIkipdSGLMS/AhR4Wg4oYRs9klYljrimKczzNmP1fIWESogzYwuRpfrsMBz9Cu9wPLO5nZQv
	mOXMU0M4m3OofO/jBhv/DFP8Gc1/wjRF2wqUFpgzFDhFdWECpU4uwDkX44siBsi2WojOhn1FqyS
	XWA5AVE29ViKCDONKNc5mysOX/t6ukhnNL0G/C1iwi8766bf3qgOBgeIFAIGXBtcKVIhsiiU00y
	YGs4uut8eDdNg8khU+1HykNsi16QFEe3qmVvHXHPiiFFf/+2KLGyKWa5adclxrr8zhFwF1EOmO8
	r5+cv/OwNqM07Nwnr27/+26Mpju7VRt6tO8Qm1ff1wJr72mritnbHD1QWpDC6XWp4wymzMWmkRG
	+WX6Ql1i1rPtp1DmK8VPHDlx4C89bCC4mftc9s
X-Received: by 2002:a05:600c:1988:b0:483:816b:67cf with SMTP id 5b1f17b1804b1-483a962f20dmr95581805e9.4.1771922957788;
        Tue, 24 Feb 2026 00:49:17 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70b7269771sm9668914a12.30.2026.02.24.00.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 00:49:17 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	activprithvi@gmail.com,
	syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: fix deadlock when creating quota file
Date: Tue, 24 Feb 2026 16:48:56 +0800
Message-ID: <20260224084909.28361-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot detected a circular locking dependency. the scenarios:

        CPU0                    CPU1
        ----                    ----
   lock(&ocfs2_quota_ip_alloc_sem_key);
                                lock(&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
                                lock(&ocfs2_quota_ip_alloc_sem_key);
   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);

or:
       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&dquot->dq_lock);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);

Following are the code paths for above scenarios:

path_openat
 ocfs2_create
  ocfs2_mknod
  + ocfs2_reserve_new_inode
  |  ocfs2_reserve_suballoc_bits
  |   inode_lock(alloc_inode) //C0: hold INODE_ALLOC_SYSTEM_INODE
  |    //at end of this func, ocfs2_free_alloc_context(inode_ac) calls inode_unlock
  |
  + ocfs2_get_init_inode
     __dquot_initialize
      dqget
       ocfs2_acquire_dquot
       + ocfs2_lock_global_qf
       |  down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)//A2:grabbing
       + ocfs2_create_local_dquot
          down_write(&OCFS2_I(lqinode)->ip_alloc_sem)//A3:grabbing

evict
 ocfs2_evict_inode
  ocfs2_delete_inode
   ocfs2_wipe_inode
    + inode_lock(orphan_dir_inode) //B0:hold
    + ...
    + ocfs2_remove_inode
       inode_lock(inode_alloc_inode) //INODE_ALLOC_SYSTEM_INODE
        down_write(&inode->i_rwsem) //C1:grabbing

generic_file_direct_write
 ocfs2_direct_IO
  __blockdev_direct_IO
   dio_complete
    ocfs2_dio_end_io
     ocfs2_dio_end_io_write
     + down_write(&oi->ip_alloc_sem) //A0:hold
     + ocfs2_del_inode_from_orphan
        inode_lock(orphan_dir_inode) //B1:grabbing

Root cause for the circular locking:

DIO completion path:
 holds oi->ip_alloc_sem and is trying to acquire the orphan_dir_inode lock.

evict path:
 holds the orphan_dir_inode lock and is trying to acquire the
 inode_alloc_inode lock.

ocfs2_mknod path:
 Holds the inode_alloc_inode lock (to allocate a new quota file) and is
 blocked waiting for oi->ip_alloc_sem in ocfs2_acquire_dquot().

How to fix:

Replace down_write() with down_write_trylock() in ocfs2_acquire_dquot().
If acquiring oi->ip_alloc_sem fails, return -EBUSY to abort the file creation
routine and break the deadlock.

Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/quota_global.c | 5 ++++-
 fs/ocfs2/quota_local.c  | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index e85b1ccf81be..4321d8f59402 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -311,7 +311,10 @@ int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
 	spin_unlock(&dq_data_lock);
 	if (ex) {
 		inode_lock(oinfo->dqi_gqinode);
-		down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
+		if (!down_write_trylock(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)) {
+			inode_unlock(oinfo->dqi_gqinode);
+			return -EBUSY;
+		}
 	} else {
 		down_read(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
 	}
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index c4e0117d8977..e451f3d96037 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -1224,7 +1224,10 @@ int ocfs2_create_local_dquot(struct dquot *dquot)
 	int status;
 	u64 pcount;
 
-	down_write(&OCFS2_I(lqinode)->ip_alloc_sem);
+	if (!down_write_trylock(&OCFS2_I(lqinode)->ip_alloc_sem)) {
+		status = -EBUSY;
+		goto out;
+	}
 	chunk = ocfs2_find_free_entry(sb, type, &offset);
 	if (!chunk) {
 		chunk = ocfs2_extend_local_quota_file(sb, type, &offset);
-- 
2.43.0

