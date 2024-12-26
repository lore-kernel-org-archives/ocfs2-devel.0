Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AEE450F2
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Dec 2024 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735203514; cv=none; b=t2DR+7ANaeP1K8XUhKfBk/T/2VvrVMCwevQzY8WbZP8MqW7SJ7Dn17t8/rXDhSUWz0aCwC4/MkXFvToofatNsuI9EG/xBhnGgWRTzzJJpaQvp8ExPSYmpj0yzdvfoiS7hmfqg5Nb4PiH8vWzRY757uFXPL+9SbnDst8DvI4+et8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735203514; c=relaxed/simple;
	bh=JmyoajwiUc73SzLF/Q6HBpyKhpI/951ZD37pM6mOIP4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UH1xyNdKFDSV7CePIBg25dRYfYqmnk9a1wOjOZi93qvhoyNUWrxqTPdZ5abwfOV64aYcHVYryzjZtHLhqaOvNSVxlao+7Ds5Jivqc8lVqb+cZk7h+CribmRNlvgheo6yWur4qEk8StaJBRPp+Rddtc1dtFtJDUnBQb4TKTSnTjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a814c7d58eso62868715ab.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Dec 2024 00:58:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735203512; x=1735808312;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qvHZqAnlazOoQjsAUNyJE/OgXHTi8WVsrsHhBsIX6xU=;
        b=sw1PZ7Bxg04NfqutQ6M5s7ddcO9X7PQfDcwuSxbg6sAEhF/i6DectNUQ2yqvHRZ4gq
         IswUUFystCc5b5aqg37GWHbdIEIVVQBvyq9UKiM12wgb1yKIBUjZXqwHCmEBfSjur5nA
         SD5fdm0Ri3vY+r6827HybzDNw2dplYiooCbTtuE6I3BMroGXanFlqC880zA7gX9vQgu9
         uRcE7BHfSjcJtSrYPVrTDTz85aQLTMA56LpkvhIsHCpM66BZOCyjeeBKMtrOTAs2YWY6
         roytEtWfstzLxocpBOzaOmVTmcI4jKeLVJQuIjzB1K64a/k9vr4cr4d1wvfzbpIvFJV4
         a+ig==
X-Forwarded-Encrypted: i=1; AJvYcCX917ENXhkv/4GNXDxckw9a81Q/QjyM9VyDnMAiRAQyXTv82BN4FjkfNbGgfwefiZG9oXArOHfOzrbLOg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+C/8VBuxLG0AWAN+OuDF4f0At75zuEa/77nvkw8cg6dXvSWq7
	9Fca2WJi3dhyzAMgmS/2WrdsBAvnl26VLfve+HebftpzJlUVyo5Pkwkuy7ZPH+t7mAgNEfSmt8k
	wjTPUp5gs1xlcqBTX8IPq4tyNw2kVVTLN7fqmFnlQEn7+a2Fv4BRv/Bw=
X-Google-Smtp-Source: AGHT+IFl7NulnlXBJREexdjc3umTpb7KuewLrq48JOg51+/HkBPti7TEJX6qYQdKKzgOW8k7l+R6OZOy8hDPJeNJ4VugWy3aKTwG
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1546:b0:3a7:708b:da28 with SMTP id
 e9e14a558f8ab-3c2d5919bcfmr162992475ab.21.1735203511965; Thu, 26 Dec 2024
 00:58:31 -0800 (PST)
Date: Thu, 26 Dec 2024 00:58:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676d1ab7.050a0220.2f3838.0456.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Dec 2024)
From: syzbot <syzbot+listb1dfbebaca740ab40b7c@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 7 new issues were detected and 0 were fixed.
In total, 69 issues are still open and 12 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  77793   Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  20034   Yes   possible deadlock in dqget
                   https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
<3>  15795   Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<4>  7623    Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<5>  6025    Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<6>  5530    Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<7>  2482    Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<8>  1120    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<9>  1045    Yes   general protection fault in ocfs2_prepare_dir_for_insert
                   https://syzkaller.appspot.com/bug?extid=5a64828fcc4c2ad9b04f
<10> 874     No    possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
