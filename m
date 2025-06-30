Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F332F1FE2
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 01:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751248718; cv=none; b=kKzXGfckROYDHs7EsB1TqZFuwcpFjGUTS7pWnVs7m1iZnbSkK1S25Ps/NQcN+xJo+KPZuN0r9T2rHSk5xuO9y27CsYb/WzoKPPwOq4fRh/N347O0ZUF3C9HBecHzwdBgNncfc1XC5FinkXMdskF8A4Bv3VPPNTUHHA5Ff81XUtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751248718; c=relaxed/simple;
	bh=ipNudjZuaN78dETBvDLyPqgHY3Qq8KaC1c8HerEARlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CdO7QVDmYRRJrzgGszNe2lbuMU/grmy4XzQTTDpp6PXaJXFw65+JkVbDXslIx005mZV1GCj1WuC1fonnrVrIZbwv+a5/1h5XBjG/jgOV10a1cS+y/PkExDVF1L7RVz8uUwV/ktcxJTu34UcJbPPg4sVCc7QTpyPOclcyMakpQWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SM/ax1Td; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SM/ax1Td"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1751248712; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0n89m+x+tT3wRfAO0hO9F9i/jJOfi8f150a3KwM5478=;
	b=SM/ax1Td4bMkN/qLFfRuCV0PH2jtohXXdKDokYg5JgNxGnPAKJpFpAUKURebt8snuksAonb6cJs2ZoAIRx2QelY24QxvLEtzS9OqBsaWjGdzHKxfJaxYRBemG9Uc7soYxKmjSDqne9jAnrOttrZ/nduYJFh86MhLPf05Ekb4aN4=
Received: from 30.221.128.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wg2pBvd_1751248711 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Jun 2025 09:58:31 +0800
Message-ID: <973af6b9-e4c7-4519-99af-9c82dc6ca98f@linux.alibaba.com>
Date: Mon, 30 Jun 2025 09:58:30 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: update d_splice_alias() return code checking
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Al Viro <viro@zeniv.linux.org.uk>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Richard Weinberger <richard@nod.at>,
 ocfs2-devel@lists.linux.dev, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <d689279f-03ed-4f9b-8fde-713b2431f303@I-love.SAKURA.ne.jp>
 <20250626033411.GU1880847@ZenIV>
 <d84dc916-2982-45dc-a9a5-a6255cbc62bd@I-love.SAKURA.ne.jp>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <d84dc916-2982-45dc-a9a5-a6255cbc62bd@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/6/27 22:19, Tetsuo Handa wrote:
> When commit d3556babd7fa ("ocfs2: fix d_splice_alias() return code
> checking") was merged into v3.18-rc3, d_splice_alias() was returning
> one of a valid dentry, NULL or an ERR_PTR.
> 
> When commit b5ae6b15bd73 ("merge d_materialise_unique() into
> d_splice_alias()") was merged into v3.19-rc1, d_splice_alias() started
> returning -ELOOP as one of ERR_PTR values.
> 
> Now, when syzkaller mounts a crafted ocfs2 filesystem image that hits
> d_splice_alias() == -ELOOP case from ocfs2_lookup(), ocfs2_lookup() fails
> to handle -ELOOP case and generic_shutdown_super() hits "VFS: Busy inodes
> after unmount" message.
> 
> Instead of calling ocfs2_dentry_attach_lock() or ocfs2_dentry_attach_gen()
> when d_splice_alias() returned an ERR_PTR value, change ocfs2_lookup() to
> bail out immediately.
> 
> Also, ocfs2_lookup() needs to call dupt() when ocfs2_dentry_attach_lock()
> returned an ERR_PTR value.
> 
> Reported-by: syzbot <syzbot+1134d3a5b062e9665a7a@syzkaller.appspotmail.com>
> Closes: https://syzkaller.appspot.com/bug?extid=1134d3a5b062e9665a7a
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  fs/ocfs2/namei.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 99278c8f0e24..f75fd19974bc 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -142,6 +142,8 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
>  
>  bail_add:
>  	ret = d_splice_alias(inode, dentry);
> +	if (IS_ERR(ret))
> +		goto bail_unlock;
>  
>  	if (inode) {
>  		/*
> @@ -154,13 +156,12 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
>  		 * NOTE: This dentry already has ->d_op set from
>  		 * ocfs2_get_parent() and ocfs2_get_dentry()
>  		 */
> -		if (!IS_ERR_OR_NULL(ret))
> -			dentry = ret;
> -

I'd like change this to:
if (ret)
	dentry = ret;

Instead of using "ret ? ret : dentry" below calling ocfs2_dentry_attach_lock().

> -		status = ocfs2_dentry_attach_lock(dentry, inode,
> +		status = ocfs2_dentry_attach_lock(ret ? ret : dentry, inode,
>  						  OCFS2_I(dir)->ip_blkno);
>  		if (status) {
>  			mlog_errno(status);
> +			if (ret)
> +				dput(ret);
>  			ret = ERR_PTR(status);
>  			goto bail_unlock;

The "goto" here can be eliminated since it has no real effect.

Thanks,
Joseph

>  		}

