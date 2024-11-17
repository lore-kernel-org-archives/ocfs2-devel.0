Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A11F1805A
	for <ocfs2-devel@lists.linux.dev>; Sun, 17 Nov 2024 17:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731865744; cv=none; b=fDHzxDoJBdGQ3u3qeGULIxDln7EEBgbrwhXCGMcQxPNcCWduyjZdtx6Nv0eLfymEr0sn8hnzJNAXZ1e2nSLtDZzz70D63s3Mto5pqNZpurvFAIyHJe96tOjiOw83xTUizuE1OpZmfYU14rsqtaSo/sPptfHb4+wZqySF/AJR1e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731865744; c=relaxed/simple;
	bh=RmZwaPE9t9S4xO4E+RPxgKRwz63mR86k6WsistzGryw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=C/JXdGyNtpcgEfH7qgI2fapzJgJBoCkbACTFp5HCqHoAKos3MfTojWglRoz7SxGjJZ/2Arzqnu+OodBsDq2YKOPpr96YyhwU3IkEn4u/0IxaV3zdZHFgIAI1Eof65uvOH5wkE/51ll0pmt6scZZrY+EbOQ0r7/i0CmwJo2htOO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a765c8bdc1so3415845ab.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 Nov 2024 09:49:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731865742; x=1732470542;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lH039o7iT31/Qu/1scxtSdidkcelHSCYJg58Ymh6JG0=;
        b=dS27V0XEtaR0MaVpQQ1VbjwKSbHVGyoNrAaGgB7VkLu+RAkZHc1+67YpLLgTWzOELD
         dqcyAY0paJ9H/vhiBEItNzzv8W+QgrkGH5LQnVRXtB5Q8XnmbcrnpcRzzOyimCaL6j8E
         CwPTlsPLzGC8ECzYIJOpxnQloMx4Lixp+4Q/NHFTwgbA+qWzGtKRVvuWrXVkidbGyQmt
         cE8CnABDl3r+6pcCYaPqo/cMCWHUxR/iw37Z0Xzsh3YL1V6z7NVDZGxCik8S+hCg3iJ0
         mxthRH35wOMcZ7X3h6DdKco2OuxNl4JE1YMqVwvPi2TLfTkuw3i3R8t0WYNi948AN7Wz
         LxGQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0Qid4K2RIujlNVKm4LmwVBPwcv24Mvtq5ksGBalTg6SfaPzE+TAm2hn0u24qzuVoht/0EXwJ00AjOug==@lists.linux.dev
X-Gm-Message-State: AOJu0YwcvP6uTicGQlX8PbORld4SRun4CgPnQ8VH/Pq5cIOaqRTdFo3b
	nCEDV/D1hHAwCKLuZMJXTyhsOsVzEcjKi3yR7Xsa18GwQ+zyUo5ycATdMjl+8wPgDJhlwuwaS8h
	zDL/LUl0JmcUhf6mKO342p1zVII/MdM84NYj1K8NUKxEh/W4Ksr0Ig2s=
X-Google-Smtp-Source: AGHT+IHgeFp9d9NI51lcsjZ1noXS6I6lDq/BwKeNkva1lw7F6tNxdBBtcQk6nkn5cPhLIMXMVlqRtPZMlC3JxYVyUzaR8xHWIlmA
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1949:b0:3a0:5642:c78 with SMTP id
 e9e14a558f8ab-3a748082c35mr93496865ab.15.1731865742330; Sun, 17 Nov 2024
 09:49:02 -0800 (PST)
Date: Sun, 17 Nov 2024 09:49:02 -0800
In-Reply-To: <00000000000093a1ca0621e8d336@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673a2c8e.050a0220.87769.0012.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_page_mkwrite
From: syzbot <syzbot+2e6495950edcf7fbfccf@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10fff130580000
start commit:   b5a24181e461 Merge tag 'trace-ringbuffer-v6.12-rc7-2' of g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12fff130580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14fff130580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1503500c6f615d24
dashboard link: https://syzkaller.appspot.com/bug?extid=2e6495950edcf7fbfccf
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f252e8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ecd2c0580000

Reported-by: syzbot+2e6495950edcf7fbfccf@syzkaller.appspotmail.com
Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported devices")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
