Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B0737A4AB
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 06:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774508345; cv=none; b=ie5vOaUC7uowVs/OFaFGk+tJEiaqaqEtCy5LzOMOXx+xMSGq3HPKavzdk8zNoIqQSFNj3CU80fmnSUqYfeK9KO/vOb6+9AxyzVa9Fa5sZ8IyMCnHoQz4XXoeHZQgqVYS0EEswLPdfvM64mL+w4lvEBw1wChiNYUK9btpdcYEiwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774508345; c=relaxed/simple;
	bh=x5PShJ88TgzH8FdyVsnskLhfiOBz3n4uaFYvwPHfwa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVz27K93ypncXRppHI4r9gUsjSiYn5I+I7SI2JOPBbHIog4mr7ru5/jIvtuzjtcHLqvhsI47Ec29AI8SiJPd3eVMWygHAEYzZn+l2dG06f5gcIay9xxLklvCbb57cRKp6d1vcbBGAdJLxcPpagaJi+rt/5GuH47meat2/vRkopc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XNeZfyZb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XNeZfyZb"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-486fc3ac9fdso675645e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 25 Mar 2026 23:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774508342; x=1775113142; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pHlF9RSYomV32eEhsUv5cmZinlB34ZOM7lnu2Ze3CQ=;
        b=XNeZfyZbgPxMv5h8Vr7lqhX2u0HpBGAg9OeUn8HZ6GB3lXb7d+lth3YMbFWfwVugZQ
         N/xOpL+8AP080i+sH2gJbG9kk9Oz/7FNTfVqvUkfbdNv5PzM3ZZ1zF2DrOMjha6SJOw1
         zxhIZzXfWeyazlIUp3Hf+T9X/2oOia8eTbvZ6O/pCnE1NvreYvt9u1izHI5KBqxdIOKY
         bGR3VWGawbnbw/vdBiMdGf6eb/cDEJO5XtXYsZSF2nLOwXzWBLoLSKf/CkYaVx2W/6Fo
         7QdaOeawTK0GqZvs3rMP5/qkTswwYSGxdOvyNvlb0Z2XHtj3c9S6Xiu9aUV+RsRqDXUr
         xvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774508342; x=1775113142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0pHlF9RSYomV32eEhsUv5cmZinlB34ZOM7lnu2Ze3CQ=;
        b=ci4rCLHgCznwe/aWWFzQ/Vu6dA5afEhfew66/J3LNS84yGqOWldODUfll1MNAcMMmn
         bJUCv9yW3DF0T7Cg3Y5bUnXodBwRvfgUIE/KdFwEnqU/kQHkUbqU3WPiOOdJtvt+V0dG
         iw22D3q89OFrTHp8pewijL242BSGX2Icvx+w7pUosDbqY1ml2nsQ4Q/6q2OwTTvssRRU
         02MqlvUi4uIqdtL5zZXLggcpDOCAa5wJ+Qwovy4piO4BAAHe+dJ+iIs8gBgZIlBONykg
         B64WiGfITUh2tZB9YtRtIODKEeX02ucp6RsvRTLtA23yCUpkq8L2vjg6WhnPsuQTFziw
         j+3A==
X-Forwarded-Encrypted: i=1; AJvYcCVOkbq+TWTl35TQ9xICLfDvB9C4aslzhIYS1XmzXXYi8wwx0zY/YU87sE9Al/K5cklOlYQtD3HVTC3W7A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzUct01dJFAM+Ua1nQzOWFKWxtrlboB3GvDdLt7pgReRSUWZcM8
	lBMSj34+4F35fFSRXqA6pfTPImzZb/PAi7F/HKzInX+q0Z9XHmorf5ZV4EcILO56m0A=
X-Gm-Gg: ATEYQzwrYUZCHMRKe0j1NV0ECc/IRsNmx037/4qjGGfA9v2yex06dGommve2vnb92HN
	fhSk5mxYXY+nEZ3aqMNxJ/5boq8QaoFd2ITeGNN5s0WpcrsFqhYNbJEdw2C+5uIKiVoSa/qcZd7
	adyRENCOwlQ3T7uuqywrxAkzWt1SMeFWqb8Z6/qZd0DQYt0BnPFSRCanQ6Nx0C7T1ab6B033auE
	fzjNcs91qUYCkToUIMFfbVmIod6C9b+Qa4c0TqARbrGDCL6NA0EJLgKGCSoQThnE0nJijHrqdUW
	ku2Ns8Nek7/U2k+ScxEKSeD8gtVP5iQuaXZBjDplucv5uVdYhMHOWsqZYrII+DH2vKtuYl+VaJF
	+BpPTs8WaHKAkgzUOkCFgON2TzdLQax1NpXr9etOelCYiJAlekBaHxYwsyYK/FVRLaNCzZ3DliI
	UuboEVhXlsH3gkL2HsejrKNUpZNx5FNCAYVtsv
X-Received: by 2002:a05:600c:3ba4:b0:485:2af3:3f8b with SMTP id 5b1f17b1804b1-48715fae53dmr58328965e9.1.1774508342496;
        Wed, 25 Mar 2026 23:59:02 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc8c4bd3sm20279875ad.63.2026.03.25.23.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 23:59:01 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	glass.su@suse.com
Subject: [PATCH v3 1/2] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu, 26 Mar 2026 14:58:17 +0800
Message-ID: <20260326065821.15156-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260326065821.15156-1-heming.zhao@suse.com>
References: <20260326065821.15156-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During ocfs2 dio operations, JBD2 may report warnings via following call trace:
ocfs2_dio_end_io_write
 ocfs2_mark_extent_written
  ocfs2_change_extent_flag
   ocfs2_split_extent
    ocfs2_try_to_merge_extent
     ocfs2_extend_rotate_transaction
      ocfs2_extend_trans
       jbd2__journal_restart
        start_this_handle
         output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449

To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write()
to handle extent in a batch of transaction.

Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
only be removed from the orphan list after the extent tree update is complete.
this ensures that if a crash occurs in the middle of extent tree updates, we
won't leave stale blocks beyond EOF.

Finally, thanks to Jans and Joseph for providing the bug fix prototype and
suggestions.

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/aops.c | 72 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 28 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 09146b43d1f0..60f1b607022f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -37,6 +37,8 @@
 #include "namei.h"
 #include "sysfile.h"
 
+#define OCFS2_DIO_MARK_EXTENT_BATCH 200
+
 static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -2277,7 +2279,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
-	int ret = 0, credits = 0;
+	int ret = 0, credits = 0, batch = 0;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -2294,18 +2296,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 		goto out;
 	}
 
-	/* Delete orphan before acquire i_rwsem. */
-	if (dwc->dw_orphaned) {
-		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
-
-		end = end > i_size_read(inode) ? end : 0;
-
-		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
-				!!end, end);
-		if (ret < 0)
-			mlog_errno(ret);
-	}
-
 	down_write(&oi->ip_alloc_sem);
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -2326,20 +2316,22 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 
 	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
 
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto unlock;
-	}
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto commit;
-	}
-
 	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
+		if (!handle) {
+			handle = ocfs2_start_trans(osb, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				mlog_errno(ret);
+				handle = NULL;
+				break;
+			}
+			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				break;
+			}
+		}
 		ret = ocfs2_assure_trans_credits(handle, credits);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2353,17 +2345,41 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 			mlog_errno(ret);
 			break;
 		}
+
+		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
+			ocfs2_commit_trans(osb, handle);
+			handle = NULL;
+			batch = 0;
+		}
 	}
 
 	if (end > i_size_read(inode)) {
+		if (!handle) {
+			handle = ocfs2_start_trans(osb, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				mlog_errno(ret);
+				goto unlock;
+			}
+		}
 		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
 		if (ret < 0)
 			mlog_errno(ret);
 	}
-commit:
-	ocfs2_commit_trans(osb, handle);
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
+
 unlock:
 	up_write(&oi->ip_alloc_sem);
+
+	/* everything looks good, let's start the cleanup */
+	if (dwc->dw_orphaned) {
+		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
+
+		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-- 
2.43.0

