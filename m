Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CCA41A8F
	for <ocfs2-devel@lists.linux.dev>; Sat, 13 Dec 2025 08:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765616146; cv=none; b=gghDG25M7VDkQ19KbOAvWkzyavuMYG4XCBDXZmlHT63LVWkjuZ2ePt4Eo2JUry+a/5GaSywjB/y7EX29c3EjU+Z4z+vN9tCALzp6bMsFUVSrN1HYivlrBXTDPazsHKi0VdI8/mlF0g6Zdkt0WB6XeHjZi0ZWIW9Wdihf7YMOT00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765616146; c=relaxed/simple;
	bh=Ap/xN+ohCrjvsa7OyB6aMNevZszmz22wTJ6d+jBLkl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WIBzHXPDnhkvAjSv5AZdIMQ0lTU7mH69O6neR9LKwj2SjFzW0H8BHRmEw0YNN6WKXw5szB32cgzsWiWlnwoGltztpuozoZBvNRR6AepfAGpqzaVpHbKkAprMElcCKPpOEl2DvxsdM7yi/6QcF1e5xU6PsA9knvS0doYMVWvE9RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ETdP2bL0; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ETdP2bL0"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso2127716b3a.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 13 Dec 2025 00:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765616144; x=1766220944; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EAPKwQxYFNxoXWaJA+G1Z4tfRb/olAqqNaUD+VOrvo8=;
        b=ETdP2bL0rRgbG0WtfylOJ/tLysELNEBh9LRy+ps31KGVgQkh//ub4qMOUhdvULxKPT
         wrY+m0ySheT41H3Fh6lWcvy6NaXqqYlKPxBUuPv2M8D5BMeC8KShgofyfA5dqkIB6EH0
         ZGJhLOg2MbBkyg+KoARBIusjMYwHBw68II2+sx7LU7sYcFR7cAx8tIbz9a3p96cYvDmU
         GcwhZzgUGNgOwpX2oQC+VqD46TblubERHn1OA3MsBb4bpzfb7NUcgqP2hVvSo/lhxmIS
         LNcJ5L/QUWtufsij9mc6jLb8/8X0maV42/J0IpNdOwuf/SZR7D0Mfl7V2fu6lym5RIDs
         hXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765616144; x=1766220944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EAPKwQxYFNxoXWaJA+G1Z4tfRb/olAqqNaUD+VOrvo8=;
        b=Vp7okIBEYU0u2tslrdw5bZEn0Cwu0rLhPvHZgkcp77Di6VKkpx7LRDoGvIqAUR+nh5
         jLm6L1zwVbINlyDFjsbiEOk9biaBsg3FQK7Deq2/ZD6AJIyhU0YwyxJnwBCM8J13oSiA
         LB081ul+Hft9cu8IfB3Zo++/jZ9COrlf50lBApdUBUVHqzdriu+NOBgQQUXai9JN6NHN
         HuKxEUMoXErc6q1+ROwLhdMdzEQnxIOJK8k4nHmAIiIjLOBFUOx3e2U+pF6uJv5rr1mO
         BRWe3XTr6OPt/G1oeUmw2DrQiRRvW0w0CwIxXbMHlVS0QZJrwqg2E+NBc3BcM9PDb+sG
         xSOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOhhM9sZuYr0GYZghf/D45UnMAnFE7GprgTyDNoAZyDQNdU6gEUBC21C7GW8x9r6+YLhHREk1dLmDaPQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwnxKS5BPQTb15pITOOc2s8l00PLVCpNAg67PzuKNV+ZYC+ndCx
	F0ce/LnL15LLXlnbTJa4UjJFN4rIoKKPYjrjmE8o9+Ol4WGj/Tq7D0HH
X-Gm-Gg: AY/fxX56dVeaNpKIQFZ15kFQw85zNwQ4tf0CQR6RJnVDbEaw1PHeT5mNVUAnwtdIlnx
	KcGO1rWJASOygdLdwz2ddjMZDSdWzXtnNXcCjejm7eKxsgDshn3VPT2UQGBdO0BR1QAoFeIahCf
	9LOSOob5rJxxkdspDR76elzSs1PwT/6jJigQLTxx5Jr5Gxa21aN6Wy3fraUHE3O9hwIvJQth/ci
	zPp6HTk2488O7QfODZUP7/0jg6pZeDymSca5Iuq7qeQVgKYGqNgf75frplbg6XQH8OQeioy6Y6+
	GP45sj11dQMuvHggrHPOBUm62rUd8GzXW3ATC0/EAijvjYF3WZp149tLtY04N8B1JSqWPFt/0fr
	KPrdUkRQa+Dmq7CJgV/GbG7q17RW6QjQbXFvlzkNXZFb7i0Sa8lQSekDdpBW4xSjElVQUnNjtfC
	MM/u+kBEELGRv+d7nc8QqsFz8=
X-Google-Smtp-Source: AGHT+IFlig2DrZx8Feq9J9/VJRsbtE/6az80e8ZmIURSYb8lP80150rRSXNzgVWthWWXmu3XAcfTBA==
X-Received: by 2002:a05:6a00:4388:b0:7ab:6fdb:1d1f with SMTP id d2e1a72fcca58-7f667d1ff24mr4111609b3a.29.1765616144258;
        Sat, 13 Dec 2025 00:55:44 -0800 (PST)
Received: from prithvi-HP ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c237ef12sm7241612b3a.14.2025.12.13.00.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Dec 2025 00:55:43 -0800 (PST)
Date: Sat, 13 Dec 2025 14:25:29 +0530
From: Prithvi <activprithvi@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, 
	Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, david.hunter.linux@gmail.com, 
	khalid@kernel.org, syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] ocfs2: fix kernel BUG in ocfs2_write_block
Message-ID: <neqzjkw3ylaqghldgkl7jzlcl4o3vofbm6aa3a2kojfaakzjhm@ele2brknwzwm>
References: <20251210193257.25500-1-activprithvi@gmail.com>
 <9bad11da-0655-4fb4-b424-8c124b127290@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bad11da-0655-4fb4-b424-8c124b127290@linux.alibaba.com>

On Thu, Dec 11, 2025 at 10:17:21AM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/11 03:32, Prithvi Tambewagh wrote:
> > When the filesystem is being mounted, the kernel panics while the data
> > regarding slot map allocation to the local node, is being written to the
> > disk. This occurs because the value of slot map buffer head block
> > number, which should have been greater than or equal to
> > `OCFS2_SUPER_BLOCK_BLKNO` (evaluating to 2) is less than it, indicative
> > of disk metadata corruption. This triggers
> > BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) in ocfs2_write_block(),
> > causing the kernel to panic.
> > 
> > This is fixed by introducing an if condition block in
> > ocfs2_update_disk_slot(), right before calling ocfs2_write_block(), which
> > checks if `bh->b_blocknr` is lesser than `OCFS2_SUPER_BLOCK_BLKNO`; if
> > yes, then ocfs2_error is called, which prints the error log, for
> > debugging purposes, and the return value of ocfs2_error() is returned
> > back to caller of ocfs2_update_disk_slot() i.e. ocfs2_find_slot(). If
> > the return value is zero. then error code EIO is returned.
> > 
> > Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
> > Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> > ---
> > v1->v2:
> >  - Remove usage of le16_to_cpu() from ocfs2_error()
> >  - Cast bh->b_blocknr to unsigned long long
> >  - Remove type casting for OCFS2_SUPER_BLOCK_BLKNO
> >  - Fix Sparse warnings reported in v1 by kernel test robot
> >  - Update title from 'ocfs2: Fix kernel BUG in ocfs2_write_block' to
> >    'ocfs2: fix kernel BUG in ocfs2_write_block'
> > 
> > v1 link: https://lore.kernel.org/all/20251206154819.175479-1-activprithvi@gmail.com/T/
> > 
> >  fs/ocfs2/slot_map.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> > index e544c704b583..e916a2e8f92d 100644
> > --- a/fs/ocfs2/slot_map.c
> > +++ b/fs/ocfs2/slot_map.c
> > @@ -193,6 +193,16 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
> >  	else
> >  		ocfs2_update_disk_slot_old(si, slot_num, &bh);
> >  	spin_unlock(&osb->osb_lock);
> > +	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
> > +		status = ocfs2_error(osb->sb,
> > +				     "Invalid Slot Map Buffer Head "
> > +				     "Block Number : %llu, Should be >= %d",
> > +				     (unsigned long long)bh->b_blocknr,
> > +				     OCFS2_SUPER_BLOCK_BLKNO);
> > +		if (!status)
> > +			return -EIO;
> > +		return status;
> > +	}
> >  
> >  	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
> >  	if (status < 0)
> > 
> 
> Ummm... The 'bh' is from ocfs2_slot_info, which is load from crafted
> image during mount.
> So IIUC, the root cause is we read slot info without validating, see
> ocfs2_refresh_slot_info().
> So I'd prefer to implement a validate func and pass it into
> ocfs2_read_blocks() to do this job.
> 
> Thanks,
> Joseph

I checked using GDB and learnt that ocfs2_refresh_slot() is not called 
until the bug is triggered. Checking further, I obtained this backtrace 
just before the bug was triggered, with a breakpoint set at 
ocfs2_read_blocks():

#0  ocfs2_read_blocks (ci=0xffff88804b6e3cc0, block=0, nr=1, bhs=0xffffc9000f37efe0, 
    flags=1, validate=0x0) at fs/ocfs2/buffer_head_io.c:197
#1  0xffffffff83a1fb44 in ocfs2_map_slot_buffers (osb=0xffff888028d2c000, 
    si=0xffff888027329d00) at fs/ocfs2/slot_map.c:385
#2  ocfs2_init_slot_info (osb=0xffff888028d2c000) at fs/ocfs2/slot_map.c:424
#3  0xffffffff83a91b93 in ocfs2_initialize_super (sb=0xffff88802912a000, bh=<optimized out>, 
    sector_size=<optimized out>, stats=<optimized out>) at fs/ocfs2/super.c:2220
#4  ocfs2_fill_super (sb=0xffff88802912a000, fc=<optimized out>) at fs/ocfs2/super.c:993
#5  0xffffffff822db16e in get_tree_bdev_flags (fc=0xffff888029dac800, 
    fill_super=0xffffffff83a8d5c0 <ocfs2_fill_super>, flags=<optimized out>)
    at fs/super.c:1691
#6  0xffffffff822db3b2 in vfs_get_tree (fc=0xffff888029dac800) at fs/super.c:1751
#7  0xffffffff82366f32 in fc_mount (fc=0xffff888029dac800) at fs/namespace.c:1208
#8  do_new_mount_fc (fc=0xffff888029dac800, mountpoint=0xffffc9000f37fe60, mnt_flags=48)
    at fs/namespace.c:3651
#9  do_new_mount (path=0xffffc9000f37fe60, fstype=<optimized out>, sb_flags=<optimized out>, 
    mnt_flags=48, name=0xffff888024bf93a0 "/dev/loop0", data=0xffff888028b54000)
    at fs/namespace.c:3727
#10 0xffffffff823659c7 in path_mount (
    dev_name=0x1 <error: Cannot access memory at address 0x1>, path=0xffff888024bf93a0, 
    type_page=0xffff888028b54000 "user_xattr", flags=<optimized out>, 
    data_page=0x7fffc7d5cb00) at fs/namespace.c:4037
#11 0xffffffff82369253 in do_mount (dev_name=0xffff888024bf93a0 "/dev/loop0", 
    dir_name=0x200000000040 "./file1", type_page=<optimized out>, flags=2240, 
--Type <RET> for more, q to quit, c to continue without paging--
    data_page=0xffff888028b54000) at fs/namespace.c:4050
#12 __do_sys_mount (type=<optimized out>, dev_name=<optimized out>, dir_name=<optimized out>, flags=<optimized out>, 
    data=<optimized out>) at fs/namespace.c:4238
#13 __se_sys_mount (dev_name=<optimized out>, dir_name=35184372088896, type=<optimized out>, flags=2240, 
    data=140736546065152) at fs/namespace.c:4215
#14 0xffffffff82368f2c in __x64_sys_mount (regs=<optimized out>) at fs/namespace.c:4215
#15 0xffffffff81328ced in x64_sys_call (regs=0xffff88804b6e3cc0, nr=0) at arch/x86/entry/syscall_64.c:37
#16 0xffffffff8ac0015a in do_syscall_x64 (regs=0xffffc9000f37ff48, nr=165) at arch/x86/entry/syscall_64.c:63
#17 do_syscall_64 (regs=0xffffc9000f37ff48, nr=165) at arch/x86/entry/syscall_64.c:94
#18 0xffffffff81000130 in entry_SYSCALL_64 () at arch/x86/entry/entry_64.S:121
#19 0x0000000000000000 in ?? ()

Hence, I think the function to fix would be ocfs2_map_slot_buffers() i.e.
the call to ocfs2_read_blocks() in it. I came up with following changes:

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e544c704b583..299751617919 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -332,6 +332,26 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num)
        return ocfs2_update_disk_slot(osb, osb->slot_info, slot_num);
 }
 
+static int ocfs2_validate_slot_map_block(struct super_block *sb,
+                                     struct buffer_head *bh)
+{
+       int rc;
+
+       BUG_ON(!buffer_uptodate(bh));
+
+       if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
+               rc = ocfs2_error(osb->sb,
+                               "Invalid Slot Map Buffer Head "
+                               "Block Number : %llu, Should be >= %d",
+                               (unsigned long long)bh->b_blocknr,
+                               OCFS2_SUPER_BLOCK_BLKNO);
+               if (!rc)
+                       return -EIO;
+               return status;
+       }
+       return 0;
+}
+
 static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
                                  struct ocfs2_slot_info *si)
 {
@@ -383,7 +403,8 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 
                bh = NULL;  /* Acquire a fresh bh */
                status = ocfs2_read_blocks(INODE_CACHE(si->si_inode), blkno,
-                                          1, &bh, OCFS2_BH_IGNORE_CACHE, NULL);
+                                          1, &bh, OCFS2_BH_IGNORE_CACHE,
+                                          ocfs2_validate_slot_map_block);
                if (status < 0) {
                        mlog_errno(status);
                        goto bail;
  
What do you think? Is this the correct approach?

Thank You,
Prithvi
