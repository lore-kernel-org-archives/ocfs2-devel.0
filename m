Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54322D0C94
	for <ocfs2-devel@lists.linux.dev>; Sat, 11 Jul 2026 12:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783773157; cv=none; b=EwdYaaYLlPtUr18WZSuCNK5lJo7296mV0OC5t9cs0wuFZafrNyyVrhB6iClRDURK7JR2orJ82Hm+9JBIruKKt8AC797xIr91yN+SxL7lUwshvUzwqWuNTEfEdi3PhLR7AkOYkDe+7iFzHUe0DhALTcH7G62a6cIKXXAUf/y/3EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783773157; c=relaxed/simple;
	bh=l31YMFPycCDY+hiVK5YGaf6zSsXboRnA60h1GKq8x3o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cdgnTdxKw4iOuAHAn8Q7eU1Fir3RG8rQEdt5h+aN4aG4ZxFDrrlxbFA6jbbg8e9CKwzrz2acxr2EJ/g2KpjjqkgbIPUymnhlH62gBX416+R8Pghqd58ZBxMW1hCHlA429pwjid3xxya2SQa+LFJ4qtdA2GSzgP9/WHOE2udg+Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-485ebc5706cso3774738b6e.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 11 Jul 2026 05:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783773154; x=1784377954;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7olUCOonmwhMGdMB5reyXwjSK0v5h7gxAlFDKE+pOac=;
        b=tEsAkh/7R7ut3W3uH31kdZZnKYn3x1QIAqTQCXI8nQXV+g1oCyqZTKXdA7U25eo+dX
         Ace1A5muGaWdfnduutkUrsx89OmOK5islOLDoBztrdfCEjzJ8yPmLj4cxHn03wx+LNV6
         jtlaNYdfKwOHRN1smUPd6GLuQGJ8obnRXJOTn5fhu2UwKe3LtPKPcHYBTNqIMtS5MvUc
         iEPmJOAhenuQ/NwACX40SbWTWzpSyFBHyBu2ZlLyqewbJwIYG75UknyxNh0GOyHg5FAl
         B2r9Krh64t35TSqsLRhZTH+tbpMV6JhwTT+6MQ9Sx3BmUsTBP+KR4GTOxPoGlf+tCAVP
         YGOQ==
X-Forwarded-Encrypted: i=1; AFNElJ/8iBbWIC/CJOOt/1/+LP8bgVN8VIBQG/qc4pCy8K4NQnVAbKy6W9TltJeoSfxkLbRI/Km2pY6SeHgw5g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxn5bHphd7HV7Lohh7pR/omrVYWV2iqq9nxhCpkOOsJF4FoARjD
	xvpNUIs8/I0jwhEoxPvBifWUBJZCWCGBZ1fa4kGDMyr4WT3xxrFUcfuWzr1TwbvVkB6T9ByIOqK
	FGIKhQWTnh4t1vDSaH4XkTsolUOi3bZvIensSbEUvFUbAWv6YVl3tExt17NA=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1527:b0:495:f0ac:8297 with SMTP id
 5614622812f47-4a40f0c7f81mr4255913b6e.33.1783773154793; Sat, 11 Jul 2026
 05:32:34 -0700 (PDT)
Date: Sat, 11 Jul 2026 05:32:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5237e2.278cdcd2.e885.0014.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Jul 2026)
From: syzbot <syzbot+list0ae5662b36cfb78d9e5b@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 3 new issues were detected and 3 were fixed.
In total, 40 issues are still open and 55 have already been fixed.
There is also 1 low-priority issue.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  424402  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  48295   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  30638   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<4>  19327   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<5>  9246    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<6>  6264    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<7>  489     Yes   kernel BUG in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=fd05de09d1267725aa95
<8>  430     Yes   kernel BUG in ocfs2_dio_wr_get_block
                   https://syzkaller.appspot.com/bug?extid=f8b081be889b639423bb
<9>  124     Yes   possible deadlock in _ocfs2_free_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=73d1166b94ed9875af54
<10> 26791   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
