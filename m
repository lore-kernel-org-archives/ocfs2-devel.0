Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A57431F99D
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Mar 2026 06:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773816054; cv=none; b=i5t3tqivqO7M+Ee3Iiq+zks9xn/hUNaMJrM3EkzuZCftUta38ObyBU9GWJos/2Ubp72LWZ4inVdZbibQBBSYAeILAq+Rzv5GXXjrgKtQ8zj6g+124k4PfVpAf1JC8YGOgCIHoV46A5GoetivoG71yVFHyzffkkNoxQHIcWe/vM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773816054; c=relaxed/simple;
	bh=Kdkkca99xSljRORPXMBzSZgULCX02aNonAS/sk9fymc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JyilOm6ToVdZpie/zQexa8awH6FzXNarZq4mv0jgEHb3WtadhdXOukUS42LtPpOlj8J/S7TLIgKdmxm4ntvraZeZZXaZAqmVwJklMcPM4tq8SLHNHIr0/FP/8KOFam+WSyxoJlC7ML57BwfoD5VZHlCPiTL7R82pDpr44nrFGTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DSzoDqI0; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DSzoDqI0"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b3e2c4e48so353453f8f.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Mar 2026 23:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773816050; x=1774420850; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mvGed1TeZ9T2ibqkt8DS6CMtVDkfmXfLQVGWVaOP6U8=;
        b=DSzoDqI0U1XnKgk+PB/6wxX03vzlVK/7lYtvVpfVGDpmCLxJVjzeThaDRoNbv7nkrn
         wyEzPnuRfBrVRihjv16FDXI/cAslHkPybAz6UfcK/BYp4m7TBfJXjlYTFbxVVApfBAQG
         PoLsMIW15NjkA2n3/wfJzwBla0CII07MLr7AD4UyOo33xHIrvyW86plmviU0vX8r9JRQ
         gjc3X2bSFmO47uoqsYwm1s++9rPfJnXlYnLw1Ij9ciFo497s9hjihu6yA0irJBRYkwpF
         gEFEs3KX5YvoKgVyBPsrGnTTZ7KDfFZi+6vHHPDp9jLibAXylBrbfNR8LdebV3z31tUD
         q2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773816050; x=1774420850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mvGed1TeZ9T2ibqkt8DS6CMtVDkfmXfLQVGWVaOP6U8=;
        b=liUm8wrTsTQTMBjTzNMvZqvb001a3agBve90+VQk+iY2+qqWRdv/WX1OuQM7dzOrc9
         dQ76eHOlWPAIR6ddIChAWFJhloyFUlRdHHNGrLGHKdFOBIUc/ibV40VGM6CXQLgRJlz1
         fGKFTiU8jorsplUv2en/V5rcc2BBE7N374QEJF9DKgkFZvpH2x9TkDejr5jvu12xgkN3
         q4GjhBTjbtw1QrMOOJyTgCLxSOy1lr3B/E2KpOv7gWS6h+iOv90dFdjQdYp3TNYeULo8
         EqRi2klrWPvlAb8uK40kdEaBRB8XXpSilZKbyZ9fO+6YY0K/juRjwWRzd1DLRqKSW/xb
         uKOA==
X-Gm-Message-State: AOJu0YzcWhIC3RZTN6w/IwpTYDqAzmI/7DwpQueb3JyPHwSFNPQ8kuD2
	Q6eEqx94GEQsVhI/Ym4JEaOIvfypj+BW+qxelv7htsN5tnAOxWECVpmNIcTVD/wSiOU=
X-Gm-Gg: ATEYQzwWvz6H3y9/0mZKQuyBCOKsMFVYoBzXGTIcSRD8V127ImjDLgwFEXifrWyfl7T
	k4kjkB/zA/5pqy0mdSXmdRBdqGMarV1cVg15wo29KPrVFMcg2kJEmZOI8nhfKjfeHPI6d4b4HZm
	KQSHPzd/lYzcV4Up33uD4jQGLjSOa5PgNdJmvw2Al43pTHKrlgK/exofR1nPaGsqZQlWbJ+EePT
	NYshGfuDOmhGRuv3YmH4XF+xC9+yqlv6iP8ESfDT4QjEw3Xrq0yQabSPxJOmP3f+4FdYpucj6ST
	xs4cgwTy1vnsNrl2ufIjoaoFUvmH/uo5NDuWYvrg5OkrHDv+G3gutlNqNMTclMJCFEouVVjGqtx
	PKyosVDtgIRHo3wxi/cVWVV+BsXERfjMuoFrKKTaKFCI60lW8G1aHkok9rPm8DGdneT4WmIPSF/
	wMl7iEz9fFWBCKeMfUtdiVyA==
X-Received: by 2002:a05:600c:19d4:b0:485:385f:674f with SMTP id 5b1f17b1804b1-486f45710cemr21997125e9.6.1773816050456;
        Tue, 17 Mar 2026 23:40:50 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e62fd3asm14973795ad.78.2026.03.17.23.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 23:40:49 -0700 (PDT)
Date: Wed, 18 Mar 2026 14:40:45 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, glass.su@suse.com
Subject: Re: [PATCH v2 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <x7tv6dzqhiwcvld2cct4olou5oioeis5k4nlpr6oglpch2skvr@duochardclqx>
References: <20260312162725.15523-1-heming.zhao@suse.com>
 <20260312162725.15523-2-heming.zhao@suse.com>
 <ca9c4609-210f-4426-a4e1-5ee732646411@linux.alibaba.com>
 <qziha6iel7os7c7ecgqphyiqluyf663ntlmxt65bibn5iregsl@qsxg6bi7r2ev>
 <488ccee8-f197-4326-aca4-4466003aed3e@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488ccee8-f197-4326-aca4-4466003aed3e@linux.alibaba.com>

On Fri, Mar 13, 2026 at 12:53:32PM +0800, Joseph Qi wrote:
> 
> 
> On 3/13/26 11:17 AM, Heming Zhao wrote:
> > On Fri, Mar 13, 2026 at 10:04:11AM +0800, Joseph Qi wrote:
> >> Almost looks fine, minor updates below.
> >>
> >> On 3/13/26 12:27 AM, Heming Zhao wrote:
> >>> During ocfs2 dio operations, JBD2 may report warnings via following call trace:
> >>> ocfs2_dio_end_io_write
> >>>  ocfs2_mark_extent_written
> >>>   ocfs2_change_extent_flag
> >>>    ocfs2_split_extent
> >>>     ocfs2_try_to_merge_extent
> >>>      ocfs2_extend_rotate_transaction
> >>>       ocfs2_extend_trans
> >>>        jbd2__journal_restart
> >>>         start_this_handle
> >>>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
> >>>
> >>> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
> >>> handle each extent in a separate transaction.
> >>>
> >>> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> >>> only be removed from the orphan list after the extent tree update is complete.
> >>> this ensures that if a crash occurs in the middle of extent tree updates, we
> >>> won't leave stale blocks beyond EOF.
> >>>
> >>> This patch also removes the only call to ocfs2_assure_trans_credits(), which
> >>> was introduced by commit be346c1a6eeb ("ocfs2: fix DIO failure due to
> >>> insufficient transaction credits").
> >>>
> >>> Finally, thanks to Jans for providing the bug fix prototype and suggestions.
> >>>
> >>> Suggested-by: Jan Kara <jack@suse.cz>
> >>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> >>> ---
> >>>  fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
> >>>  1 file changed, 29 insertions(+), 29 deletions(-)
> >>>
> >>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> >>> index 09146b43d1f0..91997b330d39 100644
> >>> --- a/fs/ocfs2/aops.c
> >>> +++ b/fs/ocfs2/aops.c
> >>> @@ -2294,18 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>  		goto out;
> >>>  	}
> >>>  
> >>> -	/* Delete orphan before acquire i_rwsem. */
> >>> -	if (dwc->dw_orphaned) {
> >>> -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> >>> -
> >>> -		end = end > i_size_read(inode) ? end : 0;
> >>> -
> >>> -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
> >>> -				!!end, end);
> >>> -		if (ret < 0)
> >>> -			mlog_errno(ret);
> >>> -	}
> >>> -
> >>>  	down_write(&oi->ip_alloc_sem);
> >>>  	di = (struct ocfs2_dinode *)di_bh->b_data;
> >>>  
> >>> @@ -2326,44 +2314,56 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>  
> >>>  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
> >>>  
> >>> -	handle = ocfs2_start_trans(osb, credits);
> >>> -	if (IS_ERR(handle)) {
> >>> -		ret = PTR_ERR(handle);
> >>> -		mlog_errno(ret);
> >>> -		goto unlock;
> >>> -	}
> >>> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> >>> -				      OCFS2_JOURNAL_ACCESS_WRITE);
> >>> -	if (ret) {
> >>> -		mlog_errno(ret);
> >>> -		goto commit;
> >>> -	}
> >>> -
> >>>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> >>> -		ret = ocfs2_assure_trans_credits(handle, credits);
> >>> -		if (ret < 0) {
> >>> +		handle = ocfs2_start_trans(osb, credits);
> >>> +		if (IS_ERR(handle)) {
> >>> +			ret = PTR_ERR(handle);
> >>>  			mlog_errno(ret);
> >>>  			break;
> >>
> >> I'd rather goto unlock directly without update i_size in case error.
> > 
> > agree
> >>
> >>>  		}
> >>> +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> >>> +					      OCFS2_JOURNAL_ACCESS_WRITE);
> >>> +		if (ret) {
> >>> +			mlog_errno(ret);
> >>> +			ocfs2_commit_trans(osb, handle);
> >>> +			break;
> >>
> >> Ditto.
> > 
> > agree
> >>
> >>> +		}
> >>>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
> >>>  						ue->ue_cpos, 1,
> >>>  						ue->ue_phys,
> >>>  						meta_ac, &dealloc);
> >>>  		if (ret < 0) {
> >>>  			mlog_errno(ret);
> >>> +			ocfs2_commit_trans(osb, handle);
> >>>  			break;
> >>
> >> Ditto.
> > 
> > The existing code still updates i_size even if ocfs2_mark_extent_written()
> > returns an error. I am not certain whether updating i_size in this case is
> > correct, but I prefer to maintain the original logic for now.
> > Does that seem reasonable to you?
> > 
> 
> Since it returns 0 for unwritten extents, it looks fine.
> 
> >> BTW, we can move ocfs2_commit_trans() rightly after ocfs2_mark_extent_written()
> >> to save the extra call in case error.
> > 
> > agree
> > 
> > I ran a DIO test using 64MB chunk size (e.g.: fio --bs=64M), the dwc->dw_zero_count
> > is about 12107 ~ 12457.
> > Regarding the transaction splitting in the unwritten handling loop: this patch
> > introduces a minor performance regression. I would like to merge some of the
> > transaction calls. e.g.: by starting a new transaction every 100 or 200 iterations.
> > What do you think of this approach?
> > 
> 
> Seems we can limit max credit for a single transaction here?
> If exceeds, restart a new one.
> 
> Joseph,
> Thanks

sorry for the late reply, I spend some time running the tests.
I have created two different types of patches (see below) to address this issue.

time consumption results:

ocfs2-dynamic-... patch
real    2m9.900s
user    0m0.333s
sys     0m22.687s

%200 of ocfs2-split-trans-... patch
real    1m48.901s
user    0m0.306s
sys     0m23.019s

%500 of ocfs2-split-trans-... patch
real    1m49.350s
user    0m0.299s
sys     0m22.718s

As shown above, the fixed "500% mode" is faster than the dynamic style.
Which approach do you prefer?

---
the test script:
```
#!/bin/bash
# thanks Wolfgang

DISK="vdc"
MOUNTPOINT="/mnt/ocfs2"
TEST_FILE="$MOUNTPOINT/test.bin"

if lsblk | grep "$DISK.*$MOUNTPOINT"; then
    umount $MOUNTPOINT
fi
echo "------mkfs & mount----------------"
mkfs.ocfs2 -b 4K -C 4K --cluster-stack=pcmk -N 2 /dev/$DISK --cluster-name=hacluster
mount.ocfs2 -t ocfs2 /dev/$DISK $MOUNTPOINT

sleep 1
echo "------fallocate----------------"
fallocate -l 2G "$TEST_FILE"

sleep 1
echo "------setup file----------------"
fio --name=setup --filename="$TEST_FILE" --rw=randwrite --bs=4k \
    --ioengine=libaio --iodepth=64 --size=2G --io_size=512M \
    --direct=0 --end_fsync=1 --minimal

sync
sleep 3

echo "-----start test-----------------"
time fio --name=tst --filename="$TEST_FILE" --rw=write --bs=64M \
    --ioengine=libaio --iodepth=16 --size=2G --direct=1
```

---
patch: 0001-ocfs2-dynamic-extending-jbd2-credits-during-dio-end-.patch
Subject: [PATCH] ocfs2: dynamic extending jbd2 credits during dio end path

---
 fs/ocfs2/aops.c    | 31 +++++++++++++++++--------------
 fs/ocfs2/journal.c | 34 ++++++++++++++++++++++++++++++----
 fs/ocfs2/journal.h |  5 +++--
 3 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7a65d5a36a3e..d9be765662dc 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2279,6 +2279,10 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
 	int ret = 0, credits = 0;
+	/* do the same job of jbd2_max_user_trans_buffers() */
+	journal_t *journal = osb->journal->j_journal;
+	int jbd2_max = journal->j_max_transaction_buffers -
+			journal->j_transaction_overhead_buffers;
 
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

---------- 
patch: 0001-ocfs2-split-trans-in-end-dio-to-avoid-credit-exhaust.patch
Subject: [PATCH] ocfs2: split trans in end dio to avoid credit exhaustion

---
 fs/ocfs2/aops.c | 77 +++++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 32 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7a65d5a36a3e..9053f1ee587a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2279,6 +2279,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
 	int ret = 0, credits = 0;
+	int cnt = 0, trans_start = 0, mod = 500;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -2295,18 +2296,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
 
@@ -2327,44 +2316,68 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 
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
-			mlog_errno(ret);
-			break;
+		if ((cnt++ % mod) == 0) {
+			trans_start = 1;
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
+				goto unlock;
+			}
 		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
 						ue->ue_phys,
 						meta_ac, &dealloc);
+		if ((cnt % mod) == 0) {
+			ocfs2_commit_trans(osb, handle);
+			if (ret < 0) {
+				mlog_errno(ret);
+				break;
+			}
+			trans_start = 0;
+		}
+	}
+
+	//commit if above loop doesn't do
+	if (trans_start) {
+		ocfs2_commit_trans(osb, handle);
 		if (ret < 0) {
 			mlog_errno(ret);
-			break;
 		}
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


Thanks,
Heming
