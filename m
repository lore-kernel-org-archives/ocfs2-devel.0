Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3306F10E9
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Sep 2024 07:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726300384; cv=none; b=dXWxBncCO+8Ihrj3datEG09sjeC/Fv3aXVp06uvM6TLyNVqkAOzu144rf/4+slgnTiIF90M5b8/BatEJvjyAkm9ir44Ad32xvAHAJLN6A8IaTxQ1kRCYU6gRFAyraRlkP2npbbH+evYO4Sn6/wG+w0NP+bbYZPbZHDzbeQ07SSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726300384; c=relaxed/simple;
	bh=kYrcfGqyI9UWqVgfDl8JjHC+PQmcip52vOqz4ExrGq8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nbjXnuE1k8gi21WEl/N89VutkI96Y6iItkvHzVFxNydYrc0SdvkJnaDRbQx+bbOF2dEMRfBRNyachwKKAHbXVvXEHDwd3SOCJWZkgGwYCjfKNJEa1zjb4Gv+Mjf31F3xR3pYTSaXEHxaAzgs6yszIs13h7aWUVgc0uqFpG2dDCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a08c7d4273so45325605ab.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 14 Sep 2024 00:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726300382; x=1726905182;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBh4u3skwGtSv3GL/wDNzy7yp1jEN3S+V/wuQDqlikA=;
        b=FBWp51GOBIo1vIL49rVS3tZgwLKSGoE3XBLYSRGIMzEKpu6snAPOLKJbbxQ48lOrLI
         OaO/KXS49dJaSEDr135FvA/b7OAYmmdLCutpXxcYCdLIfvRTyLi4Ph8PaDIwSSSKxem0
         x1KnnxdP8HB674Cb5oT/htXdkORAeLdc6PnsOjUSV2OZ0RsypHvj5Eu9umnrtuWt//AM
         03pujipOxmIi/OlFHwM9qzdZVIOcoMnjRdGDf3FTgjQwJyg1e4IAd5s4reOVJjlUBV4A
         x/ZEEJf/3ShNBLtZISGFJvd+YNNPoCBX9WZiMxrKfbchOkHs+t6VEIW5f1o5zfBAZ9h9
         anbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPhaGj4TvgZdjKtQMuQbLUrI41BtPgUo0N41qtB4vR2CBqJAzJc5oUTteMZSqWoVfK7Um88JwLRpngbA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxvxgt/P17xSekSagq68OTgJGjH0QRS3HwfAqLsniFoCs5jOWlj
	pxaUWypOC4bpmXZPAnosrs7xmc66YRjQo4AM/zdensW+LIMZng1j9xjCJ2bP/W4uXCMxAqane3/
	aJT1mqlib00dPSAHzdJ33+E1FyXfRWIAXjJZteOIqib86z0bG6zrOsNc=
X-Google-Smtp-Source: AGHT+IEilAHp69i8GKZ0aEbebAOEzDE2jEWi+Isl/7f3TMAf601houOnWWM7jwutZZkAMOjwOs1+fGn2OYwSntljErZp6dAsZHow
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e0a:b0:3a0:4d6b:42f7 with SMTP id
 e9e14a558f8ab-3a08b79a1a2mr58094615ab.22.1726300382397; Sat, 14 Sep 2024
 00:53:02 -0700 (PDT)
Date: Sat, 14 Sep 2024 00:53:02 -0700
In-Reply-To: <000000000000e28810061fb68dd0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66e540de.050a0220.175489.0002.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_get_system_file_inode
From: syzbot <syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com>
To: elic@nvidia.com, jasowang@redhat.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	mst@redhat.com, ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, 
	parav@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit a3c06ae158dd6fa8336157c31d9234689d068d02
Author: Parav Pandit <parav@nvidia.com>
Date:   Tue Jan 5 10:32:03 2021 +0000

    vdpa_sim_net: Add support for user supported devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17ea8407980000
start commit:   196145c606d0 Merge tag 'clk-fixes-for-linus' of git://git...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=141a8407980000
console output: https://syzkaller.appspot.com/x/log.txt?x=101a8407980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c9e296880039df9
dashboard link: https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16fdd49f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f5a7c7980000

Reported-by: syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported devices")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
