Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6F3339B4A
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 17:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765818177; cv=none; b=kWV7uKaQl51mu9TKI5Zv49NrMMUPqEFOAmPvUei5JAT0D8h8f4ET/PtimBbtogOLPYVoa1xFfRoEjaaVYG7WyboMzvnA+PF3E30/mcqlbTTrDRwuOpQ/iGptIYX0Wv1tkH/xrRC+IDJGyyD1/kAjBKk4duOTA/R/T9rsUwcXNUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765818177; c=relaxed/simple;
	bh=bwZq3pDn45dHMvKwRD/pGpYNsdBTtg1rw7Z6eYR0n6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVqdwKoG13JjqMH7zXPGT6mDVwNSqTyjV0XL+DjvjQCmNxDjIu1UicrKqwy41QweEgrFfqgbUK+g+ETyFQ2tK1L0qD7txTbyPl+iZoQM9/hK1pKhPKqbE1Qg93OQcXHuUDPEJEvhVy8I4OZFam9SvdMubtqJ7ccdoBSkuzU/SCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dwHfoufm; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dwHfoufm"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29844c68068so45217645ad.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 09:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765818174; x=1766422974; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aXgguA2ONOc6Orc1IUAbVwvyBKZhr/2LviXH8dqh3S0=;
        b=dwHfoufmR7YeCCqN/wbNDOcdi7V2BCOGW6IvznKUYWgM4UF/kggpMQc9KZVMCe0SRe
         0J5ttZYIk8wJH+fC4qHC6zK6GERZWkoC8sf6j6RsRY0hoQ5hJUQ92Hp/d4uEvvt9Tn7w
         P8N7bJVJcf287gKdLQrpD/KPOz3LairnbqN5gxzayzM4V6xd58LYHeE7jHgRfpIUI4I9
         vtdj2lEZtiGJltXNuXKWS6RFaHq7KnmQOWNZ0oR0UNyK8qmu/sqFSnqqknF7N1YMxh8E
         RD/CWxoXqoSYbEN3kczHw+3UdvBqw0vbaH1/DjARMKOcLeoPFNJkBdfME0xXIEWW2Ntc
         zWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765818174; x=1766422974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aXgguA2ONOc6Orc1IUAbVwvyBKZhr/2LviXH8dqh3S0=;
        b=QWrSuBMRjX0qKkfI68UmuJQly6n+1V4y/IPWZ8WfK6oLg2FiMjQgpYQQnkGa4vri34
         wmX2vOzMIpjNc37Sp7w3rqwOHZRhwpGS/M/rT0+l+k+uDYMu/tW1ahKhR4O+h2qX0lT7
         3mhwregXhDf81GtpiR5l4hAIA/p2fPHaB8+ilc4sTGlaYl6WkeC9VJhv+bNUXYXfjBYX
         33WmwTHU8dpUZd4ru7AzJrW9hb7pTOFiEUDllz0bY2OiWwG/MkZtocf4Ncdumet2sy0Y
         4uNU4N75lZ5Ht3C4hGG/TmH3sHa29PpAqE31Kb2mOanPv59CLORU3vAdVWKx15SrrhZY
         Fkow==
X-Forwarded-Encrypted: i=1; AJvYcCVL/27RAvA3DSggQUtZ5x+uTB0U2Jg/qXzPNeuNngskYiGlvuZb4SvHSqmlWfJf2qigeuWAih2e7h9T6g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzC9TlAV2UqL7GTvfvc4hij7bcKqR7aKTglmyeb52+aLmXUgfG+
	VfmC1nkVB4A1iwUbOI7gqZAy014IffJtDdQUfnGyMR+LJXFX28q+VaVN
X-Gm-Gg: AY/fxX7NtRaaPkqtDHTEGC0+vxAvlFp4+GnbRE80UtC3TdUfBaSCpo6KgWQVs0KH5cw
	AdnRDefnfJuH+BTDxW1Kt04w45qf9QIPlB4A3rrYpBs19ScwDC59K3zofSmPvj1szS4+fhmXhep
	yklDkIsmn6/o2BqghKQElShmRDUzonibzbJXqyB9zhmo4XXpy2n6y+rXYVQcI8eLaDYvdgHkR8p
	TCBJe+EHWVr34TgRltow27xDzd5zsh9vqnquNlyomhsRePY4hVcludJtvbRlKHHyMyqPDTGPJUr
	jIiJLXYOLSudkk6okwxjippeqp+dIVFG/K8Yh3X+9En2hf4Dj7rC+lI+Ena/UAQA9UwDFwJjjQM
	VAS6gKcwAGHVXz5PCkyz3k+vtxlvCJ970COCf2Nv73dFWyNeW6H7A3Aq0EYpOU5iZDu+B6kd4VH
	tOfl/gA30BAAGk
X-Google-Smtp-Source: AGHT+IE4p+UmmUv+Akr7vMEk5JRDk9BgVR4yC6f8f61tsVRIPDIvhHJSvDDX7JBsmMTr5oTAWoShpg==
X-Received: by 2002:a17:903:1247:b0:29d:9b39:c05f with SMTP id d9443c01a7336-29f23dfe992mr125761275ad.10.1765818173098;
        Mon, 15 Dec 2025 09:02:53 -0800 (PST)
Received: from prithvi-HP ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a0ced60fddsm49902845ad.77.2025.12.15.09.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 09:02:52 -0800 (PST)
Date: Mon, 15 Dec 2025 22:32:45 +0530
From: Prithvi <activprithvi@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com, 
	linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, david.hunter.linux@gmail.com, 
	khalid@kernel.org, syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3] ocfs2: Add validate function for slot map blocks
Message-ID: <tagu2npibmto5bgonhorg5krbvqho4zxsv5pulvgbtp53aobas@6qk4twoysbnz>
References: <20251215052513.18436-1-activprithvi@gmail.com>
 <pbky57xu3cdwtrxieo7y2dicl5vddy7k5ttf32nxypirceoenx@et4o3qg4ifck>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pbky57xu3cdwtrxieo7y2dicl5vddy7k5ttf32nxypirceoenx@et4o3qg4ifck>

On Mon, Dec 15, 2025 at 10:21:37PM +0800, Heming Zhao wrote:
> On Mon, Dec 15, 2025 at 10:55:13AM +0530, Prithvi Tambewagh wrote:
> > When the filesystem is being mounted, the kernel panics while the data
> > regarding slot map allocation to the local node, is being written to the
> > disk. This occurs because the value of slot map buffer head block
> > number, which should have been greater than or equal to
> > `OCFS2_SUPER_BLOCK_BLKNO` (evaluating to 2) is less than it, indicative
> > of disk metadata corruption. This triggers
> > BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) in ocfs2_write_block(),
> > causing the kernel to panic.
> > 
> > This is fixed by introducing  function ocfs2_validate_slot_map_block() to
> > validate slot map blocks. It first checks if the buffer head passed to it
> > is up to date and valid, else it panics the kernel at that point itself.
> > Further, it contains an if condition block, which checks if `bh->b_blocknr`
> > is lesser than `OCFS2_SUPER_BLOCK_BLKNO`; if yes, then ocfs2_error is
> > called, which prints the error log, for debugging purposes, and the return
> > value of ocfs2_error() is returned. If the return value is zero. then error
> > code EIO is returned.
> > 
> > This function is used as validate function in calls to ocfs2_read_blocks()
> > in ocfs2_refresh_slot_info() and ocfs2_map_slot_buffers().
> > In addition, the function also contains
> 
> The last sentence seems incomplete.
> 
> > 
> > Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
> > Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> > ---
> > v2->v3:
> >  - Create new function ocfs2_validate_slot_map_block() to validate block 
> >    number of slot map blocks, to be greater then or equal to 
> >    OCFS2_SUPER_BLOCK_BLKNO
> >  - Use ocfs2_validate_slot_map_block() in calls to ocfs2_read_blocks() in
> >    ocfs2_refresh_slot_info() and ocfs2_map_slot_buffers()
> >  - In addition to using previously formulated if block in 
> >    ocfs2_validate_slot_map_block(), also check if the buffer head passed 
> >    in this function is up to date; if not, then kernel panics at that point
> >  - Change title of patch to 'ocfs2: Add validate function for slot map blocks'
> > 
> > v2 link: https://lore.kernel.org/ocfs2-devel/nwkfpkm2wlajswykywnpt4sc6gdkesakw2sw7etuw2u2w23hul@6oby33bscwdw/T/#t
> > 
> > v1->v2:
> >  - Remove usage of le16_to_cpu() from ocfs2_error()
> >  - Cast bh->b_blocknr to unsigned long long
> >  - Remove type casting for OCFS2_SUPER_BLOCK_BLKNO
> >  - Fix Sparse warnings reported in v1 by kernel test robot
> >  - Update title from 'ocfs2: Fix kernel BUG in ocfs2_write_block' to
> >    'ocfs2: fix kernel BUG in ocfs2_write_block'
> > 
> > v1 link: https://lore.kernel.org/all/20251206154819.175479-1-activprithvi@gmail.com/T/
> >  fs/ocfs2/slot_map.c | 29 +++++++++++++++++++++++++++--
> >  1 file changed, 27 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> > index e544c704b583..50ddd7f50f8f 100644
> > --- a/fs/ocfs2/slot_map.c
> > +++ b/fs/ocfs2/slot_map.c
> > @@ -44,6 +44,9 @@ struct ocfs2_slot_info {
> >  static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
> >  				    unsigned int node_num);
> >  
> > +static int ocfs2_validate_slot_map_block(struct super_block *sb,
> > +					  struct buffer_head *bh);
> > +
> >  static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
> >  				  int slot_num)
> >  {
> > @@ -132,7 +135,8 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
> >  	 * this is not true, the read of -1 (UINT64_MAX) will fail.
> >  	 */
> >  	ret = ocfs2_read_blocks(INODE_CACHE(si->si_inode), -1, si->si_blocks,
> > -				si->si_bh, OCFS2_BH_IGNORE_CACHE, NULL);
> > +				si->si_bh, OCFS2_BH_IGNORE_CACHE,
> > +				ocfs2_validate_slot_map_block);
> >  	if (ret == 0) {
> >  		spin_lock(&osb->osb_lock);
> >  		ocfs2_update_slot_info(si);
> > @@ -332,6 +336,26 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num)
> >  	return ocfs2_update_disk_slot(osb, osb->slot_info, slot_num);
> >  }
> >  
> > +static int ocfs2_validate_slot_map_block(struct super_block *sb,
> > +					  struct buffer_head *bh)
> > +{
> > +	int rc;
> > +
> > +	BUG_ON(!buffer_uptodate(bh));
> > +
> > +	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
> > +		rc = ocfs2_error(sb,
> > +				 "Invalid Slot Map Buffer Head "
> > +				 "Block Number : %llu, Should be >= %d",
> > +				 (unsigned long long)bh->b_blocknr,
> > +				 OCFS2_SUPER_BLOCK_BLKNO);
> > +		if (!rc)
> > +			return -EIO;
> 
> Since ocfs2_error() never returns 0, please remove the above if condition.
> 
> Thanks,
> Heming
> > +		return rc;
> > +	}
> > +	return 0;
> > +}
> > +
> >  static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
> >  				  struct ocfs2_slot_info *si)
> >  {
> > @@ -383,7 +407,8 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
> >  
> >  		bh = NULL;  /* Acquire a fresh bh */
> >  		status = ocfs2_read_blocks(INODE_CACHE(si->si_inode), blkno,
> > -					   1, &bh, OCFS2_BH_IGNORE_CACHE, NULL);
> > +					   1, &bh, OCFS2_BH_IGNORE_CACHE,
> > +					   ocfs2_validate_slot_map_block);
> >  		if (status < 0) {
> >  			mlog_errno(status);
> >  			goto bail;
> > 
> > base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
> > -- 
> > 2.43.0
> >

Sure, I will make the corrections and send a v4 patch.

Thanks,
Prithvi

