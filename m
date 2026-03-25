Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E784285CB3
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Mar 2026 03:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774409470; cv=none; b=q33SJecAISAyRBvWZK5dlcKg23osq3HUooIRMQ7EW1Z6SAvfm04YcgfYX3P/9cZ+i1htL7YoHe6GfJ5vdNKIpEq+75uRSJeBsrIvX9lZ+TgDF1QjxN8N6ek+qHLjdgv3uxdiGm7lJCzSNh+l/kIvEYxFR95OXWxlhDQTAfcDeFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774409470; c=relaxed/simple;
	bh=ZMxkRBI1QQjmkKGhpx/hwUOOgzamOiAAuZc0ZrRqiZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDvzMPv5htEQWz44DvhCKl1icfeyUzmERw1pJDciL7GSG0jDKjEKbYIqfBw5ehBF+cYnDmbfqt9/+J9e1NKcOUbtZWnM0mSL9gW2qIiONuMxH7buhyqjB1NC+Qg8srvyr6c4/WKuluhR6653d2yWkx+XHlBKIPqUB8/btB5SkS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Iq+22Q7t; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Iq+22Q7t"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4830b67aa6bso9399935e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 24 Mar 2026 20:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774409466; x=1775014266; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YCcFKlYT3hj3/T0JzTSZHm3mLG7Vj9KxrxQOjBNTlRc=;
        b=Iq+22Q7tl4RbirpN2RlFue3D9dmHSqB8cqDKA/sMfpv/4hffJBuUlwdL8yKeXrNHXm
         mhUDYv3RyC/Bhe0JWLp4bz1d8Uhmsu1/GKh+iYP0nSQmxvjLB/sw28GMeSiZvHkkDmI2
         yeTO2tZXF+nKuNNtKVc5WrI1qa5tudkunnitSjqL3Gw+ivomMXFBYfU+61nX6bfMg892
         aBNPZr67Yg66T8N30GtJFO2HYZ4leW6CefFRoiHuZttD+RL+l26maJ8+hErVGZO90ciQ
         JOXW7RabXnxbkY8mp/dstye9Yl2Ee4H+GiIyK0OUq8t/ruDjCSDw+Lrao/tpDCGeQ8iM
         Yguw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774409466; x=1775014266;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YCcFKlYT3hj3/T0JzTSZHm3mLG7Vj9KxrxQOjBNTlRc=;
        b=dafSwmF4a992OgcpECSr1jPrCt9e6ZrfxDXccVkIIZcZ2trUfiqcvhPELfJN974nfH
         9kn9m4pDMMxko+zrsr5+iA14p4buc4QR7K7qz2esz40kww0iDWCmnLBXmTh5v/Cdjai2
         q4NyudRncz7XiqhYPzxKUpHsEaYqrU6G0pyiijMcWFwoGXSROMXEMy316tMaX0mVeMZ4
         m4hJ0Ark7w5Omcz4xSQoYdQ2fDLfCnO2k8OV35nwInRu+FYH4KuzPaC8/uBbq9peSN/S
         UJNBKVzYGUhtq0b7QK0QIZTxCXMImSnreTAzgmmwd+hIRpTAVuOqV3r8o4Va6DbjR7Ux
         a9yg==
X-Gm-Message-State: AOJu0Yw7eN4UdtLxosjRryTt5RI3xh3tUHmkqCH4ULflCC4Nk6zepMAf
	BV5cd93eecGMouynU+hb29rsIDmiYDHVqau9nSP5gc9sTpW8dxGm9d7e7eZmBUVV4zw=
X-Gm-Gg: ATEYQzzwtGHbGt3YwqsOJyfubD9JM4XwETrN3JONuyaMxnnDZmLZwoSjkEfc+jK665T
	L+9R6li4jXR2rAFUvgbBzO3OmSaFL4MBhrD9tYriyufBxNYepJbbCRqObCaOfDv547AlVQDRQOi
	vvjRFsg8nYM7qzpdI5Fl3ap2HTPDLZDwZm7TP0tGpbIJvyRklZ1UKpYvduYFpuTYx0nCXgMVZFI
	e4tJH2+GDFW3F5Vq7U5G1vqOnlgLogTmaOZhgSV/VnQ3JORSQUfj1fppS7ngzeY5Sr0oxtGLRnt
	gI4w7ev77T27D6MKL4bnFNxZ+mTfJlyipqhjeBmviYriOgaAzl3af1M7FF9J+xRsQYrh1YAL2Uq
	vvLjLyUmxudHDrvR8ra3PR2vd9FaYUpXf8nfrtrO9Qcd3VN6tVUcvh82HyGZG32lP3fNv758sfX
	PR8du7132jY93zeKInEzIBmg==
X-Received: by 2002:a05:600c:4f89:b0:47d:6f12:de57 with SMTP id 5b1f17b1804b1-4871606daa2mr15907565e9.4.1774409465478;
        Tue, 24 Mar 2026 20:31:05 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76565c35desm4830663a12.15.2026.03.24.20.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 20:31:04 -0700 (PDT)
Date: Wed, 25 Mar 2026 11:31:01 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, glass.su@suse.com
Subject: Re: [PATCH v2 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <fxq56b3asrnttbxflhegeetn74kbo3xfjqipcelisbifbtuxku@g2zhgyuzq6je>
References: <20260312162725.15523-1-heming.zhao@suse.com>
 <20260312162725.15523-2-heming.zhao@suse.com>
 <ca9c4609-210f-4426-a4e1-5ee732646411@linux.alibaba.com>
 <qziha6iel7os7c7ecgqphyiqluyf663ntlmxt65bibn5iregsl@qsxg6bi7r2ev>
 <488ccee8-f197-4326-aca4-4466003aed3e@linux.alibaba.com>
 <x7tv6dzqhiwcvld2cct4olou5oioeis5k4nlpr6oglpch2skvr@duochardclqx>
 <a108b18a-e27e-424c-80f1-c19ea2c30685@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a108b18a-e27e-424c-80f1-c19ea2c30685@linux.alibaba.com>

On Thu, Mar 19, 2026 at 09:53:16AM +0800, Joseph Qi wrote:
> 
> 
> On 3/18/26 2:40 PM, Heming Zhao wrote:
> > On Fri, Mar 13, 2026 at 12:53:32PM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 3/13/26 11:17 AM, Heming Zhao wrote:
> >>> On Fri, Mar 13, 2026 at 10:04:11AM +0800, Joseph Qi wrote:
> >>>> Almost looks fine, minor updates below.
> >>>>
> >>>> On 3/13/26 12:27 AM, Heming Zhao wrote:
> >>>>> During ocfs2 dio operations, JBD2 may report warnings via following call trace:
> >>>>> ocfs2_dio_end_io_write
> >>>>>  ocfs2_mark_extent_written
> >>>>>   ocfs2_change_extent_flag
> >>>>>    ocfs2_split_extent
> >>>>>     ocfs2_try_to_merge_extent
> >>>>>      ocfs2_extend_rotate_transaction
> >>>>>       ocfs2_extend_trans
> >>>>>        jbd2__journal_restart
> >>>>>         start_this_handle
> >>>>>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
> >>>>>
> >>>>> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
> >>>>> handle each extent in a separate transaction.
> >>>>>
> >>>>> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> >>>>> only be removed from the orphan list after the extent tree update is complete.
> >>>>> this ensures that if a crash occurs in the middle of extent tree updates, we
> >>>>> won't leave stale blocks beyond EOF.
> >>>>>
> >>>>> This patch also removes the only call to ocfs2_assure_trans_credits(), which
> >>>>> was introduced by commit be346c1a6eeb ("ocfs2: fix DIO failure due to
> >>>>> insufficient transaction credits").
> >>>>>
> >>>>> Finally, thanks to Jans for providing the bug fix prototype and suggestions.
> >>>>>
> >>>>> Suggested-by: Jan Kara <jack@suse.cz>
> >>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> >>>>> ---
> >>>>>  fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
> >>>>>  1 file changed, 29 insertions(+), 29 deletions(-)
> >>>>>
> >>>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> >>>>> index 09146b43d1f0..91997b330d39 100644
> >>>>> --- a/fs/ocfs2/aops.c
> >>>>> +++ b/fs/ocfs2/aops.c
> >>>>> @@ -2294,18 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>>>  		goto out;
> >>>>>  	}
> >>>>>  
> >>>>> -	/* Delete orphan before acquire i_rwsem. */
> >>>>> -	if (dwc->dw_orphaned) {
> >>>>> -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> >>>>> -
> >>>>> -		end = end > i_size_read(inode) ? end : 0;
> >>>>> -
> >>>>> -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
> >>>>> -				!!end, end);
> >>>>> -		if (ret < 0)
> >>>>> -			mlog_errno(ret);
> >>>>> -	}
> >>>>> -
> >>>>>  	down_write(&oi->ip_alloc_sem);
> >>>>>  	di = (struct ocfs2_dinode *)di_bh->b_data;
> >>>>>  
> >>>>> @@ -2326,44 +2314,56 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>>>  
> >>>>>  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
> >>>>>  
> >>>>> -	handle = ocfs2_start_trans(osb, credits);
> >>>>> -	if (IS_ERR(handle)) {
> >>>>> -		ret = PTR_ERR(handle);
> >>>>> -		mlog_errno(ret);
> >>>>> -		goto unlock;
> >>>>> -	}
> >>>>> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> >>>>> -				      OCFS2_JOURNAL_ACCESS_WRITE);
> >>>>> -	if (ret) {
> >>>>> -		mlog_errno(ret);
> >>>>> -		goto commit;
> >>>>> -	}
> >>>>> -
> >>>>>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> >>>>> -		ret = ocfs2_assure_trans_credits(handle, credits);
> >>>>> -		if (ret < 0) {
> >>>>> +		handle = ocfs2_start_trans(osb, credits);
> >>>>> +		if (IS_ERR(handle)) {
> >>>>> +			ret = PTR_ERR(handle);
> >>>>>  			mlog_errno(ret);
> >>>>>  			break;
> >>>>
> >>>> I'd rather goto unlock directly without update i_size in case error.
> >>>
> >>> agree
> >>>>
> >>>>>  		}
> >>>>> +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> >>>>> +					      OCFS2_JOURNAL_ACCESS_WRITE);
> >>>>> +		if (ret) {
> >>>>> +			mlog_errno(ret);
> >>>>> +			ocfs2_commit_trans(osb, handle);
> >>>>> +			break;
> >>>>
> >>>> Ditto.
> >>>
> >>> agree
> >>>>
> >>>>> +		}
> >>>>>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
> >>>>>  						ue->ue_cpos, 1,
> >>>>>  						ue->ue_phys,
> >>>>>  						meta_ac, &dealloc);
> >>>>>  		if (ret < 0) {
> >>>>>  			mlog_errno(ret);
> >>>>> +			ocfs2_commit_trans(osb, handle);
> >>>>>  			break;
> >>>>
> >>>> Ditto.
> >>>
> >>> The existing code still updates i_size even if ocfs2_mark_extent_written()
> >>> returns an error. I am not certain whether updating i_size in this case is
> >>> correct, but I prefer to maintain the original logic for now.
> >>> Does that seem reasonable to you?
> >>>
> >>
> >> Since it returns 0 for unwritten extents, it looks fine.
> >>
> >>>> BTW, we can move ocfs2_commit_trans() rightly after ocfs2_mark_extent_written()
> >>>> to save the extra call in case error.
> >>>
> >>> agree
> >>>
> >>> I ran a DIO test using 64MB chunk size (e.g.: fio --bs=64M), the dwc->dw_zero_count
> >>> is about 12107 ~ 12457.
> >>> Regarding the transaction splitting in the unwritten handling loop: this patch
> >>> introduces a minor performance regression. I would like to merge some of the
> >>> transaction calls. e.g.: by starting a new transaction every 100 or 200 iterations.
> >>> What do you think of this approach?
> >>>
> >>
> >> Seems we can limit max credit for a single transaction here?
> >> If exceeds, restart a new one.
> >>
> >> Joseph,
> >> Thanks
> > 
> > sorry for the late reply, I spend some time running the tests.
> > I have created two different types of patches (see below) to address this issue.
> > 
> > time consumption results:
> > 
> > ocfs2-dynamic-... patch
> > real    2m9.900s
> > user    0m0.333s
> > sys     0m22.687s
> > 
> > %200 of ocfs2-split-trans-... patch
> > real    1m48.901s
> > user    0m0.306s
> > sys     0m23.019s
> > 
> > %500 of ocfs2-split-trans-... patch
> > real    1m49.350s
> > user    0m0.299s
> > sys     0m22.718s
> > 
> > As shown above, the fixed "500% mode" is faster than the dynamic style.
> > Which approach do you prefer?
> > 
> I'd prefer solution B, it looks simpler to directly set a commit batch.
> Some comments for the formal patch：
> 1. I don't think you have to use 'cnt + trans_start + mod' to control
> the batch commit, just check 'batch + handle' seems enough.
> 2. Define a macro for the batch, e.g. OCFS2_DIO_MARK_EXTENT_BATCH,
> 3. Do not update i_size in case error.
> 4. Correctly handle commit transaction in case error.
> 
> Thanks,
> Joseph
> 

I hope I understand your point correctly.
creating and setting OCFS2_DIO_MARK_EXTENT_BATCH to 800, corresponding to the
%200 used in my previous 'cnt+trans_start+mod' patch.

the time consumption:
real    1m50.508s
user    0m0.365s
sys     0m22.829s

```
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7a65d5a36a3e..4e3a51e86e32 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -37,6 +37,8 @@
 #include "namei.h"
 #include "sysfile.h"
 
+#define OCFS2_DIO_MARK_EXTENT_BATCH 800
+
 static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -2279,6 +2281,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
 	int ret = 0, credits = 0;
+	int trans_err = 0, wanted;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -2295,18 +2298,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
 
@@ -2341,11 +2332,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	}
 
 	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
-		ret = ocfs2_assure_trans_credits(handle, credits);
-		if (ret < 0) {
-			mlog_errno(ret);
-			break;
-		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
 						ue->ue_phys,
@@ -2354,17 +2340,46 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 			mlog_errno(ret);
 			break;
 		}
-	}
 
-	if (end > i_size_read(inode)) {
-		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
-		if (ret < 0)
-			mlog_errno(ret);
+		wanted = jbd2_handle_buffer_credits(handle) + (credits << 2);
+		if (wanted > OCFS2_DIO_MARK_EXTENT_BATCH) {
+			ocfs2_commit_trans(osb, handle);
+			handle = ocfs2_start_trans(osb, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				mlog_errno(ret);
+				trans_err = 1;
+				break;
+			}
+			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				break;
+			}
+		}
 	}
+
+	if (!trans_err) {
+		if (end > i_size_read(inode)) {
+			ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
+			if (ret < 0)
+				mlog_errno(ret);
+		}
 commit:
-	ocfs2_commit_trans(osb, handle);
+		ocfs2_commit_trans(osb, handle);
+	}
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
```

if this approach is acceptable, I will send v3. 

- Heming
