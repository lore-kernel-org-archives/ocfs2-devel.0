Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B91400E0A
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jun 2026 15:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781536178; cv=none; b=cECxfifD9Zb55v0g4Cyim5M8jk8aylG5mcfxNAV3mv8hsK8BCAmCLrf/McBPEL7rn5EhW0U4r9QUvSRfd+DiF9BrJnsMSFg7T7hvQCALmEJ9rvcWaruJEOcAgaU5SQN7lVLkNoySemBPjJW/sBSV3t7SyMgynR7e2aanMRkIs80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781536178; c=relaxed/simple;
	bh=ni84w/01+N3dJ3ED+7jfXvZ9Q1gy2jaETrYrPpi4hcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVK1W4BZVgIOlu0fJWrv9hf+R3xkwG5GQBs5DxLM+sEv9NLohFRfpGIC2aOKAnoU8HEfJaC+MgOa6FuHaMGFtYPzLNFEpwuIDGGylwnCdyn8wXldFrbYmXiYUjXBeV0ptHb4VL7QG8YOfF2nZ/IQJFUAOYEBzLJnqIL7I14Jp8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WNcuC6T+; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WNcuC6T+"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490d6730461so3657075e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jun 2026 08:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781536175; x=1782140975; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eUEkUrsanBqZijxmCAC0JPoHe2szL/h32mFkqnSHjAk=;
        b=WNcuC6T+2QRHcwfZ0R1H0E0lOXPE6AagsGerH1mIuw+4WKWN7f4M7m3OtT4VHGuBsF
         QrTPtv8YIt2wGiMRJO/InQJk/naYZddLqZEHZpmhm9xSxCNp+9i//DhKWRL6ff+ghFpe
         0B+6yfOuqF0sssDU7zH3IlqzmHaEVOmXy9ryN2w4kfIDxj2cNVopo0X87dHolSZV5Mtx
         IaoERiMeO+Ij3Ebez955I2CpMpLKnybAI6Lioa6urX/bWfn1Hxhmo36CLK+xojw9ISOc
         IpKoB+2PDO7IGjDDrK5EzOOAfOc7yda4Fo9NzJfdtLoEVZCWDCRR7/CIR6ttbyE/279j
         zQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781536175; x=1782140975;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eUEkUrsanBqZijxmCAC0JPoHe2szL/h32mFkqnSHjAk=;
        b=GzT+kPUIxPdV10I3GhZhoMAxCkYZlwpxuEGhGbOGVhN5nyqb/GB7sBOuvs5/AKhLn6
         ggfGMDGsSQlemgT4nxzsd0T7tbFnlPh6ochrTWtAUMpj5nBi0PoZ9bL/q8NRchLq/s3C
         7+pGNrJynCunMIqPvfHGV+hovykdTnUO7Me+gRLPtICUpxeCzN9p85V3/kJnmShm9MvC
         tbMfuo8pOXQ859I8IyjHK5D5h59Qw8eRkPkHX5B8CdYgPGgcLvq1/WqVTQ3E8Bwyd70u
         bTqHuN+9OONFKfSQ/1ISYEjtS6hyQb9Tbkf4r6VldTkXg5DwV6Hovu+tMw20b3/qM0dI
         JwuQ==
X-Forwarded-Encrypted: i=1; AFNElJ9U3+3XVXNIxZ8VfYTurwdejR2/IssMvBMRGbKBnLy15om8BsQCP/cBn97cGZVdsqbrVLJAaycjbX9BoQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YySGK+pi4Q6KzyUqTQnQnIDwnNB6irTJv0mNNaXRnqxQ7Xb2YYt
	QSrQmiFOssQZHrpDzZQjVOP/W+79R1PK/R6Ib6lFjKl7pamF2Z5QlOpKzkVdDPKS19Y=
X-Gm-Gg: Acq92OGjk1BD7hxtEDAHXOBLynMwruvTAyhSrQkLlkJ0ju2FyOI5HDpsQYHPl8z9Una
	9kTiPmtQkvk7REZUD0d4abiD7iWztne/LCoCGBdLRYdbwGgfNxLxNFvEUgzDs/sHNz2ICzXFS8A
	9iyt1HVOfBoIr5Uxv7GZ7706wHe8jcpbhberwXQs5DjnY5MIkZbiZO3SKMWktw9cfPlbaxUjyCv
	BkODkvADHah6d30j9IfbJZAFrn0p/mlWo3JEg0Q3a2jIzfKfFZPt4By6TU+hqtQVcXP8sTvuYWx
	+B6QvaO6lYB97NQXYP9sYTDDpAiNgVrjH2WvPyoi9x3ouRgaaP46G1GvkhG58cIE5zU5TH6OjeN
	GjypcOF5luIffSAQYZlXEVgL50pkMpWBr96dSfA3RyfsxfdQC/pmVNDFf40vrx6gFDh8GDdy6m0
	jeV0F+e5yPwTuPL0UD+rpRJrnjOINLd12x
X-Received: by 2002:a05:600c:4745:b0:488:7e7b:dbc2 with SMTP id 5b1f17b1804b1-490ec4fd3e4mr93700105e9.3.1781536175225;
        Mon, 15 Jun 2026 08:09:35 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081e5d810fsm15466767eec.12.2026.06.15.08.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 08:09:34 -0700 (PDT)
Date: Mon, 15 Jun 2026 23:09:31 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Marco Elver <elver@google.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com
Subject: Re: [PATCH] ocfs2: fix orphan inode disk leak in ocfs2_dio_end_io()
 on I/O error
Message-ID: <ajAP6648UpilAPXz@p15>
References: <20260611150341.3964327-1-elver@google.com>
 <aitf5rampsYpes2t@p15>
 <aiwCgXY4tChR3MiU@elver.google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiwCgXY4tChR3MiU@elver.google.com>

On Fri, Jun 12, 2026 at 02:58:41PM +0200, Marco Elver wrote:
> On Fri, Jun 12, 2026 at 09:27AM +0800, Heming Zhao wrote:
> > On Thu, Jun 11, 2026 at 05:01:50PM +0200, Marco Elver wrote:
> > > When an extending direct I/O write or a direct I/O write racing with an
> > > unlink is initiated, ocfs2_direct_IO() places the user inode into the
> > > system orphan directory and sets the OCFS2_DIO_ORPHANED_FL flag to
> > > ensure defined behavior and crash consistency.
> > > 
> > > However, if the direct I/O request encounters an error or gets
> > > asynchronous cancellation (bytes <= 0), the VFS completion hook
> > > ocfs2_dio_end_io() bypasses ocfs2_dio_end_io_write() entirely and
> > > executes ocfs2_dio_free_write_ctx().  This completely omits the teardown
> > > of the orphan entry, leaking the user inode in the orphan directory and
> > > leaving the OCFS2_DIO_ORPHANED_FL disk flag set.
> > > 
> > > Because the OCFS2_DIO_ORPHANED_FL flag remains active, subsequent VFS
> > > final inode eviction (ocfs2_delete_inode) observes the flag, assumes a
> > > direct I/O write is actively in progress, and refuses to wipe the inode.
> > > This results in an irrecoverable disk storage and resource leak that can
> > > only be reclaimed if the cluster unmounts or crashes.
> > > 
> > > Fix this by ensuring that ocfs2_dio_end_io() inspects dw_orphaned even
> > > when an I/O error occurs, and executes ocfs2_del_inode_from_orphan() to
> > > liberate the inode before destroying the in-memory write context.
> > > 
> > > Fixes: 5040f8df56fb ("ocfs2: free up write context when direct IO failed")
> > > Assisted-by: Antigravity:Gemini
> > > Signed-off-by: Marco Elver <elver@google.com>
> > > ---
> > >  fs/ocfs2/aops.c | 17 +++++++++++++++--
> > >  1 file changed, 15 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > > index 4acdbb70882c..ad3f2057e26e 100644
> > > --- a/fs/ocfs2/aops.c
> > > +++ b/fs/ocfs2/aops.c
> > > @@ -2419,11 +2419,24 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
> > >  		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld",
> > >  				 (long long)bytes);
> > >  	if (private) {
> > > -		if (bytes > 0)
> > > +		if (bytes > 0) {
> > >  			ret = ocfs2_dio_end_io_write(inode, private, offset,
> > >  						     bytes);
> > > -		else
> > > +		} else {
> > > +			struct ocfs2_dio_write_ctxt *dwc = private;
> > > +
> > > +			if (dwc->dw_orphaned) {
> > > +				struct buffer_head *di_bh = NULL;
> > > +
> > > +				if (ocfs2_inode_lock(inode, &di_bh, 1) == 0) {
> > > +					ocfs2_del_inode_from_orphan(OCFS2_SB(inode->i_sb),
> > > +								    inode, di_bh, 0, 0);
> > > +					ocfs2_inode_unlock(inode, 1);
> > > +					brelse(di_bh);
> > > +				}
> > 
> > Calling only ocfs2_del_inode_from_orphan() without ocfs2_truncate_file() will
> > leave stale blocks beyond the EOF.
> 
> Right.
> 
> > I think the existing OCFS2 code already handles error/crash cases for orphaned
> > inodes, and this "leaking" behavior is by design.
> > please refer to ocfs2_recover_orphans() and ocfs2_add_inode_to_orphan().
> 
> Periodic scans skip direct I/O entries to avoid racing with active
> direct I/O on live nodes:
> 
> In fs/ocfs2/journal.c:ocfs2_orphan_filldir():
> 
> 	/* do not include dio entry in case of orphan scan */
> 	if ((p->orphan_reco_type == ORPHAN_NO_NEED_TRUNCATE) &&
> 			(!strncmp(name, OCFS2_DIO_ORPHAN_PREFIX,
> 			OCFS2_DIO_ORPHAN_PREFIX_LEN)))
> 		return true;
> 
> Is something else recovering them?

Searching for ORPHAN_NEED_TRUNCATE, i.e.:
- ocfs2_recover_node() calls ocfs2_queue_recovery_completion() with the
  ORPHAN_NEED_TRUNCATE flag.
- ocfs2_complete_mount_recovery() calls subroutines with the
  ORPHAN_NEED_TRUNCATE flag.

ocfs2 is a cluster fs. When one node crashes, another node handles the recovery.

- Heming
