Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D39C283C82
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 13:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775137421; cv=none; b=Oth5LjBfF9rq+3pJi1SsJJKTI8/D+gAM/p+MMFEOv0po8k00SDp1ZqOFFXa99ISvKigq+WTT8fHG2iJVa+f8lfWffYj2brmzrE98T2AXxo+BDvbdR9w2Ho5NawwO7dPUqBZJtJn1UDLNKPj/MJChw8pSvOCpqtwaxnDcdyf6EvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775137421; c=relaxed/simple;
	bh=yVZKDa6VD49DdaL+VDlExAusZJ/dxStoEWV7ymKWon8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaQI5c+pfRT01HOazl4o9icBKBFP9/YpHWgB/U2hx313L19Pf3+lq0/BdSlCLvC3xUb+aEONFB3Dy6qeO/hjR7zve9YlD0qLyV9AWlXk+cmKuFkeQCoS/2LYSMQi7xGG249+E5IKQCAtvb4TSLaVg4KZeS+E8f3tVECtx0WjeIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UtRD17pw; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UtRD17pw"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4888e0af85bso821655e9.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 06:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775137418; x=1775742218; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=203AgTqpEjje4gfAw3GCnUOhtN5N4IBxGU60/MF8728=;
        b=UtRD17pwC8nZSGNFt2ohAbnyT4aqYkBRtc+XTZe/CMdrNMwRbkMAkGPF6o829WY0u3
         HJVssGlLr9s0qbIcFrj18muPzqzDivlQ0bj/C/AhJWxuHP2Y5DiETeJ+glWKUN1XQsXI
         yjUBoBeDEfNeKgyHflOun7wbzwqY7RLo5OuwqozHqn0w4Qfx5HctVX86t4pm0TZ7/RF0
         qFHUtU086X39Aioi1As6Uu0OisHo2az0PSfQQHkrKm0TRY4jXxmUGD/1OukrgJw41iuz
         od+8+N/Uml0YgY1bH566lniyXDKPbI/pzuw8jSH09l0UDjFEAe8K5i/7WoOmT7irMSnh
         akpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775137418; x=1775742218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=203AgTqpEjje4gfAw3GCnUOhtN5N4IBxGU60/MF8728=;
        b=WOMrO24VvWXib2JA8TjxujkRbQV9lotXpedXLrV+ECjcKTprIXoMuCX2SgqMHvioQ+
         sDgKFJuun8+wZLLM21dUZOEzOyPN1MhGf8K+5WvwRFNoNrylejHTH2UoznG+lmMn3vjY
         b0e7vzQ0bEwLtgbVbGZziMwGTUlEf6I/e7rJTKGsYat6r3QbRxbom7SzBMiGs/BWFM+C
         n4LHPF/H+HIXZ2zB7AAegdYtMeizBnBFymSIDebnHoH781dL+0RdqjholjUgAkIBOV2X
         otUZGxbi8OWni1Lkzw1ZRfKWQRR1W/LVFishLrLyZ7oNX+w7j0JVnVbSlSYCrvSrutad
         OUEg==
X-Forwarded-Encrypted: i=1; AJvYcCUAE+W3EJIRqUDKQlCmcMXttXBZ0gz8+2wrtq5d4FxMZdfs0iAfzOwCUylT4T0HD3UBQLe3qBMCpdvRVw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwKX6A7eET3Fs3fs3Mjn/vEsopHxQbKhS0z/KTEXkaWTEUbwZ8e
	zxqbNoGut9HXoXwrnnipgXDeHhZ/Al0eKgWKb3B93NAm7IDA3D3ZG6G/1stcz1rhtvk=
X-Gm-Gg: ATEYQzz82KQ/f9ZnztMHOUmyjupuCTn4YsMnvx9gIC8Aesbp9qq2ITrad5HqLJjkaWH
	YKAFGx9Vv/ZzRbkVF+JmBeX0JaTjHaGhggsm4caZJveCL0noI7fnpi9+nLTST7/Q0Meu5Sza9CA
	isLsLv6Jmy25JU2KTNWxGd7qmdOGnoXnbmLbgQp+NQP+FvqVN76DxkQcgWMjwcMi85ekXKAnoCH
	2emhq7SW29hWzDM+vp9X2CchSVvLsrL5y9YVSNFTLUtLnzYMWX+LkDwSjZonEDM+OAhPTGKLBty
	yhIvGOp6uUjS79zqnIJE9SjNPoMWdCjtLlMfoKDbefw7c/GsysLf15E5dRzq6b94nLbo3i+j/tX
	ew4b62lkkZYcnAgbUr23uMqgjgDTYDMfMGreLLTs827g8m0fFOebiXLSzX/pE3nBtYPMTcuX/S5
	CZwf0AyGfG87fq/ffdyLZkjPRqG0DNTz3iUu2PlpHH/4DSVjU=
X-Received: by 2002:a05:600c:524f:b0:486:f634:f2e with SMTP id 5b1f17b1804b1-48883593358mr76958785e9.4.1775137418478;
        Thu, 02 Apr 2026 06:43:38 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27497c0f3sm31468005ad.41.2026.04.02.06.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 06:43:37 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	glass.su@suse.com
Subject: [PATCH v8 1/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu,  2 Apr 2026 21:43:27 +0800
Message-ID: <20260402134328.27334-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260402134328.27334-1-heming.zhao@suse.com>
References: <20260402134328.27334-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During ocfs2 dio operations, JBD2 may report warnings via following
call trace:
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
 fs/ocfs2/aops.c | 74 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 09146b43d1f0..c6dbec1693b1 100644
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
@@ -2351,19 +2342,44 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
+
 commit:
-	ocfs2_commit_trans(osb, handle);
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
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

