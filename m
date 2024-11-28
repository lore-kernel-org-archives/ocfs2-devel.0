Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFBD132139
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Nov 2024 03:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732764473; cv=none; b=MplripAc42UkEhRn/KB57ZHlK/izTPI3zqTiK/035PDqjcF8VqvPAlfI50yHK7zjLS4u68opYHdPZjwNVUL/ixZu8L51Vg1jCRR1rZWJkvglKx1DvyTxBnKopcA3R3dYXxSyKgA7B1z38U4WQBWOGUhwnzqtU5HO4khS/FLIxnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732764473; c=relaxed/simple;
	bh=Uf6l3zPeK1hlEFgnmIPsW8FXsCFCKsXyx9g/RHOiOhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itwS8TW54z/Yp5IAKkuK/glRc8w4Pm7QEz0djlDO+SaFQniS2/Kb1iP87DcULGWG7jcanrkpSbcTKBIcX/z3uUkcDc44OkK8yypqKt7wd1wxZvjoOn3DIKrMnzRcw5hIKhIZrb3tMU3tiLR/ySN07fb7HbZWcUPrJB5eXWWXa28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c44vtPjq; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c44vtPjq"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1732764467; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8WbltdsvGRiUJyi6JblPC5zaJY2uOIx/GnOIMySKCZI=;
	b=c44vtPjqhfRy/hTTMLeufXrgQbbJWbQ3iyKigC0mgJ2RoBbtTMSkO3RUNvzeti3314XU3oMEwdNUn/iDlPTALZQtH/R3flrQFdQWmTYzQY35/o08/Uzwnm54ShEYqJ8d82cPHO1UKnNDgdq/uW0kLL5sAVYdM8rnPnkW5cfGnt0=
Received: from 30.221.130.57(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WKOEBn9_1732764465 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Nov 2024 11:27:46 +0800
Message-ID: <e50fa38e-af09-4e85-b0f8-237448026486@linux.alibaba.com>
Date: Thu, 28 Nov 2024 11:27:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix directory entry check in
 ocfs2_search_dirblock()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+b9704899e166798d57c9@syzkaller.appspotmail.com
References: <20241119170745.464799-1-dmantipov@yandex.ru>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241119170745.464799-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/20/24 1:07 AM, Dmitry Antipov wrote:
> Syzbot has reported the following KASAN splat:
> 
> BUG: KASAN: slab-use-after-free in ocfs2_search_dirblock+0x26b/0x830
> Read of size 1 at addr ffff888012009982 by task repro/5388
> ...
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x241/0x360
>  ? __pfx_dump_stack_lvl+0x10/0x10
>  ? __pfx__printk+0x10/0x10
>  ? _printk+0xd5/0x120
>  ? __virt_addr_valid+0x183/0x530
>  ? __virt_addr_valid+0x183/0x530
>  print_report+0x169/0x550
>  ? __virt_addr_valid+0x183/0x530
>  ? __virt_addr_valid+0x183/0x530
>  ? __virt_addr_valid+0x45f/0x530
>  ? __phys_addr+0xba/0x170
>  ? ocfs2_search_dirblock+0x26b/0x830
>  kasan_report+0x143/0x180
>  ? ocfs2_search_dirblock+0x26b/0x830
>  ocfs2_search_dirblock+0x26b/0x830
>  ? ocfs2_read_inode_block+0x14c/0x1e0
>  ? __pfx_ocfs2_search_dirblock+0x10/0x10
>  ? validate_chain+0x11e/0x5900
>  ocfs2_find_entry+0x1169/0x2780
>  ? mark_lock+0x9a/0x350
>  ? __lock_acquire+0x137a/0x2040
>  ? __pfx_ocfs2_find_entry+0x10/0x10
>  ? __pfx_lock_acquire+0x10/0x10
>  ? ocfs2_inode_lock_full_nested+0x17b/0x1c10
>  ? __pfx_lock_release+0x10/0x10
>  ? do_raw_spin_lock+0x14f/0x370
>  ? do_raw_spin_unlock+0x58/0x8b0
>  ? _raw_spin_unlock+0x28/0x50
>  ? ocfs2_inode_lock_full_nested+0xb2f/0x1c10
>  ? __pfx_ocfs2_inode_lock_full_nested+0x10/0x10
>  ocfs2_find_files_on_disk+0xff/0x360
>  ocfs2_lookup_ino_from_name+0xb1/0x1e0
>  ? __pfx_ocfs2_lookup_ino_from_name+0x10/0x10
>  ocfs2_lookup+0x292/0xa60
>  ? __pfx_ocfs2_lookup+0x10/0x10
>  ? from_kgid+0x1a7/0x730
>  ? make_vfsgid+0x46/0x90
>  ? HAS_UNMAPPED_ID+0xf9/0x150
>  ? inode_permission+0xff/0x460
>  ? __pfx_ocfs2_permission+0x10/0x10
>  ? bpf_lsm_inode_create+0x9/0x10
>  ? security_inode_create+0xc2/0x110
>  ? __pfx_ocfs2_lookup+0x10/0x10
>  path_openat+0x11ce/0x3470
>  ? __pfx_path_openat+0x10/0x10
>  do_filp_open+0x235/0x490
>  ? __pfx_do_filp_open+0x10/0x10
>  ? _raw_spin_unlock+0x28/0x50
>  ? alloc_fd+0x5a1/0x640
>  do_sys_openat2+0x13e/0x1d0
>  ? mntput_no_expire+0xc2/0x850
>  ? __pfx_do_sys_openat2+0x10/0x10
>  ? __pfx_mntput_no_expire+0x10/0x10
>  __x64_sys_openat+0x247/0x2a0
>  ? __pfx___x64_sys_openat+0x10/0x10
>  ? do_syscall_64+0x100/0x230
>  ? do_syscall_64+0xb6/0x230
>  do_syscall_64+0xf3/0x230
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> ...
>  </TASK>
> 
> This happens when 'ocfs2_search_dirblock()' makes an attempt to
> jump over (presumably invalid) on-disk directory entry which size
> exceeds 'sizeof(struct ocfs2_dir_entry)', thus touching memory
> used by others (including the previously freed one). So just
> bail out if such a directory entry is found.
> 
> Reported-by: syzbot+b9704899e166798d57c9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b9704899e166798d57c9
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ocfs2/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 213206ebdd58..7a8040a47e82 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -378,7 +378,7 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>  
>  		/* prevent looping on a bad block */
>  		de_len = le16_to_cpu(de->rec_len);
> -		if (de_len <= 0) {
> +		if (de_len <= 0 || de_len > sizeof(*de)) {
>  			ret = -1;
>  			goto bail;
>  		}

This is caused by a crafted image, and de->rec_len will be checked when
ocfs2_add_entry().
It seems we can make the check here more precisely by using
OCFS2_DIR_REC_LEN().Something like:
  de_len > OCFS2_DIR_REC_LEN(de->name_len)

Thanks,
Joseph

