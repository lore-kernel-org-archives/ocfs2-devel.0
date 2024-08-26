Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBEC823AC
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Aug 2024 04:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.193.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724646218; cv=none; b=sQZS28FyOCMNHXGDV5gxdONvixmaxnc205yf5hANsKJRRZh7zpShx7fAiEUcJo5Aa27jpqeywh6Bp/RJJuKanJIOvreQ1zuJwg4wop39GBtsiN++BdjjqCAcaxeMNtK1Ga0RF45IPASmXn6sAh34JJw1G/xDJSVIIvNL72SiF78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724646218; c=relaxed/simple;
	bh=UvRwjVT+wdzSsadX45w3gvGTX/NnPXde2PFuhVgMyuk=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=W3s0OhE0bouevjfYSXhPY2jd/e+ccf92TzfPRaKEPY1gaaRGSOKe/aw4s9tbAfi3Lj2f2oO3nlqQMBTFM4MIj+xHueIVNiwjY0OmcOCSknnwihVr9WLjF59GzuUTzsw9FhOr8TrUh5MFhBaWrliFWx5v0oJcibrBoScvlIS31BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lkcamp.dev; spf=pass smtp.mailfrom=lkcamp.dev; dkim=pass (2048-bit key) header.d=lkcamp.dev header.i=@lkcamp.dev header.b=bdMqW1QJ; dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b=DCAKlRMw; arc=none smtp.client-ip=34.202.193.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lkcamp.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lkcamp.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lkcamp.dev header.i=@lkcamp.dev header.b="bdMqW1QJ";
	dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b="DCAKlRMw"
DKIM-Signature: a=rsa-sha256; b=bdMqW1QJ2u29NPdmDJUZAq9T9jEztt7DaxcycYXuW6xHuErAhgCIS7HFwWXiD65P4PUNeVoP1ZKIkG6iwZrq8wl6cFCrzcU47rfERSDFWPnnNaWBr4jGVzsvdYGDYDwvV5Ibwo6bkedFsu98ITdPyPYgRHKs84uCLGbG93fE98E/I5a2s+bZXZLhSfdudVEoQ0dPtH8crE8uRo/Ly7GwvtBj++rJ3L99nap9iG3mLr0lOwyl1HLiRn7fJPd9chYoOFGvf4EdM+IzeezuiZSByPwzTWkCuxmJB4mtKKHXEgI24+gllE5peRbVF6gmFODyrYRlD8mthqZAY3ao7inX4w==; s=purelymail2; d=lkcamp.dev; v=1; bh=UvRwjVT+wdzSsadX45w3gvGTX/NnPXde2PFuhVgMyuk=; h=Received:Date:To:Subject:From;
DKIM-Signature: a=rsa-sha256; b=DCAKlRMw9waceTuBQgqwEVY+Xq4gqA7NTLZ9Q0Et1SRF5UXNnbrxbShbMgMAYJ6paQd8GB4cww9wmFHPbjv4D36Y7a6Wv5H1Ociw/PCyz+ybCUd85LyX7R2MfMjNKhihK3Ns19VWFcO+ZcdyMYlzHmFL5fK9tl4cxW5qSBABXYi/mMgMSPfBW8nBfDZ8pFmF+FxwS9o8uTbHowTeZf5Acrx+OF3pupaM+pAv3sNbQpuW7eIcK3YuI4zFcwVucA8p0Gatv0WOUVSLgswe6IeIPC6lISZ4fSB6juf2NOi8qfippDe0j+VyJNpLZfCTOsOPxSZQ0N4AmGXRgkuqb4EkUQ==; s=purelymail2; d=purelymail.com; v=1; bh=UvRwjVT+wdzSsadX45w3gvGTX/NnPXde2PFuhVgMyuk=; h=Feedback-ID:Received:Date:To:Subject:From;
Feedback-ID: 40580:7130:null:purelymail
X-Pm-Original-To: ocfs2-devel@lists.linux.dev
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id 1044989440;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Mon, 26 Aug 2024 04:22:59 +0000 (UTC)
Message-ID: <d673f289-2385-4949-ac80-f3a502d4deb2@lkcamp.dev>
Date: Mon, 26 Aug 2024 01:22:54 -0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: syzbot+8512f3dbd96253ffbe27@syzkaller.appspotmail.com
Cc: jack@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com, tytso@mit.edu,
 ~lkcamp/discussion@lists.sr.ht
References: <00000000000070a66706204e7698@google.com>
Subject: Re: [syzbot] [ext4?] [ocfs2?] kernel BUG in jbd2_cleanup_journal_tail
Content-Language: en-US
From: Vinicius Peixoto <vpeixoto@lkcamp.dev>
In-Reply-To: <00000000000070a66706204e7698@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

I noticed this report from syzbot when going through the preliminary 
tasks for the Linux Kernel Mentorship Program, and thought I'd take a 
stab at solving it. I apologize in advance for any mistakes as I'm still 
very new to kernel development. Either way, here's my analysis:

 From what I can tell by looking at the reproducer from syzbot, it is 
trying to mount a file filled with bogus data as an ocfs2 disk, and this 
is triggering an assertion in jbd2_cleanup_journal_tail, which in turn 
causes a panic.

The problematic call stack goes roughly like this:

mount_bdev
   -> ofcs2_mount_volume
     -> ofcs2_check_volume
       -> ofcs2_journal_load
         -> jbd2_journal_load
           -> journal_reset (fails)

Since the disk data is bogus, journal_reset fails with -EINVAL ("JBD2: 
Journal too short (blocks 2-1024)"); this leaves journal->j_head == 
NULL. However, jbd2_journal_load clears the JBD2_ABORT flag right before 
calling journal_reset. This leads to a problem later when 
ofcs2_mount_volume tries to flush the journal as part of the cleanup 
when aborting the mount operation:

   -> ofcs2_mount_volume (error; goto out_system_inodes)
     -> ofcs2_journal_shutdown
       -> jbd2_journal_flush
         -> jbd2_cleanup_journal_tail (J_ASSERT fails)

This failure happens because of the following code:

         if (is_journal_aborted(journal))
                 return -EIO;

         if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
                 return 1;
         J_ASSERT(blocknr != 0);

Since JBD2_ABORT was cleared in jbd2_journal_load earlier, we enter 
jbd2_journal_get_log_tail, which will set *blocknr = journal->j_head 
(which is NULL) and then trigger the assertion, causing a panic.

I confirmed that setting the JBD2_ABORT flag in journal_reset before 
returning -EINVAL fixes the problem:

         static int journal_reset(journal_t *journal)
                         journal_fail_superblock(journal);
         +               journal->j_flags |= JBD2_ABORT;
                         return -EINVAL;

You can find a proper patch file + the syzbot re-test result in [1]. 
However, I'm not entirely sure whether this is the correct decision, and 
I wanted to confirm that this is an appropriate solution before sending 
a proper patch to the mailing list.

Thanks in advance,
Vinicius

[1] https://syzkaller.appspot.com/bug?extid=8512f3dbd96253ffbe27

