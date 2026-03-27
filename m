Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEB03B8BD1
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Mar 2026 06:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774593420; cv=none; b=qHRs9fhnsf1P/RmCA+XgyQ+MmTQNU45tONghzzjnMFtMPmmXvyAOBmNOisGja0t67WV0SElpAeHUDzJpVlPBNgrsaK3UYC6zPuNrWtfTwi3p2+dCp0dI/3sFndpxPu981U+awQ+B1tjW8wKpbD0U1Bd5jPFYN6SbTkqdjrkWNpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774593420; c=relaxed/simple;
	bh=6Qjgytl6wg2QArtvD4J05K4KuLLYc3eNsd+FdaB2Rak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDwth8uNHgCtJg3pnA5YBwLAZHrIJcVrMrPeOEQo12dO8hNBHsBcn1bD8FOnBg5SlwXSv1qndudB9mp0mZXsAsb3vHPOhdRFwbn6H9sf6tj4WQ+oYOHG4ZNZ3ncqf7r2yvo4dRnVkhCo3DEq7Xm0JxHmsH9Z1LwCvCrOyQUA6UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SxwnV+vB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SxwnV+vB"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-483ad568d68so2540655e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 23:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774593402; x=1775198202; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nU8qFExDEanhu1yB6N1aCOH6lO0L98OpkQXZxpR303E=;
        b=SxwnV+vBhUzmBdU6HLC5P4lGgsgznoOkMIZ7c2UV3GbXYtn50krKbD3vB6XnU15cF3
         vNUVPhjKpnefVsI0E/z02l8Qfr/RbGPpaB5AT1CVA47vAskmNGVwy8K186q77HYHEPfD
         yxyNPgJyMbqK9/cz6hbfcGmOPUiPFFLuFQLlQR/OXrQNysc8s6ItBw3THY2VagNAMVIX
         TW1qkZphCRjw0iHUnd3cP9gzR/m0M1HsMneyLFj/FgbI4Dv+ZtoxfweiC8iKjs1RlWjH
         yBCctnFUlr41qrul7MtJhycK0WYKJm1Rv/7w+hAC4zuT9jcVBMXJwzDTB8wpnOHCpiTF
         rB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774593402; x=1775198202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nU8qFExDEanhu1yB6N1aCOH6lO0L98OpkQXZxpR303E=;
        b=IbzBOIA94oUpokWX9X5snXFIGfqVnQMzR4p3ypIHPCJYvGj0tELVmd5YcUIQXlWdLz
         DF5UlHMAxz9JyO0I0cTOJeltN7IlBxTpFPUWMf5w8coMPNtt/uRtBK3ZOeJdStvF4+yV
         eOzkT0FNkZqgNnOCLKK29TlSsnttE3WLg/n2AVE7BYlgULGtiQ6meHFvC0R1WNwEJ5fH
         fthbZ1s3sXtcC5FVUcGVBA9iwvlYprC/kvMfDfGk9YXMWK4v9DxzLLSOvHmJpoHSXRyn
         Ncsj2c7uU1VWgIMJS4rFJRxGu7/InRFFy1TrWtoHeNx6Ft37BEDpelTh1idmvh62oRT5
         mDEA==
X-Forwarded-Encrypted: i=1; AJvYcCUZFGou/TdvhOaQ4vH3e4uNhLgeUqKn2QBNdRB0+OJy5vszekLEQgkvmeS/h8GhpVfiYqbhtNXzvpihfg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyyHFRTgi/17QDB7n9kQCbJfnEdEhwC4VTbJZOQQzohbXvto8/E
	06umZInZwOFSIof27NRiT3SOyxLWCs7Ug2UHBZ3H7rXzgA/662/QtR/n6tkpy4WN90o=
X-Gm-Gg: ATEYQzwll3X2x0MaZiOGVq3ZxdwqaDkaLyP2J40EXGLBHcVW4JLgOaWj8YjHaHcxKQe
	Sfq7J5v6Ru+4lC74qB4hBSu1xERJ3U3XgofC+95np/KtM6C8lWODOTepLW3d0Zy7/WxsEQTfE0n
	Ep+HCsKOBvn2c4XarW4gKJlDSUiCXlrVadsuWgTXdw903a1GN5A+PCu8FX6wORyhjXo9s3K+MNA
	v6uRdFQ/K0FCsbNHw6WXUSq0ulBATsX7pV8e5ZhwVsnWDAjNkTjcU1VwQw7Jsq95lD/sUCmzSmI
	VdxptMFzNELkQdD9TOnSpMb7LD91aZKSJOXjfMuIyhxblK5cHxfriSQZHJ4kCGInf7QB6vF0TjC
	fp3UU66103ZLWSPdDsfOkyl0izCfUVDSuVIvy5lFous5EfPNIO3pWlm2/YJG5NlxvizO2H2SDAq
	RnzFGyFAYZNuYSMF2gO5gXOoxwjMd/L68XWq9o
X-Received: by 2002:a05:600c:19d2:b0:485:3177:d80c with SMTP id 5b1f17b1804b1-48727d6fbc6mr11526595e9.2.1774593401599;
        Thu, 26 Mar 2026 23:36:41 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76739311d1sm3849190a12.15.2026.03.26.23.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 23:36:40 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v5 1/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Fri, 27 Mar 2026 14:36:25 +0800
Message-ID: <20260327063626.10225-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327063626.10225-1-heming.zhao@suse.com>
References: <20260327063626.10225-1-heming.zhao@suse.com>
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

To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
handle extents in a batch of transaction.

Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
only be removed from the orphan list after the extent tree update is complete.
This ensures that if a crash occurs in the middle of extent tree updates, we
won't leave stale blocks beyond EOF.

This patch also changes the logic for updating the inode size and removing
orphan, making it similar to ext4_dio_write_end_io(). Both operations are
performed only when everything looks good.

Finally, thanks to Jans and Joseph for providing the bug fix prototype and
suggestions.

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/aops.c | 63 +++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 09146b43d1f0..a542cd0a6f75 100644
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
 
@@ -2326,24 +2316,25 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 
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
+				goto unlock;
+			}
+			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				goto commit;
+			}
+		}
 		ret = ocfs2_assure_trans_credits(handle, credits);
 		if (ret < 0) {
 			mlog_errno(ret);
-			break;
+			goto commit;
 		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
@@ -2351,7 +2342,13 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 						meta_ac, &dealloc);
 		if (ret < 0) {
 			mlog_errno(ret);
-			break;
+			goto commit;
+		}
+
+		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
+			ocfs2_commit_trans(osb, handle);
+			handle = NULL;
+			batch = 0;
 		}
 	}
 
@@ -2360,10 +2357,20 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 		if (ret < 0)
 			mlog_errno(ret);
 	}
+
 commit:
 	ocfs2_commit_trans(osb, handle);
 unlock:
 	up_write(&oi->ip_alloc_sem);
+
+	/* everything looks good, let's start the cleanup */
+	if (!ret && dwc->dw_orphaned) {
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

