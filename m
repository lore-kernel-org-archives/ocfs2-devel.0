Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73691315765
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Dec 2025 00:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766536323; cv=none; b=RwAKfTIbj88meEBD4sXQwc2SJsZTjrShw+a0q2Lt8pwdFu2pqeDk5sSeb0QnY1G3X5zQ8tH49k8TltGURFcjaXEjlvJavLfPf3LCOiemigfSlOOTXm9QydaKuykUi6HHku1Z3gSjlWMrlrOvExoLOZb6hGCpV/JeyY7RQ8f7FeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766536323; c=relaxed/simple;
	bh=WLDYsKeqtHC1X7/foxDAGGLfxjA90yTqPp+EiscQlX4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=QvCv4zhjTwKl9pVzhxaB2EAsMZ/bFH217p+vos9Xu8YrWTlP4rUB4ERf/laMsf7zG3luht6zOXxgjmgTY5sJGj4QDzrjvXiy5aIC7TTYeOz4t43uptn0T8CtE6kgZI76jvMt7zLAP/9Tuv8cVtvqW4BhDJ9geEzvuPML4Fttkco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-657537cef7cso8926163eaf.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Dec 2025 16:32:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766536321; x=1767141121;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Va2VfPs9ApZjSsj5ATJ7KVoiJwVbCQA0CZHsuoEnzCg=;
        b=v7R3IQz8A1T7fFgcR5RaJwIVGsDThBPaUOALwnuDnKnyitqpFzf8CR3KOkLt6jz/++
         6QXUypwWNBG5uY3dby2gORSSCcb+ppPnk3uU566gycTXprzUQqyjUUkfD8WBmbVdNvSb
         f9YZab+zvDwpPAza4LYm4Ctk6hY6dW1QviPgKqgwqfnXb4heqamEcU7lV+0rwqzbHE16
         4MV4ZvFtCtkkeME9QOrII6rBTGG8OlEy8dmQKM6WHpILzK5tj+jN+9FL/bnDGlcGpyqO
         LMWj6lyZu0FlZDAsAFepbEi52tSbuIhXPJW5tAKp3EpPQsCOPwJZUS/3Ubw+oqMH18Gl
         x2oQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFU9ilCMjliVT4O3AehGCQqDOCV+RcYrRYzsA9bhYGCkRw++b7ry4RtkctwGEr0wFI54QOaEY+O6tG3g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzEXyxe+ikFq7YjmsId2VPF8z/KOokjBzeVUTyR6BJEd6DKfY3V
	FodWMGLN6wNerXTm+ZXQPbr6X8YPIJoNbiDcdwNiG29uL1UuGb8lhHJFY/Tg4XoPVbGlaIH9Z6J
	pnnrUEEAj/uKEwg/Vu2ls9mzHVylNIKIAeN/5aZMxm0lV7mmgWJxSQmn1C1c=
X-Google-Smtp-Source: AGHT+IHOZfF91uzeoESVPCmUGI5rO+RB8szUXHzbAvDO46/yx4H8YqG3HZpHGicG5m8L3famMF9a4gnkPXDENXrHWS/b5aTfi6Wj
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2229:b0:659:9a49:9026 with SMTP id
 006d021491bc7-65d0eb10455mr7186596eaf.83.1766536321463; Tue, 23 Dec 2025
 16:32:01 -0800 (PST)
Date: Tue, 23 Dec 2025 16:32:01 -0800
In-Reply-To: <67775d94.050a0220.178762.003a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694b3481.050a0220.35954c.0009.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] [ext4?] WARNING in __jbd2_log_wait_for_space
From: syzbot <syzbot+04ae2c9e709a347f1a81@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dmantipov@yandex.ru, jack@suse.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, kartikey406@gmail.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 93ce0ff117b0c468961d7c296a03ad57e1e8da9f
Author: Deepanshu Kartikey <kartikey406@gmail.com>
Date:   Thu Oct 30 15:30:03 2025 +0000

    ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11b4ef1a580000
start commit:   63676eefb7a0 Merge tag 'sched_ext-for-6.13-rc5-fixes' of g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba7cde9482d6bb6
dashboard link: https://syzkaller.appspot.com/bug?extid=04ae2c9e709a347f1a81
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c678b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112bcedf980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
