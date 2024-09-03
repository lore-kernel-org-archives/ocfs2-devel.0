Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB0119F41F
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Sep 2024 11:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725364491; cv=none; b=Lif4HhEwK+RnUQC+vud8G3MNC2CdIPLR7fhjTOGJU14MaJpdH/a3QTEgm+0pY+ImhVDzITiz/YsFZrh9tcv/ifzRzoiOcN0+y9dstdpQbijQZELncMyV+YeFpvvn5r6wRGoTUm1ZThGR/FW4Lvw6v7kOjN9dfCG8ZMU8suln6f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725364491; c=relaxed/simple;
	bh=+mPmNewDlZ8Ihi496kUYO8SXRxUeuQVCA1BZMp+uGtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VcdExOSEwlPfi5L4PvIK7R9er7jDpmfu6n4L4ayXfzLwKHdcRC/3/WAttZzS3q+okVGcor+GdJ6hMNEBrmp1lpjIkz1UrNptAhzqirzZy18y9zzNZkKtSWo8LNhLtflwL0OAqM3kwdBFIqbob9ZnrxqJUpYr+zXF3yTDuLNCDY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=opVlBOCX; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="opVlBOCX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725364485; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=i06l3kzqnVLxhoBfc5PeACxcFuKsRV3tYKhJtecTSU0=;
	b=opVlBOCXf22/Eq79yMbL4osBu5W4o5PqIqulewPgcfX8b8XliwnXPUkvxbz5BWvL5ZpZWjlxvAfiNH8XVs65kn+5pwDMWcGSQgiKnYMfD5HzFtw/VcGzlwQHD/PYTgyDtS5ErSi+4kg8ZNUhT9PMiRw+V4gkQXHMqSL8Hcf5vo0=
Received: from 30.221.129.151(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WEDCBFt_1725364484)
          by smtp.aliyun-inc.com;
          Tue, 03 Sep 2024 19:54:45 +0800
Message-ID: <b9efefaf-76ea-4ffb-8601-ad83b593ef7a@linux.alibaba.com>
Date: Tue, 3 Sep 2024 19:54:44 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [ocfs2?] WARNING: ODEBUG bug in ocfs2_local_read_info
To: syzbot <syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com>,
 jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <000000000000a1395d062124e614@google.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <000000000000a1395d062124e614@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When ocfs2_load_local_quota_bitmaps() fails, it will free oinfo with
active dqi_sync_work.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 8ce462c64c51..ebe0dbc8db4a 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -782,6 +782,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 		if (locked)
 			ocfs2_inode_unlock(lqinode, 1);
 		ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
+		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 		kfree(oinfo);
 	}
 	brelse(bh);

On 9/2/24 11:50 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    df54f4a16f82 Merge branch 'for-next/core' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c4a31f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dde5a5ba8d41ee9e
> dashboard link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b4f0fb980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11974d43980000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/aa2eb06e0aea/disk-df54f4a1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/14728733d385/vmlinux-df54f4a1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/99816271407d/Image-df54f4a1.gz.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/0c40477ea929/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
> 
> (syz-executor200,6389,1):ocfs2_local_read_info:763 ERROR: status = -5
> ------------[ cut here ]------------
> ODEBUG: free active (active state 0) object: 00000000d8b0ce28 object type: timer_list hint: qsync_work_fn+0x0/0x16c
> WARNING: CPU: 1 PID: 6389 at lib/debugobjects.c:518 debug_print_object lib/debugobjects.c:515 [inline]
> WARNING: CPU: 1 PID: 6389 at lib/debugobjects.c:518 __debug_check_no_obj_freed lib/debugobjects.c:990 [inline]
> WARNING: CPU: 1 PID: 6389 at lib/debugobjects.c:518 debug_check_no_obj_freed+0x398/0x47c lib/debugobjects.c:1020
> Modules linked in:
> CPU: 1 UID: 0 PID: 6389 Comm: syz-executor200 Not tainted 6.11.0-rc5-syzkaller-gdf54f4a16f82 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : debug_print_object lib/debugobjects.c:515 [inline]
> pc : __debug_check_no_obj_freed lib/debugobjects.c:990 [inline]
> pc : debug_check_no_obj_freed+0x398/0x47c lib/debugobjects.c:1020
> lr : debug_print_object lib/debugobjects.c:515 [inline]
> lr : __debug_check_no_obj_freed lib/debugobjects.c:990 [inline]
> lr : debug_check_no_obj_freed+0x398/0x47c lib/debugobjects.c:1020
> sp : ffff800099586af0
> x29: ffff800099586b30 x28: 0000000000000000 x27: ffff80008b4827c0
> x26: ffff0000d78c6ac8 x25: dfff800000000000 x24: 0000000000000000
> x23: ffff80009410aee8 x22: ffff0000d78c6000 x21: 0000000000000000
> x20: ffff8000820f29cc x19: ffff0000d78c6800 x18: 0000000000000008
> x17: 626f203832656330 x16: ffff800080345a84 x15: 0000000000000001
> x14: 1fffe000367a12c8 x13: 0000000000000000 x12: 0000000000000003
> x11: 0000000000000001 x10: 0000000000000003 x9 : 7913726110ee6700
> x8 : 7913726110ee6700 x7 : ffff80008b3cfc98 x6 : 0000000000000000
> x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
> x2 : 0000000000000006 x1 : ffff80008b462a00 x0 : ffff80012489c000
> Call trace:
>  debug_print_object lib/debugobjects.c:515 [inline]
>  __debug_check_no_obj_freed lib/debugobjects.c:990 [inline]
>  debug_check_no_obj_freed+0x398/0x47c lib/debugobjects.c:1020
>  slab_free_hook mm/slub.c:2219 [inline]
>  slab_free mm/slub.c:4473 [inline]
>  kfree+0x124/0x3e0 mm/slub.c:4594
>  ocfs2_local_read_info+0x1338/0x1550 fs/ocfs2/quota_local.c:785
>  dquot_load_quota_sb+0x700/0xb48 fs/quota/dquot.c:2460
>  dquot_load_quota_inode+0x280/0x4f4 fs/quota/dquot.c:2497
>  ocfs2_enable_quotas+0x1d4/0x3cc fs/ocfs2/super.c:926
>  ocfs2_fill_super+0x3c80/0x4740 fs/ocfs2/super.c:1141
>  mount_bdev+0x1d4/0x2a0 fs/super.c:1679
>  ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
>  legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
>  vfs_get_tree+0x90/0x28c fs/super.c:1800
>  do_new_mount+0x278/0x900 fs/namespace.c:3472
>  path_mount+0x590/0xe04 fs/namespace.c:3799
>  do_mount fs/namespace.c:3812 [inline]
>  __do_sys_mount fs/namespace.c:4020 [inline]
>  __se_sys_mount fs/namespace.c:3997 [inline]
>  __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:3997
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>  el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
>  el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
>  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
> irq event stamp: 66264
> hardirqs last  enabled at (66263): [<ffff8000802b6870>] raw_spin_rq_unlock_irq+0x14/0x24 kernel/sched/sched.h:1427
> hardirqs last disabled at (66264): [<ffff80008b2ee35c>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:470
> softirqs last  enabled at (66246): [<ffff8000801f77b8>] softirq_handle_end kernel/softirq.c:400 [inline]
> softirqs last  enabled at (66246): [<ffff8000801f77b8>] handle_softirqs+0xa3c/0xbfc kernel/softirq.c:582
> softirqs last disabled at (66225): [<ffff800080020de8>] __do_softirq+0x14/0x20 kernel/softirq.c:588
> ---[ end trace 0000000000000000 ]---
> (syz-executor200,6389,1):ocfs2_enable_quotas:939 ERROR: status = -1
> (syz-executor200,6389,1):ocfs2_fill_super:1145 ERROR: status = -1
> ocfs2: Unmounting device (7,0) on (node local)
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

