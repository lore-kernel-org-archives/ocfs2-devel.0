Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75AAFBF0
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Jan 2026 03:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768448765; cv=none; b=q0ip0Q7GxApDaG+S53U/MF0VWndugdbDFZF3xfnhqJZZWoOxtQVvZX+a3XsIHr+0Cl3BxZoTPGoqMhpLzb3WWgCYJ6NDAD0ATyA4Dg8E5r+/J+E62leWG9ci6mm0e3U4g3SP0J8o9a0/xZ7tVVyx2u9jG5wRQDsdWT5Cnb9OuHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768448765; c=relaxed/simple;
	bh=bT5HcmC5+wO/KbvlA9M5kSneNS3tJqjXvXYIZsrq9lo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=TkmG2a6e8L2kT7rWkn+GkCS+lH5YQzRrP36DonbIv6DG6yGkMXIAfXiRLyQStdOhP5X1esdoZ3l1K4z2QlWShu00oFmnl8jr7QFdko1ubeoajhnfjPFLWVkGgEPiE9Em7f7e8CaPE7p3yFoqC5xNNAkrAEaiZUFt4G8YhBtBuvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-66102e59148so1898485eaf.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 14 Jan 2026 19:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768448763; x=1769053563;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vej2+5L8sPfHEsZgfR5mpdQs3d/DGL7H7pG0dJcOTrI=;
        b=arJCefAnZZXPjty1XPES+ASgCj7pCCXnXy31cANQK1pyAUt8tkRzcILrw9XvyYpPA+
         QZ/zI7oQOD715OZpRiu+QAu5UKVbNYINTSMetuBYz+alNzUwU4kzgTPgy3vVK9A4zSSQ
         DZNg51FgLk/EX/1Up9tjqJxe8Ac6IVDMWff4U+Fiyun9V6+wHpGBOe9FYjet+g7QStWf
         gwzFFVsE6kuYk3xPDey7+a0BfxcAo1xdG4SrG14vGPWH2ooBci/8gSLXku51zJoXvy1j
         raR66c9V/fMTOcJjk1V+h+sB7psgfNrSQmSsdQvMYFlPfQR/MKGCWAnLPCaVffK2mCsK
         /clg==
X-Forwarded-Encrypted: i=1; AJvYcCXOPvAtvGTGLPaWykm4YC5rEvLlHoeIJwqxkCkbWBV9eYheZ3Ap/YSqxDxIUKCkrDU0FRs6z/zkAQ4VVg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwKycc/marX93pwt2RpbvA+TwqK1qqsJD6ys/hXwqIugsftEi4/
	jlUHdhcqB+jrOs4Jft8tSf7lNpez7g5QhqfkGzvIWo2k74s3C3jSwEE7OLMFd3TXQxuCxyYbH41
	tin1ltS7+Ir+Ya5ilBbPAV9hPHk/CzwL1HlAqlJ4DjCiX97Z9H0/qWEs9gFk=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:198e:b0:659:9a49:8ec7 with SMTP id
 006d021491bc7-661007251f0mr3916539eaf.75.1768448762819; Wed, 14 Jan 2026
 19:46:02 -0800 (PST)
Date: Wed, 14 Jan 2026 19:46:02 -0800
In-Reply-To: <676c3718.050a0220.2f3838.037f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696862fa.050a0220.58bed.000b.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_set_new_buffer_uptodate (2)
From: syzbot <syzbot+7aef76bdb53b83d62a9e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dmantipov@yandex.ru, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, kartikey406@gmail.com, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 93ce0ff117b0c468961d7c296a03ad57e1e8da9f
Author: Deepanshu Kartikey <kartikey406@gmail.com>
Date:   Thu Oct 30 15:30:03 2025 +0000

    ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=143ebd9a580000
start commit:   499551201b5f Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2b862bf4a5409f
dashboard link: https://syzkaller.appspot.com/bug?extid=7aef76bdb53b83d62a9e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136ab2df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124f6f30580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
