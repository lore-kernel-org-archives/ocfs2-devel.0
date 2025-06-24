Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DDC7B3E1
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Jun 2025 01:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750728794; cv=none; b=Rr7gIVGoJs0tTz0JoolMQClz6riQhSsqguvJwtPsO4DwQd3ORZ6eSIUFvLUme6ySVrZicCPDjJ9hUzi/jACJIDhZjdSsASHRUctS/wEcnaBZxOVmJ7AToJsG+q12fWjUpfmAizDA9aupPuJxZaykwGI9V8nLrX8dgai75qrshTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750728794; c=relaxed/simple;
	bh=6p+408MQpHytDrmhkcz+mmecWcdbhzehShay90+zkUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LV5CYrILtn766LFRfVYZMviVWIr/RfDNVY1Y408v7FPHN3LAUvN/7RnNpxssE1PsHQXBfUA5Rixcjjb1a85GmLwVoxY14tUkt9s1WfRahInx11PE73niPnZWKv97hZvMgKyZSeS952mGXavpG73ODd1DAgUCvPOXsd9JAvTlWCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R9nQRpEu; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R9nQRpEu"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a4e57d018cso696757f8f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Jun 2025 18:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1750728791; x=1751333591; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xHCKLmpVjEQudH3qzY65MufqOC1HcXRqB++GHgObSkA=;
        b=R9nQRpEuMoggdurgTrVfAP3lP0rTgFUMkYrMpJBxGlozndvo7ggGX0SGtEqUeIsdwh
         Pk0ia7LXX8855IQ8NKTonQ3v541Oizdno5ekNRK8lEGuVusdG7yeEzeBxgz2ZgQPVbEe
         4DYdYFHSUNiYwaKdXgwJIEoST5Z2L2gzoQroL/w0Q7xfaxJoinzuyKr1iogztEiE8klf
         bPjA6vO7ZPygTJnZ6FnvTcSSY5qPpawjl9q01WU9fHNZ9IQMZ2qyP9Qvqz4OQ3K2gxVs
         73D+Xissklotkl5gDURkuX9ZS/joZzuLQacGdy8m6P8nxhn8TJhDJ8dN6GM4onjCnbmf
         nY/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750728791; x=1751333591;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xHCKLmpVjEQudH3qzY65MufqOC1HcXRqB++GHgObSkA=;
        b=rLmcH4EU4b5zOt1z58nkze1KMRfJjCZDFECZ8EXF1qqLnkP/QA8C2tm4Q/czv6DEST
         w+L5sTKEH3aMt+gau3P6/FREQP/Jr6KBQs1gIXb9cA2n9WEx/TGgbtI4do7zcO5Fv6Vd
         oKzbJna6RIDeGwOlGY04cGKv2XK/ObtoitHMFdAp8HIbxokbr+bxOdviZZ8SkFmHomXJ
         XyPIkwTo6VcfpxfR9o9EoW/7nf71Frgd2Fjfi6wYKEi8mwgcWdd1GiwKuUijh/OGvIzA
         df8DLbrjRSHkayoNUdBvlSRILc4nlPTfqRPlEnLA3vFhsr2j34OXOXdTdw0DvIgF5wi1
         o6WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu0KvxJJwMd2h2gpRbMXc8n1dcCKDktegdLoX0O0166AJNFLcqjh16uZiZYsLsRN3MdgEPv2LKn1LgWQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxl2rZbS0qYF04qYcHf0tSyCwHdlmEwvIFzGLuVU7/NTR+ZsTU3
	Uz2+0blh1f3c4boNZgPFe+gM7kivAOISZZa7YwQ8tU2XJa7bA3a1fL9ja3Ao43y170k=
X-Gm-Gg: ASbGncudyDzZvm6VsPUtdSXwdbAvYv99Y7FJGeP5006MsUjm2RPOwpTZJ6Vz7tcgPZo
	MeRM/QsSN6FaKIaBLeEpXidxSpZi4KDONiPiB8Qb0Koy+pHHh5+VJ9LXTReB8CbQZcCCbwv4mTb
	3fFeWiBm7JAX4q3MZM1vs3JRz5O9/6mn4Oz69NbZ0wDGkzMYjVoPoSIu0dkg6fqRf/aoHfezD1+
	YdWJLzUV2AkpRehwM7lioj5I6+87Y+HrXuBjmqdxc0UXIbxyg/X3tVnR1tqMxfghvJejnaGCz4u
	pdnww8+hlVzEUI6x1WkTxKFHxDiTncFR1EKGePUhhPAP1kXQEdrMu4mudvCL41Cv059puXzz1OO
	1Hg==
X-Google-Smtp-Source: AGHT+IHbfpmIDPmqnU8cy+Q9IV2WuX88shLGTNNvcbapHH0ZNP+AcjRX9uwgvLrVr3YI9Yof+6Sl7A==
X-Received: by 2002:a05:6000:40c9:b0:3a4:eeeb:7e70 with SMTP id ffacd0b85a97d-3a6d12dfaf2mr4201936f8f.4.1750728790593;
        Mon, 23 Jun 2025 18:33:10 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749b5e4068esm399198b3a.63.2025.06.23.18.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 18:33:09 -0700 (PDT)
Message-ID: <faf70481-09dd-4c7a-bd43-f1e8bec877cb@suse.com>
Date: Tue, 24 Jun 2025 09:33:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, jiangyiwen <jiangyiwen@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Protecting refcnt with a mutex is the right approach, and commit 43b10a20372d
did it properly.
However, I don't see how your patch fixes the syzbot report [1]. Could you
elaborate on the root cause analysis?

My review comments are inline below.

[1]: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b

On 6/21/25 23:56, Tetsuo Handa wrote:
> Since calling _ocfs2_get_system_file_inode() twice with the same
> arguments returns the same address, there is no need to serialize
> _ocfs2_get_system_file_inode() using osb->system_file_mutex lock.
> 
> Kill osb->system_file_mutex lock in order to avoid AB-BA deadlock.
> cmpxchg() will be sufficient for avoiding the inode refcount leak
> problem which commit 43b10a20372d ("ocfs2: avoid system inode ref
> confusion by adding mutex lock") tried to address.
> 
> Reported-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
'Reported-by' should be: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b

> Closes: https://lkml.kernel.org/r/000000000000ff2d7a0620381afe@google.com
I don't think we need 'Closes'.

> Fixes: 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding mutex lock")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: jiangyiwen <jiangyiwen@huawei.com>
> Cc: Joseph Qi <joseph.qi@huawei.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
The 'CC's are also useless.

> ---
>   fs/ocfs2/ocfs2.h   | 2 --
>   fs/ocfs2/super.c   | 2 --
>   fs/ocfs2/sysfile.c | 9 +++------
>   3 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 6aaa94c554c1..8bdeea60742a 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -494,8 +494,6 @@ struct ocfs2_super
>   	struct rb_root	osb_rf_lock_tree;
>   	struct ocfs2_refcount_tree *osb_ref_tree_lru;
>   
> -	struct mutex system_file_mutex;
> -
>   	/*
>   	 * OCFS2 needs to schedule several different types of work which
>   	 * require cluster locking, disk I/O, recovery waits, etc. Since these
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 3d2533950bae..4461daf909cf 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1997,8 +1997,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>   	spin_lock_init(&osb->osb_xattr_lock);
>   	ocfs2_init_steal_slots(osb);
>   
> -	mutex_init(&osb->system_file_mutex);
> -
>   	atomic_set(&osb->alloc_stats.moves, 0);
>   	atomic_set(&osb->alloc_stats.local_data, 0);
>   	atomic_set(&osb->alloc_stats.bitmap_data, 0);
> diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
> index 53a945da873b..b63af8d64904 100644
> --- a/fs/ocfs2/sysfile.c
> +++ b/fs/ocfs2/sysfile.c
> @@ -98,11 +98,9 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>   	} else
>   		arr = get_local_system_inode(osb, type, slot);
>   
> -	mutex_lock(&osb->system_file_mutex);
>   	if (arr && ((inode = *arr) != NULL)) {
>   		/* get a ref in addition to the array ref */
>   		inode = igrab(inode);
> -		mutex_unlock(&osb->system_file_mutex);
>   		BUG_ON(!inode);
>   

I agree the above mutex_lock and mutex_unlock is useless. we can remove it
without any problem.

>   		return inode;
> @@ -112,11 +110,10 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>   	inode = _ocfs2_get_system_file_inode(osb, type, slot);

In my view, the key of commit 43b10a20372d is to avoid calling
_ocfs2_get_system_file_inode() twice, which lead refcnt+1 but no place to
do refcnt-1.

>   
>   	/* add one more if putting into array for first time */
> -	if (arr && inode) {
> -		*arr = igrab(inode);
> -		BUG_ON(!*arr);
> +	if (inode && arr && !*arr && !cmpxchg(&(*arr), NULL, inode)) {

Bypassing the refcnt+1 here is not a good idea. We should do refcnt+1
before returning to the caller.

> +		inode = igrab(inode);
> +		BUG_ON(!inode);
>   	}
> -	mutex_unlock(&osb->system_file_mutex);
>   	return inode;
>   }
>   

