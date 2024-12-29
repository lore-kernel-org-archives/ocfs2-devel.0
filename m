Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961F58494
	for <ocfs2-devel@lists.linux.dev>; Sun, 29 Dec 2024 10:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735469400; cv=none; b=MAHdRVOkKihlwh6FwxP1sHqg/EPqSazK4rzDujAOI5rLDY3Ez97MNKPUCGwTPBZ0LeJeIT1gGTjem2mnFeOt/wHYAoJKeMr3ELJdRidpXr0AbYCzWj0k1N2GZ3Viy/BiFWQNhhKswhSHBsEGTI3A2kkMV5YTe5NnyVUnJTv6Gx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735469400; c=relaxed/simple;
	bh=vSr/jPqAf8wgTa6gUzsvuUgZU40uZdRk5YNzYMl3e5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fAluK3ANDcl3Z+Lzzad3NX++/Qj/XXl3l9DZl3sktQQu4EtlApzZ6eOKpsmkmI7wEZ80rp2nVSFLzlvwReb/oXSu6wb2PcYBaWxhPtsJzprN9H7kvN1Etago5i7D2IUCX+RhJTuNghKzCiy7dbiyFHTmT3lDA05j4+Ik4oV7jO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=reflOA1c; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="reflOA1c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/H27mhtVy1EvGY2MRV5L29caiy/i84+oZmWClb0ZiDY=; b=reflOA1c5S41pvt/cZYwWusb6L
	DzKkYDqmdPK1PiQqBPyIpWw7vKncc99WNzHQ0cwekW7St1ahov3RQ5TH1f6dcxrcn+8ehOUcAD8Jr
	jmBJV48/OPPTH/PWjhU8YqGpI1jBxNK5yV2Jk1RGF+nM2E8hVdnS1kf2dq/ZrTyPgJvFE2S7pbSjG
	26GWpgutMB6Pt0FUBIsOY0oh9ASCAGP+R281C74peuaZ08lHEj70xMg6dLGx18jC/yNpyLHP7dA2A
	DOpJgldazvniBR/ZPdhheDtyeI/ikvOfeBTVRB5BLPr2BQHOIQnCYstyKQ111B2+peajcB16Y0WsM
	AjTIU5/Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tRqrh-00000009iqQ-0kWu;
	Sun, 29 Dec 2024 10:49:45 +0000
Date: Sun, 29 Dec 2024 10:49:45 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Glass Su <glass.su@suse.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
	syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: add extent record check in ocfs2_commit_truncate()
Message-ID: <Z3EpSTa5KzSazonJ@casper.infradead.org>
References: <20241217104345.358461-1-dmantipov@yandex.ru>
 <BCB4B87E-9C81-4212-8C05-CE160130A399@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BCB4B87E-9C81-4212-8C05-CE160130A399@suse.com>

On Sun, Dec 29, 2024 at 10:05:17AM +0800, Glass Su wrote:
> > +++ b/fs/ocfs2/alloc.c
> > @@ -7219,12 +7219,20 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
> > struct ocfs2_extent_rec *rec;
> > struct ocfs2_path *path = NULL;
> > struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
> > + u16 tree_depth = le16_to_cpu(di->id2.i_list.l_tree_depth);
> 
> No need of tree_depth. Just call
> If (unlikely(le16_to_cpu(di->id2.i_list.l_tree_depth) >= OCFS2_MAX_PATH_DEPTH))  {

That seems more complicated to me.  I find the original easier to read.

> > + if (unlikely(tree_depth >= OCFS2_MAX_PATH_DEPTH)) {
> > + ocfs2_error(inode->i_sb,
> > +    "dinode %llu has invalid extent record depth %u\n",
> > +    (u64)di_bh->b_blocknr, tree_depth);
> > + return -EINVAL;
> 
> -EIO is better.

-EFSCORRUPTED is surely the right errno here?
