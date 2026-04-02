Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176EE3DD526
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775124428; cv=none; b=mYWyN3sbhl/bVzeM15V8q+OrPxL+zHMasaB+uaXVw1acDb/QzV8pzTL3FLTwxDvlP/9MDoiTThTxmk/veYLdi6PoFwheUM+iSL9/+pQt3rygvCncR5cJ09nvILL4ZBx/kC0pv9bgdyRBlemJJ2oGXXEctiCkz9ONNx3OjyAAqpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775124428; c=relaxed/simple;
	bh=VwaR+Lj59Kdxww5GaaJbL/6dF5av3sXeomek3oHegR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDqm65IyfqJ+oBkuyi4VNq3DykJxaj3PlKiKGon27sKflVRj403Wti3dRdDo5oZHqjVFCpoaOjUjrCpx2edZe8e/6EA0fotyI6LmXIAkm+kMoPdsyfsGu2DzMjcBjxsTc0XA4/4k7Ma/CbEzy9voMM9wLmx5wrZ7dKE/BFVzzN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=J2YjUXkk; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="J2YjUXkk"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48371104ffdso786605e9.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 03:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775124425; x=1775729225; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1HJCFB1TIJQKf7p/L9dqOK2SnRhDX+pwg0opmf17us=;
        b=J2YjUXkk1lhLexsMZo0ijPpuaNR1QiLM5ZyEmjT4k9IU9YbYbBjUxgNqafpdRTPrCk
         s9pjQ30HJrLVF9NM3hpNEFr/avSP2WJCKhLViPzCkGrISNDGAXLgkvNWWiaaoIkgskJY
         HziESuLdAaQMbpYniaPgwh/Dyq2BsqrHqAnUZmMZpVZT5fxqzB49+sRVjkUwU1uOKPCt
         9FZfAwY4WdOKy+cbjrkVNuu2bZ1Y/zcjZhLYsiJs6FMnO3DVBNsYolYySlJ9xRJYNVj3
         xXA93vxRwbj0O1VOPYuWQbcMJqye1VWetOjDpb5lWgQbRa/49486u557MGdrAlzT/7dn
         GEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775124425; x=1775729225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o1HJCFB1TIJQKf7p/L9dqOK2SnRhDX+pwg0opmf17us=;
        b=sIBba0QZ5YTbwC8TxhF2MkFsgzFLqn31VgiVK/AodZDJNDmfQ6dKIJN61PAZjhe3yR
         1sR11IHCTUu4OTXaSbkEaesu7VLEmn9i6BAaYLTUBvbna0vYNJNnhhyZJCca9/RzH7Qx
         SmC27j/6yyelk+n/nenWJJaunIIkBJegJyq0ZoDj//P6upNZ1ya0ltmWfzbVsn/yoexc
         kY9Tt+MCGmheahSXOG6yz/VojJrgbzVNACq2oYU5d1f4Qk9UrwiRnpH7sBCl9y/2mhJ9
         mRCJsU7wgqh4ReVKG9hoB4Bqua9E6HQswn/yVfHU/dTZTOh9GC48Qa82lAfWDgAM4XKn
         iOVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzM+t+cuyhvuxAN3YNZeYDg9J2DqGDAgg3u+AoTerz5bZulSBdzZuYy9QOLlsIua2UnnZ4hSr6qEfX7A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwnvY/p7c3SmWEAgt8H9TSu4t/oKhByKVO1LaStP9ukNqRUXnfY
	HWcHvMcRkjjl1SBeuVKLgUzslgB+NRfQ5dhr/zLlTbB1Myxi2D/lU7XFxJSSAR1FkIE=
X-Gm-Gg: ATEYQzxIGV+7gLLQdk29lYBrwRUJYOdqYHwWWETbMeYv5e5U/w5HCLoyPxEayE33RSn
	3P/z9+Z4EFgdYsr89iUuNGErGTxItTZuscZGaq+EzqKUPevSSPzW0UARp/KJKFJd8EytxNKc/AY
	KXRLvdZRGWDQm0cczMQrrW5578FlWyxVZ7n/TbBg6yEN4keZeemKjTdLKZLEewzx93P+/F+sri2
	4ib4Rq262u+AMukeseDFUOqGVMehSi9t+Vi/JBG+FDti54L56VZ5xgZ4s4DrRzZrbvDnup5HHvy
	lkszTFjgo5RcN2AhJR3rZdBk0CBTmCokOCiRSSO4YROB0wkcHo1Cp0sBppNl9Upi44MPNIe9SoT
	YJ1t2OdhDKiWadPJ/c4V445mJbP3SvURj2B4lddOv+vHQftXcUtC8ej06R6zz2R75MEDWjmvO8M
	Ai3o3zlhOYq1MMUWBWO27vBfYrFXbq/jNID+/4
X-Received: by 2002:a05:600c:4f94:b0:488:78f0:5ba with SMTP id 5b1f17b1804b1-4888359ceb2mr60768015e9.7.1775124425374;
        Thu, 02 Apr 2026 03:07:05 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c65a3f08sm2307300a12.31.2026.04.02.03.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 03:07:04 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com,
	jack@suse.cz
Subject: [PATCH v7 1/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu,  2 Apr 2026 18:06:55 +0800
Message-ID: <20260402100656.24874-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260402100656.24874-1-heming.zhao@suse.com>
References: <20260402100656.24874-1-heming.zhao@suse.com>
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
 fs/ocfs2/aops.c | 71 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 09146b43d1f0..9be43ea98930 100644
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
@@ -2351,19 +2342,43 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
 
+	if (!handle) {
+		handle = ocfs2_start_trans(osb, credits);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			mlog_errno(ret);
+			goto unlock;
+		}
+	}
 	if (end > i_size_read(inode)) {
 		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
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

