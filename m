Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0497B4A02
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Sep 2024 00:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726704267; cv=none; b=nmg/JZSLoikikdF2FpVeg66ZqVHrguJtcTbjXAJQnk1pLskMMGuL9nRrfDzntMtzGi1v6FqPkU0tq/0zBxI45nYuYYIe9pikqQ4H3RLKYAjYyvj5uViS7628QeYrc1QlmRTKVDibjfLsDdjvYWCj82/mlW1v6V4kJ7c8KlK5kd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726704267; c=relaxed/simple;
	bh=seBFEfDluaukE3mbFAbqV9BKW3cC7+7uvlaqSTEGLhY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=V0745NNcGvyNpq68CoRhCVQjN2ILlN02anTSEmV9WDL+72DVVOBBiZycFU0s8EVTGXiUzq9Maan0AWo+r6V5X5Z71wqiNdjeQFoCMvZRXQrHtWMnF84TcVe3va7OiaoPiU6WrBwsqAPIv92wEyKvwi2ZCj/fybghAQRIrAXe2hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a0987c35f2so3791735ab.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 17:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726704265; x=1727309065;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NW+Qku8P+A27H+gzl0L7DRCUDwEIcFYOyGU/lOdolm4=;
        b=qJPxOvVU3I+grpeND5CuKr30ZrBEDPFxQt1BeSjKgBCEjMInGY92EFeKQVSVPlqeQP
         15p9iu2rfjCkKKyXoXN/P8166CNw2389tQIOtTUrRA0GUA49B2pvXB758Xi0Pl/oggVi
         3N+J1IP5PqDJMOT5gLZ7FPSPl+PYAnmiTxbH0a76+oPis0gf7CMSkxO3zu21BOIReTye
         qXgoJ2vmKDgWSPLXqHg/VjeDo/GzHC5vZ8cwuR6ehL7HyMO0WIOv6ibjzUiN8zKfMbQR
         OCRV2D/8Vegm3rjlalpjgWFVVAfkYRiQDBDfHW32+x3Sa6SP9bVKokfy9XhzTMY21dGJ
         OXng==
X-Forwarded-Encrypted: i=1; AJvYcCX+PUsrEPHNb6AoCTpMy5V/BW6wHD6Nv1ekOo1zacd3GmGKUOFo3zq6F/oTdYh0VDD+OVe76K5OyAk6EA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1ADD/hIT7fe9lxbGUdlKfO0doG5WygxsCSvOIPJUOFmxQHh+H
	WxDwyg1M7HzbVwCPoIviiQVFW19wcRj6KzuzbD/Z1S7bjJpVai3Rweegk2AJdRk8jXRzHV1BQAo
	9yiov4b52P+8ag7Zdrf5OXu23pcXM8xHRFgGoh3CxOTgTmauZKhnujjQ=
X-Google-Smtp-Source: AGHT+IGyBLxVy3vPfeAPBuQkdPnqAo/SrYwnxZI+yrzPpJkIbR8DFpF5jYdhTo8964Y4zA2c5fvvr5ChSLHBMkzGAsv6j7799Ou/
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c567:0:b0:39d:25d8:43a9 with SMTP id
 e9e14a558f8ab-3a08b65fec5mr180280005ab.0.1726704265241; Wed, 18 Sep 2024
 17:04:25 -0700 (PDT)
Date: Wed, 18 Sep 2024 17:04:25 -0700
In-Reply-To: <000000000000b10c48062134870d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66eb6a89.050a0220.115905.001c.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in _ocfs2_free_suballoc_bits
From: syzbot <syzbot+2d6d9df993967dde8297@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15caffc7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=2d6d9df993967dde8297
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=158c4b00580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cffa07980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f1783fdb50b3/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2d6d9df993967dde8297@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:2558!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 UID: 0 PID: 6412 Comm: syz-executor137 Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : _ocfs2_free_suballoc_bits+0x8ec/0x1370 fs/ocfs2/suballoc.c:2558
lr : _ocfs2_free_suballoc_bits+0x8ec/0x1370 fs/ocfs2/suballoc.c:2558
sp : ffff80009be27040
x29: ffff80009be271c0 x28: ffff0000dee22c60 x27: dfff800000000000
x26: ffff0000deed4000 x25: 0000000000000000 x24: ffff7000137c4e1c
x23: 0000000000000002 x22: ffff0000def04178 x21: ffff0000def03900
x20: 0000000000000000 x19: ffff0000e2516000 x18: 1fffe000366d79ee
x17: ffff80008f56d000 x16: ffff800083032784 x15: 0000000000000001
x14: 1ffff000137c4dac x13: 0000000000000000 x12: ffff80009be26f40
x11: ffff8000820904b8 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d97ddac0 x7 : ffff80008201e048 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0000deed4000 x1 : 0000000000000000 x0 : 0000000000000002
Call trace:
 _ocfs2_free_suballoc_bits+0x8ec/0x1370 fs/ocfs2/suballoc.c:2558
 ocfs2_free_suballoc_bits fs/ocfs2/suballoc.c:2598 [inline]
 ocfs2_free_dinode+0xb0/0xe8 fs/ocfs2/suballoc.c:2613
 ocfs2_remove_inode fs/ocfs2/inode.c:696 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:818 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
 ocfs2_evict_inode+0x281c/0x468c fs/ocfs2/inode.c:1216
 evict+0x418/0x894 fs/inode.c:704
 iput_final fs/inode.c:1838 [inline]
 iput+0x74c/0x830 fs/inode.c:1864
 d_delete_notify include/linux/fsnotify.h:332 [inline]
 vfs_rmdir+0x35c/0x468 fs/namei.c:4306
 do_rmdir+0x2e0/0x720 fs/namei.c:4352
 __do_sys_unlinkat fs/namei.c:4528 [inline]
 __se_sys_unlinkat fs/namei.c:4522 [inline]
 __arm64_sys_unlinkat+0xdc/0xf8 fs/namei.c:4522
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: 97932c46 f9400ffc 17fffe2a 97932c43 (d4210000) 
---[ end trace 0000000000000000 ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
