Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF7B155359
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 14:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736866279; cv=none; b=Lr0S1i6k3EXNcQTqlp0qm/6Ch77jgfE1oK+cbtfo8LGByopWOWhfNblPmCG8JiDo3aM2snH8C/3LFzRRH9SckY6TpmFzZYsnoMZL49/BGHWXY5xk6uU+6/rH37T+olQsI/FkKziFlJvPfrpwU4KG8ceK0xkgyDH/lQwBt3lK+p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736866279; c=relaxed/simple;
	bh=OnivAETXnsBl7mXrjeIuhqyy2UMVgs8PMFytRZ0/6SI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pJwARyUtWBelLqdsY8YqMgaFVlb+cSUwo2/pZwvpUIctDuBieMWbr+sLlysHLD0xtIi8JvMCHiC7fv0CIYUHfFs7Sfm8MLy5vP7jp7AUa1sjophdta89SpSm2X8Qs1qp4V5vGmiubNmsTxgTiDS6iOoos6oWKyJ5xDIa6YwFMbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fpQr5Qjk; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fpQr5Qjk"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa69599b4b0so94800066b.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 06:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736866276; x=1737471076; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pGaLjip8ws2aBkJc+HkZKzrNkaPfpsakY2s6/rWCOro=;
        b=fpQr5QjkjLVsDnrLuGGLoQs3NmwC9owU9PQURILzN5WijovFk+zap3qngzUo9Loaz+
         3UJbioEj4kbwU6nLN5+UVm0FYqCtRduKZItASqJ+BWGGu+16+KAOqP33HIrm2go/1llR
         NVdm9l8pYzMDHRMPLKaQ6d9tDs5t8jfPFWGclb55lNJGu4deGRSZ+OIcopBgrJVuoT8s
         gMgxr5ANaEeT7o+IqQUMvU8z/6tf/ApHIIyutQcTSvfOChgzn1e18Uy4FErByuCjOj6r
         ljoTRwwT29kkJD2V4CvOP67mt22HePgVpwZJz/9qxq9KdyIY3VA9QiaN38yyNQsd0pem
         WQ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736866276; x=1737471076;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pGaLjip8ws2aBkJc+HkZKzrNkaPfpsakY2s6/rWCOro=;
        b=tNG0bjpEWYhbo8Bcu5JbOLAXbGGSQ5z67EFS2ZJ3tFB5rbziPYPnlmomhatJLs+ywl
         CoYL5naDIjKb2/GvjqEuVwTqwLTdtnybaHbK6nejM/kWopLXD6d4/UiaNpCRhRayx7+T
         GRLY0D/UJMOPb5KcZXtwtEk8FxElTqX18hPBQdxjo3f9xkT7U7grp3xhYp9fJYFaLA1a
         Xms5QkStY70Uhd8VYmShBgYsal2trw/HrvrRGK3flWBBL1KmXrD0R4GBGuqjP19xcf3H
         8e7vzmYj+APd5OnFSm+0du/b7Djg9DcQnPkiW3L82Z4If8oghVKFFE3Jx8mjFEboRK6a
         ajnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUC8W2z2lsmTZqSlXYvhSgiM6BL+6UURjcreAbs1WZAS3ImNla6Q5kVL1fk2ereapn56zmuUnkGOV3Mtw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyA5ldLrduIrVeowtFXrYIDQagbI4YC9DgzwislyZXjtF/pbRPU
	cpYQ7mKYkNF/8HUDNhmfE1u/KHQRXVjsC3KfmhUR7wn9Bs03R3AYCYmQWjdl+P4=
X-Gm-Gg: ASbGncsbKUYYHkxlKnCGxRbb8Xb4TF+vuDlZQwZc684y3xnGahiFkXHqezVUsRfe2hF
	TiSsimHhkN6gu+iAhdEaMpEJjoU+bMsbatHYjaHwsxndrmu0eRbVB1fxA15dM9zza9Zm4IpR0mf
	Df9fzE9F4JqAE67boqzcE0geReeyGkIfsL+6gRJBwzNxmbWbf7z6YBSe5V/Ic5jTLehLo1iJEM4
	vxVB+RRyL//WvVxSwEGeagtS+mKq33suA7Mt2WUY/ZNXIYRgGpKeg0Vwuhpn4c=
X-Google-Smtp-Source: AGHT+IEekbyRZetOC3fp4MjYg219+9eB5QuJKqBG/xAtl77M4ni+Kg/FKCcbgOEGbgD4MYoZu3NqAQ==
X-Received: by 2002:a17:907:d0f:b0:aae:83c7:fd4e with SMTP id a640c23a62f3a-ab2abc95fcbmr744650666b.13.1736866275808;
        Tue, 14 Jan 2025 06:51:15 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d40692172sm7496304b3a.154.2025.01.14.06.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:51:15 -0800 (PST)
Message-ID: <3655551d-b881-4f2b-8419-03efe4d3aca7@suse.com>
Date: Tue, 14 Jan 2025 22:51:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in jbd2_journal_update_sb_log_tail
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Liebes Wang <wanghaichi0403@gmail.com>,
 jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller@googlegroups.com, Joseph Qi <joseph.qi@linux.alibaba.com>,
 ocfs2-devel@lists.linux.dev
References: <CADCV8sq0E9_tmBbedYdUJyD4=yyjSngp2ZGVR2VfZfD0Q1nUFQ@mail.gmail.com>
 <mzypseklhk6colsb5fh42ya74x43z5mmkzdjdyluesx6hb744a@hycbebanf7mv>
 <24f378c8-7a27-47b8-bd79-dba4a2e92f6d@suse.com>
 <20250114133815.GA1997324@mit.edu>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20250114133815.GA1997324@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ted,

On 1/14/25 21:38, Theodore Ts'o wrote:
> On Tue, Jan 14, 2025 at 02:25:21PM +0800, Heming Zhao wrote:
>>
>> The root cause appears to be that the jbd2 bypass recovery logic
>> is incorrect.
> 
> Heming, thanks for taking a look.
> 
> I'm not convinced the root cause is what you've stated.  When
> jbd2_journal_wipe() calls jbd2_mark_journal_empty(), s_start gets set
> to zero:

Actually, ocfs2 calls jbd2_journal_wipe() with 'write=0' (hard coded),
so jbd2_mark_journal_empty() isn't called during the ocfs2 mount
phase. This means the following deduction won't apply in this case.

-- Heming

> 
> 	sb->s_start    = cpu_to_be32(0);
> 
> This then gets checked in jbd2_journal_recovery:
> 
> 	if (!sb->s_start) {
> 		jbd2_debug(1, "No recovery required, last transaction %d, head block %u\n",
> 			  be32_to_cpu(sb->s_sequence), be32_to_cpu(sb->s_head));
> 		journal->j_transaction_sequence = be32_to_cpu(sb->s_sequence) + 1;
> 		journal->j_head = be32_to_cpu(sb->s_head);
> 		return 0;
> 	}
> 
> I suspect that there is something else wrong with jbd2's superblock,
> since this normally works in the absence of malicious fs image
> fuzzing, such that when jbd2_journal_load() calls reset_journal()
> after jbd2_journal_recover() correctly bypasses recovery, the WARN_ON
> gets triggered.
> 
> I'd suggest that you enable jbd2 debugging so we can see all of the
> jbd2_debug() message to understand what might be going on.
> 
> By the way, given that this is only a WARN_ON, and it involves
> malicious image fuzzing, this is probably a valid jbd2 bug, but it's
> not actually a security bug.  Sure, someone silly enough to pick up a
> maliciously corrupted USB thumb drive dropped in a parking lot and
> insert it into their desktop, and the distribution is silly enoough to
> allow automount, the worse that can happen is that the system to
> reboot if the system is configured to panic on a WARNING.  So feel
> free to prioritize your investigation appropriately.  :-)
> 
> Cheers,
> 
> 						- Ted

