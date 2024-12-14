Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECC619340F;
	Sat, 14 Dec 2024 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734189673; cv=none; b=AlbqFwbKuFC/FMw1oNZKcx7qu4TkvOUF3A+UziVhWylFcKmBvaj73D+T+YoQJ70FRCGhOV+ZCpNndWYmwUVQEpfF9I5V4gBg3hEikLoG/oEERJOk6W5AvdYKwEiFN1OjcEqqiZFGVL5aPmBZ04a83H3lp2KefMPqHTmRUVOYaWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734189673; c=relaxed/simple;
	bh=vFfgs1YK/H7YTL7AD0wGOcBJJqvVfdLWpmFzNX09RuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3gf2c97UB+xLWFNOchIUSez1VRq1iaFzyiq6qEkk9Q0rSa4f56byF6q03XE/70d6nV0zS3OQOlgQXb/1bH1nOjPQryJN/k9pfyIzoIfouAMj4hbz6jA1zuueJY4hlg1u70MrQvS92hcJQ9eF+U80s6+/dmXH6VKCV3wq4C1AI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Oe1j6d15; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Oe1j6d15"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rB1GtC/0basEJjhJTcO0uFuGQbpaMyd8syOU5yP05K8=; b=Oe1j6d15JWW4GXSyOYRxwUZ7ai
	yfSMOIsXV1V7JNfMGDzU+YkNS/cZ9i5IIhjG/sFHMig/lDBa04gNkiUfIFfADsHfn2HUs+AyWr+HO
	5cIv6dFlQvszcDo2VLH6X5DIE8II8LFpY9bnppV8/rLzSelnmS/XVBLQkmkV+PO7dmQ4LO83X2DEX
	3fp2lR5G0dbSGwdbBN31mYe3f3uXKweuVtzy0LyUccNan8R1WcjG8QOXMZJDqHk3FiAP5MalxzB7z
	/2Wv2BLqtP7LdZ2kIe+2QwPqX9/NwFb1rkFmIyuYD74YYNzyq9D+nwdnx6PUOIq5QCtLN2RvcBK12
	L+PrKuwQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tMTww-00000003Q1n-0Bl2;
	Sat, 14 Dec 2024 15:20:58 +0000
Date: Sat, 14 Dec 2024 15:20:57 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, Mark Tinguely <mark.tinguely@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 01/23] ocfs2: Handle a symlink read error correctly
Message-ID: <Z12iWZqMw8tiz7jE@casper.infradead.org>
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-2-willy@infradead.org>
 <f0279f1a-936e-45c2-9f57-0b82c3fffcd9@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0279f1a-936e-45c2-9f57-0b82c3fffcd9@linux.alibaba.com>

On Sat, Dec 14, 2024 at 08:03:30PM +0800, Joseph Qi wrote:
> On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> > If we can't read the buffer, be sure to unlock the page before
> > returning.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  fs/ocfs2/symlink.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
> > index d4c5fdcfa1e4..f5cf2255dc09 100644
> > --- a/fs/ocfs2/symlink.c
> > +++ b/fs/ocfs2/symlink.c
> > @@ -65,7 +65,7 @@ static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
> >  
> 
> Better to move calling ocfs2_read_inode_block() here.

Hm?  This is a bugfix; it should be as small as reasonable.  If you want
the code to be moved around, that should be left to a later patch.

> Thanks,
> Joseph
> 
> >  	if (status < 0) {
> >  		mlog_errno(status);
> > -		return status;
> > +		goto out;
> >  	}
> >  
> >  	fe = (struct ocfs2_dinode *) bh->b_data;
> > @@ -76,9 +76,10 @@ static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
> >  	memcpy(kaddr, link, len + 1);
> >  	kunmap_atomic(kaddr);
> >  	SetPageUptodate(page);
> > +out:
> >  	unlock_page(page);
> >  	brelse(bh);
> > -	return 0;
> > +	return status;
> >  }
> >  
> >  const struct address_space_operations ocfs2_fast_symlink_aops = {
> 
