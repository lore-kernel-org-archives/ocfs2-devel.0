Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E24B2E7389
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 07:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780299706; cv=none; b=r1E8peuPvc01iz7xB6Ml4bZiemDdO3ef1KUtk3WjGRyys1kFKX//acalEIrJVoFYqwbwa5WT7m3q5MxnfxqbsVZgelHxBOYwB9XM4IFlo8DTU14BjFbXZjOGRPWMAb2v/OREGOXAD5TLJJxRczl7E3cGM7sot5U0Kdg97Ifq9D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780299706; c=relaxed/simple;
	bh=3HrW05YbTvZNEhfW1lK9iWLfR6sVRdLfNdGvlZMSeRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OiSRUPDap4U5PlM9cRM+6sWrVr9gyrlJ8Km0dqJ0EtRMPNUr/7HnHMmwPslWk/K7Xu+pqWktaWgtR2gfGYi1AtB3C4g/xBXznlxXi80IXktOC9TCgU/+K+NYZhPb0YRtab9DDZ27j8JpQzpaM5PuD/lALuy+M8hRciJq5s5d5ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aOUCIROH; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aOUCIROH"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49048f70faaso7992705e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Jun 2026 00:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780299702; x=1780904502; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kS1ypxnVv61QoYz2k4MQaxM89Rj7Jk+DUA2Ar1EHnys=;
        b=aOUCIROHqfrdOGww/4l+LxKuOJNJW/w6V799BP0Q0viLrAvROlFpoXKV4OZ2Qrxxvn
         kSSXKXnwrEaOZbjGT51BREZdcHEo+4CmAu47k4dyfuqnQ6bJIh5jDPoIZMX8QWRnqlKb
         uIrw8LJLAVzM5bT/hpeSy47jl2E/Hc0XDDsJPAlmbNQC2zPJ/EP70d/+k82GU36A5tkc
         9X+Cw5yjePVkHUR2jrJbKJ+vl6cfANFvTU4eA15GJ5QnjP+TeepKvfzYUiozNPbzO6UQ
         aTrHCFTwao93zq4HUXM1CU2b32m0XprhgmowMiQyh4qm3u0j2jkMfRth9V2hNXtjOK+A
         +F3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780299702; x=1780904502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kS1ypxnVv61QoYz2k4MQaxM89Rj7Jk+DUA2Ar1EHnys=;
        b=Ye+iuchSUaDzQm0Ot3WoMKL+WpyY9+oc6wofjZBIzQQSM2+qZyYJ5pwts00n08LrUZ
         GqBR+4DpXnxde0/SqrMonxcV/vicYE+KPd7DeLv7O64OTQdYE7QL4Lf9wyc1wMNsx8fw
         vAIJgsTB787ZSxgV+Ub7x3s49Kfy00R0vKKRft3FB+zQ/BBRhpqJfZkJKHKbuoIFcfFY
         fAosrohXU0stQ8gjN8TPB8+dk8ELVkvZVP0xq698HpE9KfnaWasBUEUk04i3uuEZpc3r
         IJR/NF8cwZwe7ZePfAiaOguEyMtAaRu4Sotf1/TZp60t2gGah97YobnX8GmSwXBCTqz0
         soig==
X-Forwarded-Encrypted: i=1; AFNElJ91rQWz+xlYF2uhLeHXL8+puyNtl6LTwP6tOFya9KGxQMmDPLIwaO91ibp1xKe0bmZ/7qUi4rFtvqTiYQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxNA8dCDOWSPiv/jwKJdWEtbXfJdFUs5NmBxyEDwqgHqHalJkGy
	pVMocqsRticdX9KQMrC9bt0MW7mIAa8iEHDyXsz0dLApyPl7mu/cWLNqY5MZtEUP0EiOkaTCJy+
	D/En1SB4=
X-Gm-Gg: Acq92OF7cugWlBhp8PdHRgliByXdPn7+15dMlwEBlvYKRHIIAmiHKlgG28LvF5Y1YCP
	0ZDMbvJw16AMPUNDceDWZmR3v/vZL8FiGeMs5OuEvVMmLhgnSJASPlDrh4RSoXJxlsuEEnnpap3
	IZEknFHH2WHdXJbHrulxgB1KwXb6J4YDHX+Yb/M3kzjeKM21AN0pPQFwLHl2uljoR0luQN1CaQl
	fev0ei41i7rDZFDe56asKBzsN1Y//BcCauElEaJYSkImqtY+iCUeEIJyrsYlJGmza4iJ2bu3i/z
	I1e7bGqzm8tMa21h/0kExrv35bF52XWlCkFkla0+ylzRs882O/D8EXXG3FUAZvqiibo7ZO1460R
	JLH2GHUiieyyAzPZ6w7wy1FU6t2ByxqTYZidc8dhTMpYVubeRXZKUu+cRjeK8TaaZGJza8xCkpB
	BriLfnt6RbVcyTyEnhyg7xYiSNQF/h90Ra
X-Received: by 2002:a05:600c:1382:b0:48a:5664:f44a with SMTP id 5b1f17b1804b1-490a29e431cmr76061195e9.2.1780299702093;
        Mon, 01 Jun 2026 00:41:42 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23b001a8sm98422115ad.40.2026.06.01.00.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 00:41:41 -0700 (PDT)
Date: Mon, 1 Jun 2026 15:41:38 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Farhad Alemi <farhad.alemi@berkeley.edu>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
Message-ID: <ah03j60hzqr3WFWn@p15>
References: <20260531131645.3650299-1-joseph.qi@linux.alibaba.com>
 <ahz8oSUC5GXrJM_b@p15>
 <48b50de9-0047-416f-b09d-6e2e0fdeb70d@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48b50de9-0047-416f-b09d-6e2e0fdeb70d@linux.alibaba.com>

On Mon, Jun 01, 2026 at 02:50:56PM +0800, Joseph Qi wrote:
> 
> 
> On 6/1/26 11:32 AM, Heming Zhao wrote:
> > On Sun, May 31, 2026 at 09:16:45PM +0800, Joseph Qi wrote:
> >> During unmount, ocfs2_journal_shutdown() frees the journal and sets
> >> osb->journal to NULL. Later, when VFS evicts remaining cached inodes,
> >> ocfs2_evict_inode() -> ocfs2_clear_inode() -> ocfs2_checkpoint_inode()
> >> -> ocfs2_ci_fully_checkpointed() dereferences osb->journal, causing a
> >> NULL pointer dereference.
> >>
> >> Fix this by adding a NULL check for osb->journal in
> >> ocfs2_checkpoint_inode(). If the journal is NULL, it has already been
> >> fully flushed and destroyed during shutdown, so there is nothing to
> >> checkpoint.
> >>
> >> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> >> Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
> >> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> >> Tested-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> >> ---
> >>  fs/ocfs2/journal.h | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> >> index 6397170f302f..f8b3b2a3d630 100644
> >> --- a/fs/ocfs2/journal.h
> >> +++ b/fs/ocfs2/journal.h
> >> @@ -196,6 +196,9 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
> >>  	if (ocfs2_mount_local(osb))
> >>  		return;
> >>  
> >> +	if (!osb->journal)
> >> +		return;
> >> +
> > 
> > In my view, the code is correct for this bug.
> > However, the if condition is insufficient if ocfs2_journal_shutdown() sets
> > "journal = NULL" immediately after this line.
> > 
> During unmount, journal shutdown happens before final inode eviction is 
> triggered by generic_shutdown_super() -> evict_inodes(). That means they
> run sequentially in the unmount path (same thread context).
> 
> Thanks,
> Joseph
> 

Thanks for the explanation. I will provide my Reviewed-by tag.

Based on the call stack in Farhad's email attachment, it seems the test case
triggered the if (osb->slot_num != OCFS2_INVALID_SLOT) condition in
ocfs2_dismount_volume() to skip the released slot_inode.

Thanks,
Heming
