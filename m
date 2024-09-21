Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F172119
	for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726893124; cv=none; b=Oem4c6Tnd3qGdSMFkGCJ/0h9pWwEqKxR9Rwv9i5gCVFhPtgxnwzoE3IqjESUAFM2ME8cuRzjRmkNFNBcbcLIpMp5/Zhubx+72tHYrDltU4qrH8jazijY+koFs2GRINfCFP4h5bS4KQNJ5XlSGCmhRa7VfL0Z1cw8n15mghhN8s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726893124; c=relaxed/simple;
	bh=dEJRLbwriepgA8+heAwnMgcv4g/JJ4a4/mj1GxmJHRA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=IjRxSXbamrTi1FR6rfx0uk/AmgEwGOfeI6HQW+7m6/xQVBt3+2F8Au2svv9be4Fxhr3NWu4LWAuky+9DOA0yVftZdTXF+YWebqXqcLRUF7RlVf5UZqANhuJK8KrRfr880ZjfUbKbyDEK7l4VMYMfE2VjytyaoJ7rbMg8gVAVyCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82cd682f1d2so356286239f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 20 Sep 2024 21:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726893122; x=1727497922;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vuNcgYuN5DBSEVplwSPWmZCV6DyfXmkHpp3huHRYLW8=;
        b=HPlTciuEQJoFCdwN8WGby/hSEU1pClgLo4ZX+jRw/Ddc+eUFqNZo79I7TdmHV6ECqd
         3t5xd+zL9+ixsKxdAYCiJnZFsIZNDJXtK5ash1LgQfiGBlyo1JOKPp42ASZFdnsbdh4o
         XicXzQ9r9vH4TuW7IfHlcuDZupL89XS84w6p5Jxc4xd0rLsZhp3w+/+V+wi7wp7VYuqi
         BauHfDPyj9An/LBFODcQdkMoCjtH6lKz2OmWh/IZ+bisnB9l2VGPSJAnNKQuKO94JGNc
         6c2SOmroVE1hQTDAHIpJOQiqvCqZ3xtNegh/5lodW8A4a69y6kp2k/KYd57SIvG8cBZk
         LhQw==
X-Forwarded-Encrypted: i=1; AJvYcCUNLzi9MXOEFXqwDUI1/r4GYV0k4qUFjseiVAcbCuBFU2zmmdf2DMjWtfTZLkvRTeaNbxHjQsbvYV8Y7w==@lists.linux.dev
X-Gm-Message-State: AOJu0YyrDKO9dqDiPFWyAgMnA5kBDcHGuSrIzD/Uv+mnAFLFiJ8TG9yw
	YldNV/BExzzZ7IbwCCcsn0Nmbdz9h53UoosKZkPNHwGFGQ18FH8jeeh1cBT1outR05bBTiKT8cy
	xptybZx6lY26ylqfEIC8h0/vjhG12NvYmgzgEyQpqh44jvcgoRQO6jrY=
X-Google-Smtp-Source: AGHT+IEulUQBpl4tL0SqCT1/1/6jseazyTqTRbHZh6NpB8nmbgYhVnxlc8yT+zTDXNyXaNSC+Dg4EMhbqT3YK41tClxIk4Rkja50
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a85:b0:3a0:4d1f:519c with SMTP id
 e9e14a558f8ab-3a0c8c6b184mr57606895ab.3.1726893122095; Fri, 20 Sep 2024
 21:32:02 -0700 (PDT)
Date: Fri, 20 Sep 2024 21:32:02 -0700
In-Reply-To: <tencent_E64425D6BAF8BBC833499EEE1BDC4BD41B08@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ee4c42.050a0220.3195df.002d.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KMSAN: uninit-value in from_kuid (2)
From: syzbot <syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com>
To: eadavis@qq.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com
Tested-by: syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com

Tested on:

commit:         1868f9d0 Merge tag 'for-linux-6.12-ofs1' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1152ee9f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acaa65be5f19fc5a
dashboard link: https://syzkaller.appspot.com/bug?extid=6c55f725d1bdc8c52058
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=136b7607980000

Note: testing is done by a robot and is best-effort only.
