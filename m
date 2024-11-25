Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812E01925B6
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Nov 2024 10:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732530924; cv=none; b=V/7bK65Fy0nw+aIqbCE0HlxrWp7v62znZ3Iu74vwJf6dftjfQqhnMm8AFXxkPbPtB2fmExWzZc95kdv43WqG1fRlsaorM3etLNDgJBvLjn/y7WT+Our4Eh6s4gpLrRbw73WLcQCZE+IDmKI/+l2ziI+cQt0VskjTvlC8GIMBg7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732530924; c=relaxed/simple;
	bh=kYeLsRCC55prGddl1rvycD6DQ1IxGBOllcx+pzN/RlM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VPt3Qle1LKrJNQmj/woF1Lkig3zMnnprBYivaMOh+lREcGcQKTrd1jytm9AGwwnC1/BeVVtKWJGINfQQmXIZjPvnuUhp6y4PIFK9bVZltQvybGKgZeYOn16FoZyioWQehxD01o+QekpTWmNXl2RbvfPyhMQQUp4hZVzLAyHlBRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a7ace5dd02so19327665ab.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 Nov 2024 02:35:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732530921; x=1733135721;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hdM6Eb6e6UaUAMCHN+q74HhFFbBoAp1VLyBMNSuGSzE=;
        b=lSGu4SRH2aETGHnaFpbYN7e9sIGFazHlWgbpQvgAkClRnb7aoPPgC8TXC7zYa4x2F+
         N8+vfWRwcPn9JkKa+tjub/J4IFeEbyN2J4/vGp6BeE5iJgFDM/X7KOGQHTplLd7+YPn4
         KN5toYxd1sXGAt3QdFY3te0DtYCc0a+XEcrs1jsKBduQQsJiRVCN2qyCGRacRonXl2t1
         tSMFeCkQSHj/lR04amiMMgtys5aSNCjMZB55Orf/5feHyv5yJajZRgrhDh+8kQ9WUEjC
         1Gwg+lzOP6V3SQcug5t25DtiBVDWKIWcbAEZVjEheaBzUP598Vbkf0JAsSi0taEi+ugz
         5XlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu/BxQfMUvpglH/LLycteR0M4/Lfq7P/Y40bFDsfL3Bq7j8IDmHlY4eRydEMVxp35sM43nOaRRqW57iQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7PIaZoIfKBwfS4GS4p7euAOGGEOfKarLnTqf7NJlMsoQ19y/w
	a+6fWVmKaVncGeTXP4gMrMRYywHshns6jqhDRlPq6GsthF8Abxy10tKiFiEMAf2v8/PuheWOEeJ
	Av9BRjehWLX/WpNtz6ezPTb9pd8LcWqBSYdscKG4HkKnF3dNau8IGzlM=
X-Google-Smtp-Source: AGHT+IFruRPvdd7rTyPzVt2JG6dY4nkORJzAxJqablJPRzlJ9js6NMifGG0zMaemkg8Wa1AIhb0GoZjDBy7bkpit5V81T8C6/tbJ
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c547:0:b0:3a7:8720:9deb with SMTP id
 e9e14a558f8ab-3a79ae05038mr111434355ab.11.1732530921633; Mon, 25 Nov 2024
 02:35:21 -0800 (PST)
Date: Mon, 25 Nov 2024 02:35:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674452e9.050a0220.1cc393.0075.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Nov 2024)
From: syzbot <syzbot+list73c7d7a82dbeae5f6a11@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 8 new issues were detected and 3 were fixed.
In total, 61 issues are still open and 10 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  53646   Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  11688   Yes   possible deadlock in dqget
                   https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
<3>  9642    Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<4>  5226    Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<5>  3938    Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<6>  3598    Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<7>  1749    Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<8>  1023    Yes   general protection fault in ocfs2_prepare_dir_for_insert
                   https://syzkaller.appspot.com/bug?extid=5a64828fcc4c2ad9b04f
<9>  810     No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<10> 458     No    possible deadlock in ocfs2_lock_global_qf
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
