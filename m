Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463AE33A007
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 02:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775096828; cv=none; b=f0YMbEYIEKpVoiNB5TZZvc/piVXFc9e2ZJwKmyXg3GGD4NUFnwhuqbaIwxW68zhzD5pNy1cAlPeHB049iquDGz1BV4efNwLgysoJbEyeV1ia8r5IaPo5wuSuoAaeloFRZYA25u5Bekj8XnsqfMmBl534Gi9C0QSBQiDEZwLeqUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775096828; c=relaxed/simple;
	bh=GiIclVWQHexOzu5lM/R6he1wcQTSIX4oFMTch1lZKH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=um5+P629054ht04VnavZUY32xWP5FURqxCyQp65QxrY19AazXy/E58vj243z4Xodj0YWPHdUTuGVSqbMErYhpZgqfTODClhDFg6B8sRiDyXRR3pOY4KRBwoZxMAvzyj2en4gaSY5eEpNDPKutxG82DPWs62C2U1mdP6gNo7T7DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EvkROuqM; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EvkROuqM"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so442075e9.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Apr 2026 19:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775096825; x=1775701625; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5taoFtsIX/OcxB0oYunjH+s7OHrNZ2jsC79Mj+cKZ1A=;
        b=EvkROuqMyX5Y63WGzGOQdP7CuOHFZJB0nmOKxTiHBpPO1/SMZQ1Pkh8t8dczg8hhRY
         qtJ0DksRQum/AQSZvGkaAnsn1J+RHX2mJ9+WYvs1sk6dV72JMNev/AG7Gdce/s+aB3c1
         lpEEYvmxrF/t5j89wZ//PwBDnV2OQ9/xQb40e5GAM5RUCA0+T5lUbIIz4mxWAiQkJaaL
         9n1yH7/v7BVRI1jWW5f0+rwf/6ktexc07dgnjq1751MVHV9VOYang80BsWDFH8VogDl9
         5LuD8P6yK+X5xtOukhhZ5uVsz7xZ1V0alBDls0F0W+6jvkufhL/MsEqzK3mmBQf04EJZ
         r/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775096825; x=1775701625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5taoFtsIX/OcxB0oYunjH+s7OHrNZ2jsC79Mj+cKZ1A=;
        b=YoKzYX0bsRtk6GfMN3IiSmeKtVdWkvF/roG7QsADe+wyvp2cx2QyKO/su3e7E3h4GI
         wFCDnkHJY13GC6aj2OChvIm2zCcKYLnrqw6ickWXAAFhDxffsBmBDS+MeDLggT0Fzd8K
         tG93yBmO0N/cAaQa5zzUCazwVdrMAtVSA8Q+cbkW/oeXhp9yizNmfdQ+enx80BKwOROd
         qtU2+is8/y0BtfVrAmUyrSXsLh7AN6DUavvRP+aDKVODRGV97WPtB/jJyX+MhII88msV
         1SGqlnJW5Z843doE4ceS+qut60kf4xZnLaTKqCQu7r2JWgAiO69EAJyEL1iQOJYYo5Fq
         AvjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiCCxLFZjjsxbVVTGFTlv3tLZBKujDQWhxaQ3R6MOypgk34gOzLkabmXDoA4rJnVB7R8fbedDUnkDvtw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwzsdtFD20WeiJzAHTYjt3Jp+BOOqxazVP0LdHa6u0Tx3URRc0T
	2tBvtQUw5Ym+nMANGslFT0dAJC1CtvXCtM8VAMsBXfwHFRHemXIlY/5ZwSJnwnpTvfR7FQC6h1i
	R+sFu2/AYgQ==
X-Gm-Gg: ATEYQzwG8oTCXdC52vTpJ4Pxm8M+UqCuEbRAhdOJEqriwM1YQLoWiqWig6u4ql+zThd
	Kwk/5aBZH1IMg5zsRB9ZC7xK7OJmYhl6A0bp5XwVUbLjW9usXc9DxcoBE9hNte/DR2lh1UR4nrP
	OK9vl5jMu+ehdm1OK71DDepATJBrDoxzUEGv7FlQmtDhEeiiY4rEdeRQRB10upjXHzyrO4d8hzP
	yG8fswtpaIEWC4YBu7ccFPmfX/l0cFys8RmC61LFgvmTTA/8HaoP2yyUaq5LXLEJxhfMMQoTfdi
	sjabsnrkkecvts+n2eIRbU2hsOE6AcYF7MVr6yq/hmqAXMnggQ++v6yOOBgiH7ceJcMGiNyGAjk
	7ZBCQYt5vN1ikFmIpdJZoiGUxnQ8QzJRGWTzEQho3aJ0ilpNRzVGf9y0096a2zRyKrCFzuy04uN
	/lb5lImCyIzx/JtUnp/IyNikI2fsjO7yrdgl6A
X-Received: by 2002:a05:600c:609b:b0:488:8d97:9982 with SMTP id 5b1f17b1804b1-4888d979adfmr6925725e9.1.1775096824577;
        Wed, 01 Apr 2026 19:27:04 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9ca1869sm1268600b3a.56.2026.04.01.19.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 19:27:03 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v6 1/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu,  2 Apr 2026 10:26:54 +0800
Message-ID: <20260402022655.19714-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260402022655.19714-1-heming.zhao@suse.com>
References: <20260402022655.19714-1-heming.zhao@suse.com>
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
 fs/ocfs2/aops.c | 71 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 09146b43d1f0..0c88f751ffd5 100644
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

