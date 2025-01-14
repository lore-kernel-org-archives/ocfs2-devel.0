Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7E1233522
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 06:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736835930; cv=none; b=Pao5qbioLmS/HABJnhCorcDd5YaOjEOEMUH3Q8Dq5p9X8hhfvX8FICQn0YEn+8EWuXFVepTO0s1QrGiDCqinBMiHYuBLFYr+Sqnbg7XXkdfGrSgXtQUEVHRCUgsIkSN0R7kr6TUd3dn2GsCpwIprjNpTqmNvsCCiWZO4pirgc7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736835930; c=relaxed/simple;
	bh=YHTZsofczZciM2ldx8u0jApBGwSPKeL/VawoG+8D4Pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BaT/ANVP7KzCqqLqd1d0kepWZR0kIXplA7ztKOVlCCrgRANJpStPF0mn5HqiTsrfXxH4G/V89Gb2AUWxOtCrhEeu7vuyig265ZvBPv+nagk/ABx7ak0Rk4IEBPiVtbtQFXhFQiaHbGgenf1tYYCMvoFQoofnL1a6YxGxz/+vjkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EFu4yd6S; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EFu4yd6S"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d9f842f237so67649a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 13 Jan 2025 22:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736835926; x=1737440726; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WG68zHpgXN0JEeAnT6d8e+4V4GunA7gzOhdUvu4l6bU=;
        b=EFu4yd6SA3F5BkkMFE2WbLEpJyIl3CK30MHwIjuPpmnXojDVWNrAThGwK8NgS8Jjje
         tQ9S5B2oXMgg2difKMAMblvuRkYcSWYX1SSvVdp9kBNYlS+ZM1Y9TmRto4I1gaFtfd7P
         ytTszpNZxOkocYssdx3o/JD/9YFsrPMr9CgZcboT5Lpn43Biwdvs2U/T0kY88V2iUE25
         DHScvGi3zwtHM2qXg50Fe7MZuzOJbcrsBJC/hF6cCYBbLa9PxJz8rVSntd0T1qiKr7+j
         NShJjHGHkUKLhT6hF5gdBoISdeYEqIv8yiEYqhV/YwPgxQJ6dxulMNvcVJwxM48xJEJ/
         ZJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736835926; x=1737440726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WG68zHpgXN0JEeAnT6d8e+4V4GunA7gzOhdUvu4l6bU=;
        b=aWNxPMPsHNBFwtSjo3TV2lhlpbwLXbU7eCFPc2iclOTrw9SoRxOdZHI5fVXcNyKz7P
         CQH05JkJtOD26FWcThJbDpgJku0nY6chLnmo4dWbyKZZSA1AObQvTOTan0l53rz0lvPK
         iyyvbn/cnD068i77GlCdQ/OVCfq7NLXzpCQmd6s42EQS0kr5YBLog8YwArCe4lqYnO1F
         E1vgHYHvBAduHfSu8vW9RtNeIgLBtvS0C1xJfk+u22AeqZKkOQUlCDqDe93kGCFpDPAq
         kV49ISGUOHhE0M9Q5MzfL6y3rRlO4ia88EwSBR2t8D6eCtqSDbTZ6uSor2B5mYTW9OUY
         pfsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWojNLKYWIma+76GG1w2bX3+665TJ5rqNE7FteQNkg7Oth7RkDi1EVJMm5Tgo2iW1FG0e3n6Uv0bYtLJg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxBGF/kFKVDoxIre4BEHGhyAbUW7lXotn9fcn8wVJOWqF4qa4DW
	CMzg56WZmVOJ/WW5Xtq0s1jbxzukt1BIIg0IeTbS9cBv7ENC/lToNJv3cQt172I=
X-Gm-Gg: ASbGncu4/gEr3Bj6/se0g3MWTf1JzDc31PZlvO2S6lvq4guRGElVUI7SX4IU8rmmkjE
	PFYVIwTi4HZNksm/uHNRRuKy+wkE/B2FU07LaDd+f/tgDGrPkdgOSGahN5P/HqaA1A9HMfZX/Tv
	rdMbiu37k3YZjmerzMXMLkd7vLssFksstAL2kcjNjCyat+wNOEhwHlsyB0VWUkkaF3u0PjdW+Vh
	YcG8N7ri/k2E1QWQoMdlnLyN5WN5HuVFjEeUS28KJgnXww2T02iRCZlEAeK
X-Google-Smtp-Source: AGHT+IGmy8xIOYJXQcPObq4m2Cx6vmu6xHGtv84+U2bEN4z54Im+X4nF9QMlaXFY1yA4XzhFd18Shw==
X-Received: by 2002:a17:907:7203:b0:aab:fcbb:da37 with SMTP id a640c23a62f3a-ab2ab6cbb84mr866865466b.11.1736835926558;
        Mon, 13 Jan 2025 22:25:26 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df62sm62491835ad.21.2025.01.13.22.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 22:25:25 -0800 (PST)
Message-ID: <24f378c8-7a27-47b8-bd79-dba4a2e92f6d@suse.com>
Date: Tue, 14 Jan 2025 14:25:21 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in jbd2_journal_update_sb_log_tail
To: Jan Kara <jack@suse.cz>, Liebes Wang <wanghaichi0403@gmail.com>
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller@googlegroups.com,
 Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
References: <CADCV8sq0E9_tmBbedYdUJyD4=yyjSngp2ZGVR2VfZfD0Q1nUFQ@mail.gmail.com>
 <mzypseklhk6colsb5fh42ya74x43z5mmkzdjdyluesx6hb744a@hycbebanf7mv>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <mzypseklhk6colsb5fh42ya74x43z5mmkzdjdyluesx6hb744a@hycbebanf7mv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jan,

On 1/6/25 23:14, Jan Kara wrote:
> On Tue 31-12-24 13:53:23, Liebes Wang wrote:
>> Dear Linux maintainers and reviewers:
>>
>> We are reporting a Linux kernel bug titled **WARNING in
>> jbd2_journal_update_sb_log_tail**, discovered using a modified version of
>> Syzkaller.
> 
> Very likely this is actually some issue with ocfs2 since the only thing the
> reproducer seems to be doing is that it is mounting ocfs2 image. Joseph,
> can you have a look please?
> 
> 								Honza

The root cause appears to be that the jbd2 bypass recovery logic
is incorrect.

 From the console log [1]:
  [   70.568684][ T5316] JBD2: Ignoring recovery information on journal

The above output indicates that ocfs2 is calling jbd2_journal_wipe()
to clean up jbd2. (IIUC), Therefore, the subsequent jbd2 initialization
flow should not perform any recovery tasks.

However, in this crash issue, after calling jbd2_journal_wipe(),
jbd2_journal_load() still attempts to perform a recovery, which triggers
a WARN_ON().

On the other hand, the jbd2 code logic is correct, ocfs2 should call
ocfs2_journal_wipe() with the parameter 'write=1' to address this issue.

code flow:
ocfs2_mount_volume
  ocfs2_check_volume
  + ocfs2_journal_init => jbd2_journal_init_inode
  + ocfs2_journal_wipe => jbd2_journal_wipe (input write is 0)
  + ocfs2_journal_load => jbd2_journal_load => do recovery job => WARN_ON()

[1]: 2024/01/12 06:56 log
https://syzkaller.appspot.com/text?tag=CrashLog&x=106f2bc4580000

Thanks,
Heming

> 
>> Linux version: v6.12-rc6:59b723cd2adbac2a34fc8e12c74ae26ae45bf230 (crash is
>> also reproduced in the latest kernel version)
>> The test case and kernel config is in attach.
>>
>> The warning report is (The full report is attached):
>>
>> WARNING: CPU: 0 PID: 6139 at fs/jbd2/journal.c:1887
>> jbd2_journal_update_sb_log_tail+0x32d/0x3b0 fs/jbd2/journal.c:1887
>> Modules linked in:
>> CPU: 0 UID: 0 PID: 6139 Comm: syz.7.135 Not tainted 6.12.0-rc6 #1
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>> 1.13.0-1ubuntu1.1 04/01/2014
>> RIP: 0010:jbd2_journal_update_sb_log_tail+0x32d/0x3b0 fs/jbd2/journal.c:1887
>> Code: fe ff ff e8 05 0e a7 ff e9 f4 fd ff ff e8 eb 0e a7 ff e9 16 ff ff ff
>> 4c 89 ef e8 de 0e a7 ff e9 d5 fe ff ff e8 94 ec 54 ff 90 <0f> 0b 90 eb 88
>> 41 bc fb ff ff ff e9 13 ff ff ff e8 7e ec 54 ff be
>> RSP: 0018:ff1100013b6ff818 EFLAGS: 00010246
>> RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffa00000034b3000
>> RDX: 0000000000040000 RSI: ffffffff81fd15ec RDI: 0000000000000005
>> RBP: ff110001405ce000 R08: 0000000000000001 R09: ffe21c00276dfef5
>> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>> R13: ff11000107e3a018 R14: ff11000107e3a000 R15: ff110001405ce0b0
>> FS:  00007ff345cd5700(0000) GS:ff110004ca800000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007ff3470375c0 CR3: 0000000117544001 CR4: 0000000000771ef0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> PKRU: 80000000
>> Call Trace:
>>   <TASK>
>>   journal_reset fs/jbd2/journal.c:1779 [inline]
>>   jbd2_journal_load fs/jbd2/journal.c:2109 [inline]
>>   jbd2_journal_load+0x93e/0xcf0 fs/jbd2/journal.c:2074
>>   ocfs2_journal_load+0xbe/0x5e0 fs/ocfs2/journal.c:1143
>>   ocfs2_check_volume fs/ocfs2/super.c:2421 [inline]
>>   ocfs2_mount_volume fs/ocfs2/super.c:1817 [inline]
>>   ocfs2_fill_super+0x19f1/0x4170 fs/ocfs2/super.c:1084
>>   mount_bdev+0x1e6/0x2d0 fs/super.c:1693
>>   legacy_get_tree+0x107/0x220 fs/fs_context.c:662
>>   vfs_get_tree+0x94/0x380 fs/super.c:1814
>>   do_new_mount fs/namespace.c:3507 [inline]
>>   path_mount+0x6b2/0x1eb0 fs/namespace.c:3834
>>   do_mount fs/namespace.c:3847 [inline]
>>   __do_sys_mount fs/namespace.c:4057 [inline]
>>   __se_sys_mount fs/namespace.c:4034 [inline]
>>   __x64_sys_mount+0x283/0x300 fs/namespace.c:4034
>>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>>   do_syscall_64+0xc1/0x1d0 arch/x86/entry/common.c:83
>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f

