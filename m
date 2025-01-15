Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3BF1CA9C
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 Jan 2025 01:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736903593; cv=none; b=GMQsjUiMf83R4phUxpioX3pcrRYmeqibenhFa8CFuO4WUUpGTzJTLNAwmIAMd6nhSfxE+VR+h78shjvyOfaFgikklAl0eEwlKHLqXwpHXJD/HlQPW1mm0s/I8mg9yclVFh64xQfvV12l3H5cTfUMTYiW/1HJjzIGbwsMHeNztjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736903593; c=relaxed/simple;
	bh=XXBHyN00QPij1xugSLJ3biwn6f8UdPdm2t8pe6vyul4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=PR6YvgTmGUqpxJUswLtqRg8IcQQPTnTVrGeaPROV0s/lWm1oddX4VwmQAdy/jZDR0w+hZxamRWkpBr8/WSVrm9FaJFXtfJpB0/mgWE72IWvJFplNe5JUWPiMj9nfLPzu7lJqNCIgPVPrTdyjSL+uL8uyaw8SITWwjirPJuQW1HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PPUaTb3W; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PPUaTb3W"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d3ea2a5a9fso801745a12.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 17:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736903589; x=1737508389; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V1+q+8g2NTZwgZPIGU1r93tzMcK0NND9lKoYXkBIuB0=;
        b=PPUaTb3WidVg6n7cvidf0DQlS+PRRhFpWOuBf70SdLfVrI/R/9GmUgWtCGrlgubf50
         +V74HqyBJeoljPSF47IURkwPuASyTQhYE3lJYx8qdHezpTLNUxw9DQzy+8BtZtNVs959
         J0746eFJpC1/HnXY2t+IE6n5C6q0/Jlaik79mAYUmcbsxCgAuopQW68of83oMBHWthUa
         L8jJJUPz0wKadODjukAX27v+iJm9lU82xyUY/S1bZtoUiOX3gOB7goDCoFtWZOGkIfd5
         B4m9N8Pva1sOivWL2WmLSylo0O2mjAUcnL/Y3uq/UX+/bACKB8e8fyVETHqdiQ/sROhA
         FTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736903589; x=1737508389;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V1+q+8g2NTZwgZPIGU1r93tzMcK0NND9lKoYXkBIuB0=;
        b=PTcUQQPRqFjWhO4nSGYbBJjGaJ6eyhYUORj16YUSW737eLOS8Jmsfl2b3+b8qLOTVt
         0y5Sd9WIl8qdck8ydOIDrW6+vvfwD6PsrbhcH+4KFDk2U5kKyZ+vkIdxndfacQQXBmA3
         tJRbGHDdHGKtXnmHK/oDcIq24wW0DgWi7LoVXoB/YJ+Wvy5XulNai/gNtoSn62MXWY55
         TVzhcpAmIu/1HoXp5H6h6Mp8HZ0SLugPHXmMXaz6N8L5rTvz7TBNW2/vRrito60NQGNa
         0yqeijs24dX9WzGDLZvhFXHAZiUNTeTnogveglReLmnok4eqsNfKo57oiShFZF1mWd+Q
         b5rA==
X-Forwarded-Encrypted: i=1; AJvYcCWvfZwHqzECwJXvEDkLnfUIbODKO7MFNQK7mEErccOTdqkVehwjG2Xlu2k9JtzVMIQenx2w1IuEcKn4ag==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+jXdL1wfOqLFtXXHOfu1l8hBQqC1CBdykXJBWOBKmDtYBHU+8
	lAv6lIkfhO7t01SGN+oipYd6HFrr/MdYnzV08P9A+JiPNVxppxzyWvXFxLn3DP8=
X-Gm-Gg: ASbGncsjtoVCHSxNFEt1z9iC2iqS7lYIM96W1aHUghc8JIDrOehEpoamDzudPWgejqu
	dZWiJaE+hOmHnpC7KdzE0Oq7ECmPPsakpRSz9uZ117LbefDefttemsE8H9JSUA9HlJaVhYyPiff
	hVIv/0WMrYqaC7ybBYXrH/q7k253S/DZAg7mwjGmIC3YKVsyOFh9oSGRUxUtaltlxpOko4Oivyb
	2nPLxmEwaM9ZUSKHh7d6bPwtEJsFGU1o2ymGMwfB+xOOyS50W9NCGVS+2wC
X-Google-Smtp-Source: AGHT+IEKFHaVkdWn3B+Q40FlCfCPEjPyfa3Hfz5J5vetx3o/aEaVniKL2BOHvBpqgFe6+8bdRv2m1w==
X-Received: by 2002:a05:6402:510a:b0:5d3:d747:649f with SMTP id 4fb4d7f45d1cf-5d972e7907emr9614079a12.10.1736903589465;
        Tue, 14 Jan 2025 17:13:09 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c20cfe5sm169583a91.39.2025.01.14.17.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 17:13:08 -0800 (PST)
Message-ID: <04a9ad29-51de-4b50-a5bb-56f91817639d@suse.com>
Date: Wed, 15 Jan 2025 09:13:05 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [ext4?] [ocfs2?] WARNING in
 jbd2_journal_update_sb_log_tail
To: syzbot <syzbot+96ee12698391289383dd@syzkaller.appspotmail.com>
References: <66f98a80.050a0220.6bad9.0021.GAE@google.com>
Content-Language: en-US
Cc: syzkaller-bugs@googlegroups.com, ocfs2-devel@lists.linux.dev
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <66f98a80.050a0220.6bad9.0021.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 01:12, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    684a64bf32b6 Merge tag 'nfs-for-6.12-1' of git://git.linux..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=138c0907980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bd75e1a00004094f
> dashboard link: https://syzkaller.appspot.com/bug?extid=96ee12698391289383dd
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bea99f980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d04aa9980000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-684a64bf.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f05b4b08a420/vmlinux-684a64bf.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d59f9edaf3bc/bzImage-684a64bf.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/a82758cb7d80/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+96ee12698391289383dd@syzkaller.appspotmail.com
> 
> (syz-executor214,5103,0):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0xb3775c19, computed 0x2dd1c265. Applying ECC.
> JBD2: Ignoring recovery information on journal
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5103 at fs/jbd2/journal.c:1887 jbd2_journal_update_sb_log_tail+0x2ba/0x360 fs/jbd2/journal.c:1887

#syz test

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c79b4291777f..0d9a7bb5bc88 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2410,7 +2410,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
       * recover anything. Otherwise, journal_load will do that
       * dirty work for us :) */
      if (!dirty) {
-        status = ocfs2_journal_wipe(osb->journal, 0);
+        status = ocfs2_journal_wipe(osb->journal, 1);
          if (status < 0) {
              mlog_errno(status);
              goto finally;
