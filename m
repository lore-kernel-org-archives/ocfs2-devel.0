Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67C3156879
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 Jan 2025 05:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736919845; cv=none; b=gz9NFlNRrsBm755ijMqfjnafYpSB/fAzVCPDZjClrp3LWFRaewZK5doTbdBuGJki/eaWd+RT7C1RltvXAbEPLFeujKxOZFmJrcpAXxvNZLltxqvOqC8nzG7rAt1m9uzCadPlNbO5WiOb8R6GJqh1hCYpqx/tZzHuP+vldGGa4KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736919845; c=relaxed/simple;
	bh=rpb9H4hgWFqXY+pkagdolg0egHQ5jj34VD7yDLyKjiA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NAqS1z4xcwrRha4AM3kipP70/LKbzbbmeeG7Sl/uJ25VbxQK8b698ojWG+ePf74IWy8OkC+awBi02xalKrq38pnri9s5fie5SKSeh43lcZnT/dU6m9soGZiaV3Ogj1T7SOyTWjS5x+AYqjqhX5rqN+lUD0ITTiVsYmg3cYfVOQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a9c9b37244so114827235ab.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 21:44:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736919843; x=1737524643;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RQxyuk9v8MEwmH1WAob6AlxAtxg+b7Idsm25Mj4Sy2g=;
        b=uzl5J1ULeIYRy1iGW2dlEkB6Xy6XvmSUH4rgsPCeKuf63X+gwntz16x1BJFqO2QoZQ
         ITT9JNpmCVwXY6LFR157pZCVgFEj0onN4XMn22T5LDYR5VDKK2PYtNwmAGI5EU9esSCH
         wf3sLhwrPEHOxctvyrT7ZmjMLukmp2X8lRgKv2yrhjPP2hVJ0nwUd83tyClUD5k76r63
         HrhkDnUHzfERp4qqhH7TXa2xU7gxyaBO5B7wekNaTv1q8rd4zs+iG9RAm17BoAofJeyM
         kiEX7trCzNrW7h7aGV26R8eoA1IB7Hqcri8IE5PF1edAZwxunvk31RC7il5Tzd6xouFQ
         PaIA==
X-Forwarded-Encrypted: i=1; AJvYcCXdWzrvfGs5HfsL65fKqajTyjrQ8MdfwZKri3eQjUsHLS1cRXaBW2O9neJbRUWUShHwHKDaC7YlkizpgQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzgr2peszKxgrMXPQU1NPdY3PouWgeb1N3yO7/Y9GHCyxG8w1Ir
	fJBSP7ZEh8sNJCMDZ7ogFB33q2QrSaQs3+WLhSq65HGSBJESAUgAp4uYUSgqynfjE/JrjIEbkdC
	gJVTNDSh8UxdiRFyx1v3JJxVch2/2LRZtrrTcUb5hX5hkCQxQJdbKUiE=
X-Google-Smtp-Source: AGHT+IGc5HFQ8rXSfXK07QvvkAoM+ldclQ3yGgPAHT/EpsjNWiPi7eXT6pIGIotNHqwi/zoGgJg4uxJjCY0rKmhPum4+Fea8nG5t
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1f89:b0:3a7:dd62:e954 with SMTP id
 e9e14a558f8ab-3ce3a7a8ab7mr227961405ab.0.1736919842833; Tue, 14 Jan 2025
 21:44:02 -0800 (PST)
Date: Tue, 14 Jan 2025 21:44:02 -0800
In-Reply-To: <63e6ff86-5573-40cc-b7f3-0ffcf070ba7c@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67874b22.050a0220.20d369.0005.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] [ext4?] WARNING in jbd2_journal_update_sb_log_tail
From: syzbot <syzbot+96ee12698391289383dd@syzkaller.appspotmail.com>
To: heming.zhao@suse.com, linux-kernel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+96ee12698391289383dd@syzkaller.appspotmail.com
Tested-by: syzbot+96ee12698391289383dd@syzkaller.appspotmail.com

Tested on:

commit:         619f0b6f Merge tag 'seccomp-v6.13-rc8' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128e6a18580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=954e5731cdb4e750
dashboard link: https://syzkaller.appspot.com/bug?extid=96ee12698391289383dd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=125907c4580000

Note: testing is done by a robot and is best-effort only.
