Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F34258ED1
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 11:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588665; cv=none; b=iFzd9OWI3htKM2XmsH+BwnJk4csod2T2nCMJcztjepNJSHWtCNy3VyqsK74rcgTNXvFRX2xEJupOUpgKDzXpoHq7fJRKfgc/5TzrrulT2WCf8+zIX934Lg72qzDQaPS+2W/GaK9z/qH6jbuX7UH/ixubOa/6vyMWvQfy0qPTAK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588665; c=relaxed/simple;
	bh=iUtsPGzDHwd4Buj6J0im/ocBJDVwuKinJjqU1Mx1Bcg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=BUtJyM4nEKrn7orboioAXcIVe9Rospx8/DyVM4RjmRchnxqiheZUa296ml1bthn0JTkJ35osbvfeUcRQdWsSpNnfVl4yDMLKnsvnDtl+Cr521WrnayKsPi4jKiLXHkFHtjvrrSYrm1jw2Tugm9/6r7QCvnYt6kMTz8eXt1vjN1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-948ff1d169eso268702739f.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 03:31:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764588663; x=1765193463;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BaGFbIkLFtRvviDMCGZeglen+7E+S6ZJUMwN+/1SxnM=;
        b=LXsUv1uibhoBZb06hmzsJb3bE86P2qVTHjwMxTOmIRyLQyECg6BJ6MDK7qgyFyIFkM
         xc99niddjPjD5fBeGivKwKz+Iyx4AZnM/ceWaXZhgz+oUnMTLaLiPFq37ZRMatMH29LA
         jdBgIm+nixTJYL0w+tudhARFayHqDrjXTLm5DU5ytffzBME7pUSxTUinERJnMwjnVxYT
         JTmiKEXGWf7FXuObhJkPf+E+x7shB2MgtrhR67n/nsp5GlMAK2xSP+qMmZfmCPxsxmSP
         nVuXIKHtK21RvFPyuxeEv2CbpEQZoXw7DA/nGo0rzyNYQiKfQTSIhd5ZGBEF0wda+VLx
         2uQw==
X-Forwarded-Encrypted: i=1; AJvYcCWyDBiueZp0X0dsOVeaEemyk+8qKjbu/dETqr9rnAq5cdRSYh+vV5A/VuQmyDNDJ2ciQqbHXnfHDLwg3w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzhadsjfUJBfgwO8q+UmFvbG3tJJ+FOd233tSgepA8TIABeTMM+
	sMZVmGKeE60bRpfzTGzK0ZBo/+KMEU9aqQW9FJe4VzHuIU+W5YngWI6COGy880bkkMfnbA5paIv
	hmuEeN7rXniaP4czZNGp82P/uDm09nrRKqkQoXYiqRyxVrHnLxdQI+34je3Q=
X-Google-Smtp-Source: AGHT+IEUkZRJbi0MmCvtHs3I6vi4Ox7hW7oCgvdLcuvqsWs7MKg37TS/8ysOlGJ9To7GNVIEwPryzfGFtqxlsLlWvGY/HEHr4DWD
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:483:b0:93e:8332:208e with SMTP id
 ca18e2360f4ac-949777ce599mr2382955039f.5.1764588663583; Mon, 01 Dec 2025
 03:31:03 -0800 (PST)
Date: Mon, 01 Dec 2025 03:31:03 -0800
In-Reply-To: <20251201101938.103998-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692d7c77.a70a0220.d98e3.0186.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_claim_suballoc_bits
From: syzbot <syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

fs/ocfs2/suballoc.c:2082:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2116:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2143:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2152:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2215:1: error: function definition is not allowed here
:2289:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2330:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2345:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2364:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2392:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2463:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2479:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2562:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2631:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2640:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2658:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2700:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2715:1: error: function definition is not allowed here
fs/ocfs2/suballoc.c:2736:1: error: function definition is not allowed here


Tested on:

commit:         939f15e6 Merge tag 'turbostat-2025.06.08' of git://git..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9ebb51ccc2ec42f
dashboard link: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12782512580000

