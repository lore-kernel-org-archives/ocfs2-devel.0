Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CD5946F
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Sep 2024 02:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727231069; cv=none; b=Lxr88fpvcHlHEPietoqmvwh2JAGmf5IhE/MEqg6FiLPWNcI0blfamz+52wlUllIEJYp5gxpQkeXtNMirrjvTKPkiE15ADwyNwI2CyXgpl9whZYdbNOGZ6eBPhA9Khtmbg5k7d8zxz1SWX1f6cGxDEtpgpyzcvaH1NvHBjDnw8z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727231069; c=relaxed/simple;
	bh=1hfjPVR8xYUNEGOQYEwDTU/sigNSviBYkdwpcTH1enA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mAgRltLDwF9UkALOo0VewhtAHFvNkpVnsuVrfXFx8Zf/DIcyGCRIDHix/LRs4q9v3kU5jwS1Mk9+OEoBKM/mSfl0g/FyDhaGRd12ud61gNU0cuIwhdmVLLS54FDk8Pen4Hgjlaq0GlSqOeXSHXSKYpzjb6QUtT1TeJ1EpjJJAzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vBxbZb4U; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vBxbZb4U"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1727231058; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ctPCbbIrXfLhie32yFDtiMEmUEiu5OCZekEIljzc/7k=;
	b=vBxbZb4Usv7aZtO2fAWl8xfJhp6BkUt3GX+HT8ywbhTOCWLlKfPl2Br0u7mw6479NUqQXj3SLGE8yLiD+TrzsfC3YmKMLD88TQQn6ztZNOPvM39DrgIxXH/UBy0R+kM2KQyFKRCaciO/LiylQ0e9Xo5elvtV+sNhoiLkhQzRNH4=
Received: from 30.221.129.244(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WFhmHNe_1727230740)
          by smtp.aliyun-inc.com;
          Wed, 25 Sep 2024 10:19:00 +0800
Message-ID: <3a4a1d88-0a5c-4636-ace9-ffc269c64d4b@linux.alibaba.com>
Date: Wed, 25 Sep 2024 10:19:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [ocfs2?] KMSAN: uninit-value in ocfs2_get_block
To: syzbot <syzbot+9709e73bae885b05314b@syzkaller.appspotmail.com>,
 jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <66f36739.050a0220.30ac7d.0004.GAE@google.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <66f36739.050a0220.30ac7d.0004.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This blames p_blkno is uninitialized when ocfs2_extent_map_get_blocks()
fails.

#syz test: upstream

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1fea43c33b6b..db72b3e924b3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -156,9 +156,8 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
        err = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno, &count,
                                          &ext_flags);
        if (err) {
-               mlog(ML_ERROR, "Error %d from get_blocks(0x%p, %llu, 1, "
-                    "%llu, NULL)\n", err, inode, (unsigned long long)iblock,
-                    (unsigned long long)p_blkno);
+               mlog(ML_ERROR, "get_blocks() failed, inode: 0x%p, "
+                    "block: %llu\n", inode, (unsigned long long)iblock);
                goto bail;
        }

On 9/25/24 9:28 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    baeb9a7d8b60 Merge tag 'sched-rt-2024-09-17' of git://git...
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=172af607980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=acaa65be5f19fc5a
> dashboard link: https://syzkaller.appspot.com/bug?extid=9709e73bae885b05314b
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161e2ca9980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=151bff00580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/cac89ddb3388/disk-baeb9a7d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ddec90b149ab/vmlinux-baeb9a7d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f8db8244cc07/bzImage-baeb9a7d.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/25ed405f5727/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9709e73bae885b05314b@syzkaller.appspotmail.com
> 
> OCFS2: ERROR (device loop0): int __ocfs2_find_path(struct ocfs2_caching_info *, struct ocfs2_extent_list *, u32, path_insert_t *, void *): Owner 17 has empty extent list at depth 312
> On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
> OCFS2: Returning error to the calling process.
> (syz-executor337,5180,0):ocfs2_find_leaf:1940 ERROR: status = -30
> (syz-executor337,5180,0):ocfs2_get_clusters_nocache:421 ERROR: status = -30
> (syz-executor337,5180,0):ocfs2_get_clusters:624 ERROR: status = -30
> (syz-executor337,5180,0):ocfs2_extent_map_get_blocks:671 ERROR: status = -30
> =====================================================
> BUG: KMSAN: uninit-value in ocfs2_get_block+0xed2/0x2710 fs/ocfs2/aops.c:159
>  ocfs2_get_block+0xed2/0x2710 fs/ocfs2/aops.c:159
>  do_mpage_readpage+0xc45/0x2780 fs/mpage.c:225
>  mpage_readahead+0x43f/0x840 fs/mpage.c:374
>  ocfs2_readahead+0x269/0x320 fs/ocfs2/aops.c:381
>  read_pages+0x193/0x1110 mm/readahead.c:160
>  page_cache_ra_unbounded+0x901/0x9f0 mm/readahead.c:273
>  do_page_cache_ra mm/readahead.c:303 [inline]
>  force_page_cache_ra+0x3b1/0x4b0 mm/readahead.c:332
>  force_page_cache_readahead mm/internal.h:347 [inline]
>  generic_fadvise+0x6b0/0xa90 mm/fadvise.c:106
>  vfs_fadvise mm/fadvise.c:185 [inline]
>  ksys_fadvise64_64 mm/fadvise.c:199 [inline]
>  __do_sys_fadvise64 mm/fadvise.c:214 [inline]
>  __se_sys_fadvise64 mm/fadvise.c:212 [inline]
>  __x64_sys_fadvise64+0x1fb/0x3a0 mm/fadvise.c:212
>  x64_sys_call+0xe11/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:222
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Local variable p_blkno created at:
>  ocfs2_get_block+0xc7/0x2710 fs/ocfs2/aops.c:140
>  do_mpage_readpage+0xc45/0x2780 fs/mpage.c:225
> 
> CPU: 0 UID: 0 PID: 5180 Comm: syz-executor337 Not tainted 6.11.0-syzkaller-07341-gbaeb9a7d8b60 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
> =====================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

