Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF11AEC2
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Apr 2024 01:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711936557; cv=none; b=mO1xbpEiDIQQoWoLdaIbU6kxXD/jwMO8nOl9CcE2t1AwNS1iOgF8AQWyle5EVVk3ZwsDDmoY6CjuIGnfpiJjThL5TrIRRK8XFR9Cr7IWfUM96YBwv7t0IDjjPtkFa22osGYaTY7sX3vatCTlpWaUDEzqRxu4eluttEVcbVOWUZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711936557; c=relaxed/simple;
	bh=CCgaS0zx9SNaZdRbcy2DJ3vDk1BqiJmvSbntBFt2vP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RwDKyUzPHPMi6Ig0MntbodtkDT0DtviHFE08sL8qHQCpauRtEihWrHr6kiNlm1a4TdNIPyYhnSNA6pBnvrBDz4ZWn0k30qhR34ninqSlMwm7MngQ2A/aOQLK3pfTSZWW9jeGHEqB7Xod6bx0Ae+3KnqE4W9D4BkeWHWADHmdrJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=u6p4W1lQ; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="u6p4W1lQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711936552; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fgXtZpseGpxBgCEB3N5qo1FMNP8oy6uhSLLe+QGbVJs=;
	b=u6p4W1lQ1gN8Sq0cZMPtmUpD+HXfdgEi7A3DOQB/6qZMn/FnK/0o2/0Tv743Gj/eTt28oCHZfyMT3l4IEiGesePaIzoYTHviz/KZTns4C7l7S7t+i9yqVJrX/7T38z0XlD7WWrU2qqA8BC+PCrmLl72P0HGGH/YrtBU54YLjr48=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W3cwIxH_1711936550;
Received: from 30.221.128.209(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3cwIxH_1711936550)
          by smtp.aliyun-inc.com;
          Mon, 01 Apr 2024 09:55:51 +0800
Message-ID: <16c91894-792b-4d2c-96bd-69a7c7a037d5@linux.alibaba.com>
Date: Mon, 1 Apr 2024 09:55:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] ocfs2: update inode fsync transaction id in
 ocfs2_unlink and ocfs2_link
Content-Language: en-US
To: Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
References: <20240331111744.7224-1-l@damenly.org>
 <20240331111744.7224-4-l@damenly.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240331111744.7224-4-l@damenly.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/31/24 7:17 PM, Su Yue wrote:
> From: Su Yue <glass.su@suse.com>
> 
> transaction id should be updated in ocfs2_unlink and ocfs2_link.
> Otherwise, inode link will be wrong after journal replay even fsync was
> called before power failure:
> =======================================================================
> $ touch testdir/bar
> $ ln testdir/bar testdir/bar_link
> $ fsync testdir/bar
> $ stat -c %h $SCRATCH_MNT/testdir/bar
> 1
> $ stat -c %h $SCRATCH_MNT/testdir/bar
> 1
> =======================================================================
> 
> Signed-off-by: Su Yue <glass.su@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/namei.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 9221a33f917b..55c9d90caaaf 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -797,6 +797,7 @@ static int ocfs2_link(struct dentry *old_dentry,
>  	ocfs2_set_links_count(fe, inode->i_nlink);
>  	fe->i_ctime = cpu_to_le64(inode_get_ctime_sec(inode));
>  	fe->i_ctime_nsec = cpu_to_le32(inode_get_ctime_nsec(inode));
> +	ocfs2_update_inode_fsync_trans(handle, inode, 0);
>  	ocfs2_journal_dirty(handle, fe_bh);
>  
>  	err = ocfs2_add_entry(handle, dentry, inode,
> @@ -993,6 +994,7 @@ static int ocfs2_unlink(struct inode *dir,
>  		drop_nlink(inode);
>  	drop_nlink(inode);
>  	ocfs2_set_links_count(fe, inode->i_nlink);
> +	ocfs2_update_inode_fsync_trans(handle, inode, 0);
>  	ocfs2_journal_dirty(handle, fe_bh);
>  
>  	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
