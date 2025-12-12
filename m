Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9FA1D7E42
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 05:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765517906; cv=none; b=WG28w7OZokn9pG6wUj6I/voIqvhrD398Fx6eUYz9fMGJhM+BFzlAxT3yD0d5w4eTj3t8R/2/p/kW8+AYEZ61mrHagNeWBDTFy5MutNTnxHeiguxXJSOz9F6dfGyfyYUleq20PFcf8anpqC3i41e2tcos7h2e+1gt5JDI9X0TOXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765517906; c=relaxed/simple;
	bh=rywOz4yL6nuiX8PvK0MdIlQmOGuPXA7w2wPYTvSvSAY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Et8CVnxU8TL37aebDjeNjG6HqIdGPqZYC7/YEIsHfpQMCi4u0SiWcDrv1NjJkjo31iCH3/NUMDv3T/V1T72ekyrBh7rU3kmHKTza9XvhLdSOnTZTaprZQef1EKnS63Xhah0DYLnj29Y8h/D0EqJZycoxZ9lovZlHkdZiY3IMUOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7c75663feaeso923782a34.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 21:38:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765517904; x=1766122704;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n5FRsk4k8pWgQW3pvBEcPfoJffLNVMpt8tBMgDX/ISY=;
        b=Igi5o6C+Cg087Y5QYdHHQkJFXMbbVbBykI/UVyoupS0R3oRGHSb9EpaytisqOvPCIk
         TZwCEjJwqVKNInNlAGY19Sopt2iaIxqh+W1ZZ4ammQgupTckJt6x4uTdioIONxbwEJr7
         mkBJfAXgGTcPEzkm5AQx6BKg/hd3h31nuLCEjlWzCANQz7tKt1ubIEV+fbxfq9mCj5ud
         WTsWQ7Eo/EYXH6VZelhStd3jDOkOcaAaMVO7PZzer1Q5JpmMxK+H7pBhc834QKQtB+HD
         nze96UKpmOjkWItPPXirpxEipMKlRb9lBal1sWhA771g1L6hnUO7LW2V3YWjtza1+5/q
         ME7w==
X-Forwarded-Encrypted: i=1; AJvYcCU1zVmHtX0yE1CpaWOPFdo4YoBhrXEiknZHY7g7cMMHeNgB4DatPA3ZVm9IQDh954+baLnvB/GikCMlhA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxVmW9VbQ14/w7TTm4fTI9Lb8RjUMGc60W5Dbcmcpvrqa2fjK65
	IoFajHrsQuDpFPFFqXf8sqLwNTg7h+Oe+nWr3g17WVN5brsE6IuUEXPk32DlExo9l2KQUBMKLrs
	Q6XqIL/072Mqz7f7PZI+tXdMLtvGF5DulZT4EES43ZBrNJ8h2AWrCon/9oDo=
X-Google-Smtp-Source: AGHT+IF4CPr+Icxa2AMMPOWRjHV9UEywVk7iEqsgwQZyCqiKFIwm2AXnA5jMPW301LjfZanyUdjHouY7WS2tVDxd0XAIRzyY5rDR
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e917:0:b0:659:9a49:908f with SMTP id
 006d021491bc7-65b450e91a4mr456646eaf.14.1765517904503; Thu, 11 Dec 2025
 21:38:24 -0800 (PST)
Date: Thu, 11 Dec 2025 21:38:24 -0800
In-Reply-To: <68f777f8.050a0220.346f24.0016.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693baa50.a70a0220.33cd7b.004b.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in __ocfs2_claim_clusters
From: syzbot <syzbot+d937c5714fc8cd6d39df@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    05c93f3395ed Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=111f21b4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b5338ad1e59a06c
dashboard link: https://syzkaller.appspot.com/bug?extid=d937c5714fc8cd6d39df
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b4661a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102c5592580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6b5c913e373c/disk-05c93f33.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/15e75f1266ef/vmlinux-05c93f33.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dd930129c578/Image-05c93f33.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d7f8cb828f94/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=16b4661a580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d937c5714fc8cd6d39df@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
ocfs2: Mounting device (7,0) on (node local, slot 0) with writeback data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:2390!
Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6742 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : __ocfs2_claim_clusters+0x768/0x7c4 fs/ocfs2/suballoc.c:2390
lr : __ocfs2_claim_clusters+0x768/0x7c4 fs/ocfs2/suballoc.c:2390
sp : ffff8000a1706a60
x29: ffff8000a1706ba0 x28: 0000000000000040 x27: 0000000000000040
x26: dfff800000000000 x25: 1fffe00018d35af0 x24: ffff0000c69ad780
x23: 0000000000000039 x22: ffff0000da3ec000 x21: 0000000000000000
x20: ffff0000c69ad798 x19: ffff7000142e0d54 x18: 1fffe000337d4a90
x17: ffff800093335000 x16: ffff80008ad6b188 x15: 0000000000000005
x14: 1ffff000142e0d58 x13: 0000000000000000 x12: 0000000000000000
x11: ffff7000142e0d5d x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000c8278000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : ffff8000a1706d90 x4 : 0000000000000000 x3 : 0000000000000020
x2 : 0000000000000008 x1 : 0000000000000040 x0 : 0000000000000040
Call trace:
 __ocfs2_claim_clusters+0x768/0x7c4 fs/ocfs2/suballoc.c:2390 (P)
 ocfs2_claim_clusters fs/ocfs2/suballoc.c:2458 [inline]
 ocfs2_block_group_claim_bits fs/ocfs2/suballoc.c:474 [inline]
 ocfs2_block_group_grow_discontig fs/ocfs2/suballoc.c:515 [inline]
 ocfs2_block_group_alloc_discontig fs/ocfs2/suballoc.c:641 [inline]
 ocfs2_block_group_alloc fs/ocfs2/suballoc.c:703 [inline]
 ocfs2_reserve_suballoc_bits+0x1b64/0x3b9c fs/ocfs2/suballoc.c:834
 ocfs2_reserve_new_inode+0x3c0/0xac0 fs/ocfs2/suballoc.c:1074
 ocfs2_mknod+0x710/0x1cf0 fs/ocfs2/namei.c:306
 ocfs2_create+0x190/0x474 fs/ocfs2/namei.c:676
 lookup_open fs/namei.c:3796 [inline]
 open_last_lookups fs/namei.c:3895 [inline]
 path_openat+0x12d8/0x2c40 fs/namei.c:4131
 do_filp_open+0x18c/0x36c fs/namei.c:4161
 do_sys_openat2+0x11c/0x1b4 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __arm64_sys_openat+0x120/0x158 fs/open.c:1463
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: aa1803e2 94384723 17ffff3d 97951fa1 (d4210000) 
---[ end trace 0000000000000000 ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
