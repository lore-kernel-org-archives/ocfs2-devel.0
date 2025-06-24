Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4E36F53E
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Jun 2025 00:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750725494; cv=none; b=u1bUbyKcAQ6R/LhA0fzQQodR8Flv6Qem1Jux03gfVGRlGN1XrU67AmKkRGPPNXCfxnI4d9x7f1AVXx+rNP8q9eEv7M3xHnSNUslVtqenlQEoRj04INSkPNWUnON1u0AsjFWj+vMrNt2bSeUAnRxmUTrL574D3tztTlnbyqRP7Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750725494; c=relaxed/simple;
	bh=JQs9gz/NFvI8N4HhUMBLmxyBxTQKG4fUiQcyMBmCzas=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=He4ihjRYRQ073qm23Cm8dfqQYyaq36vlTM84GSK+bAAnhzmc0uYnkq1hJTRqz/YOVfJsxxjznL2mtL2KbswuZPybXSRkBBavNEI+tEP1kzcGBe+A+vWERkBskFZTufqGyCePBjx5C11z3JWpw6B3Fr0asmdHQysZfV2bRuAa5JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BFd3tAuR; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BFd3tAuR"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a4eed70f24so695814f8f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Jun 2025 17:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1750725491; x=1751330291; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vZlvEXovKxyFzMFNSWh0wIgJwy0g694LXaxz7gWWKKs=;
        b=BFd3tAuR1ELs4bDNDygrx5rXd0A9npX6lVxCv4M0M/SWhMORyx5lEdLCQkzkTSt1yU
         kiiBgO5HyyJB5r3Vld4TIefGB7KmKMcdCHq0QhGwcTr7YW2ZQG6+IlPoyxJ3plpV6Xrh
         8t/KmAdeByEz6NmxPqFWf5K5ZITkhznNuXZgyPb8/cd3dOnFwgmrZQRW9/xqHHW7pQNj
         yMBHEJaInPttra7KPuTCw5gFqcGs4BtQ+C2zVqLDvT6V98J59yZnxIyexirGWpWK9GP+
         sKxbxE5hkCIXjmEUn76g75nL3jQrBgB91SmRf0LePWgIR++QbfRvPniZlc+zvzTqjV/2
         TaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750725491; x=1751330291;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZlvEXovKxyFzMFNSWh0wIgJwy0g694LXaxz7gWWKKs=;
        b=R0QI8uLbPPlZyvyE8xC9UDbnFhXU7aliRyYKEdU7CrTkj5VNglLkb7K9AppasmIMXJ
         6+FYhUFvm9/zrRJ0rDxl8Kiy6P69TpPuBjDF6BGIee8HtZAmmiZq+oPqYJl66jbQ56so
         odtpy1mnbzc8GJKQYDTkY4f4oWYflAdJ/aBANStEmVwNp/4qwFjB85PbQGXaDx+A4eU1
         o1qoCFdyofo0u3TtlLmVz4XhF303nXyMV1UZVQg+PwjGpaKRp6tFV1zMMcM2L4G61Tqf
         MbkQLdebAjVn5Y5mPBDvrsl9AotXT0ONlCcDmbiZT6MpFpeo/XaDcjIKk0+YgGrBw/oy
         sHcw==
X-Forwarded-Encrypted: i=1; AJvYcCU1zgnuMRVD8Odfom+85tS8Gj7PECLx4jkXqyhSf3xc5Gi8ndbF0Vp2EQ3voDRa4YkeHdacglWyqEt1Pg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzGftGESK/FgE2jYOhx5ZqHyl4KLoZxF8yhqYrUsLMgdigCPJy0
	WuAwIjV7QUNCdx3y40/LjnYHTSyebz6EYvP0vvctpSgw1C0d/Hcuzx3biM78VRNNrqn0i27vh8V
	VadMN
X-Gm-Gg: ASbGncsf+xqTapLuikQj/2xbLsO5HlRD+akC9H9rv+EyN1GnpSZW91rEiTbGzyVfMEx
	cnIe2jd18GBKkJFonDlbKJ68HYaPG7jLY+ahJ4lmmJ4Qy9y7J3vxu4SSjTZ1iasYUsHmK3aOtmz
	8oIhSt+VSbO/4PdUn5vDpHrwslmyW0X7ETERTKp3QbMGxIZ0BXdJYUK2auClOJYATLSlNvqohLP
	eX730000txY4DHDy0EBPSixfOhujjqBdxXNI3x2DeIyubpC1atcxZ/BZSN7lAbZJZhdo+R5W4C9
	o2XT5PhCp/pZWhtFGjrS6Q2oaKKr7xTChDIzFS8PD1kX3xhTV030p+EuGXko6Qnz1AA=
X-Google-Smtp-Source: AGHT+IHxEy9DDw/+nEJmttPoKno5HQNQCaSpkN5KhFruKdgujErU45jroQo5ctCLDze/KEon8/VKFw==
X-Received: by 2002:adf:9d8e:0:b0:3a5:2dae:970f with SMTP id ffacd0b85a97d-3a6d12eb506mr3667961f8f.13.1750725490712;
        Mon, 23 Jun 2025 17:38:10 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b32075895f6sm6135371a12.21.2025.06.23.17.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 17:38:10 -0700 (PDT)
Message-ID: <8f689011-4f35-41a1-a4cb-b81c833533f7@suse.com>
Date: Tue, 24 Jun 2025 08:38:05 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: embed actual values into ocfs2_sysfile_lock_key
 names
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <29348724-639c-443d-bbce-65c3a0a13a38@I-love.SAKURA.ne.jp>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <29348724-639c-443d-bbce-65c3a0a13a38@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Just from your code logic, the switch is unnecessary, and converting the input parameter into an "unsigned int" type is sufficient.

e.g.: (not test)

unsigned int type = args->fi_sysfile_type;

if (args->fi_sysfile_type != 0)
         lockdep_set_class(&inode->i_rwsem,
                 &ocfs2_sysfile_lock_key[type]);

Thanks
- Heming

On 6/23/25 22:54, Tetsuo Handa wrote:
> Since lockdep_set_class() uses stringified key name via macro, calling
> lockdep_set_class() with an array causes lockdep warning messages to
> report variable name than actual index number.
> 
> Change ocfs2_init_locked_inode() to pass actual index number for better
> readability of lockdep reports. This patch does not change behavior.
> 
> 
> Before:
> 
>    Chain exists of:
>      &ocfs2_sysfile_lock_key[args->fi_sysfile_type] --> jbd2_handle --> &oi->ip_xattr_sem
> 
>     Possible unsafe locking scenario:
> 
>           CPU0                    CPU1
>           ----                    ----
>      lock(&oi->ip_xattr_sem);
>                                   lock(jbd2_handle);
>                                   lock(&oi->ip_xattr_sem);
>      lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
> 
>     *** DEADLOCK ***
> 
> After:
> 
>    Chain exists of:
>      &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> jbd2_handle --> &oi->ip_xattr_sem
> 
>     Possible unsafe locking scenario:
> 
>           CPU0                    CPU1
>           ----                    ----
>      lock(&oi->ip_xattr_sem);
>                                   lock(jbd2_handle);
>                                   lock(&oi->ip_xattr_sem);
>      lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
> 
>     *** DEADLOCK ***
> 
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>   fs/ocfs2/inode.c | 70 +++++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 66 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 12e5d1f73325..14bf440ea4df 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -50,8 +50,6 @@ struct ocfs2_find_inode_args
>   	unsigned int	fi_sysfile_type;
>   };
>   
> -static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
> -
>   static int ocfs2_read_locked_inode(struct inode *inode,
>   				   struct ocfs2_find_inode_args *args);
>   static int ocfs2_init_locked_inode(struct inode *inode, void *opaque);
> @@ -250,14 +248,77 @@ static int ocfs2_find_actor(struct inode *inode, void *opaque)
>   static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
>   {
>   	struct ocfs2_find_inode_args *args = opaque;
> +#ifdef CONFIG_LOCKDEP
> +	static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
>   	static struct lock_class_key ocfs2_quota_ip_alloc_sem_key,
>   				     ocfs2_file_ip_alloc_sem_key;
> +#endif
>   
>   	inode->i_ino = args->fi_ino;
>   	OCFS2_I(inode)->ip_blkno = args->fi_blkno;
> -	if (args->fi_sysfile_type != 0)
> +#ifdef CONFIG_LOCKDEP
> +	switch (args->fi_sysfile_type) {
> +	case BAD_BLOCK_SYSTEM_INODE:
> +		break;
> +	case GLOBAL_INODE_ALLOC_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[GLOBAL_INODE_ALLOC_SYSTEM_INODE]);
> +		break;
> +	case SLOT_MAP_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[SLOT_MAP_SYSTEM_INODE]);
> +		break;
> +	case HEARTBEAT_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[HEARTBEAT_SYSTEM_INODE]);
> +		break;
> +	case GLOBAL_BITMAP_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]);
> +		break;
> +	case USER_QUOTA_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
> +		break;
> +	case GROUP_QUOTA_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[GROUP_QUOTA_SYSTEM_INODE]);
> +		break;
> +	case ORPHAN_DIR_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> +		break;
> +	case EXTENT_ALLOC_SYSTEM_INODE:
>   		lockdep_set_class(&inode->i_rwsem,
> -			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
> +				  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
> +		break;
> +	case INODE_ALLOC_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
> +		break;
> +	case JOURNAL_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[JOURNAL_SYSTEM_INODE]);
> +		break;
> +	case LOCAL_ALLOC_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]);
> +		break;
> +	case TRUNCATE_LOG_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]);
> +		break;
> +	case LOCAL_USER_QUOTA_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[LOCAL_USER_QUOTA_SYSTEM_INODE]);
> +		break;
> +	case LOCAL_GROUP_QUOTA_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[LOCAL_GROUP_QUOTA_SYSTEM_INODE]);
> +		break;
> +	default:
> +		WARN_ONCE(1, "Unknown sysfile type %d\n", args->fi_sysfile_type);
> +	}
>   	if (args->fi_sysfile_type == USER_QUOTA_SYSTEM_INODE ||
>   	    args->fi_sysfile_type == GROUP_QUOTA_SYSTEM_INODE ||
>   	    args->fi_sysfile_type == LOCAL_USER_QUOTA_SYSTEM_INODE ||
> @@ -267,6 +328,7 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
>   	else
>   		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
>   				  &ocfs2_file_ip_alloc_sem_key);
> +#endif
>   
>   	return 0;
>   }

