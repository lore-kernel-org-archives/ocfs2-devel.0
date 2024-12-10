Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE0178F39
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Dec 2024 11:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733831227; cv=none; b=uBbzII7zqggLtDqtusiKQblDlAhVwpkROimOX+T8U2JrHIlU63RT263uxr5RhBdIwo03QLLgblqYfxAqyUwSNid5aiWuizuirVF5Vc2Q5j55Kp/e6FSKAyL4SZ6GsYelATyJXnmDN/hMSwFqS95MyVsNjFxlc+yqzVlNhyYFK1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733831227; c=relaxed/simple;
	bh=S+1mWHR4pCHTgvD28d7yG1W8tBQWQlxedbN3pTWnZAM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=mDcxmEtcA1dDf8wM7lYhNFlA2ad35yGzJIiznh1ILjdJajWlrQ+LWb6IrlIEolfeETP1LXbraZb1dJXNOxuCRQz21fn5RxZBAcAhfQO1lrQIqLkSBznwdn3T7sj7iYzHx22g7ArOoTu5dFY0Cf7Jakfn5h4lXG2YWEU1TRuoMoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a7e0d5899bso110583955ab.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Dec 2024 03:47:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733831225; x=1734436025;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=97+9s3dhngU3xzp8BQV2/r6pIIBerftQCixS27XkXtU=;
        b=scPRVKNCI5USMeVUA5ksvugL5lTO1MDHku7x+VToVMHnn0xzAL3mHmv4ZnULdej9WM
         Li3MYeQJSix7nPSN+9GcZUjcHRhzoPVn1qmKxQ/n2AJ1tvIudq7R86thw2X1Q2UL8M8g
         ZYtuYhMZbIya94nr6RVOqyoi/krHtWMqbCPAJuvLQeezggMfqCLbYWI9ruSN5/1yVsuE
         Fva6A+im3UX3JtGqep3lO4HB5Rfq9DFh6v0yEn9UWJ2H9Y0LwLQzliM+6DQ3dwAodNqk
         qaAYXvcsaYYEdOGcGhlOGmsNF+BYRFxmT8eOTyCU5GBAb5bHmRkctvqDheCd9lBzg6a7
         XklQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDNgtYGkS+0EnVp7l+97gP+fy7ker9dbKEJFskm/ka3Dv/S/RiatSaf4VRV9CcIpzvFZ1pl7yygAjBDg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyRWmtgmvyHZ0ORj+OsX1/gACsWdQVB//S7Rha+fhHFWlc8ZSfT
	cTimYcpCxIE0vAhp7WhS09ioBgoY0Uh3BGkKJ7U8o5qHIurSSMklxo/WMtGFdmCXPM5FjBVkvj+
	/3+Sn6h6N1cfrBa18UnbPtbTCd8gDzNh99HhwN1/c0PeLqb5BbqokpjI=
X-Google-Smtp-Source: AGHT+IGZ2yzTbkD5GOwx0wnDW5tMQ6zpvXOegf5S/zDXBVd1y55E1FHLLQ9R9C2Byuk35bm2PZeyqXdJTaT5HPFz3OWbiUUW1isB
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4a:b0:3a7:e01b:6410 with SMTP id
 e9e14a558f8ab-3a811e0815dmr172123085ab.18.1733831225469; Tue, 10 Dec 2024
 03:47:05 -0800 (PST)
Date: Tue, 10 Dec 2024 03:47:05 -0800
In-Reply-To: <a1ef0b7bd9d2491ad346fb2a55b4279c4bd2f1fe.camel@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67582a39.050a0220.2477f.0063.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: use-after-free Read in ocfs2_search_extent_list
From: syzbot <syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	sunjunchao2870@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com

Tested on:

commit:         50760016 Merge tag 'loongarch-fixes-6.13-1' of git://g..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=17037c0f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=50c7a61469ce77e7
dashboard link: https://syzkaller.appspot.com/bug?extid=2313dda4dc4885c93578
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=106c68f8580000

Note: testing is done by a robot and is best-effort only.
