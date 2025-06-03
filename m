Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B798322DA0A
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Jun 2025 11:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748949085; cv=none; b=AhmwLiJHzdOZ2tO51k+iV+uLlqF/ar2Tc8MaGdKgJcTEhnXgMcJN+KMgagiExbI4MhTjDIWw6EhmlpgMj6A8Lx9wxMD6E8PCgGrdlKVhJgQPYlMirILadtb453sCkGZWJuY8+Pqqth6QEdWd301lmyWEFAejVRnVHUmV8u3W6Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748949085; c=relaxed/simple;
	bh=39mXXvyyfIMkXS9zXUd6AfYEqN7yOJb7H4QluG04Es8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LMZ/W9ioiYArIP7pFnkV+q8POcu3BlvTgSsjSOmcdYhKJ5rJJv4wnF2bG0rFaPBCwAB35DjEw/5WhRSefYccjHZBUQODWEotkaKV1b6SKxdDWSF3ov1ct/rnhBOtasMc8FF0lHvuodl08V94J6zWlY0qgV2MeUeWGrNIf9fdiIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3dda4148039so47597815ab.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Jun 2025 04:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748949083; x=1749553883;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tpl8XxbiMV1cRiVkI/cGvUd7CgFxBQkoXApbA76gKdc=;
        b=PeBEwxf335VUWXIMrYB7kIj8NE4rDRuUFpPw2DfRZAh+K4BRtLcNh+KOlA1n3dcZ/D
         lKujW2BsvtCEAfxvou8U4g76EFBOZiGYBFn5/HhWeZUHenPxMsecv/KwvS0AVyAmfokq
         PoME3Yx0KO2eg/c8U3aCKM6cgaReJJLovnQYLgl38BoaGe+sQXRfu2ynGODCVi+CPmYf
         I0iI7zo0im7/vQegr/73VZ+hIjSAOnFm3BfvBUekon9UIMgXjbp41xiHPBXtTnO8mXXL
         XMSFHcixltDxxdcepHuWJi11HmxEliUa8fNe3BDkFPv6BCgfQYoua5/rUq7fCB5SDrP7
         e9+A==
X-Forwarded-Encrypted: i=1; AJvYcCVYyvRSNaWAVJiwnfhDFUKW13+D/4kag4DXfGVhpGFnB4aWS58L7ugJx68Fjn7rp9i6AQ1+vj+ENiH5ew==@lists.linux.dev
X-Gm-Message-State: AOJu0YwpAXNd4xCT7WY2FbET3tIBx7JSRI7DdaDzQjNyvSF1F1VWgSCO
	z4sX9nECSVOBceW+flk3G0axh/SbCGi7bwtbFF/9lXpKyefORHkenNDZJXFCuYSBL6+TC/WPWd0
	p7hN3pXw3X9VYU9rLlA0a3K1md9POXgUJUlQj3TJSgP583nAEnOFbQM1abco=
X-Google-Smtp-Source: AGHT+IHHXp+bRWodpMAlloxTc6DFDLShox9JCRW71P7EMP6IAmp/Bl/hvklldZ2HMNI74y370h5TRku0JNjrBTnyj2ApY5MTx1LQ
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174c:b0:3dc:7660:9ed9 with SMTP id
 e9e14a558f8ab-3dd9c7135ebmr160327415ab.0.1748949082930; Tue, 03 Jun 2025
 04:11:22 -0700 (PDT)
Date: Tue, 03 Jun 2025 04:11:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <683ed85a.050a0220.55ceb.000e.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (May 2025)
From: syzbot <syzbot+listcfb743ead64ed2872d1a@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 2 new issues were detected and 0 were fixed.
In total, 69 issues are still open and 16 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  195056  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  58588   Yes   possible deadlock in dqget
                   https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
<3>  42999   Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<4>  19736   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<5>  13063   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<6>  12679   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<7>  7371    Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<8>  2696    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<9>  2409    No    possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
<10> 1359    Yes   possible deadlock in __ocfs2_flush_truncate_log
                   https://syzkaller.appspot.com/bug?extid=6bf948e47f9bac7aacfa

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
