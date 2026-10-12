Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE17489874
	for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 12:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808421; cv=none; b=sE0sysiSEYa8Ud0/dqfoGWijFKlHlUA6/71Z/xX5//Izk0VFft8EPWuwYYc5+PI9umLEOHpjko9dEG2krUQ9i8QNElixTK9kduA9kgwqzgLjjrqxyJQChmYkrwsJTVWOx5Sl1cNdTZ5IgiJCFL/yWApWD1luIlcXUFbGQsw6LcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808421; c=relaxed/simple;
	bh=XihemXfcYZe5DT/XSjTaqS/KCGASOQQLYoMk/bpzjfs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CfQ5+krsMdxKwPMgbJMDmSMyAio33JAKraiFAROnWgGf9PxlHZPlhvDEgqWe5Pw5IeyGpY4t+OaFIy4PXSfuflcU8OyB4uyPOpER9og/o1KlugP7T16ApwZxCbT9j9VDVBe8eLVrwWKpl0QBTW5tyudjouudrGZD87WkL53SAco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ab4f652f9bso1641874b6e.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 05:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791808419; x=1792413219;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZH+gAu+BLHr4YrFurgl7HL56gbd1v3K9opgyg2ImIcc=;
        b=Jil8OIhGerVDjSyjHG9eEd/H/H63P9T5hfqhp+dOVGa6gKnsd9vSYD/yD4k8jLe+1j
         o+xyEjrioJQzcQavlFbcA7PrE/dpzzo1eOS1ZWnHNzXkiXP6XMEXSVS9Ny3952O34T7s
         mkJEsBIoIBZzI4ZOmy4+85t2JtvM3pkifQHrL5RR3XnnJFX7t2eWBOzqTAcHJwnH67IE
         /6R5YGJf3M03VPeHBJBhGGhYmK3XhczvjGRpW+ZOoIPSgZKJzs5kv0mMDRQM70HiKZHH
         6yKJD2IfwK4Pyx3GR9jrYJxjUbThpv/3QE0i62jK7JJg9H2YTX2Z8OUsrdKM9+BRbq1N
         ukqw==
X-Forwarded-Encrypted: i=1; AKwUvBzTAWZ11PqAL1XPnk45THscW/BHPLq8oZOJW2KYMBD86b/HC1mQ1jMN2tNgOV/gtV0v3u/k6Dk7UIcVHw==@lists.linux.dev
X-Gm-Message-State: AFq9FYLoDsbqkh8zDyDmUty6uQ2SON1ccR0QNcBn+fxfBlyjIrrSDqz4
	0sE+ClzwI9Lky6+8hnRulKsHtxrLRwtV+tF4/qzKdETsTPgLbdyJcY2R8PBXbqwpE44WlXVcVhO
	OGhgu3LsuI08NSiBr5R6tZ+mkb+Pid3E9671TfZor7nRVATqhjN5qN/fx3+4=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fe0:b0:4e6:76eb:b997 with SMTP id
 5614622812f47-50c59399cb4mr10097103b6e.62.1791808419060; Mon, 12 Oct 2026
 05:33:39 -0700 (PDT)
Date: Mon, 12 Oct 2026 05:33:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6accd3a3.0e5b5d80.2c029c.0576.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Oct 2026)
From: syzbot <syzbot+liste7c729fb813252b362b8@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 1 new issues were detected and 0 were fixed.
In total, 31 issues are still open and 58 have already been fixed.
There are also 3 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  433952  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  49909   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  20068   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<4>  9400    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<5>  680     Yes   possible deadlock in _ocfs2_free_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=73d1166b94ed9875af54
<6>  587     Yes   kernel BUG in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=fd05de09d1267725aa95
<7>  463     Yes   kernel BUG in ocfs2_dio_wr_get_block
                   https://syzkaller.appspot.com/bug?extid=f8b081be889b639423bb
<8>  27243   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<9>  2788    Yes   INFO: trying to register non-static key in ocfs2_dlm_shutdown
                   https://syzkaller.appspot.com/bug?extid=d7935821694d430624ea
<10> 2060    Yes   kernel BUG in ocfs2_iget
                   https://syzkaller.appspot.com/bug?extid=5bdd4953bc58c8fbd6eb

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
