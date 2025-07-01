Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781B027380B
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Jul 2025 10:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751364092; cv=none; b=SwTfoZV+8HCJKItWcs96vl/Jz/XCmewg4JGQ0ev87wdSAUX34K18wr1b6u2+ECrLWwy7H+HdDL6EWnb2dcO40vNlBTGLZm0f39JRjM4vvcl/dNPz5/IWeFjTRT2+Egy1/dNRZy8RRkypOWtcjzQdz4i06d3g7No2zs//iuYrmUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751364092; c=relaxed/simple;
	bh=P5Rt189e8qUG+MHvROZmWhZjXpiZa0oSmFfwPWBZtUg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bz30Nu94lfTe6z5UiQyHZI5lWf6Gwoy2UFgwbuy9itm+4TXFDkMib31dhRwrr4a9w3GuyefHOQYEgg2wtHEQF4/SGK8Vb9P5PLQWXoaDmOs2Gp/xZj6HudefSC2oTHq+FY77rWO/0kMja4HpA5YGmxEEJbBKe9Q8OTCpUPkl2B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-87595d00ca0so537903839f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 01 Jul 2025 03:01:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751364089; x=1751968889;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JBnYfLShZRP+QHc7hp6xE5I2iMcE/JPwNu1jf/ePmmo=;
        b=p9mW9hJIPRDDrGIO5p9epQSSN2L6lBMPjHMssMXJBR3Ttrp3qj6Ncw7iWs2A4axORJ
         wfHrEwRpT4QiQK2maMC857JLnF1ZENYtAN7g2Glm0hZ5u3BsLpKX/rBNDw1d2lm9BEiX
         yyH7rA2u7ovEwSQ+F7L8gStoq/WCwfKX1ix8quVnLAy6Wd/TS5mbRD9KWhjtOOf7Opn9
         cyxuLryCLiPAuban7Y5jxmcQ0BtMz2YblFOX5wPc8ICP9UvrK2fqYZTS5fHMr0mTRTWg
         aa6XhsiKeARxgn1EaBmUEjQYyDQCQWPV0NE/c+NzMp2Fu3rbM2SYa1XG4Ctd2zw8Lptc
         fp9g==
X-Forwarded-Encrypted: i=1; AJvYcCWMJ/WSY6KFxIUJMLTsxyjT0x6QyQ/b1XMjI9RfclCBE0qE8k/XkzlwAXyTtHE3PJ/XCJXc5NQktu42Yw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3P9QuRN6WqKzJ8EynTwyP00RmVmymxKjw3TD3MGu3ESkpOJFM
	0W3RJKe/p0RLLeW6akxukOM8vha5pwP8qwXmm2nn7u/KS7eKrDsqt/ypD5RcyH+Tlu1aeX/Jjey
	oiBsQRTFstw9z7/nXYhCSGbMJoqri5/sTCcHglV3MvyNYGPat3yj1ksmLGDQ=
X-Google-Smtp-Source: AGHT+IHgtx7SqShvK0/sNakTaVtzibjONzpxOzeKpEIP0Jy8y46gQyIV2NTDXUQD4Cc414qVDKPq5z23SppLkt2Y/BoTCvaEWEau
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1691:b0:876:1c5e:8c50 with SMTP id
 ca18e2360f4ac-876885d256amr1917863439f.7.1751364089410; Tue, 01 Jul 2025
 03:01:29 -0700 (PDT)
Date: Tue, 01 Jul 2025 03:01:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6863b1f9.a70a0220.3b7e22.1936.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Jul 2025)
From: syzbot <syzbot+listcb86ed7f103eeb1415ee@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 4 new issues were detected and 0 were fixed.
In total, 69 issues are still open and 17 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  65257   Yes   possible deadlock in dqget
                   https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
<2>  47058   Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<3>  22465   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<4>  14511   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<5>  14041   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<6>  8235    Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<7>  3182    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<8>  2603    No    possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
<9>  2163    Yes   possible deadlock in __ocfs2_flush_truncate_log
                   https://syzkaller.appspot.com/bug?extid=6bf948e47f9bac7aacfa
<10> 1551    Yes   possible deadlock in ocfs2_del_inode_from_orphan
                   https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
