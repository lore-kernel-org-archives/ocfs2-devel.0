Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534C127A103
	for <ocfs2-devel@lists.linux.dev>; Tue, 23 Dec 2025 20:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766521883; cv=none; b=VEEZKaJdpEQi0z/836wc/c8fEsedf92bnuUnmqWD0CYLKg6FU7LXGF1kzQ22hJRIEu6pJWlK4iG/iSbSthj7NkmjXyYADMqrNQQst7zBc8KRCve9hfHxHwC1XBMrtVY2dI19xZbFn61+kRs/l6ypuw3Yk4gyiCP/flb0iYzoIQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766521883; c=relaxed/simple;
	bh=HHESpmR1tK8gSkmx9sXywfu4V+qe2wB3rl0EXcCfdkU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NoTJGOTQZJp7/9iIcQ9EENw6FyJyCqzwj7uXyCVnbufvVSIp2cEqeurwQ4mrMdgyGnpRADlOYuSDf0fqbAPxzGOwTKTbJA+lIyiEWQyhFRfc41UXZ4q+6w9lbDj9JDt33uiQet+jcy+xPslyZCNS/+WEpulrK+MxTTrCCzMrQis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-656b2edce07so8851432eaf.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Dec 2025 12:31:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766521880; x=1767126680;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=enGZm49RUgF1V6AJU/+Rzow89Q8CpOstgdHUtOvF0YA=;
        b=miPrbOIxHO3yYSCDKOZPXy5uw2efR8OmdMoDGPZvAhWTcBqEFWGN3tc/FJnAle94lG
         cTrUr/Cahcl2g5yrEAnUgzL0fXWK7U63l8epyQ84oBUUyEGcmWcCRMGUVLoPqkrlsRCC
         3WxlTZMo3vEausG8/86zWAJgEdgqQN+UllaHf4MBVGvexwHn/jHRbjaNo8uGBA61RZT7
         1UBnpSkbE7Lxt6as66UoXAzSj5J3/TRojEWLKm+kn5UhhTAEECs5kmSjey+xvnYXUWQ4
         gUbPSdY82SG+5ST3cWNe3NQSOwFSjm8e1txXqnqdTHXpsXCXqR/LcDhCD6r+Y/FJq2Dw
         68Eg==
X-Forwarded-Encrypted: i=1; AJvYcCWRetVuP1lEMg6kZh34Csn9gM2xTKuPhS0FUDkM+SwbR0WAvPKKktgbs/ehom6+MtH9JcKZj0v8u8HcSw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw77qa4OC29Kttt4GtvPK3Np57/+oxiiPn3srxYVr2IhXOShDFp
	gcRsdxMrpmYydxi1uM1NYwnY+BvJEOl7yWBfFyXW/XcwBj9oZBW08moo5aUfPOpIjJ74rN/Ixmj
	nDIj945JDHkvu0n71VQaR1nRMBjMHy5ce0iHEKXbX66pp6yXPwzg226qQZ5E=
X-Google-Smtp-Source: AGHT+IGG2r6M+zIgcdivfRd7iUP41KU2ZT6AymZdssJNCS+vfdED5ZfEKuVzK7I2aEbdn2L3byCGGOP74NFYtPqlyrz0uWKs4r9x
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f029:b0:65d:b36:bdd4 with SMTP id
 006d021491bc7-65d0e94cf20mr7073768eaf.17.1766521880229; Tue, 23 Dec 2025
 12:31:20 -0800 (PST)
Date: Tue, 23 Dec 2025 12:31:20 -0800
In-Reply-To: <69441a92.a70a0220.207337.00e4.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694afc18.050a0220.35954c.0006.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_move_extents
From: syzbot <syzbot+7960178e777909060224@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8f0b4cce4481 Linux 6.19-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=12eb8bb4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8594efdc14f07a
dashboard link: https://syzkaller.appspot.com/bug?extid=7960178e777909060224
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14838f1a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16eb8bb4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cd4f5f43efc8/disk-8f0b4cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aafb35ac3a3c/vmlinux-8f0b4cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d221fae4ab17/Image-8f0b4cce.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2c226c2e3d21/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=10838f1a580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7960178e777909060224@syzkaller.appspotmail.com

=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:1383!
Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
Modules linked in:
CPU: 1 UID: 0 PID: 6734 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : ocfs2_block_group_set_bits+0x784/0x8ec fs/ocfs2/suballoc.c:1383
lr : ocfs2_block_group_set_bits+0x784/0x8ec fs/ocfs2/suballoc.c:1383
sp : ffff8000a3eb7260
x29: ffff8000a3eb7320 x28: ffff0000f60124f8 x27: ffff0000ca05c000
x26: ffff0000eaee1b00 x25: ffff0000c5c8c000 x24: 1ffff000147d6e58
x23: ffff0000c5c8c00c x22: dfff800000000000 x21: 0000000000000001
x20: 0000000000000002 x19: 0000000000000000 x18: 00000000ffffffff
x17: ffff800082225fb0 x16: ffff80008af67980 x15: 0000000000000001
x14: 0000000000000000 x13: 00000000fffffffc x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000c8f1d580 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000002 x4 : 0000000000000001 x3 : ffff0000c1707d98
x2 : ffff0000c5c8c000 x1 : 0000000000000001 x0 : 0000000000000002
Call trace:
 ocfs2_block_group_set_bits+0x784/0x8ec fs/ocfs2/suballoc.c:1383 (P)
 ocfs2_move_extent fs/ocfs2/move_extents.c:693 [inline]
 __ocfs2_move_extents_range fs/ocfs2/move_extents.c:865 [inline]
 ocfs2_move_extents+0x213c/0x2e78 fs/ocfs2/move_extents.c:937
 ocfs2_ioctl_move_extents+0x448/0x614 fs/ocfs2/move_extents.c:1069
 ocfs2_ioctl+0x1c4/0x738 fs/ocfs2/ioctl.c:942
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0x14c/0x1c4 fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: 17ffffa0 97944b2d d4210000 97944b2b (d4210000) 
---[ end trace 0000000000000000 ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
