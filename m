Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C14B1F875A
	for <ocfs2-devel@lists.linux.dev>; Sat,  6 Dec 2025 13:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765028164; cv=none; b=pe2ui4KoSxXvIYTCu8k+NPOlF9Z4dOmKo5EuDN5rEQvaOQ+d2mfhoccTbwAQkYFQ0L8amYCqbUkoy654dHWj55T/8VspmfJTMoXv9zTr7FZ9+cL1/Kthm8RGvPAXkXylX7mO/H3le1izVGGbOXzDwcUVKH63QpH12R/OnlkqccA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765028164; c=relaxed/simple;
	bh=nlVQIZs9apxRddSuOpDOCV3Wv4pSI9nGTs8bo0V76PE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=S0QAn7kNYXS7Q3ddv5KAAIpZEjlzEReC9S5obtHb9IZNGApuEPgDL/iEhFIk4yv8+LRaWlgTKQdnLpcjErV4FaeMpWYQ4YgyqZV4oROhAPBwEnzVOAvUWPfsL8ijvpXdmKumB7PVxzpWQi5eKJ3yJmrYFjEnA2pNr67yhC/jhQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7c7017d5284so6026621a34.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 06 Dec 2025 05:36:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765028162; x=1765632962;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9aSIs2vK7S34sRSoGY3JfIGgXjzRI/MUH+XHsSlvBg=;
        b=lfKxImemwGsFljCS0MW4FG5v0pNO7OM641WoE373jr/0qSwaQMeo16kJuVL3cuVfo4
         aCoEVIPUsyX13kDxuJXZaEUPQj/655yRJWAY5A5a7eSc5jv+0dt+QeEtyPBa1oOYBtld
         O1prE6PwNGsY84ywgZ39l2NOhKYhq6rzl+cSmARR4drv0lNJQf8942nNFtybSIWmGDnf
         z1ZcZWyjAreYYD69rUpriwcEv1WKpk1yCt9IlCAR+lo9JKL1v70Lj5WhltCtX+9Bnonh
         21vDdKN+OAMzVdFUNHYWCapCCMckQx2W4AOLV2CTvWVAcoqBeWshYo/4d39LMS1WGIfr
         3yiw==
X-Forwarded-Encrypted: i=1; AJvYcCWlmC/JVaNzBsak64vrUSst6Ea1lTg1ymG87ykfuTo4NHsGisr1/ELADrw/VYVEXCtKoYj8AFWOB/aGcQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzQw0wUzkbYjgSJ94pO9tJv+if5em+6ktIU0AzVJZ9N0CsgU16j
	ZIgsEcNCnszPEOTaVfD02kdfP53/8rdWnVmUkzba41Gz9mUojlCRszRpgTChdti0Kj7I+mBVLb7
	q+UXMzVAvcn7Kf4b2+Sw8h1mTYL5llyXUoHdvnB9oVvanTjcpMeIgGDmuDd4=
X-Google-Smtp-Source: AGHT+IGK985zR86wuYl0Z7c3F9+yQ6rXprXR74vWwb5LbkKy+18izgntC9bd8lD3663aVhoZrek0iFy+p1jh8wTZmr64UdZMNFUH
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:a0c:b0:659:9a49:8f87 with SMTP id
 006d021491bc7-6599a999a81mr910050eaf.76.1765028161800; Sat, 06 Dec 2025
 05:36:01 -0800 (PST)
Date: Sat, 06 Dec 2025 05:36:01 -0800
In-Reply-To: <20251206130503.168731-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69343141.a70a0220.38f243.002b.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_block
From: syzbot <syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com

Tested on:

commit:         24172e0d Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12b54992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11da421a580000

Note: testing is done by a robot and is best-effort only.
