Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DD824468B
	for <ocfs2-devel@lists.linux.dev>; Sun, 17 Aug 2025 08:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755418352; cv=none; b=Ym99UoIK57khb2pgKZ0ETfVwHO09gRGTezzzn6x4kJpkOs7v9s31vKoZTvutPweZFUNzcUtl79bPt3ZWJGh+ROlqPeD1hEd38uAgQ1gQe0Gk0/NkPilwsG1hl2Wz1KyPybvPvaOWoYO7mHlczWL/m5sBnAB6hOdt3XZXwpdBev4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755418352; c=relaxed/simple;
	bh=AW6sLmSazbtbXmO7U6soHWpoFEqrOq0hjEP8XJJLFCU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=btQxQoQP7SNqpXahoiF0faK6An4i8oRGAQlA+oawmrseebaKJvB3FpP6yx8Uxjy5Jiupq+o65mY19JOSJTMEqmfFWE84+CWkIssJrz4yhhBzv2oH0uszZ4rRz2t0ViKoNcIl4HAkNR3+XhcMswldMqh3ZBqftqZRV4aXE5uNAvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-88432d877bfso833045339f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 Aug 2025 01:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755418350; x=1756023150;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1FEo5MNdjzGf+HIXbS40h2xQo76Aj3b1D1UbSjxnMgM=;
        b=mdfecHHtfyKYlvsV9YsmYMXxl/+n6tBkUF5dEQZeT1S6liUxd7Wl6Toe62/5+fhmvl
         xg2reZmhekQXo5t3lNuI3CJk41adyY7qeC/NV3PrilFvvc3DB5ePLt+r6mOm1hUAD9bY
         YDfyUiZDqdvQkMYlETkZNKdUCev9sBUC1xw/G1G5FvMMzFY89KMOaaTJ2+oT5I19qhra
         qH9gEIWiThmAvcP8lv+JmnLSMBSsv60QXdjw0BG4E5wS06Hx8BSyw037hsRmhEgICE0E
         il/3mQsvD26EVr5t/FIDpqMszEi9DeiiAg1cm+w9z+FgB1ENMCqNUbhameNPTr4sC6QL
         uRhg==
X-Forwarded-Encrypted: i=1; AJvYcCVK3dzcYeuaGb08FxcEA8v/0ayMXhW6FGviaQlLMtnoqiHpXXS/zdHIUoA/i9CfNQVY/TEN6tBPTamQQQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2VfztLukRRouDpiOuKOBfiHnUqta+Z5epdm50jqdzeM3DQ1Nt
	fGDrVA7u/BUzUdHjnsvt1VJnhJoEVrwMbbHWWmMLMB1HMGgFSTP+Z2pvInrIBG02TxPyHI/nrvm
	KDpTgRI01ERxSG3S0bU370ogLK/PjS1BGw4h9h7Kh+viUIIWntCSr5zJTt1M=
X-Google-Smtp-Source: AGHT+IG6d6PVrrGKrga+vdY3PDaxjskgFCezOAFrniJYq1rzRtzVkYWelqZ2P7eI0BCxzG9gybNWtTAW913YyFsXgEd4I3hxjK8J
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:750c:b0:884:48a5:4d51 with SMTP id
 ca18e2360f4ac-88448a552b8mr928341139f.13.1755418349909; Sun, 17 Aug 2025
 01:12:29 -0700 (PDT)
Date: Sun, 17 Aug 2025 01:12:29 -0700
In-Reply-To: <67ff1158.050a0220.d2ea7.0004.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a18eed.050a0220.e29e5.0063.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in __ocfs2_move_extents_range
From: syzbot <syzbot+f2107d999290b8166267@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1777e3a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=f2107d999290b8166267
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1599cba2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1399cba2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/cd2aa4d483e9/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1199cba2580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/a56844890eb2/mount_5.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1377e3a2580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f2107d999290b8166267@syzkaller.appspotmail.com

=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:1382!
Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6767 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : ocfs2_block_group_set_bits+0x780/0x8e8 fs/ocfs2/suballoc.c:1382
lr : ocfs2_block_group_set_bits+0x780/0x8e8 fs/ocfs2/suballoc.c:1382
sp : ffff8000a10b71a0
x29: ffff8000a10b7260 x28: ffff0000f456cfb8 x27: ffff0000c8f34000
x26: ffff0000f46155d8 x25: ffff0000c6265000 x24: 1ffff00014216e40
x23: ffff0000c626500c x22: dfff800000000000 x21: 0000000000000002
x20: 0000000000000004 x19: 0000000000000000 x18: 00000000ffffffff
x17: ffff800093507000 x16: ffff80008afd94bc x15: 0000000000000001
x14: 0000000000000000 x13: 00000000fffffffc x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d38dbd00 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000004 x4 : 0000000000000001 x3 : ffff0000def9fae0
x2 : ffff0000c6265000 x1 : 0000000000000002 x0 : 0000000000000004
Call trace:
 ocfs2_block_group_set_bits+0x780/0x8e8 fs/ocfs2/suballoc.c:1382 (P)
 ocfs2_move_extent fs/ocfs2/move_extents.c:687 [inline]
 __ocfs2_move_extents_range+0x2104/0x2ad8 fs/ocfs2/move_extents.c:859
 ocfs2_move_extents+0x314/0x7f0 fs/ocfs2/move_extents.c:926
 ocfs2_ioctl_move_extents+0x424/0x5f0 fs/ocfs2/move_extents.c:1052
 ocfs2_ioctl+0x1c4/0x738 fs/ocfs2/ioctl.c:946
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl fs/ioctl.c:584 [inline]
 __arm64_sys_ioctl+0x14c/0x1c4 fs/ioctl.c:584
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: 17ffffa8 9795f801 d4210000 9795f7ff (d4210000) 
---[ end trace 0000000000000000 ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
