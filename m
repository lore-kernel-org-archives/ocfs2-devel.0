Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7F522E3F7
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 Jan 2025 05:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736917233; cv=none; b=EZSBL2EwhwXPCCVWlaHKk17eqzzq3uTTt49NzDynzZumTET28tT54rTe49FT5Uz2dBtfZd+3vfKB5xkgpSR+Mhce7NVX5mUfa78adADisPfusvgE75V2DRRDwkEd+/ssxNBLYEltsTvChCHEFz8Dg7AmllwHt5WmMoD2FDgZsCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736917233; c=relaxed/simple;
	bh=cIJFpZ2hrk7DGupK9ItVZj3+AgxWS9w13/A0QFIO8OE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n7wsPrZKn3UCPe/fDtgcJfLnwtZ3Us4/SFFS7W8D90b6a+pc/Gr0tI7rgwafy8X99ZUZHq0vD07VttTyIMcFt/izQhfOAXLKpMuESRIU3Mko72sUElO/U661FL9K4SMu2jtHD95Ut1L/1doEN2+7Y2hB1GjujD5XDcZZo3Yq9II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NXytp1UA; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NXytp1UA"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d3c1f68f1bso940705a12.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 21:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736917229; x=1737522029; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XJMW9rnub/plt9wklWDGLR+ue2+UySWkbfATgGqVPsw=;
        b=NXytp1UA/feQIl9+sEypmAZPbuqK9asrGB3k6oXbznK2yshLC8nf5Cqo2AXo0GpL4A
         R7zRmPkPJS9lWjRdviPlxRxaZ6Xl2JY72E4WLg69Bcx1DhxjKYaum5sHSjEnlya31+el
         1eeh5iZN3gmIUEXOukcWad79kJqJLcsBbbk+tVFZ2LF92h53BVi1ENMPFVolkMq4OmEA
         w7v3c3PKAeGURxiUz2CxIkVs4KD7ibI331NRnEv1VK7QLi/UPCqtiMiERn/GOAYQsQ2c
         ZcNlhYmYOTJEgVPOT9LODsi3b3DZSiO/7MA1ulrRTzlDgeR6azcxFtC0bRt92SRCouBK
         BWmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736917229; x=1737522029;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XJMW9rnub/plt9wklWDGLR+ue2+UySWkbfATgGqVPsw=;
        b=CK8//jEgJXtDUKsDgk7UrnAAuFhJli6hlQzl5zYexrqk8jCe1qWe97O9BxWqIU6DS0
         ohb0F1y310u7CpsunGP+OR4lpn+h9UhN1jLhkelIzh/Hnp0WFsuJgQdjC1cTnzOdqo9p
         9PYNuBDDdrJlP36bzicWT2XaAV6tYJbquolamaXj4xBdmyczm1DO8/fSHrHNrGGT4VXf
         w8s+hNNkeQTxUWhz+J9Nqsi5+oMbAUqcwHAajOdedNRL+z0Cfq62xqfXiy6ZbAL5XGk1
         bCMBWmtAgjZFRgy3P0YL96SKVHw7mTQyzSVMslyieIFhnSM60KK+M5/4IIOEM0Bu4c8x
         2tIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPj+4vR8K7tL3jqNN1goMkFnghPP2OwuKC3d7rhZTDvoG/PtTmERfgnYCXhCcrQ47P6F3zkIfPGPh33w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzB+UC2XznYpGvVPX8n5j8J5HWdqE+myELQwdzgY7T8anUzdJG4
	dk7xkG8FGteMwQ5Y4RoIKvqti363rZ//WJqj8nuuTaq9eObZz3wdO26feCHZcG4=
X-Gm-Gg: ASbGncux+3w9dbr2vk2Wx62LsTS2EKIwMnHNmD8Sf1FZIILOTMaapuz0sxagkKqpnh5
	GU2BHJpRYBxx9GFz8t1yn1mj17ppGJD5c14lUF8FjbkTIQkC/w2xHXVugQoZpyH46cYnft65M8E
	5MLh7HK2hDyAj5mPlDIVB3XcgraDFHrPz3IiL74/CdXedHx3BoHfWMfkNwTFBDzfap8ALrUBBd3
	+gqy6nr+S9Ze2gqc+DSYcaQPr/9GaiR/RJB4LAUUhlNFFbJvf6GI9kLyDvm
X-Google-Smtp-Source: AGHT+IGNe+b4wa4MisZ5kr1URc23Ns5uB8BbpHRkS9J8ACHpwmz0gD/aOPF9gHMOwDMMIS/6+ztEGA==
X-Received: by 2002:a05:6402:2743:b0:5d2:d72a:7803 with SMTP id 4fb4d7f45d1cf-5d972e06b12mr8320833a12.4.1736917229376;
        Tue, 14 Jan 2025 21:00:29 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a31ddb9e4b4sm8964243a12.70.2025.01.14.21.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 21:00:28 -0800 (PST)
Message-ID: <db4da8db-d501-4181-994b-c25845908161@suse.com>
Date: Wed, 15 Jan 2025 13:00:23 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in jbd2_journal_update_sb_log_tail
To: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, li.kai4@h3c.com
Cc: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller@googlegroups.com, Joseph Qi <joseph.qi@linux.alibaba.com>,
 ocfs2-devel@lists.linux.dev, Liebes Wang <wanghaichi0403@gmail.com>,
 syzbot <syzbot+96ee12698391289383dd@syzkaller.appspotmail.com>
References: <CADCV8sq0E9_tmBbedYdUJyD4=yyjSngp2ZGVR2VfZfD0Q1nUFQ@mail.gmail.com>
 <mzypseklhk6colsb5fh42ya74x43z5mmkzdjdyluesx6hb744a@hycbebanf7mv>
 <24f378c8-7a27-47b8-bd79-dba4a2e92f6d@suse.com>
 <20250114133815.GA1997324@mit.edu>
 <3655551d-b881-4f2b-8419-03efe4d3aca7@suse.com>
 <CADCV8srwww_--oOvi1sdS4JfUafidPOPr0srG1bWO66py2WTtQ@mail.gmail.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <CADCV8srwww_--oOvi1sdS4JfUafidPOPr0srG1bWO66py2WTtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello Jan,

On 1/15/25 09:32, Liebes Wang wrote:
> The bisection log shows the first cause commit is a09decff5c32060639a685581c380f51b14e1fc2:
> a09decff5c32 jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal
> 
> The full bisection log is attached. Hope this helps.

This bisearch commit a09decff5c32 appears to be the root cause
of this issue. It fixed one issue but introduced another.

Syzbot tested the patch with calling jbd2_journal_wipe() with 'write=1'.
The Syzbot test result [1] shows that the same WARN_ON() is triggered
in a subsequent routine – the classic whack-a-mole!

Back to commit a09decff5c32, it opened a door to allow jbd2 to update
sb regardless of whether the value of sb items are correct.

To fix a09decff5c32, it seems that jbd2 needs to add more sanity check
codes in a sub-routine of jbd2_journal_load().

btw, in my view, this is a jbd2 issue not ocfs2/ext4 issue.

[1]: https://lore.kernel.org/ocfs2-devel/04a9ad29-51de-4b50-a5bb-56f91817639d@suse.com/T/#m86d01f83d808868bb5e6548d30f79b4f9f889b13

-- Heming

> 
> Heming Zhao <heming.zhao@suse.com <mailto:heming.zhao@suse.com>> 于2025年1月14日周二 22:51写道：
> 
>     Hi Ted,
> 
>     On 1/14/25 21:38, Theodore Ts'o wrote:
>      > On Tue, Jan 14, 2025 at 02:25:21PM +0800, Heming Zhao wrote:
>      >>
>      >> The root cause appears to be that the jbd2 bypass recovery logic
>      >> is incorrect.
>      >
>      > Heming, thanks for taking a look.
>      >
>      > I'm not convinced the root cause is what you've stated.  When
>      > jbd2_journal_wipe() calls jbd2_mark_journal_empty(), s_start gets set
>      > to zero:
> 
>     Actually, ocfs2 calls jbd2_journal_wipe() with 'write=0' (hard coded),
>     so jbd2_mark_journal_empty() isn't called during the ocfs2 mount
>     phase. This means the following deduction won't apply in this case.
> 
>     -- Heming
> 
>      >
>      >       sb->s_start    = cpu_to_be32(0);
>      >
>      > This then gets checked in jbd2_journal_recovery:
>      >
>      >       if (!sb->s_start) {
>      >               jbd2_debug(1, "No recovery required, last transaction %d, head block %u\n",
>      >                         be32_to_cpu(sb->s_sequence), be32_to_cpu(sb->s_head));
>      >               journal->j_transaction_sequence = be32_to_cpu(sb->s_sequence) + 1;
>      >               journal->j_head = be32_to_cpu(sb->s_head);
>      >               return 0;
>      >       }
>      >
>      > I suspect that there is something else wrong with jbd2's superblock,
>      > since this normally works in the absence of malicious fs image
>      > fuzzing, such that when jbd2_journal_load() calls reset_journal()
>      > after jbd2_journal_recover() correctly bypasses recovery, the WARN_ON
>      > gets triggered.
>      >
>      > I'd suggest that you enable jbd2 debugging so we can see all of the
>      > jbd2_debug() message to understand what might be going on.
>      >
>      > By the way, given that this is only a WARN_ON, and it involves
>      > malicious image fuzzing, this is probably a valid jbd2 bug, but it's
>      > not actually a security bug.  Sure, someone silly enough to pick up a
>      > maliciously corrupted USB thumb drive dropped in a parking lot and
>      > insert it into their desktop, and the distribution is silly enoough to
>      > allow automount, the worse that can happen is that the system to
>      > reboot if the system is configured to panic on a WARNING.  So feel
>      > free to prioritize your investigation appropriately.  :-)
>      >
>      > Cheers,
>      >
>      >                                               - Ted
> 

