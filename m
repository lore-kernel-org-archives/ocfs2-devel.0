Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11827320F
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Sep 2025 19:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757964811; cv=none; b=qm03De4q9czI/D81JWOR9fJpeEwkILXJrW5+ywxfnuuMjwpZrwZijrJcmANl0Mwsx2roBsVGXFC8gIA4A6P07Of0ou4OBZhAbe/0r/Nfc7KRGqMyYay8VlnPl6dOjNjmm7SS9sAjjMZnooDwRw1C3LkrIreErpE02pWBA9eRYMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757964811; c=relaxed/simple;
	bh=pjzd8pQuKxzYkuZM20tPwv8q871Whbzseio2ANPiCnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HN5b9P85futH21kNevAnrtvVWKM+OvUYOTJBgkowdXS4eEwVdk86RmGO42Vn3eFsBgSf/qnRGMudf1VIeSc1OgTSETviuQfNnz+LFe5Ok9pCCWFiPgkurYS8tv9xn0dl/KXp3X5nzlgHu5WdTsRJN5VbALP4uOZ3UWN38GjrfbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=fail (0-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bys7orlI reason="key not found in DNS"; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bys7orlI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JkLtlrY+ize8Y8pFQl9k6znsSzzqZpnjjdgK4v1eFww=; b=Bys7orlIYNIvzt1spg5eDfzlu+
	Kkrm8spbPezBDfukmVCqbHHrVneQ1wRlfuxlzQGuznktktg6vyWlDqALGu2BYQkLO4LvgnmTkPQbd
	PmW7tXgpn7XueyXEWeXSdFmBmbqT8tKfrTz7+LGvucEJMMi5XVmxuwDdXKzhFFWlbQK1gcx2vcQjJ
	esvFTWffn42MrPSKNtOvLQG9KeHSzMUB7TMvrOoQp1QLa9SqkPhRbxuF//PnMMMiXWasLFw34+XD8
	hql+EGhlCRnpx3i5NJz0YcG/AVlfvdrrE3enP8sL1OWT6JUJ8DAyCT/KAW1i3oA4FGEGdE/oiH45u
	3pZgRl/w==;
Received: from jlbec by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyEwy-0000000GoC5-33dt;
	Mon, 15 Sep 2025 19:33:20 +0000
Date: Mon, 15 Sep 2025 12:33:16 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: avoid extra calls to strlen() after
 ocfs2_sprintf_system_inode_name()
Message-ID: <aMhp_C36-ch4aO_X@google.com>
References: <20250915121906.514039-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915121906.514039-1-dmantipov@yandex.ru>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
Sender: Joel Becker <jlbec@ftp.linux.org.uk>

Reviewed-by: Joel Becker <jlbec@evilplan.org>

On Mon, Sep 15, 2025 at 03:19:06PM +0300, Dmitry Antipov wrote:
> Since 'ocfs2_sprintf_system_inode_name()' uses 'snprintf()' and returns
> the number of characters emitted, callers of the former are better to
> use that return value instead of an explicit calls to 'strlen()'.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ocfs2/ioctl.c        | 18 +++++++-----------
>  fs/ocfs2/move_extents.c |  6 +++---
>  fs/ocfs2/sysfile.c      | 12 ++++++------
>  3 files changed, 16 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index db14c92302a1..b6864602814c 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -358,13 +358,11 @@ static int ocfs2_info_handle_freeinode(struct inode *inode,
>  				goto bail;
>  			}
>  		} else {
> -			ocfs2_sprintf_system_inode_name(namebuf,
> -							sizeof(namebuf),
> -							type, i);
> +			int len = ocfs2_sprintf_system_inode_name(namebuf,
> +								  sizeof(namebuf),
> +								  type, i);
>  			status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
> -							    namebuf,
> -							    strlen(namebuf),
> -							    &blkno);
> +							    namebuf, len, &blkno);
>  			if (status < 0) {
>  				status = -ENOENT;
>  				goto bail;
> @@ -651,12 +649,10 @@ static int ocfs2_info_handle_freefrag(struct inode *inode,
>  			goto bail;
>  		}
>  	} else {
> -		ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type,
> -						OCFS2_INVALID_SLOT);
> +		int len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf),
> +							  type, OCFS2_INVALID_SLOT);
>  		status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
> -						    namebuf,
> -						    strlen(namebuf),
> -						    &blkno);
> +						    namebuf, len, &blkno);
>  		if (status < 0) {
>  			status = -ENOENT;
>  			goto bail;
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index cbe2f8ed8897..a2b4c3f2a71c 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -375,9 +375,9 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
>  	struct ocfs2_dinode *ac_dinode;
>  	struct ocfs2_group_desc *bg;
>  
> -	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
> -	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
> -					 strlen(namebuf), &blkno);
> +	i = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
> +	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf, i, &blkno);
> +
>  	if (ret) {
>  		ret = -ENOENT;
>  		goto out;
> diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
> index 53a945da873b..d53a6cc866be 100644
> --- a/fs/ocfs2/sysfile.c
> +++ b/fs/ocfs2/sysfile.c
> @@ -127,14 +127,14 @@ static struct inode * _ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>  	char namebuf[40];
>  	struct inode *inode = NULL;
>  	u64 blkno;
> -	int status = 0;
> +	int len, status = 0;
>  
> -	ocfs2_sprintf_system_inode_name(namebuf,
> -					sizeof(namebuf),
> -					type, slot);
> +	len = ocfs2_sprintf_system_inode_name(namebuf,
> +					      sizeof(namebuf),
> +					      type, slot);
>  
> -	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
> -					    strlen(namebuf), &blkno);
> +	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
> +					    namebuf, len, &blkno);
>  	if (status < 0) {
>  		goto bail;
>  	}
> -- 
> 2.51.0
> 

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

			http://www.jlbec.org/
			jlbec@evilplan.org
