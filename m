Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B53433A6
	for <ocfs2-devel@lists.linux.dev>; Fri,  1 Aug 2025 13:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754056178; cv=none; b=ItQrxLtqcG5He2kM54OoQSx59UBBZaxfk88s4BEWxE2EHRGGczjFEiopktLn6Fr8U+pOHRjlwCzVU1idL8heLDewgFQ7cZdwhk5Kgq1lK8jOECVth8KS6ZTrjN7UWVKvyBfs1Ock7yUxcGVqMq7zBgtdkb7cmDTMJw8/HMU2wsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754056178; c=relaxed/simple;
	bh=Fj6rXaUO8WHt/CHlKj63Vly6jGXSbrWkztjUl2DCuNk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dDkMVQAv9mkVv63JVxoWfw0wnzYZyKsqgK0VT4iCbAyMN0wH+5+5YYg+DlsQJsuhzAMqQT6WmrNjqUvgE/m/YwjowOcRDa27ljouApttRu3cl+w+GEpm6RASNWi+PKoMu0YRYktrx//n+XiNg0VKqWhLSUYZ3cBOZ90kNIKL9cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e3ef793a6aso31176195ab.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 01 Aug 2025 06:49:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754056176; x=1754660976;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N6Jdi0KBf8R5gpV6SKL4gvFEk7UUvYJr9LK+Qld5MrM=;
        b=HHV+NvZ5LfDr64i/Cx7AK5xkxoHI6yUt30rl7Op+TAZQ/1JiAG3ad8vH78c6P65u+y
         OqBVD9pngGSJJoULImTP5GnZRwbjG5wBdYZS9xhjNBDpCrJ7L0+COGtBiPAfv6Qx/uX6
         YFQVGCrGjdvWQij9FV8eAoIais7EgcAqttQdhqze2STNyxucn5kheumx7DtFHtI5/n8F
         5NoljpgiTzriEFRRypKYuLeJM4pgQhXSm5c41mJ3D71HXFez9wdUKFnVngkUI/EzorVi
         Fgxzo6zenEz2IZahqU6vn5Ynr5Qr3C+6VsF0ebn9aygXZ/CLsQBqkMEJhbBTLdWEuqsg
         EEGg==
X-Forwarded-Encrypted: i=1; AJvYcCVrCcxHHZNF1PhftV5OrPwhC6uS8t/TjUBI2CVP67gul/OpTO6UtCfdYkj6W/lKjDIK6CF84WCET04QOg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxj+1Y3nMEqmOpLMib4zNDl9aun9fDRXuQXCjxOOGMNgL8d3hWm
	TNaCuGvG1c0XvlefqlRiCh7p1om7aFij55M9HGZSR1t8LWd7dRiVDpm8uM7QMt3gekToGOLZ52K
	S6cLOYBSEsUH2QLSb4Q7j6lZvt34i8mvCsy7EQJ+sCG2gDdd/7oQMeatQXI0=
X-Google-Smtp-Source: AGHT+IEr4cbvEyFi4hkxpvio41E5oVZpusC2bpehtJo1lPBPBp4xS+Q3NgVy8FoSK3+2ajK9VzybtnTxLo5nJDsECZcMEpSwqn1s
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ce4a:0:b0:3e3:ef1c:ef16 with SMTP id
 e9e14a558f8ab-3e3f60e7801mr152893225ab.7.1754056175892; Fri, 01 Aug 2025
 06:49:35 -0700 (PDT)
Date: Fri, 01 Aug 2025 06:49:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688cc5ef.a00a0220.26d0e1.0070.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Aug 2025)
From: syzbot <syzbot+listab88b7664693b962d600@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 3 new issues were detected and 0 were fixed.
In total, 66 issues are still open and 17 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  74334   Yes   possible deadlock in dqget
                   https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
<2>  52021   Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<3>  25223   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<4>  16247   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<5>  15179   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<6>  9525    Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<7>  3809    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<8>  2783    No    possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
<9>  2117    Yes   possible deadlock in ocfs2_del_inode_from_orphan
                   https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
<10> 1581    Yes   possible deadlock in ocfs2_xattr_set_handle
                   https://syzkaller.appspot.com/bug?extid=57c4c06621ff1840eb8d

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
