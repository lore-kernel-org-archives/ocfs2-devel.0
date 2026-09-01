Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040EA389107
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 01:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788225393; cv=none; b=QbwJIwKCdeXUQmsQR3tNilB5rDNEz+uslqBoUeeTDSsDXwmqHb00gZqyTeO4LtAB85mLStVwpa9tCd7xeNfCO4vYzBV/deDV8U1Xghw6r3TAPadPeoxBHBxt2iHcI8vGYgmpXVfeeGu6jwn4mZoIMPC3BNbqgLwOrvFDYrBHVbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788225393; c=relaxed/simple;
	bh=nPaFhJ5bh81rQnYHWi18R3G/SlBdQwiZJ2sXZwzRAwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mznW5oRxVvapIQ+4sevPEwKA9sTqOhFJcb81RnEc5yF06tkBvwXAO5vgbYjoH1K73ItKR6w2YQNfYKzEqid/jB76Gc9AQ6x17d+l4YMGhMoKRhCWkRKLtOnUoDDXyW6zCMLDYZtUX1C0JTN0+ZjHDuBokzEOB0LtLH1euffSIzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e4nDNuGc; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e4nDNuGc"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4843907a4d5so201598f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 18:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788225384; x=1788830184; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X78DpyuVQCNYSBmXxws/u1WGsj/hOlLkVFIFIGfWSnU=;
        b=e4nDNuGcpF9X0Csb5WXtYOYvJXudae9ANOXPxqxhhmCH04Oxah/cbeciTfF7CKD+M/
         jo7TliASVY01CljpzAesdMCaA/DtbYe1a97maPeR4V+qoj2uCfT+3s/4rzPcdgD14FuN
         0vrXE38mCOGv4XXLRtUol4ajdgIM4keJUGcfCI0uqOMVh5tJ/Dadd6l598toXa/aAMDz
         sDf0Fz0q4Z2POJ8kHnCyiMUTOk/+NRd+04KopPAvHhFjmBTOszRvEIAFr7oHIsjGBBXz
         fluCxzwo+iPb19+bqaqsgTlxikZpmUEhxJl7FA+Y1ZabIeL2pLAsw1g3wqBX5gWrZslq
         NZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788225384; x=1788830184;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X78DpyuVQCNYSBmXxws/u1WGsj/hOlLkVFIFIGfWSnU=;
        b=P3gQmzcuqv7CZlDzBxW9WZbUE8BfTmOSH8ra7FHOVhuu4kcy/c0vnNI1eqLU8eRo8B
         8aePrByKpC3sRq8vRMgqnpxkm2UxzGnpHykis+FqE5KJnMYVSr9O7JtM2Wpya0sZSOJk
         +N95AcBiwYaHGZG/+0uBiJmgAWBnnkST51jDjpU0T79U49eiJ0ilanl7Iyh6zJPkeWqL
         hx+LpnumdXRa9z0VkkXAA5W34ptBdZrlyyy6eXDXvGdisZocty035ijYTTTniPJopwCA
         YmOza/k8g15nrmEJErRFBEf9EBOEGXmJL4CiZC4T7pELch8QCUSie8XT2OPwL/c/Mpti
         2xdg==
X-Forwarded-Encrypted: i=1; AHgh+RoBbfmqv+JMPsThNTGEx+NeyC8B0nXjTMrJqmirsWZmPlA7XWipac4L219BlvWs3gLHxSPBt+VXMAc8mA==@lists.linux.dev
X-Gm-Message-State: AFuF++nQ0ZuvhvpmjcSJuqC4+8nCErebmm5Rhrh4IDjcg2mBQKhe0O2O
	XCZDXz2CGp+iQySDDLMZRUvTKZtzox+lEicZ8dX2CIuGBZIOi6bgMJyv/eIGEcPXb8Q=
X-Gm-Gg: AR+sD12wcYecgVukIZwitSpO3ztCOL5aKmhwU6WClrbaJlEb5TivNT9rEqHEJWGntHh
	ko9+9K/mGqE7ZEambwbTMxZZ46pTasjHBo1EKTaZ2PICQ+P6J2uxOofUCcnlEz7hEU875mT+YSl
	O8CppXhS15DR/F8DH0EFHpwthm7VRj8pNxLXnmEazweytLE23DSTb8yfAw7vafwyHC2flKp5fXG
	qKGLP9eDiBWuIyfrB9E1rrfKVLnP0LEu380O/QEF3U1nyfaChK+YXyZWHNZen33soxFUcHCiavk
	Lyxso9oo/RchcCuE/lE8rd4mWrPEP88ayTYyr1cJ/mc8oGWBBtan7ZIeLk8CrqV/MifQ0rBFrTT
	+ngYDjKDLWx2GguFFJdNSXDSqJiLXMwI6R3bw9ZJvNQw/AtAbUSVyDPhtHKynVnIhYIX7iGNFem
	tYyH2eK5TNu/LQLdrWilcsuqo5OpcnPLGVt8PzSlbGra5JGdn5KXQCu4RQ6RY=
X-Received: by 2002:a05:600c:4686:b0:499:d95a:41f with SMTP id 5b1f17b1804b1-49b91bd68famr241492125e9.0.1788225384174;
        Mon, 31 Aug 2026 18:16:24 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d471e75sm2506061a91.8.2026.08.31.18.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 18:16:23 -0700 (PDT)
Date: Tue, 1 Sep 2026 09:16:20 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to
 system inodes
Message-ID: <apYnADntUmNwIgcj@p15>
References: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
 <20260831062848.2743436-2-joseph.qi@linux.alibaba.com>
 <apWJLyCNwqfdiRQb@p15>
 <fdd373d2-0c70-4a64-b2da-50f2dac194b1@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdd373d2-0c70-4a64-b2da-50f2dac194b1@linux.alibaba.com>

On Tue, Sep 01, 2026 at 09:08:26AM +0800, Joseph Qi wrote:
> 
> 
> On 8/31/26 10:02 PM, Heming Zhao wrote:
> > On Mon, Aug 31, 2026 at 02:28:45PM +0800, Joseph Qi wrote:
> >> ocfs2_validate_inode_block() currently permits i_suballoc_slot to be
> >> OCFS2_INVALID_SLOT for any dinode.  Only system inodes created by
> >> mkfs.ocfs2 are allocated from the global allocator and thus
> >> legitimately carry this value; regular inodes are always allocated
> >> from a per-slot suballocator and hence must have a valid slot.
> >>
> >> If a corrupted regular inode with OCFS2_INVALID_SLOT is accepted,
> >> ocfs2_remove_inode() will pass the slot to ocfs2_get_system_file_inode()
> >> and get_local_system_inode() will hit BUG_ON(slot == OCFS2_INVALID_SLOT)
> >> when the inode is deleted.  This can be triggered by an unprivileged
> >> user unlinking such a corrupted file.
> >>
> >> Reject OCFS2_INVALID_SLOT for non-system dinodes during validation,
> >> while still accepting it for system inodes.
> >>
> >> Fixes: fe7a283b3916 ("ocfs2: add suballoc slot check in ocfs2_validate_inode_block()")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > 
> > LGTM.
> > Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> 
> Thanks, sashiko has some review comments, I'll fix them and send v2 later.
> 
> Joseph

It seems sashiko review comments only go to the patch submitter/author.
In my view, they're also sent to ocfs2-devel@lists.linux.dev, which is nice as 
it lets others on the list see them."

- Heming
> 
> >> ---
> >>  fs/ocfs2/inode.c | 19 +++++++++++++++++--
> >>  1 file changed, 17 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> >> index 180107a11046..eda50f13ffb5 100644
> >> --- a/fs/ocfs2/inode.c
> >> +++ b/fs/ocfs2/inode.c
> >> @@ -1520,8 +1520,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
> >>  		goto bail;
> >>  	}
> >>  
> >> -	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
> >> -	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
> >> +	/*
> >> +	 * Only system inodes created by mkfs.ocfs2 are allocated from the
> >> +	 * global allocator and thus legitimately carry OCFS2_INVALID_SLOT.
> >> +	 * Regular inodes are always allocated from a per-slot suballocator.
> >> +	 * If a regular inode with OCFS2_INVALID_SLOT was accepted here,
> >> +	 * deleting it would pass the slot to get_local_system_inode() via
> >> +	 * ocfs2_remove_inode() and trigger BUG_ON(slot == OCFS2_INVALID_SLOT).
> >> +	 */
> >> +	if (le16_to_cpu(di->i_suballoc_slot) == (u16)OCFS2_INVALID_SLOT) {
> >> +		if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)) {
> >> +			rc = ocfs2_error(sb,
> >> +					 "Invalid dinode %llu: suballoc slot %u for non-system inode\n",
> >> +					 (unsigned long long)bh->b_blocknr,
> >> +					 le16_to_cpu(di->i_suballoc_slot));
> >> +			goto bail;
> >> +		}
> >> +	} else if ((u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
> >>  		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
> >>  				 (unsigned long long)bh->b_blocknr,
> >>  				 le16_to_cpu(di->i_suballoc_slot));
> >> -- 
> >> 2.39.3
> >>
> 
