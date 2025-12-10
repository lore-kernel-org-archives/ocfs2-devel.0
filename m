Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84119326944
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 20:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765397166; cv=none; b=a3+RW/w8Vq5BUYBaIeiih35G3PgUP+PtT6a0LI6qqf1sxo83ZOLQP3+FOBpJ5v8rfm5pC1cKUzPoFbNCbHK9U0xCSZ2YdgiGrZwkENJ9ZZ9tSMSNdeTbHiV2PK6E6h2O2xnxHDkhtsb6M+w1uEkhcmy5tbwMYFG5nVOHx5c44To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765397166; c=relaxed/simple;
	bh=o/N9hNYDFGaPPiccpt1MWu5r6nedgV25JSOFHlJwRBE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tB30GHQbGUnjyn+6q5M2TrPVEhDek6/fkXPbWUSKTKe5OjcPzknbNtjU/YjkiTUNetTh/+mXr6SkmBd2MTFgCM6Q7frXcwMWnpseJQfsrZmHTYOn8X17pzyogfgMfBzj67P82jsbE3lyEV4JC9LiRZBsoxZd+dxnwSUQgQbqCZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7c75798bfacso583887a34.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 12:06:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765397163; x=1766001963;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gdpoFQRlR9CsknvUV9HU8+SF/nRNvJP5Go3OaipCpTY=;
        b=N5k6O9VUCDIWoHxQ9/iV0obKTd1xC9hik++/nBR2nooVMyqgBpMCZvkrzj7spfYfWb
         /AEjKYAA+T8QwePX0y6I8jPRTMQKAAb9Mq8VforQFRX4Xiga2G5DCNqwBth5G6wWTXUA
         GWLQ/cwNRsIGATJFPGtR7U6lewc4mPpGqJzTtHzfx25n42OWxf5TFPtI4II2aNmJFb/c
         vy+mje/kuSNd5ZeSW65A5xWGkEr/sVjmlhXcAO0aA7cmKzA4oaWu/nUTqN6UoSHNMfKR
         Ei1wUJSt93CuyOyKLQ2l11218aJxA62s4iHBUGrP8p41UukQq/UZx506gzefbKoARUo/
         lGlA==
X-Forwarded-Encrypted: i=1; AJvYcCWsqLSf3PutdlWOFcOiYyFafYZ+vSfofBIhs9JBYth+Tmo8Po1N0f5fT0ISa5AysnOcS+UGaTsk0EubFQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyNQNpQNJzZnKehxCR+N/d4zBz7J6SocxPe1gU0q1oMo6/RduJP
	mtTE+bnw64YCWr6k9IhBzSdHIiyrcNddjhPOgrypB5gHSHhzsxGrcSz1NpXk8I68K8HTrO9FdFP
	jMwmGIzXILokys77Z9oVvyHN+kkHsEPgbzgPJDzA+B+iQ7yzq3nk+tGClhQI=
X-Google-Smtp-Source: AGHT+IH2drRLJviEjM9rn0/o/Ucd3/rXK4gn13nxFWO1Yth2qfGPOfT9g4jca/MwVBRdNkdfRv7PnZGaG7JkJGUqUpGB5UWyUmkz
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e842:0:b0:659:9a49:8fcb with SMTP id
 006d021491bc7-65b2acf8273mr2227515eaf.68.1765397163648; Wed, 10 Dec 2025
 12:06:03 -0800 (PST)
Date: Wed, 10 Dec 2025 12:06:03 -0800
In-Reply-To: <ff7k3zlpiueyyykotdpfcaoxn2tukceoqcbmfdwjfolndy4sen@3f5r362sg67g>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6939d2ab.050a0220.4004e.01e7.GAE@google.com>
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
From: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	mjguzik@gmail.com, ocfs2-devel@lists.linux.dev, sj1557.seo@samsung.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
Tested-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com

Tested on:

commit:         0048fbb4 Merge tag 'locking-futex-2025-12-10' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15607992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de48dccdf203ea90
dashboard link: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14261a1a580000

Note: testing is done by a robot and is best-effort only.
