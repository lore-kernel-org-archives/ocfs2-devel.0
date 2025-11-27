Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253D62C0F68
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Nov 2025 07:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227873; cv=none; b=FWVMylEgSEMGFstNKLa2r45VncD+ME++ynpHG4RV6a93bV24ru/7hJK4J3h+aRYNwval0g1simooGLX9gHgpt8Jk0EklTByNb22iiDLnH5O8owYBdN6oNlqg11Tj2W0y3Zr8RRTNLUh//ndNDZ0weuF56qXVvLpGgRzlrbtTR+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227873; c=relaxed/simple;
	bh=FUeGHOPe/kciT42446qFqyIsVLes7scBplDDzmSwX1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qat/5AmWpDGKnu3OgGmakIa4XHEblb8EqQHT1HoFxrPNyWQwuQtEx2SDvLUBsOB9lCVYeD1g40AiHwsoji4col2CZopHNXmzT25oG5ORuNb3a1s8IItrAsVCfmDGcl5FN2RMb634Mz/09FQMeUZXuJ+X+WXQUzdu9RmqnJglO8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KuqxmHU9; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KuqxmHU9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764227860; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MlbeyS/FybiKSKs//zk488BMWWlYD4Yfbm+8zuSaKDo=;
	b=KuqxmHU9/67RaIuhcNO6lfWA/Y/Jun5ZCxY8hif+S/OS9nClB/agQauUSXwcV1csSbKCUAk2NNJ309L7oBODmpSkHTEWxABuR/hiKAVDTMBYQ17fX0Pt0ygI5V5RBIjfvVUxbAAd+5iS392O/hH0l7BT56wko6zYfvDiAfSx+iI=
Received: from 30.221.128.129(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WtWJVyv_1764227858 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Nov 2025 15:17:39 +0800
Message-ID: <17daaf4c-0081-48f5-8127-0aa9ea534169@linux.alibaba.com>
Date: Thu, 27 Nov 2025 15:17:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: check tl_used after reading it from trancate log
 inode
To: Edward Adam Davis <eadavis@qq.com>,
 syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com,
 akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <6927a541.a70a0220.d98e3.00e5.GAE@google.com>
 <tencent_B24B1C1BE225DCBA44BB6933AB9E1B1B0708@qq.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <tencent_B24B1C1BE225DCBA44BB6933AB9E1B1B0708@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/27 11:26, Edward Adam Davis wrote:
> The fuzz image has a truncate log inode whose tl_used is bigger than
> tl_count so it triggers the BUG in ocfs2_truncate_log_needs_flush() [1].
> 
> As what the check in ocfs2_truncate_log_needs_flush() does, just do
> same check into ocfs2_get_truncate_log_info() when truncate log inode
> is reading in so we can bail out earlier.
> 
> [1]
> (syz.0.17,5491,0):ocfs2_truncate_log_needs_flush:5830 ERROR: bug expression: le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count)
> kernel BUG at fs/ocfs2/alloc.c:5830!
> RIP: 0010:ocfs2_truncate_log_needs_flush fs/ocfs2/alloc.c:5827 [inline]
> Call Trace:
>  ocfs2_commit_truncate+0xb64/0x21d0 fs/ocfs2/alloc.c:7372
>  ocfs2_truncate_file+0xca2/0x1420 fs/ocfs2/file.c:509
>  ocfs2_setattr+0x1520/0x1b40 fs/ocfs2/file.c:1212
>  notify_change+0xc1a/0xf40 fs/attr.c:546
>  do_truncate+0x1a4/0x220 fs/open.c:68
> 
> Reported-by: syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f82afc4d4e74d0ef7a89
> Tested-by: syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 162711cc5b20..570d747a00ca 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6164,7 +6164,7 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
>  	struct buffer_head *bh = NULL;
>  	struct ocfs2_dinode *di;
>  	struct ocfs2_truncate_log *tl;
> -	unsigned int tl_count;
> +	unsigned int tl_count, tl_used;
>  
>  	inode = ocfs2_get_system_file_inode(osb,
>  					   TRUNCATE_LOG_SYSTEM_INODE,
> @@ -6185,8 +6185,10 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
>  	di = (struct ocfs2_dinode *)bh->b_data;
>  	tl = &di->id2.i_dealloc;
>  	tl_count = le16_to_cpu(tl->tl_count);
> +	tl_used = le16_to_cpu(tl->tl_used);
>  	if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
> -		     tl_count == 0)) {
> +		     tl_count == 0 ||
> +		     tl_used > tl_count)) {
>  		status = -EFSCORRUPTED;
>  		iput(inode);
>  		brelse(bh);

