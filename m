Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CFC4206B
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 Jan 2025 02:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736908849; cv=none; b=YLdgAAHafbQv+rP2Rn22Sjt+cffnDdwvbZ8pIBqt1Ry8XCEWgVscvO9rHIn2cho53IVNlGPi3rnIGwivqnU8Dar0y0jqXi7+VZziQ9vaJRJC4EBRa2ujY0wUk/zeF1xdscsIMvfHYA5eeOAqN939HGIkjdBs5Cy8wJs7C+uTxmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736908849; c=relaxed/simple;
	bh=Ma5ClEhziFIERdQC2RQz02vBvY+kK7F+9UEShFeYWEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=RWpSDqwVgRrSv6iBxN41B/6yrt29p9qmjeigrN2+FWw+v6drrP9tCECBUhTtm8DPfG/JZE1cg/8QBalVctZVBsCtDhhACtewpcqJb/P3vS1tCgnH4ttQarJCPT9fQobHnf4jAvAMyMcxAqSOWNt8DVM8sy4fpbxVffREOd35hEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gAqwKkwf; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gAqwKkwf"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa676e4f36cso80504866b.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 18:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736908845; x=1737513645; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ldI9VoHECn6feQFNybcLc5Ry2ofk9vm9WQ4lEJNAAsU=;
        b=gAqwKkwfKHBSKgfj93QuJTE9E8qMKGjZsgiR4kp8EF0iKbvxrVU5PctWqpFX8xKSla
         ml/II/dtdjcGZ2AhV75H9bcOGN7ZugxtpRjQy6WznujfYK5MP2D72+Lyl9AXRhh0nhHu
         bJ4I51mTp+2Vd+eJV4qdmT0k650xYFCWfxGmNawi+w+O/L9fZ5uccEsk5b/1WEixNnrJ
         v2dto0c0A+Kv1O8vIQ/Tq26tYsnGgscLx6XERVYIVs5akOmSURBwUycf5WHcuNpmtOh5
         RCfgCoBWvlhwQ5g+9tBNRngSJOlnUKMF/43OhTIFOBPWp33twN/XsJktqFiQlJMCmlvm
         UYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736908845; x=1737513645;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldI9VoHECn6feQFNybcLc5Ry2ofk9vm9WQ4lEJNAAsU=;
        b=ihdcNiDrX/cb/LUPbZXtArSZ3KM4x95xNLhJWZWhFosINkTJxBHwgAQL0GTVL+RbWy
         97Tz7wGkSjMlarS69SxLI4ak0UzkpiH5EspGkSscXJKO2L4L8vlsMx2KoD21TuBzk+e/
         UPevV//IiN59hElm5v3i2EZJrHVSh4kwEFmCG/oEgEAPBlOesPwSR81xM2wiTOnGYzsR
         SwPSs19S2xWZ/kQLPO16QIZvBSTBKuUQNXS8GR8Qh742ii/JWNvDWkkfCKxEscr9wnUw
         YI1cFZqxDgNshARdYdpM9E1fRe7jRX9+Ai77U3PJVWYV4bUxxRhKWgXKZUAmgZ/BaWJj
         ChlA==
X-Gm-Message-State: AOJu0YyXtLb9ZRQcgslbAmIU/VwkxxZ5hDMTz9EIZfGnouozzj+UDoF7
	uqrnApvO5FNk1MmaLRL65/M5AJFT84C0DBUXk6tYteTKLSMXWQjKXtqiZ0gFsEQ=
X-Gm-Gg: ASbGncsXQMSvhc5cddMEU89yRN7wGYNO4a7NM+G/vrIotc0y3lIFrPGiaymWU8QOjfE
	83Hf7V2hs35m2ETGe/M5cCd6bvSSaNHB5awvpteYhbWhqkMWl77D/cG86oiO2BsqQ4YoMB9GeTp
	iS8zXzzR6D48VXdb4FcngXiMVbyERSpUCNwdK9+wvM8FHa2thlfn6U419xUCVFK8ixe+C6+yCZ3
	zojXFQVNScELN/0POCBoCRkhgq+RVfEV0M9Zu9tyKr4sNEYhRjtQgPAriTG
X-Google-Smtp-Source: AGHT+IEt/Tg4J7RkdivI66l4wDYzyQBR0enMQJBZ18I0rQYU6R89Iq0IYXCAs7hsHVN3AgmC1c0Oyw==
X-Received: by 2002:a17:907:72c7:b0:aa6:6e2e:b7b with SMTP id a640c23a62f3a-ab2ab178953mr841703666b.1.1736908845374;
        Tue, 14 Jan 2025 18:40:45 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f25cd50sm73857845ad.250.2025.01.14.18.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 18:40:44 -0800 (PST)
Message-ID: <63e6ff86-5573-40cc-b7f3-0ffcf070ba7c@suse.com>
Date: Wed, 15 Jan 2025 10:40:42 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [ocfs2?] [ext4?] WARNING in
 jbd2_journal_update_sb_log_tail
To: syzbot <syzbot+96ee12698391289383dd@syzkaller.appspotmail.com>
References: <67870eac.050a0220.296bc1.0002.GAE@google.com>
Content-Language: en-US
Cc: ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <67870eac.050a0220.296bc1.0002.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/25 09:26, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in jbd2_journal_update_sb_log_tail
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6052 at fs/jbd2/journal.c:1882 jbd2_journal_update_sb_log_tail+0x2ba/0x360 fs/jbd2/journal.c:1882
> Modules linked in:
> CPU: 0 UID: 0 PID: 6052 Comm: jbd2/loop0-29 Not tainted 6.13.0-rc7-syzkaller-00041-g7f5b6a8ec18e-dirty #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> RIP: 0010:jbd2_journal_update_sb_log_tail+0x2ba/0x360 fs/jbd2/journal.c:1882
> Code: 30 ff 41 80 3c 2c 00 74 08 4c 89 ff e8 df 48 94 ff 41 80 27 f7 4c 89 f7 e8 83 10 4a 09 31 ed e9 72 fe ff ff e8 57 6a 30 ff 90 <0f> 0b 90 41 80 3c 2c 00 75 d5 eb db 44 89 f1 80 e1 07 80 c1 03 38
> RSP: 0018:ffffc900037577f0 EFLAGS: 00010293
> RAX: ffffffff826f07c9 RBX: 0000000000000000 RCX: ffff88801c7c0000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: dffffc0000000000 R08: ffffffff826f0799 R09: fffff520006eaeec
> R10: dffffc0000000000 R11: fffff520006eaeec R12: 1ffff110060f7000
> R13: ffff88802b13001c R14: ffff8880307b80b0 R15: ffff8880307b8000
> FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555563a325c8 CR3: 0000000031c10000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   jbd2_journal_commit_transaction+0x46a/0x6560 fs/jbd2/commit.c:397
>   kjournald2+0x41c/0x7b0 fs/jbd2/journal.c:201
>   kthread+0x2f0/0x390 kernel/kthread.c:389
>   ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>   </TASK>
> 
> 
> Tested on:
> 
> commit:         7f5b6a8e Merge tag 'pci-v6.13-fixes-3' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=169e07c4580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=954e5731cdb4e750
> dashboard link: https://syzkaller.appspot.com/bug?extid=96ee12698391289383dd
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=155681f8580000
> 


Revert commit "a09decff5c32 jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal"

This commit seems like the classic whack-a-mole.
Fixed an issue and introduced another issue.

#syz test

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 7e49d912b091..f8c7917efad2 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2092,11 +2092,6 @@ int jbd2_journal_load(journal_t *journal)
                 journal->j_devname);
          return -EFSCORRUPTED;
      }
-    /*
-     * clear JBD2_ABORT flag initialized in journal_init_common
-     * here to update log tail information with the newest seq.
-     */
-    journal->j_flags &= ~JBD2_ABORT;
  
      /* OK, we've finished with the dynamic journal bits:
       * reinitialise the dynamic contents of the superblock in memory
@@ -2107,6 +2102,7 @@ int jbd2_journal_load(journal_t *journal)
          return err;
      }
  
+    journal->j_flags &= ~JBD2_ABORT;
      journal->j_flags |= JBD2_LOADED;
      return 0;
  }
