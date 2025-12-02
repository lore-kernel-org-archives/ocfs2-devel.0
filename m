Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5683D2E0916
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 19:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764705089; cv=none; b=haJB1s2Y1pajZNrZs4eIGSLemfnMkImDip+bqaF2emKJlfJmqBrjt57KgVUt+KTRsQ01rmBqiQfFiioCLMR/pur985DGpTI6iFxYxgwhPapjX/5hhXVcT77Dj+XN+zb2aeiVdXswfK8kRVojJyx1nEGEYt4At6GnomeYWZqxnto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764705089; c=relaxed/simple;
	bh=fwCFv2z9e223jg0pAovRQ9E+1W1x3hd5ePnE3QF9fis=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=UlOZgVBPh8uhpZ4qxoxSDT7+Fyeq1FL/6Go/WaKVlKS7/+/ykzrFCB0u9PgjHQFLH8wAzpjlC2yxl1mAfaDB/Be7nxYJcYfqXWXtpG/WEBSsolIq6s8ZPdRSFOuxxKWRH06MpjzQbn5NP43U3w5EW2PEDXxtxaYAH1HSIPDQgrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-45322138f81so322873b6e.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 02 Dec 2025 11:51:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764705086; x=1765309886;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vrTA8/Ib4dqg468mg7sXdU5lKN1300g4eFvAGgrlg20=;
        b=D8k0FfS3rfTnNxi/TROFI3vZOP2p9cA2owezaG0DLVjSlTNswZlyY09EEEpGk8fa3/
         Z6M8ylOulD6mVS9QWPZ3VwzEpmCmmrhVxSkNgZufaf/lv+FWMET4/P6wDiHKniOnCIjE
         5wk4BLB+TzqWIzBgM9Sdov4/64eEdUerHZ/fYVpt01gmUYTIPTe4TEiAKldYZCGKSmk1
         Q+vsSOPNTcNTnIUsI92g5vuKUiwJlNDLYXijSrvTh1Xx/VSq/IEFYce89zttuznkKv4G
         LS1k4ceDIX3P285IHy5J/vfSPEahzM7LV60Zwl+YxoswPNHQdx3SX2viFHhDvbGd22I0
         6/ag==
X-Forwarded-Encrypted: i=1; AJvYcCWqjr1PeIu1iXw2h4R5BLfSdubIMXCxIEGtyEnPYq+rV/ZlIvocit+MMoCX7pqjDbBSMz39cvD6Echzbg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyeJmjel/nkKR6uH68owTm0t+A5kc32So1Xc+ojE6BqTMqVoUBS
	g4F/5u0nF+b60LfBUoNGu5iEfGIJK2JA1QXlQ6xr6r5zL/EhcKBjCCXKXnXR+J4+cJFeKnboWVo
	HVI2hQpESnajFuHX4cjbkEHC3GIxn79fzDN1XX/HJ53DGl+e3XyC3e2NoCts=
X-Google-Smtp-Source: AGHT+IHSDhpAfgj8NpXYE1+938IBzEeH6v2xujWW6bryC6W1Kbk/To6d4FkOrTPq7It6EsLEB7nSzYosBkgZ0W4B75A5ZUSymq+V
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2f14:b0:43d:2e06:4e84 with SMTP id
 5614622812f47-4535d2f36b5mr2523422b6e.13.1764705086559; Tue, 02 Dec 2025
 11:51:26 -0800 (PST)
Date: Tue, 02 Dec 2025 11:51:26 -0800
In-Reply-To: <690e2846.a70a0220.22f260.0057.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692f433e.a70a0220.d98e3.01a3.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] memory leak in ocfs2_new_path_from_path
From: syzbot <syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david.hunter.linux@gmail.com, david@redhat.com, 
	dsterba@suse.com, jfs-discussion@lists.sourceforge.net, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, khalid@kernel.org, 
	linux-kernel-mentees@lists.linux.dev, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	penguin-kernel@i-love.sakura.ne.jp, shaggy@kernel.org, shivankg@amd.com, 
	skhan@linuxfoundation.org, ssrane_b23@ee.vjti.ac.in, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    4a26e7032d7d Merge tag 'core-bugs-2025-12-01' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=111c14c2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbf343972ee89096
dashboard link: https://syzkaller.appspot.com/bug?extid=cfc7cab3bb6eaa7c4de2
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16833512580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=151c14c2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3f4ff8b7d65f/disk-4a26e703.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2fbb585ef1ac/vmlinux-4a26e703.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dfdc58db78d3/bzImage-4a26e703.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/ef2db83daf44/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=14cae192580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff8881292668a0 (size 96):
  comm "syz.1.52", pid 6365, jiffies 4294945684
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 80 0e 31 82 ff ff ff ff  ..........1.....
    50 e7 58 27 81 88 ff ff c0 54 eb 33 81 88 ff ff  P.X'.....T.3....
  backtrace (crc d3d62878):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    slab_alloc_node mm/slub.c:5288 [inline]
    __kmalloc_cache_noprof+0x3a6/0x5b0 mm/slub.c:5766
    kmalloc_noprof include/linux/slab.h:957 [inline]
    kzalloc_noprof include/linux/slab.h:1094 [inline]
    ocfs2_new_path fs/ocfs2/alloc.c:688 [inline]
    ocfs2_new_path_from_path+0x4f/0x90 fs/ocfs2/alloc.c:702
    ocfs2_get_left_path.constprop.0+0x182/0x390 fs/ocfs2/alloc.c:3491
    ocfs2_merge_rec_left+0x426/0xe60 fs/ocfs2/alloc.c:3543
    ocfs2_try_to_merge_extent+0x3cb/0xe90 fs/ocfs2/alloc.c:3794
    ocfs2_split_extent+0xd2e/0x1330 fs/ocfs2/alloc.c:5139
    ocfs2_change_extent_flag+0x2ed/0x720 fs/ocfs2/alloc.c:5230
    ocfs2_mark_extent_written+0x1e3/0x2c0 fs/ocfs2/alloc.c:5276
    ocfs2_dio_end_io_write+0x5bc/0xaa0 fs/ocfs2/aops.c:2350
    ocfs2_dio_end_io+0x8c/0x180 fs/ocfs2/aops.c:2404
    dio_complete+0x12e/0x4b0 fs/direct-io.c:281
    __blockdev_direct_IO+0x1782/0x1b40 fs/direct-io.c:1303
    ocfs2_direct_IO+0xf6/0x100 fs/ocfs2/aops.c:2441
    generic_file_direct_write+0xb4/0x180 mm/filemap.c:4234
    __generic_file_write_iter+0xa1/0x130 mm/filemap.c:4403
    ocfs2_file_write_iter+0x68a/0x15a0 fs/ocfs2/file.c:2469

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
