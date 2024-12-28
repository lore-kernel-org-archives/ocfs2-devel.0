Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FCA433C0
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Dec 2024 12:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735388832; cv=none; b=VY42WHQC4wLBWLP3uYIRIrPH+Y5vOvFe4JsRcI972rSrICfr6AM/TUj/0A/iW1HMqwN22F8PBj20UGhcreBE+2ln5hZ6cZgdoQKdrm9QNp6nuyxwgeNmqRiFwMMhRcwOTk3XqYob7vB4z0wMwti7CX1jsUYSMyEeWmERhxIIxok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735388832; c=relaxed/simple;
	bh=6UmkB3eZstSAK7daexABxJxiI8h6Ww0ubiKJ8LBY9bE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pw85dZd1L/To3BFnGdGlTCgy5sE1/I0wvuHOle8RVKTkv4iLsrS//2+68eIh/+e2bBA4YzFl4KXhjOraYOMuLVIu6vmfHPQ+nGHwlVBhpXGRt0tXQjlkehcd/A49NF6NxvdxpnlsREqVzJr4p2Fp5B6LrwZW1u08nNyjcABNWqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=U6VOUM2N; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="U6VOUM2N"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735388824; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/fqJWtqed0UQys0LwaLOU0WGv4tofJ18X2nQksLejJ0=;
	b=U6VOUM2NBINnjTIrX8qqgQ2RgLYgcidjUckZyxJdbIobrRwU5khAf43tCPMauxwghtGN+67M1GjcePurWlAiF1FbAPRtAjKxU4RP20KxUnjPTC4320xG9cp40dvphKhp5oWkNf8d1dBn1MUtVSqMLrqOPBinG+xMvdiir2B2drk=
Received: from 30.121.61.3(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMNp-rm_1735388822 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 28 Dec 2024 20:27:03 +0800
Message-ID: <844e9f34-1ef8-49ef-9f42-54fdeeefc18d@linux.alibaba.com>
Date: Sat, 28 Dec 2024 20:27:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: uncache inode after ocfs2_search_dirblock() search
 failure
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+7aef76bdb53b83d62a9e@syzkaller.appspotmail.com
References: <20241227130717.144988-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241227130717.144988-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/27 21:07, Dmitry Antipov wrote:
> Syzbot has reported the following BUG:
> 
> kernel BUG at fs/ocfs2/uptodate.c:509!
> ...
> Call Trace:
>  <TASK>
>  ? __die_body+0x61/0xb0
>  ? die+0x9f/0xc0
>  ? do_trap+0x14a/0x3d0
>  ? ocfs2_set_new_buffer_uptodate+0x149/0x170
>  ? do_error_trap+0x1c2/0x280
>  ? ocfs2_set_new_buffer_uptodate+0x149/0x170
>  ? __pfx_do_error_trap+0x10/0x10
>  ? handle_invalid_op+0x34/0x40
>  ? ocfs2_set_new_buffer_uptodate+0x149/0x170
>  ? exc_invalid_op+0x39/0x50
>  ? asm_exc_invalid_op+0x1a/0x20
>  ? ocfs2_set_new_buffer_uptodate+0x148/0x170
>  ? ocfs2_set_new_buffer_uptodate+0x149/0x170
>  ? ocfs2_set_new_buffer_uptodate+0x148/0x170
>  ocfs2_group_add+0x318/0x1240
>  ? mnt_get_write_access+0x68/0x2a0
>  ? __pfx_ocfs2_group_add+0x10/0x10
>  ? mnt_get_write_access+0x68/0x2a0
>  ? __pfx_lock_release+0x10/0x10
>  ? rcu_read_lock_any_held+0xb4/0x130
>  ? __pfx_rcu_read_lock_any_held+0x10/0x10
>  ? __pfx_lock_release+0x10/0x10
>  ? mnt_get_write_access+0x223/0x2a0
>  ? mnt_want_write_file+0x172/0x200
>  ocfs2_ioctl+0x60b/0x750
>  ? __pfx_ocfs2_ioctl+0x10/0x10
>  ? lockdep_hardirqs_on_prepare+0x401/0x750
>  ? bpf_lsm_file_ioctl+0x9/0x20
>  ? __pfx_ocfs2_ioctl+0x10/0x10
>  __se_sys_ioctl+0xfc/0x170
>  do_syscall_64+0xf6/0x210
>  ? exc_page_fault+0x92/0x110
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  ...
>  </TASK>
> 
> In 'ocfs2_find_entry_id()', the buffer head remains cached (by
> 'ocfs2_read_blocks()') regardless of the search result returned
> by 'ocfs2_search_dirblock()'. In case of search failure, that
> buffer head is no longer used and should be uncached before
> calling 'brelse()'. This is very similar to commit 737f34137844
> ("ocfs2: uncache inode which has failed entering the group").
> 

Hi, don't see the relationship between above logic and the triggered
bug.
Could you please elobrate more how it happens?

Thanks,
Joseph

> Reported-by: syzbot+7aef76bdb53b83d62a9e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7aef76bdb53b83d62a9e
> Fixes: 23193e513d1c ("ocfs2: Read support for directories with inline data")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ocfs2/dir.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 213206ebdd58..3bfbc166d1fe 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -416,6 +416,9 @@ static struct buffer_head *ocfs2_find_entry_id(const char *name,
>  	if (found == 1)
>  		return di_bh;
>  
> +	/* Cached by ocfs2_read_blocks() so remove it. */
> +	ocfs2_remove_from_cache(INODE_CACHE(dir), di_bh);
> +
>  	brelse(di_bh);
>  out:
>  	return NULL;

