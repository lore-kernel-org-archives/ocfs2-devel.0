Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3356244D68A
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Mar 2026 10:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773138266; cv=none; b=I8Dumjp//NdhPnN8jkOVYbcSjDsAsAY/s4GBWXHJzKUafD+bY/HWiciK1jMNho60AjBy5DXsMk3iTP7D1nX3f1HCL+bEmdyinWFwZp74UpK0QabAWTVgIMzK6/0F9++IyQly/LPEx18GzrOLJPG6kLCDLi7PglYbILuYXMMqI18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773138266; c=relaxed/simple;
	bh=z0z9B7ZBOmRZ8glWgHskxYuryo6uTmZVrX4gK72k3Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qd0WkoOnYRXrCaDu+g/3pv2Y7d7On/MYUHn2mZDeZLU7y+XMcuRNJHq12BguNdka2GWChV6hhrQclV5r2FB7LR7aIM4/OK2zycE7CNA/twP40HdpNJME9myy2Y512C6rgkWKGYWZ0/sx5IAOWZ0rQE0UngQ7s314NMc+yOqNwIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=grBAYbkb; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="grBAYbkb"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48371104ffdso16254085e9.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Mar 2026 03:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773138264; x=1773743064; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1N3sjVkf58k4WLx94+8KZoUfh8dzAxMyEL/Uf8S4aTA=;
        b=grBAYbkbeksvXJnYUe/cFrAyEtd8eV7j2lOkgfV5kpcT8x86KkKsL4qxZewx37VZij
         qUYaC7KeLc+hznOC0GGXr9cFUudn3R2COyU7vgJI+rzSP9kLvLRk9aN/pwqxmZu90P2C
         rdkTPjDy4n/s+M7n8/rmmoPxMjteNagwkQ3GsXet3ZmXWj1MD0iPFB30KhN17nQ6Oh3I
         NSDEMS8sMYAgm17o/HPVjilpCl8RgQzXKwMi3kWYFFNZqMcuviU6QbgjEfpanOK3mrOz
         bhv1JjWF57ICj/14zsdwpLKJthoCxScQq1fsZbWtB9zIpwGGjZkEgIq/kN7/raUD9uct
         bf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773138264; x=1773743064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1N3sjVkf58k4WLx94+8KZoUfh8dzAxMyEL/Uf8S4aTA=;
        b=aaKjxLAfJZMM5SjZngPb/hfKB2QTl+k4QbjxpQw+CYnntYRYIVf3pIpGlqEH4fqg5a
         JkywcbkWLntNgdX2UJaLiz86qxtTZv/IPKqKdBF7QUSWBi/AEUDDzCeNi2cOPBofc3zG
         OWqMq+3FcA9xZ4z54ZGOBVk801mLs+CFvN138QndRICFgzw8OShZf5BAm9O/3j5pJz6T
         CNJVITA8XLIVJPxuCeq91h6kBGcs47lAC2RW874vXuI+Rad1cAmXBvQPUo1WBPPWI/mH
         /c+8gqexSoZ+io5PKbmYN7qew9IAIkRX8gSTeENFvNU4xtjwOn0GdA05sWCDlNSGe1pC
         rzfg==
X-Forwarded-Encrypted: i=1; AJvYcCUzS834bRyD82SkP9tQ6ujRLx5J8HWKPJe/cm58pf3ZcAP17XrdmTF80Ma+09i0Q1oVoY2wg+BWjM2v0w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/aTjQJCBRRpFGBIZ6O9t83fy5Zsu9WHBjYV4MqXVrObI6wlVp
	v2wquusw6FzrsbN7y0hjutJBZRVzR0bAH+CgdfgHwKKP0yNYPkcFSTEFpmYkcQL/aYs=
X-Gm-Gg: ATEYQzwaSlmUs7l22HvS+E8Zy1VaZ4pjaRxlbIn9tl+ZtYFN7npWZIyrWe+P3FQQ+v9
	iMNXp7FnrBL9rKw5h5G8xqciyLHDdgez5ENHDanIV3oAi5ydjZsIyuNbRJVfshO4iO0qkYJqk6C
	6R1PeFyk0f2eed/UDAHHe9JUaqkj/S0a0iHmo7SPa/HTas+MORE4dBoGsArCu/v/SsJsS9suIjS
	XEvBXkc01u44k6tX9+LDBc2oEWdcwUvQ4MBbIEJ9OoAl872jQVOfvrlhiDV2k+WuNle2dE91hg6
	8gfN2YnPNaOV3ejvw8fwb27R/c5RSVtUqmvDgF6zE/xMlW46blEjkVqC6T1aFE0Z2TdK+mf9/Di
	rdWr0RdarzCv6A7auJtaMI5OYKLOy+NXeUy2bwk2Z8FP8ubaxN8o1QbNjOu5rdK6Uhyt3zgWC7r
	0k6tquNmI/LJVAUqN4Ooj/uUleoSceG7fwef6C
X-Received: by 2002:a05:600c:c044:b0:485:3177:d80c with SMTP id 5b1f17b1804b1-4853177d98fmr51806825e9.2.1773138263535;
        Tue, 10 Mar 2026 03:24:23 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e9c965sm150251325ad.32.2026.03.10.03.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 03:24:22 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Tue, 10 Mar 2026 18:24:10 +0800
Message-ID: <20260310102413.12501-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310102413.12501-1-heming.zhao@suse.com>
References: <20260310102413.12501-1-heming.zhao@suse.com>
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
handle each extent in a separate transaction.

Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
only be removed from the orphan list after the extent tree update is complete.
this ensures that if a crash occurs in the middle of extent tree updates, we
won't leave stale blocks beyond EOF.

This patch also removes the only call to ocfs2_assure_trans_credits(), which
was introduced by commit be346c1a6eeb ("ocfs2: fix DIO failure due to
insufficient transaction credits").

Finally, thanks to Jans for providing the bug fix prototype and suggestions.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/aops.c | 56 ++++++++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 09146b43d1f0..50b4d474b88c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2294,18 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
 
@@ -2326,23 +2314,18 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 
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
-		ret = ocfs2_assure_trans_credits(handle, credits);
-		if (ret < 0) {
+		handle = ocfs2_start_trans(osb, credits);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			mlog_errno(ret);
+			break;
+		}
+		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
 			mlog_errno(ret);
+			ocfs2_commit_trans(osb, handle);
 			break;
 		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
@@ -2351,19 +2334,26 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 						meta_ac, &dealloc);
 		if (ret < 0) {
 			mlog_errno(ret);
+			ocfs2_commit_trans(osb, handle);
 			break;
 		}
+		ocfs2_commit_trans(osb, handle);
 	}
 
-	if (end > i_size_read(inode)) {
-		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
+unlock:
+	up_write(&oi->ip_alloc_sem);
+
+	/* everything looks good, let's start the cleanup and update i_size */
+	if (dwc->dw_orphaned) {
+		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
+
+		end = end > i_size_read(inode) ? end : 0;
+
+		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
+				!!end, end);
 		if (ret < 0)
 			mlog_errno(ret);
 	}
-commit:
-	ocfs2_commit_trans(osb, handle);
-unlock:
-	up_write(&oi->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-- 
2.43.0

