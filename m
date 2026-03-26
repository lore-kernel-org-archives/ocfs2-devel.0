Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355C03FB7D6
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774535214; cv=none; b=JIH7DdZ9ZY+iCNt9XAevf0NNVnMGpNgK209+PJrdTc16qozCM2GpCMvrgombj0Hgc8xlxI6CWya/6GsJIhnv1OYEQj5DxqnidqpJXjMulwJwaXgzUN3s1ULRyZjQC1w26tsuotEtjOohFNqKwhH1YDHc71wiLOY1eNTSyBOerzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774535214; c=relaxed/simple;
	bh=BDyu5KwiPa7M2np+5xdPTZBdkU/tI1xyfr6mh7/aAHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Doq3SjdN7okvC0E9izEUJQl4x0BE0DrLxRIB9khARO99E1LqdzSAY7aDcI0qbZ3QxHBQtyqnY8J3ONqOykgT5qC7CIk0dx3hpjahoOC1CEVdIwRNIyhLEt2/DDQomb/V/ephTrVG/6T3Q3IN/tUOo4UOenM2pLXReNG9qNB0yvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QVaT8xu0; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QVaT8xu0"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4830b67aa6bso782015e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 07:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774535211; x=1775140011; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FcschafzOX4ZtZ5FxQW1RYx7FdkCvz1J7dcg1OXPLpI=;
        b=QVaT8xu0MLZqHejYiy0qWD1SKtKG0BX/+C8cB2fv4Yip4AiG2QOn83NUAqB8oLF1vT
         nI3g+/RsTmDPYhvAhtJQtMxzjE3mQ+iC0oPtgn/SEKLmaYD7Hiv38lBr8WOEqiAjTzmL
         5iFbynrUwUQvbQJj8/Oil9jxlxgamHdMd99AV4+mTDoA4YbnfDuIv+wCy3o/j8/FvUcN
         Uk4AgV9jK7qxb3Y8ytV8CgXfgF7xKZDyjRc94TMbPhQsmxxsR4qHA1uWIAqhrJO6Ex1k
         2iUe2WcstvJwsZSCyDrAaYunqoTozWfIbxtaawGCFxkrZHrNObcJeheH9vkwKoxOHWvV
         7kSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774535211; x=1775140011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FcschafzOX4ZtZ5FxQW1RYx7FdkCvz1J7dcg1OXPLpI=;
        b=BjeuAoAXLKaZtwrhZwxArzenhTHe+wrtAbmPSDMEfad6I1GgVd7uJym7s/4UlTkAPm
         dBga5EvFoimFnJg9Yq7z+nmFpoXo+fag6QdLutoWHrKsHLifS279lR9nhaF8v75nj9Yu
         BldsW06PcmgJk4Ad9wxOYSOuOcoEQnzNSTfMluqDvsBQHjY8P170EwkjUTF3iWurQaos
         jqrlYApOSbSN93feX7k3rY+fIJ6w1HzVIpNIRvSbFI69yhUTDOvuxAcRnDF5fRAtViue
         /f2KgHc/ssFrAFGvU6SuqetTq/fn14N0rPde8TWWU4H4sg4FVhaWl5BMLOZ00d1LXJtO
         6yfg==
X-Forwarded-Encrypted: i=1; AJvYcCUbvLr1pG9WiG1tFFz6KWsjo1iEKOGucw1HiBrfcQ6kmF5+k/rGimjMzZriw4Ds6iH4ULJeI81FBU4ZjQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxck2F7YWBvqQUs4Jg/7axedsq4n3q8rScDBs2nndztg53IPSSZ
	ZPZxD5JKJQltydjDIwNrvR+DYsuUf5dn5fOyPpNa2isuIWpoOilHSJJ85kiEiwQ6lcA=
X-Gm-Gg: ATEYQzx/GSFbRIdAlJvMK6okBlibU7y2V/7A81VoriM8M8fXK/kyngXLGv9AHEFJjJF
	ypLvjw5ETu6C4WucvDRk02j9mBLp4+8uCGmx0HIaq/Em8x7QMxH7jcMmYFdxAD3y8amQ5XCsZxc
	dxEQVF3Q75tQdH7p3FOHu8EUCUgFRE4Iif1gDGEJrP2kma0X+Ojxrmz/8JdlG/sRamwlvqqZC/l
	Im7VRXLT2I7Snq2wT+/XkyTRCtioEAtkEhYQQFleGQ97EIRLNyCVUv0djRIDHAkI8vUL8TSFlGY
	55VwzsJyr3OJxQB0dD9gcd3G7Iz1OaKGtg1hZimaPDZDpRjhqPpx9RMUCuyl5+wSRl2fCWDnYo6
	+hCWbs5p+JbxNjPxkJPpNUqFlxH2rwF6eti2RxH9EcUpN+mwgfiCT5SSuwiFDUvQdDSik/mglsm
	8Gj3U1rNz2jtq4Txzbh5uNB6wrw2pn1HYhy/9v
X-Received: by 2002:a05:600c:3b11:b0:487:2439:b7c3 with SMTP id 5b1f17b1804b1-4872439b842mr12829485e9.4.1774535210579;
        Thu, 26 Mar 2026 07:26:50 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d23841fsm3538669b3a.26.2026.03.26.07.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 07:26:49 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v4 1/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu, 26 Mar 2026 22:26:39 +0800
Message-ID: <20260326142640.20077-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260326142640.20077-1-heming.zhao@suse.com>
References: <20260326142640.20077-1-heming.zhao@suse.com>
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
Reviewed-by: Jan Kara <jack@suse.cz>
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

