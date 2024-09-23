Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F24C42AA2
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 08:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727080265; cv=none; b=S8Uuoh5CIhopd5FHvkrnyyEn4uW5j5j09mdKxTE1Bz7lalECp6vfslUCNOND98dyyxeiUSrqzqnqBwaNeXuwqj3PI1HAOyAU6WyoFqIfnAUYdFSk3UkMdr+DjOt9Ld9fpW2n8E4bWQ8fdcGwNh/JvRgzxllQ4t15xTjRVCYdwas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727080265; c=relaxed/simple;
	bh=pSfvSnMdUGXLyIQ69U2ktdOupz3zK04NOIHmix2s50c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=YLQf9zTD2HJs+nIYJKUCAAoGzu5k4NM0H5xQ+oDg4CAD6YxYF9iGqpNlPV7QfiKGeD882tO6N+v34PcO18IJHgG06yvJb8sE1Ld4oap95DG89ooBTPrZ18FrbB+cxLuN61S6UjKXkNPKTdtT2eBSjUBkQn7RJRkfZawGFBpoukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a09da3baa8so45343985ab.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 01:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727080263; x=1727685063;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D8dBS9nfxwKc8wJ81YcoZcfizUSL7JA5WGCQagHEnVA=;
        b=ObjkzzJjyFJj2JNgTCo4Xcj5evQeBhU06y4h2+ZWa+1xN2ZWNE35+ZOpX+eThhB0q+
         SMJfJEr8mYrOH5ipaS519Xsu9JGUyn+aa6/USIBnJdcWkstuzfH2s6TXUmx1RWehLXla
         g68GloRVQW6wLOJAU7xnkgkKJEdkzfxzmAEBzFd265yG4rbNIdmer2CFCYDosDaQPTaq
         wcKcs4Ql+wORbjwyJdkSNJdQXDqb2MJ079mtw8yh4t1+oQRFddqnNaHlFiYYxEumX/Pn
         h26nqk6M0AEBX5Y+SQu5+Cd/4ODQgrh6rKcsoEFkBZrJPRze1WPn60Zfn63i7ijMgX/s
         eMVA==
X-Forwarded-Encrypted: i=1; AJvYcCXZ8RGEnoqODCjiff30Sf9z+cry1MNN7Rmw1qQxwyjhfvAh1V+NDHqoJQ9Sr4Puq+dWNaHOPjrnzHG5Hw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywaq+RVC5j6tmd5xe6/QEYWB1s6MpOC5mENgLRGl32mI5mluba0
	0JTrQKmWVqzvcLPr6ADVRA5Mg7QHd8OFCAnx+ssSjCxw22J/mldhqFPbItN12tTt6JOceOOIA3g
	+O2oQ5ltKV+RKhfw9HyLAhVkWabNnf/p1oHyw8L07gVQkR+RCwDYamk0=
X-Google-Smtp-Source: AGHT+IGvL8KtLMpluihqLnA0qmeGiZAgQEbIy/BxeKmJ0LBPZlE5xwAO+u8QrWagHINyQfFpf+3ERBI8bSoxvBSjUnF4l8lpxwwk
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156d:b0:3a0:98ab:7932 with SMTP id
 e9e14a558f8ab-3a0c89fd980mr74950315ab.9.1727080262797; Mon, 23 Sep 2024
 01:31:02 -0700 (PDT)
Date: Mon, 23 Sep 2024 01:31:02 -0700
In-Reply-To: <0a4b798a-db82-40da-9167-141b684f43fa@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f12746.050a0220.c23dd.000c.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_cluster_by_desc
From: syzbot <syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com>
To: heming.zhao@suse.com, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	pvmohammedanees2003@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel BUG in ocfs2_write_cluster_by_desc

loop0: detected capacity change from 0 to 32768
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/aops.c:1179!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5600 Comm: syz.0.16 Not tainted 6.11.0-syzkaller-08833-gde5cb0dcb74c-dirty #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_write_cluster fs/ocfs2/aops.c:1179 [inline]
RIP: 0010:ocfs2_write_cluster_by_desc+0x207b/0x20b0 fs/ocfs2/aops.c:1240
Code: 03 48 8d bc 24 30 02 00 00 48 c7 c6 2e 2b 11 8e ba 7e 04 00 00 48 c7 c1 80 23 49 8c e8 7e 96 1d 00 90 0f 0b e8 c6 b7 0f fe 90 <0f> 0b e8 be b7 0f fe 90 0f 0b e8 b6 b7 0f fe 90 0f 0b e8 ae b7 0f
RSP: 0018:ffffc90002a3ee20 EFLAGS: 00010293
RAX: ffffffff838501ea RBX: ffff8880493116e0 RCX: ffff88801fa3c880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002a3f170 R08: ffffffff8384e89e R09: 1ffff110092622ac
R10: dffffc0000000000 R11: ffffed10092622ad R12: 0000000000000000
R13: ffff8880126f0000 R14: ffff8880493116b8 R15: 0000000000000000
FS:  00007f40e6b146c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020201000 CR3: 000000001317a000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_write_begin_nolock+0x3a2f/0x4ec0 fs/ocfs2/aops.c:1816
 ocfs2_write_begin+0x205/0x3a0 fs/ocfs2/aops.c:1903
 generic_perform_write+0x344/0x6d0 mm/filemap.c:4050
 ocfs2_file_write_iter+0x17b1/0x1f50 fs/ocfs2/file.c:2456
 new_sync_write fs/read_write.c:590 [inline]
 vfs_write+0xa6d/0xc90 fs/read_write.c:683
 ksys_write+0x1a0/0x2c0 fs/read_write.c:736
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f40e5d7def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f40e6b14038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f40e5f35f80 RCX: 00007f40e5d7def9
RDX: 000000000208e24b RSI: 0000000020000240 RDI: 0000000000000004
RBP: 00007f40e5df0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f40e5f35f80 R15: 00007ffed859a9e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_write_cluster fs/ocfs2/aops.c:1179 [inline]
RIP: 0010:ocfs2_write_cluster_by_desc+0x207b/0x20b0 fs/ocfs2/aops.c:1240
Code: 03 48 8d bc 24 30 02 00 00 48 c7 c6 2e 2b 11 8e ba 7e 04 00 00 48 c7 c1 80 23 49 8c e8 7e 96 1d 00 90 0f 0b e8 c6 b7 0f fe 90 <0f> 0b e8 be b7 0f fe 90 0f 0b e8 b6 b7 0f fe 90 0f 0b e8 ae b7 0f
RSP: 0018:ffffc90002a3ee20 EFLAGS: 00010293
RAX: ffffffff838501ea RBX: ffff8880493116e0 RCX: ffff88801fa3c880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002a3f170 R08: ffffffff8384e89e R09: 1ffff110092622ac
R10: dffffc0000000000 R11: ffffed10092622ad R12: 0000000000000000
R13: ffff8880126f0000 R14: ffff8880493116b8 R15: 0000000000000000
FS:  00007f40e6b146c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020201000 CR3: 000000001317a000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


Tested on:

commit:         de5cb0dc Merge branch 'address-masking'
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b99c27980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b5c53071a819d59
dashboard link: https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=148fc107980000

