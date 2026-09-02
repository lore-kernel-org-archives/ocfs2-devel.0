Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C8F3AAF58
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Sep 2026 20:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788382371; cv=none; b=q2wCDLag3j/DMDEiMfo9M75G39sRrmqewHjQxHGFF6esjQQY+Ot6w5XV6+yuVM1crrFQwxJz18VpvrFzCaFGq6M24H7RNzjAHK8LNKPeKskmay0PN66R9WaDhACfL2vY0ZXcxLMhWhiIKcNRlu3X3Iyh39J/UiSgBmwxu/hf8BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788382371; c=relaxed/simple;
	bh=/BadFUsA3OstmHGhfK99QbnF/NkulvL8khR/iLpaHno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JY1sRI9jpeLaovGSNMtKQMkBolQ605LLz97Kz9zSTxSoDjMHRk2qkJLTRq5KDcKUQiuZQNqRqiQkoKnzgl+qLMZgpl+5t28z2r5OMi8jliwnn9HKKjepz6zwxa5Q/i+funDDPDcz5fPhsCXJY1JU9jE6QZfhiuxCBNdamPDTFhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GWppZuRf; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWppZuRf"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8520161fdb9so1967981b3a.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 02 Sep 2026 13:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788382369; x=1788987169; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VXjufAEosIj1q8FXumUFsTj098OQ/YAIZCUC7EsihNw=;
        b=GWppZuRfN+nUS6ech2iXZGNwZ2eiRRsbahInHEw7X6pDHiLxv6EZ5SxBtV1SHFtlcb
         tUx5gFIeuKncHFUtjQKTYamhgcze6OSkH2trkNsS6iP1AtJDay//BGo+Vbu6v6DYxE52
         ChwN/Jcppa9k2DfS5Rt5DrT48Hc95Km4fzdYQVIuEdk1ue6uuq1IwkRMJo+XFqz+7d/t
         kEpGf8R4hXNeTNALM6N6mNeoHxCHuTpydi9ATQkPuL9X2SAjlaQJyNZdWPC7d/U6tVkl
         P5fB0MVDmNufPngu53f8vlOB/+84Tk2ZWTQE0+wW3AG9kQx3bysdni40oAL0HkYoGEKm
         ft0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788382369; x=1788987169;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VXjufAEosIj1q8FXumUFsTj098OQ/YAIZCUC7EsihNw=;
        b=D7AamYzNhcXUGup+QCxvjxtzy1OtoRaHy0jRwRWbdhdD/TFyg1jEPh5wnQnCLm2M8m
         RXQ+zeJd81IRBwk83U4WPoAP94ePiOkcoAPg/xhEh4kCEEmtI9wwlI6NBBDonJVvUYvN
         9jfzq6tG93MWni4phPsDGy4CJ0Ktpe/GnRfbr3QKUaWPS2C7VPTNe84QBUPoiX3tG0kV
         FZ4Ii2HQdsoNMuZnm/5yegPh7c82Bmeu5I41fSxU+RF88Eqv6dCk4Q+RNHHyqOa6gKBx
         88M8payjwxtk4fgqpOWrHCfbB+3taAUcUn9JMPRQSILX4U5PmTPwOjfSF/vRjlmwStu5
         LzkQ==
X-Forwarded-Encrypted: i=1; AKwUvBwK0lX2BO+2gn2+eDH+Yh8bk3aWQhthZuz/oHxIKF+vJr1q3XII3y/YOAQAFyNCWO96XcHIK2gmP/XDdw==@lists.linux.dev
X-Gm-Message-State: AFuF++khUudP9ORX79OH0pLVMAieDj98pxodz7beEa8frPMqbaQNtCEd
	TrbBOIIC6JkIhIFtwW513iZZ1mSRMxQPDnGUv2USZRpD5qPnBzZIC9uY
X-Gm-Gg: AYBFou3txsO/+vSO1MX4GiqAX7gFQnWgIO0NoF4WTfMd6wAsv55ju6nDi5TrYBSntyQ
	eXEFCQqgmVcoJA2jz5mT+surggeCtLpfcsjZUUv4piIGDlxyyA2a/OhBJ3j2wYR4m0BE2avZa9k
	pToIbZKqHA4SSdfqi0Wp31ZqMLrMZYulENtonCh/b+wybMRF6HjsbvMBN0DTxoR0whzcpvtqf8i
	f+5Arp8M/0l6S0f58nefECZcNnBe+BCS35Wj3LCpepucsgQPwTuQGvLw3CPIOTDaAqIh/hwDslq
	ds8b2/5+s2zkxMSXybnMpDmIrxJM0EGuMWNTtLxypbM//h8bcFHk81LJnrb/WMVMlC1j8xZy8wR
	g3iPw17hOmrHvx5kaGNymYpmWX0KKkUA/puUnDFOHsKG6skp9YMiScE0IN6868DZjkCMBb3k+nE
	2Jxh4cIxdNQs9ao240R/LPUxE6ryGFRth37k7l/EwcJAplGAVOwx73/YY3yFKEVCpX
X-Received: by 2002:a05:6a21:6004:b0:3d0:88f5:f813 with SMTP id adf61e73a8af0-3d9b05238admr12663995637.11.1788382368648;
        Wed, 02 Sep 2026 13:52:48 -0700 (PDT)
Received: from user ([2405:201:c052:b00b:4bb2:9d5:1e62:39c6])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3325592d9c5sm642702eec.11.2026.09.02.13.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 13:52:48 -0700 (PDT)
Date: Thu, 3 Sep 2026 02:22:24 +0530
From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Srikanth Aithal <Srikanth.Aithal@amd.com>,
	Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
Message-ID: <apiMiLlwujmqyYLP@user>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>

On Wed, Sep 02, 2026 at 09:33:57AM +0800, Joseph Qi wrote:
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.  Submitting such a buffer during journal commit oopses:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>    jbd2_journal_commit_transaction+0x932/0x1b10
>    kjournald2+0xb2/0x250
> 
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=writeback.
> 
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
>
Hi,

I was working on a fix for this syzbot report [1] and didn't realize that you were
already working on it. I noticed your patch on the mailing list, so i won't
send a duplicate patch.
 
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")

Could you please add the Reported-by: and Closes: tags from the syzbot report
to your patch? This will help syzbot associate the patch with the reported
issue and track the fix.

[1]: https://syzkaller.appspot.com/bug?extid=41453ea05ab61c075f1f

Thank you,
Pavan

> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/buffer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +	    op_is_write(opf))
>  		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  
>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
> -- 
> 2.39.3
> 
