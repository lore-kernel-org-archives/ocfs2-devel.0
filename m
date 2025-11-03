Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7F230CDA3
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Nov 2025 13:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762175437; cv=none; b=P8C6YKD+zrasF3Xr9A+lAdS3ER3hlgdmSDn4asEczdkAISvTi6VBcVNPnCwOeAfasXIfJ1V8Iimwj1vwkHN9pbcE7N1Lhol0ic+AetwHKyvDvTh0dqDdJMquYnDa7SR1yHcBUSxoQ0W6H80rk/IbDd14R7hF/n8SsEuy1il+KkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762175437; c=relaxed/simple;
	bh=OXOVdV7W/lso+SggOgvU+U8UHJEOSob6qb3AvgPoOIY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=me1J818+obMa1VGAOSbP8JUEHtvB+p75DVrlfxzOTFI/p8r23z/oDGYgyULd4FNSS5AlOZytEyX1/eZeK3NVb11jnrnBZVuyZONa/m53oEK0yrjDGWs7qUr+Jx7lGaZwcVL8sjdXs0tF0CcwNMKGoOXviX2xp3UyR7UOlc147mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4330f62ef60so23647955ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 03 Nov 2025 05:10:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762175435; x=1762780235;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zeYYuyjJ6Kzb3Aak8HjT4HbxnAJaJ6aTQhKetjvoumI=;
        b=TZFbWHgyq8ZimIGRvZPKaX9cK2e1lcHVTp7OUpzE5c+HAzLijvm4K+fAV4AQmbnpS+
         L+DjecckaDUc7q8C3+Revzzs5w+C7Kw/uW5ImfUDcysZ4smq5iDkEJXDdVmLQ2TZ2LSE
         XkV/VMdANJv0PpzddSRSkKmFwGDWhxJK447aAvx9v77JQ+poZMfzafQ+CNVfcyuvbZwo
         XS49lzHXqBWL0hfBNsHlvLJLYBiP6wwaeDZ5LU10xBPLL6eBZuabYD6NuWJjArTSZkQm
         oaKi6riUZgZdUKjVqa63qh1lKLWrBk2nhjrdZy4/chZFl9dcXSWIyuOUhRUGzycPBwyQ
         NrlA==
X-Forwarded-Encrypted: i=1; AJvYcCU54q2MFMJTH8cYux2dwXoeDKx7iZoWd7M1A4QmXaO+04eAgyc4Ijc3l2kGtu+UABUu1Fa/pXBAIX+bmQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxKhZhx9ps61GiHrHOfRv8NPTegJk2pVwstWk/F3KTzXQREtFKa
	6bs/SgJTz9Ku++KtqpVzaY9ZkNuYOejjdys55KRaVHJjIKdFnmJr/lSt4jHF+EvFpCo6CA1V2qs
	6Hoyksk+JjluRAK8njsVJCGsVhKvT+hZ1rOyBM8zpAfc1avdf2vaxrf1AXec=
X-Google-Smtp-Source: AGHT+IFZaxk75JBJmqNMX3nF/Ut3FXrSED++Vz28gRoBhTH2+Z4YLt0co66+RnwUzfKzHcyBJrYnrG8WmlEcUJWjcjJsbmd5SpCk
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c246:0:b0:433:306e:2c83 with SMTP id
 e9e14a558f8ab-433307d7042mr41424335ab.28.1762175435016; Mon, 03 Nov 2025
 05:10:35 -0800 (PST)
Date: Mon, 03 Nov 2025 05:10:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6908a9cb.050a0220.29fc44.0046.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Nov 2025)
From: syzbot <syzbot+list699dc14d87d84bf275ca@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 4 new issues were detected and 1 were fixed.
In total, 62 issues are still open and 24 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  306918  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  65246   Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<3>  34033   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<4>  21191   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<5>  20054   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<6>  13013   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<7>  5612    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<8>  4575    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<9>  3538    Yes   possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
<10> 2549    Yes   possible deadlock in ocfs2_del_inode_from_orphan
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
