Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A575C25CC74
	for <ocfs2-devel@lists.linux.dev>; Wed,  7 Jan 2026 05:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767764469; cv=none; b=bRT4zCXaxAlAxTEd2c4OWYuBRAtUNlX4/cCy7lZKM4m/AO6xsdM1I0SdBEXMfwdYzc1QjDYT+PWjiltJgzd5fcNMqB8DSganVUPkIgeBcImJ7t0JyTtv/8JRdERu7MMdHiYweejCWM+32tky1+yqjmN7B0ZZOjlUVqiO9DoCFWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767764469; c=relaxed/simple;
	bh=V+U4c3SryLMqWlecolLETghgvplahAmf5R7MVDKpVyk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=BMuRgqg9zp03x0w20zTXKcy5dYSqQU1EZxZPtdx++k/ZfedzV+Ko4WKJ3TxmoApK8DbH1OrnPPIv5kGLIxehmfzNCtVOkBRX6FDFCbF6g1pN03dml0ne/c3GWwKjRhtdklyzNMTuH6C37zB6M1R6dUjPZgwiaS/dNSuDL3xxh+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7c7595cde21so4730950a34.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 06 Jan 2026 21:41:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767764464; x=1768369264;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=soPypJi/MTp2xbRev2qRthiLFkOgsjlh8R+ksjubeuk=;
        b=akv1AEGSINGF/rDj5QqHnMr3qo+aBMgR9fUZ8/3lLd7cI1EIFv9wxc1DyFbbV7uVFH
         LTRhTAA+6YKRtGUiTRgy3upSihfsEG5v4adIDlwWWOi8Ltlf3mXqm8eC26pwkgEY5lgB
         T50WTJ8dKiXeYt7uQqY8vOGxzQPpJR/i4H3j9IzrzbMz168j7I2islWxXsUlrBRBnJgz
         HCcJxQJOTr3ifPZk92emBOvDBqfvhqTl0Zz16QFH6prfr7Z4SCNuHVTPQVaXRE/Qa5Vl
         UGp5fVbN4TVF7D6OuTL3/sZ7la5657W2VRAQzuLzx7t9vfOWFx0Pq60X3bfaStOIzy5c
         wScg==
X-Forwarded-Encrypted: i=1; AJvYcCXyhcysPCtAXAr4lcCxbhuOjG1LLMyNnx2ZX0IzQugc2WwIJwA8K9y8TdrkMhwdqPn1r3aMxyCuA6D/Yg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxzi/4Y7culRaBG+pt9e2A9Wh94IW4vlduYBb2Z2SCNkeywCZAK
	uYhqV0kYJuyXSdsIpMhcmWdEi/UFQdW/smtUjQK/n3vqV97kahkASXtVsx+9cFy0seXCUVFSHzR
	W3vZvZH7dzE/N1pj4GN9ruixQXs6ndT/TYT0oVskyNIotY692gMGpgkJIAk8=
X-Google-Smtp-Source: AGHT+IG4C8GqQ5d2+uYFcVd8Z1pmp7cmlKEmPcFDCSNDk/MqAyUv/ygCQZcRrTlm8UWhg4Sus8jNOKGkMCM3Jjc78GJgOtsyAO7b
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4983:b0:65d:3c7:b57 with SMTP id
 006d021491bc7-65f54ef66c9mr362718eaf.34.1767764464468; Tue, 06 Jan 2026
 21:41:04 -0800 (PST)
Date: Tue, 06 Jan 2026 21:41:04 -0800
In-Reply-To: <683bef14.a70a0220.1a6ae.0011.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695df1f0.050a0220.1c677c.0353.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_remove_extent
From: syzbot <syzbot+8882b2f5f48a7170a726@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dmantipov@yandex.ru, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit e1c70505ee8158c1108340d9cd67182ade93af4a
Author: Dmitry Antipov <dmantipov@yandex.ru>
Date:   Thu Oct 30 15:30:02 2025 +0000

    ocfs2: add extra consistency checks for chain allocator dinodes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13776f92580000
start commit:   be48bcf004f9 Merge tag 'for-6.17-rc2-tag' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=fe8fc1adb24b215
dashboard link: https://syzkaller.appspot.com/bug?extid=8882b2f5f48a7170a726
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152226f0580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: add extra consistency checks for chain allocator dinodes

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
