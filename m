Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62243F7E7A
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Mar 2026 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773332865; cv=none; b=LqErhBCS2+bPDt2k/g75TRBkhlB3RIbeMnn/YdyAq6gsLWO15QCdyzaC/OgHQSirNx/BqPWKNasbcjyBgtsUUw/qPX5aZy6uNnWFHrY/21nPg/9eEXOPKTnataoR6DO5TeQfq04EhG4FQWmBQhdDvlK78Ay53fvgsc8qljDS4k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773332865; c=relaxed/simple;
	bh=jlZ6vyHL/5H17GGmpSuyXizwo7dtt8ALbzqE+CcAIWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lbwc8vuE9/dpBkLm6fiSuwO6wBVLa81TWwZNtXdgeSSqVwRW9vjGcOBT6z1xUnkLeWdN1cEnM9sVRzbJL4VyKjFTmR8p29mCBh6rYABRj6GEvoItkjz69VAmWWnuiWE1+4MRbYlJzflTBoBVtlYh6+u4o6pSm+O2U6fQgB/gucQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E+8qCCsU; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E+8qCCsU"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439bc1a201fso106056f8f.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Mar 2026 09:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773332857; x=1773937657; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2K0kUSW2jmLPn139Qdn7K3kU+YuzTW+FKmv+jdtRF0=;
        b=E+8qCCsUfMAFuwvUF+oS9UF32GPHCDyqJuS8B3eJlyQ+XR7io+BMQUXJNddPG/Oz1L
         vo6sKwl3RGMzkR/IP9qm47+twCOKixE7sAqAUMLSS8FMZu7rzlOeIwS0Jhc+uRNkH9/k
         pNwmZR2GaAujpY3fmw7ze0TFuLCWAyqu7wgDNxYd3H1XliWDtNI8V0yrZBt7IQWDsnN2
         Q4Zw1SKAcgOmpUmmseinl5S3Jvewiaby0Zj657Dx5IcYfW+TsWwXsve8Ug8dy6Oy2MTW
         Db07qz2C+oonG/mHBIzzU77iBSr2rjSBt+eUFO/XwKNNqqNSrlZXws3YJrZWqvIb/M1R
         Kz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773332857; x=1773937657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q2K0kUSW2jmLPn139Qdn7K3kU+YuzTW+FKmv+jdtRF0=;
        b=kc0Z1RSZMCqDhbmEwOmQdCNzE4mBaYrU4E400Slnd7Zp7MqcXDWch5mx7Pj/BYkwpo
         MENlRh/t3HBC7L21pJy5CGpl4F5WuRdcEhjTOhBRbKv/hZwsAv+Sy6uqs/bO2cjxTwaM
         Ed9l15g6gcAxGs+jGGmQf90Wuotn5SuaOBOK6EjAH5c9FnRf2LdXVgtitM1BGfOHE0Zk
         8K19ZZrA0SPpRTIiqgs2mRYdESJIZYjCxebES3zWs6bImD9Ta+EXmqwVHSlqEdV41tHP
         QPFn+2t5wAwrb3JNlzHHJljzQpq+AbCyj2RJgpJ+47O5NVdTCUdnIhtDI9ZfSHrhRyhi
         aDGg==
X-Forwarded-Encrypted: i=1; AJvYcCXUhqZGnDa71vQen39Fxwx3yM0cmmvKBZPQ4XzluUcxDVofekTFHRui6TcoKgLuuuhHZAH1AHHBdKUspA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzyuUEf4BhovuN2JUeDhq+Sh0I+KNVAHPhU9rOCjirTt0wsnIG/
	3D7qF2ajKbvDGLojGbh6JuQOwqoEwoZsw7+xpl3NU9emNnJnVRDBGo9dURV7W+LsPz1wiuuT+Ok
	E3MO1
X-Gm-Gg: ATEYQzxa62zenKP34VxmfPSgGUrPziRRjjUtCDSpi168F5u2CXjZ3ug8DJFeXMJup3V
	ETDkeW1zvoyLyMWdpyhvvFft/Q8tQZNWg11U3Ypr8tenWKnP/Pue+h4D7Ig8IxkjwmEuAAz7dyL
	0nTGsW3uBnDjyoKT0u7ogYnELjRjNuNFR5ygq4LzSRGrjjeYiVdJTpkmwiXZQ2338B1g/JInZK2
	CWXhJ9EciNt961W0xDyb07rIiSr1xOdYo8fnLk5a6iRpz2kD2URlzeaBNhb2Yww8McPqexjDiYm
	uWQwGIybbbPNNeJbMm+n1lk5Sz40GlmRmVGasPILzRFQiCVwSCjnlV5o+jVSbd4EiHOJg1X55dS
	wPM+JWqvG6CvhweuopZksfIMuFogl4GBZazdArlDX6nSuQM0L9lbo3VmYXctFcS1ZOmIi/h0jKV
	QXXjIODh9pCXpSk7G0cQ7MAqMiMTpq4PLo8956
X-Received: by 2002:a05:600c:6297:b0:483:887:6e32 with SMTP id 5b1f17b1804b1-4854b139988mr65541525e9.8.1773332856745;
        Thu, 12 Mar 2026 09:27:36 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73cdf2725csm5877790a12.13.2026.03.12.09.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 09:27:35 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Fri, 13 Mar 2026 00:27:23 +0800
Message-ID: <20260312162725.15523-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312162725.15523-1-heming.zhao@suse.com>
References: <20260312162725.15523-1-heming.zhao@suse.com>
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
 fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 09146b43d1f0..91997b330d39 100644
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
 
@@ -2326,44 +2314,56 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 
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
 			mlog_errno(ret);
 			break;
 		}
+		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			ocfs2_commit_trans(osb, handle);
+			break;
+		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
 						ue->ue_phys,
 						meta_ac, &dealloc);
 		if (ret < 0) {
 			mlog_errno(ret);
+			ocfs2_commit_trans(osb, handle);
 			break;
 		}
+		ocfs2_commit_trans(osb, handle);
 	}
 
 	if (end > i_size_read(inode)) {
+		handle = ocfs2_start_trans(osb, credits);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			mlog_errno(ret);
+			goto unlock;
+		}
 		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
 		if (ret < 0)
 			mlog_errno(ret);
+		ocfs2_commit_trans(osb, handle);
 	}
-commit:
-	ocfs2_commit_trans(osb, handle);
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

