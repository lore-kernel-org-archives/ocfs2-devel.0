Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962338;
	b=c8gjUTwRbf1qscx5z0XAkXQffeeuIcpnjHPRzzldWJnhw+98pqwq0yBT1S81leZjIgfu
	 ZYtEIWH3kbOiwY413hvgv3WkeBCXf37s+jfRVc6yu7tNaT8fAWOq0FwUs833qHzE0fe7y
	 Gzo1psm02solkwpUHTVsv+EpvLRoua6x++V++0jc4I16Ol0CVS055WxgwNmJXWtz4exq6
	 DstelK3wT/1saOOgdBS4rg8BQHcVwR1cCEJOE1wMRJ/CCG0yENrQ1Bq+PdN7AgK7FHBAx
	 tJnYEI/FBabl3EXFvcFNYXTBaVQGc+soeDDOdwe0u40gG0gd7E7F1nd3/npEKh7h2jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962338;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=mDVydUmGj6EymxfHi9Cw3ENPwSNdO/hARLLpYkWQtHA=;
	b=mIimo4z7e/Tw1jqUyhqfgzVK1NAnD10pqebeBA+uGqkVA+8BwI0bJ/3g+ShWt0JzI0Z9
	 d632A0+6t13DB4nVblfxfJ62w/UgE6LQiLdkJwYk3b5HWEgM1e6qJxBjHsSxtnskgtIvn
	 hY+siWxtdD3L5P7y+90tTYSlVKELZugw8dI6ML7MkwmqQxnrX73U4dMjwBDQLVOsGHw/i
	 VJTh7N8zYQ306SPjSDXZdgr0RP/vO8P4as/koYHkB6pE/Qd4fKk1YLinksTenm2IRv3G6
	 w6Aw+dd6M3H00fH/GTICiOCbwuX7TvoxZP+t4X412YrkMqLn8fPh5xH0XyyJLGhtOQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963C9606A33B
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 10:52:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 963C9606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 467C968BEB; Fri,  6 Nov 2026 11:52:13 +0100 (CET)
Date: Fri, 6 Nov 2026 11:52:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	hch@lst.de, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 3/4] ocfs2: switch dio write path from
 buffer_head to iomap
Message-ID: <20261106105212.GC5746@lst.de>
References: <20261105071930.16399-1-heming.zhao@suse.com> <20261105071930.16399-4-heming.zhao@suse.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105071930.16399-4-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 05, 2026 at 03:19:27PM +0800, Heming Zhao wrote:
> Converts OCFS2's DIO write path from the legacy buffer_head
> infrastructure to the modern iomap framework.
> 
> Key modifications and designs are as follows:

That's a not very useful style of usually AI generated text.

If a change is not key it should not be mentioned here.

As should "modifications" in general - what is changed is pretty
obvious in the diff itself (and if it isn't it should be made more
clear in the code/comments).  So what should go into the commit
log really is the high-level considerations, pitfals and not quite
clear bits.  The rest is just unhelpful noise.


> +static int ocfs2_lock_map_blocks(struct inode *inode,
> +				 struct ocfs2_map_block *map, int flags)
> +{
> +	int ret = 0;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +
> +	down_read(&oi->ip_alloc_sem);
> +	ret = ocfs2_map_blocks(inode, map, flags);
> +	up_read(&oi->ip_alloc_sem);
> +
> +	return ret;
> +}

This pattern already showed up in the previous patch, why isn't the
helper added there and used for reads as well?

Also this and the next one have a very similar diffstat.  It would
help reviewers a lot if you merged the two patches and did any pure
code movements in a separate patch, so that the actual changes stick
out instead of just adding a wall of new code here, and removing
lots of old code in the next one.

