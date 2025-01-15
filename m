Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B741798F
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 Jan 2025 01:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736904367; cv=none; b=mHiurm1SqqIWpojGb/DzZar6Cg9ICnEtJ4tX2CIeuE4sSlfA8b1qAjvCsLDKdNfTzvNBi1QU7Fvm4wiHmCZ6do+zasBOB7GIWcXp5Xg0JS+TIA0BA6u8+/065Q9a/tzICYOQXexSrdiMauppAJORSoh728K1HTB8NJ22FCL9zhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736904367; c=relaxed/simple;
	bh=/UJ4wb9LSSOYJ52yHYuLVOblzozNVfjn8H6cGgB7BvI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nENlihNFgU7IL5P1PzfN2x75BT3Ict6CCR9BHmHycMBaOHEKBxxsiCg60R8K+TirJ+tIiR0hqQznjK18GbYUSLKOoDQfuAi8tKPldtUDdxEEEd4ZyFX/iIn96vTDjbd5oprCCYUnm7CBJ8q+0hIRF02wF+SHYE75fkYAGEQvoCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a814c7d58eso50907625ab.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 17:26:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736904365; x=1737509165;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7jc7nsIl+xyEDp8bDHxDT+1xZ51LqxnlCnM6uKDYqfc=;
        b=E2qxjcTAMk1xab/wMD1/xIGhdxDKBWzxlgcoR3SYykXk2KdiFmwko9uP5MFScjed9V
         JjxZoZ+mrGh5uAuTsCIZRqHXEa1CrP55H8zNrxCXC22g6dPFgmp9JWmyCJlMkCR4BciC
         ZSo0CdssefQEAxq25tRVNoZR5PdYVtbFgPM5Kmb3U0Del3qniI16PX3nHH/KTOV4EX6o
         /xyTN3m3dlw9ALusK3pPTf7AWHCVuiqLFvhKu6WstPdXcSeVKjL8leZAaBcfhtE1n3OM
         dVPk0/SE+FZWODvBFO1vH21i5qlM5dAmFMU40nQZX63SGw9ArIXskNDPEnz0enaKKCKu
         VJgg==
X-Forwarded-Encrypted: i=1; AJvYcCWDP/jioe9zzzEnSt0MfT/BclXREAHjrjEYXgYiihMV/U1wMxAfAfXnb3KY5a715XV+nSrd5pd59V+SzQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwnezCcUke5atRCzb9IHq4AAQmJ72vanDBcpzajGzhV6bTAOveh
	5+GeQVuTLNNWi3LkKmByCoTq9aNU7cpG1zXWb9YyMim6yHzRVtM3TuKaXx2DiUSzjKGZnrA0DnO
	ml++3Of4sKDrjs2CuK7+ciSuEKAfSx9mrvJhXPxyfykEItzRuewVJtpc=
X-Google-Smtp-Source: AGHT+IFj+o3RdhvTRo31A2VeZDfyYkT3JL4SdKnlaYtRf+N7mUzNCdgK8qnd7l6HPiKPenL1esCmFi8WM3yK9j3/gnkOEzLg2dOj
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194c:b0:3a7:e286:a56b with SMTP id
 e9e14a558f8ab-3ce3a90ee50mr212962195ab.5.1736904364905; Tue, 14 Jan 2025
 17:26:04 -0800 (PST)
Date: Tue, 14 Jan 2025 17:26:04 -0800
In-Reply-To: <04a9ad29-51de-4b50-a5bb-56f91817639d@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67870eac.050a0220.296bc1.0002.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] [ext4?] WARNING in jbd2_journal_update_sb_log_tail
From: syzbot <syzbot+96ee12698391289383dd@syzkaller.appspotmail.com>
To: heming.zhao@suse.com, linux-kernel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in jbd2_journal_update_sb_log_tail

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6052 at fs/jbd2/journal.c:1882 jbd2_journal_update_sb_log_tail+0x2ba/0x360 fs/jbd2/journal.c:1882
Modules linked in:
CPU: 0 UID: 0 PID: 6052 Comm: jbd2/loop0-29 Not tainted 6.13.0-rc7-syzkaller-00041-g7f5b6a8ec18e-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:jbd2_journal_update_sb_log_tail+0x2ba/0x360 fs/jbd2/journal.c:1882
Code: 30 ff 41 80 3c 2c 00 74 08 4c 89 ff e8 df 48 94 ff 41 80 27 f7 4c 89 f7 e8 83 10 4a 09 31 ed e9 72 fe ff ff e8 57 6a 30 ff 90 <0f> 0b 90 41 80 3c 2c 00 75 d5 eb db 44 89 f1 80 e1 07 80 c1 03 38
RSP: 0018:ffffc900037577f0 EFLAGS: 00010293
RAX: ffffffff826f07c9 RBX: 0000000000000000 RCX: ffff88801c7c0000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff826f0799 R09: fffff520006eaeec
R10: dffffc0000000000 R11: fffff520006eaeec R12: 1ffff110060f7000
R13: ffff88802b13001c R14: ffff8880307b80b0 R15: ffff8880307b8000
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555563a325c8 CR3: 0000000031c10000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 jbd2_journal_commit_transaction+0x46a/0x6560 fs/jbd2/commit.c:397
 kjournald2+0x41c/0x7b0 fs/jbd2/journal.c:201
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


Tested on:

commit:         7f5b6a8e Merge tag 'pci-v6.13-fixes-3' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=169e07c4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=954e5731cdb4e750
dashboard link: https://syzkaller.appspot.com/bug?extid=96ee12698391289383dd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=155681f8580000

