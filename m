Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C0134403D
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Mar 2026 03:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774580532; cv=none; b=Efy9yQqMAvc69UR3Jw2JTedka+C/fqSo/Y5qbSr/sOopIJLm3dw6hLbY+mXl/cvZ5eT0MhbTIDTAX57J7QexWWJHkQznFPUVLx6/LQJjUd9Xwj84S7annlYkaZ4Z0IUMKQ8RWLH4/ZqLo/IFKNmJZVjBUBtnAjZLf2fN8e4/29o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774580532; c=relaxed/simple;
	bh=20oNYQqM0JkkCGOrU5NDFKnRx92hkRk2p+4LI6df9GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lg38+PPN53o6dBPxhFKOgd28TivjpR8rPF5r+tUuDzJvYR/INsfbVhCSfZUsyYDmYETP0lxb5jAHUMxi+03c45lA/8HwteQGmL9iZjJZiSplm30QM1ROtf1SxHpBV8alQfmpNmKrS9tN/tcih08UN6EBqU9hggHTXAxZTQYRqzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PB6LlMfo; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PB6LlMfo"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43b3a5973e7so180354f8f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 20:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774580529; x=1775185329; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=srdV9OMk9A3XF4tfh1BXukTTCI62EYXAQwG0rTVUpOg=;
        b=PB6LlMfow9QmdJ8cHQCLTSu0XvF7LgLISLaZsTT4mAWEsCNSxXPBoTpHc0pqkr2vfS
         +e1wU/EBH8SJWhWhZ1VZS1n6/BvxXpSLUdutSGZDki8b6r4NQi8HMzuqPEG0/0w4G6S0
         jvWD9I/iL1hp6K5pmaVuvsV0x579m6WTJJJF3Z7H4v7xWwjRXLslsiOPbTuKZA6mywZk
         OW23BBxr6549VLF6+0EfVdoNqxqT1qztD+4WXdEjLTQUqiKdLS/KjrvW/fjunpiDcV0o
         xc6rBbK/JZ2R5FbHEqsIRqp1vgmn1fZCFLirtTqs4Cmbx98VXmWQIWpqBTJAeOkL5MOu
         rPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774580529; x=1775185329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=srdV9OMk9A3XF4tfh1BXukTTCI62EYXAQwG0rTVUpOg=;
        b=KMvRZyshgJuuI8z8xQvLGsiRvHwYcaE3gB9RnM0g5XoLL091fESDKSrRzT0PMsbGFV
         1SRe74VjKgaaGzvLv50Ge3olMFLW6gk1pe7U5gH0zGATBzur393niF2qat/fqsRdQ2Mc
         0wOdwgFX7x+sJPs40Mr2rUJTWNBwNbdGxad93d7B2Ib0SPmQyqDeiGXJKs5E2+DhyvVu
         Y5k4uf2Djdd+yKbQsuWK2BhXivhiwc6DMjb/9uZLFWrJDbf0BKGa+9EBnmG7m2tBghQd
         4Xeursi8KyRw34s5K+rb71D8S4/MuKdPOgoLNrb65rJ4FuiuvaukKbkWdiDAC9imt8Oj
         bMPg==
X-Gm-Message-State: AOJu0YxsIuJS7YrXqBKJki6vTEd1FGzQVybM0IEdxf0i/4y5papMzHf0
	1RTehKVPtqkteSBgJEd1nnwwFjIzTjKI1CcSCueMVfqH99leKL4EYZ490ryo9Gc03sM=
X-Gm-Gg: ATEYQzxtHFAXsuD9WEFfRTPErmpD3+GaHa+PBNNiXRwYdvc52CQreLBOgqvAzc00g1W
	wSW2spNJaJYKUdrZtpKKcuPWi5p6crdpxvrjFAVf4dWRwqOFZ913zxypjiYiR/oagpObBoWHh5/
	V2ICZ43AmeCCVPvpcZ4R+efTFQZ4w8ALMxQKltaPRiiB2cfJ4AW6y51g31JrjWWwc37cPXBXRKG
	k9hMfxmVvgiZUhF7UKRdFGo71Ul8wJApnxAXygmcD7v1mAyiORG9nThO+fSusN3rqwrfExJkbFs
	axcIo045H11EXW6EygZFlQe/rNOnBvLlTag2rBtGWKtsiBj6OhYiEIhLk2IXMlbf1JdVNBL0hdH
	m6Gnz8oyfwY0cOUnpuKbfRCRlDyG20mYujnEgUBnOZpllFMSnOCwG6TC2BY6ymQRdt5SAvGJajW
	aAc8Kw/za4m3ScZbyE7pB/8w==
X-Received: by 2002:a05:600c:314f:b0:486:fb8a:fed with SMTP id 5b1f17b1804b1-487283d7a9dmr6055595e9.8.1774580528524;
        Thu, 26 Mar 2026 20:02:08 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0ccc8b781sm7087615ad.80.2026.03.26.20.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:02:07 -0700 (PDT)
Date: Fri, 27 Mar 2026 11:02:05 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	glass.su@suse.com, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <ohp7ryqyx67edlqxtw6z77omxtdsjwtfqlfultpemfkur4y4iv@ptnborr5awav>
References: <20260326142640.20077-1-heming.zhao@suse.com>
 <20260326142640.20077-2-heming.zhao@suse.com>
 <b0ba52bb-ab01-48a2-ab40-b2dfe4cdc236@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0ba52bb-ab01-48a2-ab40-b2dfe4cdc236@linux.alibaba.com>

On Fri, Mar 27, 2026 at 09:42:55AM +0800, Joseph Qi wrote:
> Hi,
> 
> On 3/26/26 10:26 PM, Heming Zhao wrote:
> > During ocfs2 dio operations, JBD2 may report warnings via following call trace:
> > ocfs2_dio_end_io_write
> >  ocfs2_mark_extent_written
> >   ocfs2_change_extent_flag
> >    ocfs2_split_extent
> >     ocfs2_try_to_merge_extent
> >      ocfs2_extend_rotate_transaction
> >       ocfs2_extend_trans
> >        jbd2__journal_restart
> >         start_this_handle
> >          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
> > 
> > To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write()
> > to handle extent in a batch of transaction.
> > 
> > Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> > only be removed from the orphan list after the extent tree update is complete.
> > this ensures that if a crash occurs in the middle of extent tree updates, we
> > won't leave stale blocks beyond EOF.
> > 
> > Finally, thanks to Jans and Joseph for providing the bug fix prototype and
> > suggestions.
> > 
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/aops.c | 72 ++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 44 insertions(+), 28 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 09146b43d1f0..60f1b607022f 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -37,6 +37,8 @@
> >  #include "namei.h"
> > ... ... <--- snip --->
> > +		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
> > +			ocfs2_commit_trans(osb, handle);
> > +			handle = NULL;
> > +			batch = 0;
> > +		}
> >  	}
> >  
> >  	if (end > i_size_read(inode)) {
> 
> I still don't think it is a good idea to update inode size in case error.
> The original logic behaves inconsistent, if ocfs2_start_trans() and
> ocfs2_journal_access_di() fails, it won't update inode size, but if
> ocfs2_assure_trans_credits() and ocfs2_mark_extent_written(), it will do.
> So let's make it behave consistent by both checking 'ret' here.
> 
> Other looks fine.
> 
> Joseph

After sending the v4 patch, I did some tests and identified the key of the
performance degradation in the dynamic credit adjustment patch.
I found that by using half of the jbd2_max value, the time consumption returned
to the same level as the "direct loop" style. 

key code change:
(base on patch[1]: 0001-ocfs2-dynamic-extending-jbd2-credits-during-dio-end-.patch)
        int jbd2_max = (journal->j_max_transaction_buffers -
                        journal->j_transaction_overhead_buffers) >> 2;

my test env:
- 10G ocfs2 volume
- DIO 2G file, write with 64MB block (--bs=64M).

observations:
- ocfs2_assure_trans_credits calls "commit & start trans" times on every 64MB block:
  - using jbd2_max (5449):  ~9 times.
  - using half value (2724): ~20 times.
- v4 patch ("batch" style), call "commit & start trans" on every 64MB block: ~62 times

time consumption:

jbd2_max:5449 case
real    2m9.346s
user    0m0.277s
sys     0m22.748s

half jbd2_max:2724 case
real    1m49.400s                                                                              
user    0m0.343s                                                                               
sys     0m22.734s

v4 patch:
real    1m49.650s
user    0m0.337s
sys     0m22.780s


the reason (I guess):
The original patch only performed a "commit and start new trans" when jbd2
credits were nearly exhausted. I suspect contention between the commit flush
operation and the jbd2 operations in the dio end path, leading to high latency.
By using half the jbd2_max value, trigger commits more frequently, which appears
to reduce jbd2 contention and racing.

Finally, I suggest we use the dynamic credit extension patch for v5. This
version only adds logic to ocfs2_assure_trans_credits() and does not affect
i_size changes during error cases.

[1]:
searching "0001-ocfs2-dynamic-extending-jbd2-credits-during-dio-end-.patch"
in following url:
- https://lore.kernel.org/ocfs2-devel/75f89a17-213b-42a0-a30e-d52fb2d077a6@linux.alibaba.com/T/#mbe2b5f52ee249178e1ad4c76d964de2dc818eb32

-----
For easy of discussion, I past the full dynamic credits adjustment patch
(with half jbd2_max) below.

```
Subject: [PATCH] ocfs2: dynamic extending jbd2 credits during dio end path

---
 fs/ocfs2/aops.c    | 31 +++++++++++++++++--------------
 fs/ocfs2/journal.c | 34 ++++++++++++++++++++++++++++++----
 fs/ocfs2/journal.h |  5 +++--
 3 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7a65d5a36a3e..9cdecfa0ea0c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2279,6 +2279,10 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
 	int ret = 0, credits = 0;
+	/* do the same job of jbd2_max_user_trans_buffers() */
+	journal_t *journal = osb->journal->j_journal;
+	int jbd2_max = (journal->j_max_transaction_buffers -
+			journal->j_transaction_overhead_buffers) >> 2;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -2295,18 +2299,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
 
@@ -2341,8 +2333,10 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	}
 
 	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
-		ret = ocfs2_assure_trans_credits(handle, credits);
-		if (ret < 0) {
+		ret = ocfs2_assure_trans_credits(inode, &handle, di_bh, credits, jbd2_max);
+		if (ret == 1) {
+			goto unlock;
+		} else if (ret < 0) {
 			mlog_errno(ret);
 			break;
 		}
@@ -2365,6 +2359,15 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	ocfs2_commit_trans(osb, handle);
 unlock:
 	up_write(&oi->ip_alloc_sem);
+
+	if (dwc->dw_orphaned) {
+		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
+
+		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index e5f58ff2175f..57ad69d19494 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -474,14 +474,40 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
  * credits. Similar notes regarding data consistency and locking implications
  * as for ocfs2_extend_trans() apply here.
  */
-int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
+int ocfs2_assure_trans_credits(struct inode *inode, handle_t **i_handle,
+				struct buffer_head *bh, int nblocks, int jbd2_max)
 {
+	handle_t *handle = *i_handle;
 	int old_nblks = jbd2_handle_buffer_credits(handle);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int ret, wanted;
+	int plan = nblocks << 1; /* Double the credits to prevent boundary issues */
 
 	trace_ocfs2_assure_trans_credits(old_nblks);
-	if (old_nblks >= nblocks)
-		return 0;
-	return ocfs2_extend_trans(handle, nblocks - old_nblks);
+
+	wanted = old_nblks + plan;
+
+	if (wanted < jbd2_max) {
+		if (old_nblks < nblocks)
+			return ocfs2_extend_trans(handle, nblocks - old_nblks);
+		else
+			return 0;
+	}
+
+	ocfs2_commit_trans(osb, handle);
+	handle = ocfs2_start_trans(osb, plan);
+	if (IS_ERR(handle)) {
+		mlog_errno(PTR_ERR(handle));
+		return 1; /* caller must not commit trans for this error */
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), bh,
+			OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret)
+		mlog_errno(ret);
+
+	*i_handle = handle;
+	return ret;
 }
 
 /*
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 6397170f302f..08a76ffb870a 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -244,8 +244,9 @@ handle_t		    *ocfs2_start_trans(struct ocfs2_super *osb,
 int			     ocfs2_commit_trans(struct ocfs2_super *osb,
 						handle_t *handle);
 int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
-int			     ocfs2_assure_trans_credits(handle_t *handle,
-						int nblocks);
+int			     ocfs2_assure_trans_credits(struct inode *inode,
+					handle_t **i_handle, struct buffer_head *bh,
+					int nblocks, int jbd2_max);
 int			     ocfs2_allocate_extend_trans(handle_t *handle,
 						int thresh);
 
-- 
2.43.0

```

- Heming
