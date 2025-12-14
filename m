Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A743288C08
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765725297; cv=none; b=IOVwHQndTVhBDGTdtUmXgyd/mIvncYn2pcMfH+EUmTGMGDS99vg3eLUnGoqDmNS55IDnls3WBsR5cjPO2Ov33w1guih3GHt0wRAT2nUvZMQfI+kE812RITCwpbSF786+/quxTd6X/mWcjBDd1kv/5J8/viNq8Lxbt48cmr41dYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765725297; c=relaxed/simple;
	bh=fRoN88ddSlH0xWv2ZUrVwnFWoW3YVMNo1QBsVJia53Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rY+D1FCygdUwLJpnUo2EPZnaF0ltvIlrZXwkCMrZm95/myQCifpZtRtuizMnD2IiPQoDx4XcjEH21rGBfELM72A8V/uyMgJvqviUZJACptRltofb/LsZiLy2NfYGvdzsvgMye+WsLLGInehBwjmW3egxF7NMpqzH04g4Ry8SFUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KQIor7cA; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KQIor7cA"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47928022b93so6363725e9.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 07:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765725293; x=1766330093; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=49iQ7lYFnys+Q7zYpktn7ew+7CCFucveN4rLo0rSKLY=;
        b=KQIor7cA8JyechJZv01JXZOGQgvw7zk6XHxAQC5KcNcZHgvmPgJ/O6zWvw5R5AZp3X
         jwKeDhK6LsMcJs+WlFiZjMxtdk7pIq2mmAVVckTn6CWI9ChgkxM7LuNevK+nWKtz9VrT
         wsPqOZfO4Wc+QRbP0OOrt5KaCKeSOuzn2AfFhPjucmGCAKGvRa7hfW31ZpkVZeYCHgJm
         lPAzySABIygzzon9xE+j2MTIUEFNMce0YLt8Md1i0amCmucxMkeAKaCPm8QriFkSDjWU
         nqQYwoBNzlZHT0GkQN3OGUt8y4fRQaRQ0Wph3UgehgnlGX+dqBfB8KfpkvRqTVELW8Jn
         DlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765725293; x=1766330093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=49iQ7lYFnys+Q7zYpktn7ew+7CCFucveN4rLo0rSKLY=;
        b=TLRBy9Ft47mvbByW69uJyF7VvmuJzEPAJ+Iyrv9f9li/6xjeDR7YzZveYfiFCJiidC
         Pfnalt5U/Plu0qaDvSLw/v5SpshvtGZZGZdJJ7V9ya2Zieys889Ys3KUn8XhXP8Yr7Ik
         Fa+biBPEOhikTFSWtZpPkF/STjdT+Lq89d2sQxhTQTDhBvc8UMTCZo5LC+vF6lqBbVYn
         RL4S97Nh+q3/lKS8vlb91p7T/5CrOaJ6UaLzZ60n6HWJbHEqhOsQdSQ7nW0IoJbF7Phx
         m3odLMMJMHM/S5UnoOOL0Zdk3oelwQ6Qwnha0KLCVXfyReoA8iVduoBViu/KLN9EUJER
         YSpg==
X-Forwarded-Encrypted: i=1; AJvYcCUZcb/kimwxuIxQpFEs8LlLbdFQE720LFBivIcv5UpYsc0Xe/OCFxAwpIWG0b8dj5nWHWMcD5jkX5170A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyB/HpVHLQMmhOnGZuO6SKF5YrJc/isCLJ2DNp03rFJUGyAyPoH
	/avo+/mqNORPRL+nhnYxA78bryZJP34T0R0Kzy+NU+uw4auf0PHzw4u3mQxWmyLksIo=
X-Gm-Gg: AY/fxX7ZAlUlN3mbPdVG1RMPMJ+qCmH0t8VJ90VYvs7sodujtlRqig71R+FroA6u7qx
	TGPX0mIoDAdNpCsmK6HrDmxv75cPJZB9rKqGKkWVPpYMX9HzJCPQLcNlwozSD9UKe50sYGPjtjI
	VGHnAPyOqiRi2vuHqEvDCwtEenSV+KTkU1IIm8fp3zM53tE8RcRwSFi60nhkkAZK3gq3/QfvBqD
	A2asOWP6aGBFRh6cZMAIqyza5ijfrLb6PIIHUr4NPbZYhbIkrvx8ooo72z5241h/zfd3D5jxJF4
	CRPCuYq2qssclUJhRkouL1DZbrnKWm87PcpD89ZVyiGB0dM2vF+dMypAIRtp2SncppqrQwpxZz9
	qiplgzm4S3YnQJsBWGWnzmLx/rJO3V2tPgo6lqRUCYhfno18wDFAnyEyEodjzm5TvSf6sbfbv7K
	uRDEWKkrv6CtTmZS+u3gLa
X-Google-Smtp-Source: AGHT+IH8fDYrv4CBdVSWblZYqizfjog9OVerDZ4SxgNvELSxrCk8F9cJnxyJRITKSy0IE9v3PNryNA==
X-Received: by 2002:a05:600c:1990:b0:477:7a1c:9cb5 with SMTP id 5b1f17b1804b1-47a8f931529mr50350605e9.7.1765725292806;
        Sun, 14 Dec 2025 07:14:52 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe27d580sm2283334a91.6.2025.12.14.07.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 07:14:51 -0800 (PST)
Date: Sun, 14 Dec 2025 23:14:46 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Prithvi <activprithvi@gmail.com>, joseph.qi@linux.alibaba.com
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, 
	david.hunter.linux@gmail.com, khalid@kernel.org, 
	syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] ocfs2: fix kernel BUG in ocfs2_write_block
Message-ID: <htz6wcj3y3dhp7jyzgrachhrz6uzi7ytuby6fdtrugm57cik32@2vo56g6wmidb>
References: <20251210193257.25500-1-activprithvi@gmail.com>
 <9bad11da-0655-4fb4-b424-8c124b127290@linux.alibaba.com>
 <neqzjkw3ylaqghldgkl7jzlcl4o3vofbm6aa3a2kojfaakzjhm@ele2brknwzwm>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <neqzjkw3ylaqghldgkl7jzlcl4o3vofbm6aa3a2kojfaakzjhm@ele2brknwzwm>

On Sat, Dec 13, 2025 at 02:25:29PM +0530, Prithvi wrote:
> On Thu, Dec 11, 2025 at 10:17:21AM +0800, Joseph Qi wrote:
> > 
> > 
> > On 2025/12/11 03:32, Prithvi Tambewagh wrote:
> > > When the filesystem is being mounted, the kernel panics while the data
> > > regarding slot map allocation to the local node, is being written to the
> > > disk. This occurs because the value of slot map buffer head block
> > > number, which should have been greater than or equal to
> > > `OCFS2_SUPER_BLOCK_BLKNO` (evaluating to 2) is less than it, indicative
> > > of disk metadata corruption. This triggers
> > > BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) in ocfs2_write_block(),
> > > causing the kernel to panic.
> > > 
> > > This is fixed by introducing an if condition block in
> > > ocfs2_update_disk_slot(), right before calling ocfs2_write_block(), which
> > > checks if `bh->b_blocknr` is lesser than `OCFS2_SUPER_BLOCK_BLKNO`; if
> > > yes, then ocfs2_error is called, which prints the error log, for
> > > debugging purposes, and the return value of ocfs2_error() is returned
> > > back to caller of ocfs2_update_disk_slot() i.e. ocfs2_find_slot(). If
> > > the return value is zero. then error code EIO is returned.
> > > 
> > > Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
> > > Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> > > ---
> > > v1->v2:
> > >  - Remove usage of le16_to_cpu() from ocfs2_error()
> > >  - Cast bh->b_blocknr to unsigned long long
> > >  - Remove type casting for OCFS2_SUPER_BLOCK_BLKNO
> > >  - Fix Sparse warnings reported in v1 by kernel test robot
> > >  - Update title from 'ocfs2: Fix kernel BUG in ocfs2_write_block' to
> > >    'ocfs2: fix kernel BUG in ocfs2_write_block'
> > > 
> > > v1 link: https://lore.kernel.org/all/20251206154819.175479-1-activprithvi@gmail.com/T/
> > > 
> > >  fs/ocfs2/slot_map.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> > > index e544c704b583..e916a2e8f92d 100644
> > > --- a/fs/ocfs2/slot_map.c
> > > +++ b/fs/ocfs2/slot_map.c
> > > @@ -193,6 +193,16 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
> > >  	else
> > >  		ocfs2_update_disk_slot_old(si, slot_num, &bh);
> > >  	spin_unlock(&osb->osb_lock);
> > > +	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
> > > +		status = ocfs2_error(osb->sb,
> > > +				     "Invalid Slot Map Buffer Head "
> > > +				     "Block Number : %llu, Should be >= %d",
> > > +				     (unsigned long long)bh->b_blocknr,
> > > +				     OCFS2_SUPER_BLOCK_BLKNO);
> > > +		if (!status)
> > > +			return -EIO;
> > > +		return status;
> > > +	}
> > >  
> > >  	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
> > >  	if (status < 0)
> > > 
> > 
> > Ummm... The 'bh' is from ocfs2_slot_info, which is load from crafted
> > image during mount.
> > So IIUC, the root cause is we read slot info without validating, see
> > ocfs2_refresh_slot_info().
> > So I'd prefer to implement a validate func and pass it into
> > ocfs2_read_blocks() to do this job.
> > 
> > Thanks,
> > Joseph
> 
> I checked using GDB and learnt that ocfs2_refresh_slot() is not called 
> until the bug is triggered. Checking further, I obtained this backtrace 
> just before the bug was triggered, with a breakpoint set at 
> ocfs2_read_blocks():
> 
> #0  ocfs2_read_blocks (ci=0xffff88804b6e3cc0, block=0, nr=1, bhs=0xffffc9000f37efe0, 
>     flags=1, validate=0x0) at fs/ocfs2/buffer_head_io.c:197
> #1  0xffffffff83a1fb44 in ocfs2_map_slot_buffers (osb=0xffff888028d2c000, 
>     si=0xffff888027329d00) at fs/ocfs2/slot_map.c:385
> #2  ocfs2_init_slot_info (osb=0xffff888028d2c000) at fs/ocfs2/slot_map.c:424
> #3  0xffffffff83a91b93 in ocfs2_initialize_super (sb=0xffff88802912a000, bh=<optimized out>, 
>     sector_size=<optimized out>, stats=<optimized out>) at fs/ocfs2/super.c:2220
> #4  ocfs2_fill_super (sb=0xffff88802912a000, fc=<optimized out>) at fs/ocfs2/super.c:993
> #5  0xffffffff822db16e in get_tree_bdev_flags (fc=0xffff888029dac800, 
>     fill_super=0xffffffff83a8d5c0 <ocfs2_fill_super>, flags=<optimized out>)
>     at fs/super.c:1691
> #6  0xffffffff822db3b2 in vfs_get_tree (fc=0xffff888029dac800) at fs/super.c:1751
> #7  0xffffffff82366f32 in fc_mount (fc=0xffff888029dac800) at fs/namespace.c:1208
> #8  do_new_mount_fc (fc=0xffff888029dac800, mountpoint=0xffffc9000f37fe60, mnt_flags=48)
>     at fs/namespace.c:3651
> #9  do_new_mount (path=0xffffc9000f37fe60, fstype=<optimized out>, sb_flags=<optimized out>, 
>     mnt_flags=48, name=0xffff888024bf93a0 "/dev/loop0", data=0xffff888028b54000)
>     at fs/namespace.c:3727
> #10 0xffffffff823659c7 in path_mount (
>     dev_name=0x1 <error: Cannot access memory at address 0x1>, path=0xffff888024bf93a0, 
>     type_page=0xffff888028b54000 "user_xattr", flags=<optimized out>, 
>     data_page=0x7fffc7d5cb00) at fs/namespace.c:4037
> #11 0xffffffff82369253 in do_mount (dev_name=0xffff888024bf93a0 "/dev/loop0", 
>     dir_name=0x200000000040 "./file1", type_page=<optimized out>, flags=2240, 
> --Type <RET> for more, q to quit, c to continue without paging--
>     data_page=0xffff888028b54000) at fs/namespace.c:4050
> #12 __do_sys_mount (type=<optimized out>, dev_name=<optimized out>, dir_name=<optimized out>, flags=<optimized out>, 
>     data=<optimized out>) at fs/namespace.c:4238
> #13 __se_sys_mount (dev_name=<optimized out>, dir_name=35184372088896, type=<optimized out>, flags=2240, 
>     data=140736546065152) at fs/namespace.c:4215
> #14 0xffffffff82368f2c in __x64_sys_mount (regs=<optimized out>) at fs/namespace.c:4215
> #15 0xffffffff81328ced in x64_sys_call (regs=0xffff88804b6e3cc0, nr=0) at arch/x86/entry/syscall_64.c:37
> #16 0xffffffff8ac0015a in do_syscall_x64 (regs=0xffffc9000f37ff48, nr=165) at arch/x86/entry/syscall_64.c:63
> #17 do_syscall_64 (regs=0xffffc9000f37ff48, nr=165) at arch/x86/entry/syscall_64.c:94
> #18 0xffffffff81000130 in entry_SYSCALL_64 () at arch/x86/entry/entry_64.S:121
> #19 0x0000000000000000 in ?? ()
> 
> Hence, I think the function to fix would be ocfs2_map_slot_buffers() i.e.
> the call to ocfs2_read_blocks() in it. I came up with following changes:

Why does the syzbot test code never trigger ocfs2_refresh_slot_info()?
According to the comment for LOCK_TYPE_REQUIRES_REFRESH, we know it requires DLM
AST callback, but syzbot only mounts & operates the ocfs2 volume in local mode.

For this specific bug, adding validation function into ocfs2_map_slot_buffers()
is correct. However, we should also add a validation action in
ocfs2_refresh_slot_info(). This is another way to read slot map data.

> 
> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> index e544c704b583..299751617919 100644
> --- a/fs/ocfs2/slot_map.c
> +++ b/fs/ocfs2/slot_map.c
> @@ -332,6 +332,26 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num)
>         return ocfs2_update_disk_slot(osb, osb->slot_info, slot_num);
>  }
>  
> +static int ocfs2_validate_slot_map_block(struct super_block *sb,
> +                                     struct buffer_head *bh)
> +{
> +       int rc;
> +
> +       BUG_ON(!buffer_uptodate(bh));
> +
> +       if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
> +               rc = ocfs2_error(osb->sb,
> +                               "Invalid Slot Map Buffer Head "
> +                               "Block Number : %llu, Should be >= %d",
> +                               (unsigned long long)bh->b_blocknr,
> +                               OCFS2_SUPER_BLOCK_BLKNO);
> +               if (!rc)
> +                       return -EIO;
> +               return status;
> +       }
> +       return 0;
> +}
> +
>  static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
>                                   struct ocfs2_slot_info *si)
>  {
> @@ -383,7 +403,8 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
>  
>                 bh = NULL;  /* Acquire a fresh bh */
>                 status = ocfs2_read_blocks(INODE_CACHE(si->si_inode), blkno,
> -                                          1, &bh, OCFS2_BH_IGNORE_CACHE, NULL);
> +                                          1, &bh, OCFS2_BH_IGNORE_CACHE,
> +                                          ocfs2_validate_slot_map_block);
>                 if (status < 0) {
>                         mlog_errno(status);
>                         goto bail;
>   
> What do you think? Is this the correct approach?
> 
> Thank You,
> Prithvi

Based on my above comments, we should also add ocfs2_validate_slot_map_block()
in ocfs2_refresh_slot_info().

Thanks,
Heming
