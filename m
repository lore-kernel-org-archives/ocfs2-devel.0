Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E63E5572
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Jun 2026 12:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269131; cv=none; b=oDF3JP8htezGL9EfeiPLAYvc+RnPZt4PIJ4KoEUjfDPT49x3gpjqisqwJ77nWvwsJev69ldL3F99/soY6QaxzOu1ZdLai2bfN5s1YyGQg1DMMEoM4eP3kt9shxP8eLBqI9gdEQk7FwVGA1AbSqlIFSzteHChsbOUo5BZC8I8B1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269131; c=relaxed/simple;
	bh=Pqfx17+79DuqSVcb+AsRH4WiOpNiLOxJmuWGiTA4Zlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjScA0rpWRySL1laJ2IpNbrGazD5QNm4U3iyFdWMFJOySFrktCubt0QmX2TwbiXmrou+1y1M4gxLCMdymS2/KtJnby69rgqucra54T7yF/G4q6jAAIKuOdACu0jRDw9bHdqVq//YRpW+fa/t8ApKSPKN4AHVRQUX7y+ZpCoz7/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J3eCFMPn; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J3eCFMPn"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4602e2a0372so723153f8f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 12 Jun 2026 05:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781269128; x=1781873928; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59wd4/+QBimDuJWgIi3+urwJ4PUefXw1ZXMMO24I54E=;
        b=J3eCFMPn6/JsrtAXMmLfCkhGFfeo4adQWsANIyy08UVRD8yJwbxqKNQK1/DVPx2ib3
         0ksolKbs+6vxAmHbcrb+iYqzq58jT9Ykz77Eau8zk2+SaaNHEsr5RZlVJXhkTbz+AtK/
         Gm8/mfqNMarTs/0/92LboGsf3wQZdwLAMUnC+m8Opwq2PXnn4g0X+YTClYJmyQfg16xA
         QDT5HXU0voOCau1aKcV7qqbkEsr+mtuDj1q5nDCbbK790c6nBYtc9bGQWjjG3UczKKU8
         iMWr4c0hAPuv11dvn7TLzjkRAsfZfwOcNV05+yhuLRKLUfzmjz5OFxFaO0h2dCdlGZKO
         rPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269128; x=1781873928;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=59wd4/+QBimDuJWgIi3+urwJ4PUefXw1ZXMMO24I54E=;
        b=Qq4JJPoAxM+3pHA3AtvmMl/M+zB9Cf87Y3Mz2qK2HWHgIbiDhAhOjC/hFZbLRnV/ak
         mjNFbxzWyPiSIVB1tPq523HgX7eV4zSIF9hud/MdPhAhDteLUuRZdVzJn+J3v+1SLM05
         YL/Mhj5o2FnF3o92sGrjkeF9hFlyTzkk9r2+3iocTNoAP38Py4dj8Yhmu9Hvf4RcJ+v7
         HY0YdlLUh1BIcJRsTJV74Wsyg+EtYDGo+EsdwLfoRGwyWupSn5I3/s1DGGUu5ayyCdTy
         jF9wEvRjui4ChTtcLHmVDjJ33QFgkBwPjRkSyqlxUHcZYtpzyFzf9XP+2RYkW5iYNkNv
         o7uw==
X-Forwarded-Encrypted: i=1; AFNElJ+FubQNYakZl5aDuuAneVLWE1QX1S8cL0tndU+XxScWXmPBk6pkELhXu43pPJiMs7NQuw9+uu8ExHZtzA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwwMbpLfQyU5RRwfFTbBlJitqIXP+QAonri/yeRcIEfGO3MbWTf
	M8Id4DrDE1cB+m0wbIoThsngLwkL/Q5mYhw0u8kLhh/YgPX44RSKoR/OjH1cQrpU0g==
X-Gm-Gg: Acq92OEmxfiNR2qEL0i/ZpvVlXc5qXz4SE+GAAFZhjsFG8mD7JV7I3SiA5/hcXjuZPb
	2c9L+QISsd+JBbzSfP62WyLFW1xo972Onat8KbM2ss3rHu2rxdgzGzc8ngQeaw9ahrCT8yMN1yF
	yfBxrhX89MIHRyWGC7+BQCKsCtU3h5l4iEV8hb80iO1QbXG50Dclm87UqqB341dlBwr6BwO3783
	rKnuAN6b2v8rMi/NPGyr7LjNHSQwnlxsilkErqTgitGWFDr7az9Fng2m4UEjIawujB1v3NDWfwD
	FxZfMUOB81Ckkosw+5wLLas1SzVd21S2AehUZqwkgWqyRlRklk94SxLOzqG1W9VobkVul9W4HAb
	1EQ/VAg80LHWzXyRuRdDBEubfaum4Csef1kavUH+VxZaqKn+42Z1LY1KOzu+k/QDW6CvudAA2HD
	aOyDgy4KvMK7YzUtmhI8SYgtUpG2/9H/P+NHIJBrg4TZRBNJqjADmSycSmL50=
X-Received: by 2002:a05:6000:40cf:b0:446:db72:e8ec with SMTP id ffacd0b85a97d-4606dbdf6b3mr4287095f8f.23.1781269127976;
        Fri, 12 Jun 2026 05:58:47 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:46c:4c2e:b5ff:53ca])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2d933esm5821770f8f.33.2026.06.12.05.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 05:58:47 -0700 (PDT)
Date: Fri, 12 Jun 2026 14:58:41 +0200
From: Marco Elver <elver@google.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH] ocfs2: fix orphan inode disk leak in ocfs2_dio_end_io()
 on I/O error
Message-ID: <aiwCgXY4tChR3MiU@elver.google.com>
References: <20260611150341.3964327-1-elver@google.com>
 <aitf5rampsYpes2t@p15>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aitf5rampsYpes2t@p15>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Fri, Jun 12, 2026 at 09:27AM +0800, Heming Zhao wrote:
> On Thu, Jun 11, 2026 at 05:01:50PM +0200, Marco Elver wrote:
> > When an extending direct I/O write or a direct I/O write racing with an
> > unlink is initiated, ocfs2_direct_IO() places the user inode into the
> > system orphan directory and sets the OCFS2_DIO_ORPHANED_FL flag to
> > ensure defined behavior and crash consistency.
> > 
> > However, if the direct I/O request encounters an error or gets
> > asynchronous cancellation (bytes <= 0), the VFS completion hook
> > ocfs2_dio_end_io() bypasses ocfs2_dio_end_io_write() entirely and
> > executes ocfs2_dio_free_write_ctx().  This completely omits the teardown
> > of the orphan entry, leaking the user inode in the orphan directory and
> > leaving the OCFS2_DIO_ORPHANED_FL disk flag set.
> > 
> > Because the OCFS2_DIO_ORPHANED_FL flag remains active, subsequent VFS
> > final inode eviction (ocfs2_delete_inode) observes the flag, assumes a
> > direct I/O write is actively in progress, and refuses to wipe the inode.
> > This results in an irrecoverable disk storage and resource leak that can
> > only be reclaimed if the cluster unmounts or crashes.
> > 
> > Fix this by ensuring that ocfs2_dio_end_io() inspects dw_orphaned even
> > when an I/O error occurs, and executes ocfs2_del_inode_from_orphan() to
> > liberate the inode before destroying the in-memory write context.
> > 
> > Fixes: 5040f8df56fb ("ocfs2: free up write context when direct IO failed")
> > Assisted-by: Antigravity:Gemini
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
> >  fs/ocfs2/aops.c | 17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 4acdbb70882c..ad3f2057e26e 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -2419,11 +2419,24 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
> >  		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld",
> >  				 (long long)bytes);
> >  	if (private) {
> > -		if (bytes > 0)
> > +		if (bytes > 0) {
> >  			ret = ocfs2_dio_end_io_write(inode, private, offset,
> >  						     bytes);
> > -		else
> > +		} else {
> > +			struct ocfs2_dio_write_ctxt *dwc = private;
> > +
> > +			if (dwc->dw_orphaned) {
> > +				struct buffer_head *di_bh = NULL;
> > +
> > +				if (ocfs2_inode_lock(inode, &di_bh, 1) == 0) {
> > +					ocfs2_del_inode_from_orphan(OCFS2_SB(inode->i_sb),
> > +								    inode, di_bh, 0, 0);
> > +					ocfs2_inode_unlock(inode, 1);
> > +					brelse(di_bh);
> > +				}
> 
> Calling only ocfs2_del_inode_from_orphan() without ocfs2_truncate_file() will
> leave stale blocks beyond the EOF.

Right.

> I think the existing OCFS2 code already handles error/crash cases for orphaned
> inodes, and this "leaking" behavior is by design.
> please refer to ocfs2_recover_orphans() and ocfs2_add_inode_to_orphan().

Periodic scans skip direct I/O entries to avoid racing with active
direct I/O on live nodes:

In fs/ocfs2/journal.c:ocfs2_orphan_filldir():

	/* do not include dio entry in case of orphan scan */
	if ((p->orphan_reco_type == ORPHAN_NO_NEED_TRUNCATE) &&
			(!strncmp(name, OCFS2_DIO_ORPHAN_PREFIX,
			OCFS2_DIO_ORPHAN_PREFIX_LEN)))
		return true;

Is something else recovering them?
