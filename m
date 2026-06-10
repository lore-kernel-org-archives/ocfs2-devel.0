Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554AE36921C
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Jun 2026 04:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781065948; cv=none; b=nPXv/nTCUnw+2J37QljrXA8P6nutBzRQz/PP6yHXkCxVIhfCmTaKBhhqk+/eoSZVr9MOOYlSgbKCyfv4KThzl5pY4nE9JHnEPK1qLBRveeJtOfQphP2sn6sJMt7CSqVRQpJHH0IYPXEIyCtS+WS0Ur1WnPAsyhRWfqaBzPpGJGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781065948; c=relaxed/simple;
	bh=s5z4TxiDIdIm6lKlqnECpvt+eetM+dWkuKfPqfv1fIY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SBm56UsuBissWxAGvSrab7Y/H5nXWu8/HySacdvYupk2GC0JbDPQTVEj7HvhL+VK3Pliv2jqoiIn3/DMtgjcybswe9RF1Xaevi0PSRkcUrAFfv1txQEVC/Fu6A5NI0D90GDlOfIP5h1cYML4WCcQIZny8FFMzGC4WZK1P4jbeWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e7271fad26so5710629a34.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Jun 2026 21:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781065946; x=1781670746;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D0MUI8Ir+7jrx8lamat2MOJJ5dluK+X6bYJuPjizbQc=;
        b=i3DmLouOOTLcBmOn8f+U3sDrgFCWpTUzflUmF80Eeg7ALZrx2TV+ClLs6m71xwrdkM
         Wtb2U6cH0x+8ni6qDrWLWBpmrRblMI8K2hE4s4ql9X90A7xqoW+FedZi5IMgmv43NSsM
         chqvXwzX8fnllXuZku2bPzKTWJzlyt3aBaa4/Tov/D8xlqDarrHotNy5wCqCd29DoEmJ
         +aa7V9bdIhL28UcAy8Wjky0RFsCwF1jx1R3/P9FbtdxnrV5n0/OogSEryKSCd2cvnabk
         L+ongcjT2v3jAZ4DgFity94a0OZl53kOnToY/wDA5UMbX4oh/dY3tY9XdXUYE10oaT6q
         +mkw==
X-Forwarded-Encrypted: i=1; AFNElJ9kwxfevE5jqJEj8HX/HLiYGaFqL2jjQmT1QVvCEkGpC8/mdEd39qqqPmmvXu3fB+5yEnNeWFG/fZlexw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwFb6gvPyVua/lFnSA42B5kGaKwYqAYmbBfCLqHxVa933Ck6z6C
	J04LVV2HlknntOtzIyXPZx4nMhHWBM5pEtP3qs0+lJzzBPZIQOOAoR2ntUhdXOEyOgUZyCSfBuF
	6a4okRR30cSv0IAyHAighcd+FYbpHKaKYxTG/TUxgup0fyoNEeEBp8zhSQqM=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d0a:b0:69e:9a17:cd54 with SMTP id
 006d021491bc7-69e9a17cddemr5322874eaf.22.1781065946384; Tue, 09 Jun 2026
 21:32:26 -0700 (PDT)
Date: Tue, 09 Jun 2026 21:32:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a28e8da.39669fcc.33b062.00af.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Jun 2026)
From: syzbot <syzbot+list0717046fea3bd04a43a1@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 4 new issues were detected and 0 were fixed.
In total, 47 issues are still open and 49 have already been fixed.
There are also 2 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  420199  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  47417   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  29868   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<4>  19085   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<5>  14896   Yes   kernel BUG in link_path_walk
                   https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
<6>  9171    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<7>  6252    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<8>  2665    Yes   possible deadlock in ocfs2_evict_inode
                   https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
<9>  448     Yes   kernel BUG in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=fd05de09d1267725aa95
<10> 401     Yes   kernel BUG in ocfs2_dio_wr_get_block
                   https://syzkaller.appspot.com/bug?extid=f8b081be889b639423bb

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
