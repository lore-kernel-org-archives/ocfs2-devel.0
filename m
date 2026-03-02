Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF9F3783A7
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Mar 2026 06:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772432243; cv=none; b=OEp6DyiD+4pxtumYFsq3n8GOmf3Cb3Zanq7RwVcZ5lLOUs1g0HSYUYbtsJyHvpXT7qot5MsveGrrrRObsMo5UJ1FAHUulGptRoUlZ/IIQVbOTv0aZXKEVGLwT3yxTKdJetyVwCxqvC2chdj4cCu8LbkQvqDkaRLOmM2fk5Bp9CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772432243; c=relaxed/simple;
	bh=HdmXiNkf7a4UfaHaGYAxOFrV3lCIup7pqCvr4LTzPHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CkLYiJVftZReovAfadeKqMv7xCi1cQmQA78q+Q4sN5vDXK5J8JqRVFfCUN6yc1eLE4MADpjiRLkslHeDGEMEjQe9reZNVpe9kGZyxHi+W5q5MGo+wVZHYXRFog8LErKkLY/Sq3pbs4uFZKW59RddMPGcCb68Az33a+1q6tYYe2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=blgPipL7; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="blgPipL7"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4832c8f9d87so4616375e9.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 01 Mar 2026 22:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772432236; x=1773037036; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CI0Xa6XU/VZSjgHw+n0dc8NiAgI35yHSFxoFfjU9+1E=;
        b=blgPipL7XBc8he4PLWMov4SUTxSMFbMpolneuEjL1JWzc3bEmPzMXAySaRcN0A1b6K
         5L0p6dW9RcZEL/c9bdsJcuZW6qcYivvuF2ZGpm0SBSOkio/AszNjGy2Dxr+zgUYBOwLC
         HWd66uwqz6ZWAgQWzo5Wuy3bem7GM7iGQGEL1SSsbUd63/h+P7qOJt3lSQ0Od5B2XgkS
         V3Tjd2RhTeb2IMB5o7g8CtUjbZEOdFJ8NfGOAqFxs2iOOVDOz1hawtwmAJX1k5eAKlGc
         Dr6NtUbP56l7EsQz7Hriwy6R+fYpDHOoZ+k9xDLnKjOUNCS6uKkz0Eth4pLOdf425T/v
         PmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772432236; x=1773037036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CI0Xa6XU/VZSjgHw+n0dc8NiAgI35yHSFxoFfjU9+1E=;
        b=J/MdysQXkKrqnyzYeSMb34rGtkf6T7wIXwZxb1EaKlo6R8fWeiB0ePSYCCU0m4wAcQ
         ekQ10qJ7HDhq07/WlRkA7r5AcVj/lLtJ+x5Ru9TizAu3YQdeNTDUEuAi6ZhLRTAkZVdY
         0xbniOxxiX6WJbkWmkSPGzsr38MpzOnGuyFQPUfpdeZCfjLhTgjrItBk7wzIUfU0nW4+
         UoOCRtDgFABOlAEd5Iu7Nqk9m/fmiZI0B6EQjQJu6z8bqQGUmLpsxeC9jSfOjgyNHjkF
         3/5tgCYnwftgUBKHUZRNXhRDoFQ4/N6aVCBOwvOBhEue++TrpRFcra1kJ0mj7R1QfyB5
         q4JQ==
X-Forwarded-Encrypted: i=1; AJvYcCV304WtcaFRv3XbxsWE0c4B9ITYaqWAj6R6KEPzIYvVs6gcBsaV1KdOBS8M7xR723b1DEeBk0O0TsbfBQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yygkh6wMWBKL8WdM0T/Jlb6i21IgNwY07BVkylTK6/KLvde2rxg
	JbLzJaN9IW/gNVEK2pWwv4B/cVMRhOMR3mtSFG6XWrtEkhBwKQUt+2VQc2Ty+UhNqAI=
X-Gm-Gg: ATEYQzxqm1TxNB7JNSkTRHWF9yI/GDcxkpfbhb1zD4CpkGaRc5scCFv6qqWx3WyMwIr
	fmJzij+Uc6CtVc6dcoIw8c86AmL2S3HW6kCTwwj9CWkXuIl/9N56yqEQ2SDwjaY1u0qYbeC4EI4
	u0jRyh1axs7tfcpAQWfnRlSTxbAAEg4PskBJO2uV0ZWwkMi2BtAzP1yU84mwBBo3xlbF87P42V2
	9deqof9grZGfUqChdwHD1+SxcjkAi4QqHaEslLzUUC9j/xmrNX8Z+ZRpoafi293/a4fpZOE4ESO
	tQbOpPiP8glm/VMi9hEIlD135LDMDhyO9zJppBntkprNUMM5wubqBwokAyBregSTQ9PocKMjIcl
	+xpeyj55wVICgtV/zgxdL41xpU2eVc/P57hXg0cafs1wMJJqoXhO2WTlRDxZO2qmkN++t5BZtgw
	2gthFEg3xYMI8siwknk+La+eCc0wrhn6Wy6iyzVbyC6DYIEPU=
X-Received: by 2002:a05:600c:474e:b0:483:7d93:9fb7 with SMTP id 5b1f17b1804b1-483c9b99876mr116148015e9.2.1772432235569;
        Sun, 01 Mar 2026 22:17:15 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3598b27b7a6sm2790995a91.11.2026.03.01.22.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 22:17:15 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	activprithvi@gmail.com,
	syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: fix deadlock when creating quota file
Date: Mon,  2 Mar 2026 14:17:05 +0800
Message-ID: <20260302061707.7092-1-heming.zhao@suse.com>
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
  |    //ocfs2_free_alloc_context(inode_ac) is called at the end of
  |    //caller ocfs2_mknod to handle the release
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
v1 -> v2:
- revise commit: the explanation in ocfs2_mknod() path
- fix error handling mistake in ocfs2_lock_global_qf and 
  ocfs2_create_local_dquot
---
 fs/ocfs2/quota_global.c | 16 +++++++++++++++-
 fs/ocfs2/quota_local.c  |  4 +++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index e85b1ccf81be..77b8f0363e94 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -311,11 +311,25 @@ int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
 	spin_unlock(&dq_data_lock);
 	if (ex) {
 		inode_lock(oinfo->dqi_gqinode);
-		down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
+		if (!down_write_trylock(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)) {
+			inode_unlock(oinfo->dqi_gqinode);
+			status = -EBUSY;
+			goto bail;
+		}
 	} else {
 		down_read(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
 	}
 	return 0;
+
+bail:
+	/* does a similar job as ocfs2_unlock_global_qf */
+	ocfs2_inode_unlock(oinfo->dqi_gqinode, ex);
+	brelse(oinfo->dqi_gqi_bh);
+	spin_lock(&dq_data_lock);
+	if (!--oinfo->dqi_gqi_count)
+		oinfo->dqi_gqi_bh = NULL;
+	spin_unlock(&dq_data_lock);
+	return status;
 }
 
 void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index c4e0117d8977..e749cd064c87 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -1224,7 +1224,9 @@ int ocfs2_create_local_dquot(struct dquot *dquot)
 	int status;
 	u64 pcount;
 
-	down_write(&OCFS2_I(lqinode)->ip_alloc_sem);
+	if (!down_write_trylock(&OCFS2_I(lqinode)->ip_alloc_sem))
+		return -EBUSY;
+
 	chunk = ocfs2_find_free_entry(sb, type, &offset);
 	if (!chunk) {
 		chunk = ocfs2_extend_local_quota_file(sb, type, &offset);
-- 
2.43.0

