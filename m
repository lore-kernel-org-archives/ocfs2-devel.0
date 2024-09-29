Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5F117C9E
	for <ocfs2-devel@lists.linux.dev>; Sun, 29 Sep 2024 05:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727586546; cv=none; b=dv2jb/EoEcxQcf9jBgQIuHruE9z1u1eg6fg+3V7HLrWC/noJCDCfTK0Htuj1dHIEAkxPxT2vDpYMhNLfwCV4iAeOwvgXKlnOGEQfPfKC3muvlAQs4nahx9nPO2NcoLfDFZDF7fQSWNOcVq2iyZoILCdS1nXAaIiVunx0vpGDxXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727586546; c=relaxed/simple;
	bh=1fqDQMUO1L6aOZIZYZVWskI2QvY0oNjEVXmhWq6+8Sc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Bq8is3Jp/qCcjJTceUfDClv9tr+qiczX8O8mSi7M/4WkDiJhn/sBX3t6Ak2cTd29mhIB3fS2ZNIKEQIzjOxuIT0+LPENE1sv8JcwlwnVOXFX4caP7OZgdKuWd6jM1XPvEGQOdgxqfZ122ehCZDKYfy8+GDEwhOGidYR2VA6QPRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82aa94d4683so453812839f.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 28 Sep 2024 22:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727586544; x=1728191344;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ixz4PnwE432RBX+FcXTgYnYvlP3v9+OVI1Dv2yGJdE=;
        b=ixCLLMy6bfIA8eiknDRy3rM9yAWcPJxIvtNr73RTowCsuonm3IoNxFWkJ22id6g/PI
         eBQ/mJgyoT8cYAxzg4JgiX0VoO94HNpaoNwe/U5QpM+b59EGSXVM9bYOjEFIwN94m2uw
         SiNfNJvj94kSI0GVxsX7SR0BmH4TltlNdWmOtWHQCsFGKVrrVbR/UGOKauBQCC4Xbwl5
         bYcFAcURUob0AJHdcIv5JRXet90uN8AWP3Fptvj2HL2+dhbQG4Elblnqkrhv7ErNScfs
         m2zl4r83dLmf3OggGhX07T8DQTRnl0tew1H2dnVcLWRCAnyk420tWJQ2ln6QJQil6lJc
         kWww==
X-Forwarded-Encrypted: i=1; AJvYcCWw7GeGgqhRXS8xgKnAteoXSxT/BohTLnDYuM/drVUVP2QTUWdNWjO4zhHPIFfCgtFW+NgxadzSAZ5OLA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzFwZ25r/JqrMnI2DEltpcv41CydbqosmCusvMjFd9TtkPOvtGs
	mSjIHhaUaZHfk0rSTnjoJSY6/gwEYR0iVQGLpxl+mtUvg+brCNoQJRpECEmBezTF53Jy0WYTUat
	KZA5aklCtPp37c+r3BCBapeBACSJlnuFvSR3ytp9HKdhxbD0obD2+a5k=
X-Google-Smtp-Source: AGHT+IGE3xOEAYgej5Zskaz7mVfx5jsGS58Pis1Wkt6tlKBnbX2HPT/8treLWMJSZZNGUecPfLe++/aAAV7xuwzG6Y6qZAgbt9Id
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ee:b0:3a2:aed1:1285 with SMTP id
 e9e14a558f8ab-3a344fc8e06mr84891645ab.0.1727586544164; Sat, 28 Sep 2024
 22:09:04 -0700 (PDT)
Date: Sat, 28 Sep 2024 22:09:04 -0700
In-Reply-To: <20240929044749.135112-1-lizhi.xu@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f8e0f0.050a0220.4a974.0015.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: use-after-free Read in __ocfs2_flush_truncate_log
From: syzbot <syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, lizhi.xu@windriver.com, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
Tested-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com

Tested on:

commit:         3efc5736 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12edfe27980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7782ef71990b6dba
dashboard link: https://syzkaller.appspot.com/bug?extid=4d55dad3a9e8e9f7d2b5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12fb4d9f980000

Note: testing is done by a robot and is best-effort only.
