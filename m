Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F9219408A
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 09:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727082205; cv=none; b=VnOEzKt8gyZuPJgqa6cordYSxZ72CVzDmkVeeAgR1yoTuDNU9L0VGk3gTREurZOpOYxPfhE72ZAYIszQP+Srkxfa3Up+LwZ4aGWk6PIl8AcZZTRh4DNTV88A4AD6x9W18TrFH3AtF6hIUCXRCKzovG7dccKoyuFdLks4nxzlv88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727082205; c=relaxed/simple;
	bh=xn9P+BXue5kA2yv7kYUdvO+JxKsacy9SXOwPhCle9xw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NzaKSN/hknBIMWgUZK54AoLIVFkmiqgZhBeiZI7TiDc4kFYJ2ji0LAWbi5uvLi5gz/uLRKdf9JlyDTgEhEbOAP2vUCcp0oGEs1lwJlpmgDGRZwGiqw2QhD4LgSY0TufahDDRQcP7DJb3H+UNAqTxzaHeaUV5uzqKX7IITY3m1Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39f4e119c57so39876315ab.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 02:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727082203; x=1727687003;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4pGPXvPWs6tQjlbmfR8dIzPo3akjS+xpC3EdLlvl8Ts=;
        b=W+ApLY7cFoB5438d5yZfnznkqf0A2BFAqikBZulHm9Xy1/F94nx+rX+PaHO3K4qcJL
         1FfQUW4jbDx+MP9wGc5zi8adZxM9Mn49ZV/tVwaqhreaAdx/++mzNwLpGMkfcH8vVz8U
         VoGN15LqqBOK+7d0tIigBm7/CnrfEv9qA82Hru8qZZeHQjLyVAbFPVdH78CVcj9eb9Lh
         0+lcF+yXcM18EVBXd0ifzcTHYT5sKntj/x1JiQ6+eW4OszOKNc5BciGhaeizL5vHbQUS
         aZsv9Ydt9m8a3SqPSyZy/uMR9dNOsMBUEg0mmSbPIOqAO9qfZK2zomwmo9+U5Nnys0EM
         OYFg==
X-Forwarded-Encrypted: i=1; AJvYcCWPZkX66fGnwpvynMfM0+NNrEN0Uo3IGtyb2A9+2/Iw2Iixu5hiN7jCLeK+yT7Tki11JS2x+X+Lo02ojA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzHh3wSuCEWgD3luDh65NCiB18EkDDwy5AdfByN5g9XLghfETIw
	5ee3XdC0blno52rTNjd7Xj1dfbUrR0H+BptRUVBHH9MucF51NA5/7SkgMEg9rvJkU7B2CS0OJ6c
	l6+yrqX7qWRBTxuJJN3VxVFpDzuggwzqWv5j2Ieajvp/J+MgNTrj1pno=
X-Google-Smtp-Source: AGHT+IECaPxN1xbHfV+FltzIPfEbCo8R0YKJnUkDUgat5BMBOqC/clTy/55btm0hrM72+kRpxBBVV7nPqiz/yev/78YYUPDZPUeW
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e0a:b0:3a0:9050:702a with SMTP id
 e9e14a558f8ab-3a0c8d091b9mr93008285ab.17.1727082202782; Mon, 23 Sep 2024
 02:03:22 -0700 (PDT)
Date: Mon, 23 Sep 2024 02:03:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f12eda.050a0220.c23dd.000d.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Sep 2024)
From: syzbot <syzbot+list211859bdf2f8ebff42fb@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 17 new issues were detected and 2 were fixed.
In total, 32 issues are still open and 3 have been fixed so far.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  5169    Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  679     Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  379     Yes   general protection fault in ocfs2_prepare_dir_for_insert
                   https://syzkaller.appspot.com/bug?extid=5a64828fcc4c2ad9b04f
<4>  312     Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<5>  278     Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<6>  44      Yes   kernel BUG in ocfs2_iget
                   https://syzkaller.appspot.com/bug?extid=5bdd4953bc58c8fbd6eb
<7>  34      No    possible deadlock in ocfs2_fiemap
                   https://syzkaller.appspot.com/bug?extid=ca440b457d21568f8021
<8>  24      No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<9>  18      Yes   kernel BUG in ocfs2_set_new_buffer_uptodate
                   https://syzkaller.appspot.com/bug?extid=453873f1588c2d75b447
<10> 14      Yes   kernel BUG in ocfs2_claim_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
