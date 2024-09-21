Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B4B224DC
	for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 02:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726885685; cv=none; b=mZNSo3XcJjSrx4pzkJmREFQQAdJ30nb76rtdoq87BI/P3DlWHN5doUdYAlXZB8bB9OwYGJaGay0IwmI8FmZgfLi/g/4D2LDYrwOuQBpJIDfi/4wjV5NI9jK+gm+PtfVImRHSX1rlGyXsqG6H12hGLq0iiS6zeO5b+wu7w8Wocuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726885685; c=relaxed/simple;
	bh=Sf/yzFQmkJpemzBUSSHu8EYMjfz2GGlqtPerwLWt16s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jWu4VLw/SpO4GkDCuEAMTTGkfBi3jVn3s4hooNwmp4j7IE9HimZGDnwp+ssG2JGxZhJ60dDJFs1BAsmckukCJFIaX8tatE0opwtJEqLxH+sqXk7jLhxlnW7lGd+BGBoVO5Xwa/HjHJbeliPZcq3QEG4CYyAjz58foi2T12391dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39f5605c674so35933705ab.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 20 Sep 2024 19:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726885683; x=1727490483;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yMaBaEBkg/OpyzN2Uqpyv+3f9rsnvjhbKblOU2k1UIY=;
        b=EFijmxz5wJaVy5tdSUPtTFUpqgJgx3XNLUNLsQ5+WzMQoZovms2t6y+aShGknD4xaq
         N3WBJQmIXqgepKBua0zsSKrb39e6pYeabIWqBCKcSlKIgpd9RmfjCgkcEwSwhIreSxmO
         DG0lBdJBF//4ErFW+AsZmRiiW0uOgxHi8c0PYFdaV0uwDYJ3VoMzgiTFLk/eCXoIDZFO
         x1O79lhRbf7uD2uUUsHJzjN83PgXY4EDale/6IOvbXMSjQmIvpfP3bmol8QYdWZbzUHw
         EsXveRZql7ZAYDNgml1ny8KfspqI7z/tmHGUKHhRiwOS9wPJwOmdW/9fDRe4cuzqo3yE
         vmcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsqLCAPPCiUoqSsiKZTcVRe2LJBrwxtNZ5HwY65gagIoha8AYHD+mGrNjQPJiiRO+b74X4zCvNfepxLA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxhXC6og0vQ2wFtXEG6jslpMBtEULG+TCf34DVVt2wCzReSM0qT
	7aKAUv/o05CTldY42h2yjA6lu3x5Pj1iIh+IZOHvy9+FBcKGuUC3/xCKFJ43M26t9fk12Rfmyn/
	wMAWgzlw+NlNQZ0NH3vXVkOe4tH5c43WqFY/WvfjgvVY1ycYpJxghXkk=
X-Google-Smtp-Source: AGHT+IEBX0mqdaKQMXd3phHkA5Bo7NhLiKl7gSe+Czm+rTbLUAbFma0yjB0JcMYuUWElVfz8LxXmUdnVRWORvK/jjNt9gxUoUyj0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c2f:b0:3a0:b23a:81f2 with SMTP id
 e9e14a558f8ab-3a0c8ceaf88mr47172195ab.12.1726885682790; Fri, 20 Sep 2024
 19:28:02 -0700 (PDT)
Date: Fri, 20 Sep 2024 19:28:02 -0700
In-Reply-To: <tencent_8A28BB01332A9E381B7A4BFB1BAB2512BA08@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ee2f32.050a0220.3195df.0025.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] WARNING: bad unlock balance in ocfs2_inode_cache_io_unlock
From: syzbot <syzbot+0e4e71041c9609d922a2@syzkaller.appspotmail.com>
To: eadavis@qq.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+0e4e71041c9609d922a2@syzkaller.appspotmail.com
Tested-by: syzbot+0e4e71041c9609d922a2@syzkaller.appspotmail.com

Tested on:

commit:         5f567360 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1210ff00580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=0e4e71041c9609d922a2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
patch:          https://syzkaller.appspot.com/x/patch.diff?x=107fcca9980000

Note: testing is done by a robot and is best-effort only.
