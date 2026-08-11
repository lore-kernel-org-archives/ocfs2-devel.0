Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CA02264D9
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 12:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786451557; cv=none; b=bePSCR4ZGaMn27LlpZ5uzf8audhkwemMHEQXqJ/W9PE9w/ExLY7dw9xoLDR7GB+ZVVSUL93kS+6DUjtP5ZbBsQffFWngFnPMfLJi8zr5haRpVB9X31ZJKnJBhyOs7bp28tQVAxQIg8kfDA2/MGx2BsyPPXPkYT+z5s3YDWqRrJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786451557; c=relaxed/simple;
	bh=dT6+Z+Hv9qikM7hPtsNpnTONBV55XY37CJC1SGf9RGo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eChlkIyxcnDyItIX2IoB7qvtTAXgeKcSBfrSM5pgVC3XIjtsj0qIqXd2C3/uBk5KunzXId6U11KdQ/U/PZVJdF6lAi+zDt1rssbawGSccy+GUcyo+K9C+38XptcU42ICLfekLftZ09uWGVdFQelIL9NAD1j+ifxrxXrOfPs1h5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a49f09233dso1400183b6e.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 05:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786451555; x=1787056355;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q0++VftPN0ibaDEwTbiezSlhL93IThwV3RaFWSFhLpg=;
        b=q5AkYcl6LHEr8pa+oqXvqpVEG8I7qVuzGsfL6JDlk19emOWjn/DvUV0bsl1dN3EqfT
         WLS0DCzyE7wd1GXHH8/hrcPufqJPKJcnAt3cvYX6Xn6FSnYanHFkWwXHm7gMtLeiNtQS
         RhUMaubB1EUL0G7W+mmuhvcLrtUeHEzpRgi8gTOVswhArfoV2q6cRSMs919NvuiKYupl
         WkiIf+zACUF1F9scvfhxK/Z1n21TfPYhnV1c/dHKpyCSG0ovxU7+XJWK2qHGsDrNiw3O
         hQrAHHYwGk6KSSqtPCW8r0lbByNg6T6E9lekt8tun2AulCpr7ec9aJC30iLz+r00+3fT
         atDQ==
X-Forwarded-Encrypted: i=1; AHgh+RrsN+z8YS81lBnqIBosNS5BOlmaz87lW8owbLuj9BGXhrE+mLy3wTGLJM6dQG8HGDzx/9XwRburN3iubQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwHF30SNu4b0anRQfpoHFVqdwdoPt2kUS+UCBtHwXURIWhzy4yl
	zgGEHdhHmG3f3vMZYQxScuejapgVTN8qy9GqxPizoUSOKhfT5VfqlGRB5RhhxSt5/T5lJW1R221
	F7GOc77pFHTKcxD6eHCrwQTF3wHh3G4eE9wDxPDK47V2kXNNxuc691OJB0FI=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6781:b0:4a4:744:a4ff with SMTP id
 5614622812f47-4b1fd6f1423mr1902148b6e.4.1786451554910; Tue, 11 Aug 2026
 05:32:34 -0700 (PDT)
Date: Tue, 11 Aug 2026 05:32:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7b1662.01d0871a.3a0d52.00ca.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Aug 2026)
From: syzbot <syzbot+list7f65aacdb3e77d50a9fc@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 6 new issues were detected and 0 were fixed.
In total, 39 issues are still open and 55 have already been fixed.
There are also 2 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  430165  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  49260   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  19808   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<4>  9331    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<5>  6273    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<6>  520     Yes   kernel BUG in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=fd05de09d1267725aa95
<7>  439     Yes   kernel BUG in ocfs2_dio_wr_get_block
                   https://syzkaller.appspot.com/bug?extid=f8b081be889b639423bb
<8>  135     Yes   possible deadlock in _ocfs2_free_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=73d1166b94ed9875af54
<9>  128     No    possible deadlock in ocfs2_try_to_free_truncate_log (2)
                   https://syzkaller.appspot.com/bug?extid=c535cfdd86331295512d
<10> 27040   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
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
