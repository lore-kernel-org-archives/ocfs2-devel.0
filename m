Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195D0303A0D
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Jun 2026 04:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780373947; cv=none; b=cXSeLdKzr+f/SGg32r7vEExupIZb6Qmx3CqAGG/+PA3+rei11jQz1yiXpv+NEWtrcH63oTQBimTyd97sAiG98mFSfRfJLKX9t9f2IsoYctCh5xXStMV99oZmypJasOAQlsqaqT0zAmRlG+BT3szxj4Magfiw6MHPmncpmgJFAD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780373947; c=relaxed/simple;
	bh=D2tkcdqQevHKnm7iyZrvFSN0FryfucMDfN1jJHoaB2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDwV0VkP+uUvUjtZP3umb3G6J/+piAy+hM8RWKJZ5V3cWF2jYKF1WiMxOWq/h6EEdpN80wtKl9q2FS6oxK4kuDdQoySw24Oz6ChvWMFUVaU23EyX3oy5ZYaNm491Q8LGUEaTc2gpITk0YQUoCKL+fjvytsWKSTZrO2Zh77m8T9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SelqA7pP; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SelqA7pP"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ef57256d8so368453f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Jun 2026 21:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780373943; x=1780978743; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GQIJYgqXVDOV+QlU5wqTYbdRma5//XsEXiIIBLD54Ts=;
        b=SelqA7pPs7724iNeJ7aO6XBht1l9Ce2N2iXrK7drRL0d7hdrYeygSlMPgW+utZfBc7
         23r+ELAIjv3dWLjqnN3o3vR1DGM5IOJ9YTr1JXu+Rzw8juMOLD1eBEOKvjHtvf6C1mXW
         PLpKSs7BZjoH/TDCAviRI4/BikfVchFZgQeXV3BxyIgqiLMkhk1Qvpi3KeptdtE9/9RI
         953UErSWTO4bCr0NZgZK/Ig8OYIK3X5NaxrSPGYufOMBWSVNwyu/h7/zkfeRgjMidWz8
         X/50VoOZIorPJqbkuZdzSel2P8YLFVc/xUCqSH8+4SLxuYHtk/PIA/e64rFGldV46H5s
         OsDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780373943; x=1780978743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GQIJYgqXVDOV+QlU5wqTYbdRma5//XsEXiIIBLD54Ts=;
        b=YYL34CIS2rnA0/riMCjgSlwlDZJZNhFyTzUHKC48dD9Vk7HFS+zrfRG/4mBJPvuDaw
         IdkRjAizXOcSVRodlVbM6FZAMQxUTK7N8JzWHYF9H/FNnEquHOhfLht8IWhoHKiWktzS
         8mZ6lh8wllCf3l/MkSngQ/VTFRiYKZitkObivmpI3xnfd/CLHEfIjwBQQW4l5kejZ4w+
         +qXxE3rrkhrRBrdjlJwo2njGCMZkKRKE4d9hbsaXtcGn5JYLnxD8mv7tAFys6p/Y9Pi4
         IM+880eDoI+WXL2ZJkhuztNeh/wFJhPWdsCd63UHhLndckyJnLPj7Q4bTAAZxwfQJNjQ
         uXYg==
X-Forwarded-Encrypted: i=1; AFNElJ83vNYLWbS0TJvIyIR/HkpKSPxMqpPJ9TpPWD09tpK8jxDzpRXMjqDC4FsK0XaekE31v9b8RhHUMszhmg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzsRdXb4o2QYDodupxBwqX4UfsVRAnTuE0cDIW3tqwfybylOu4I
	j4Qob0iO4Bhy02/fdSv7H3IYte7YM3UE1Id8fD8A7pzUSw0SZSrzaGjN6PMCykmt2bUZ4ddUg8D
	s3mK/Wpg=
X-Gm-Gg: Acq92OF0o6GX0GNQu1Ti2Iwca83Yty8L9Dsr+kHfcZPEL+BiBzxvP4wrE4yU/nOCxNT
	4SlDoNlIhL4Hk/duiI+sojrvZRbgDjjqw5Xk9aLVYmkDBzPzo1pfnr1Yr7Q9StN6FicRY8QFpyn
	JG6jjlZeUxAHfZ9auwxNeO5+q6JgPZJGHQFUh/ueSr6gkEOzpdzhD6RF4s/dzOg43OCskjkp3y/
	OyRh/HcH92jY06stfH4J4c0/NT10trdc8+JbsC9Y19AgwfwfpHXcnlaJxLDjPv7A/hkpXRz35F/
	xCGx3ozgoOFlts0UwsVTTarFYMViv/85AyKU4kxPQ0iaYp5UQFysEjrO/IpTM0NEu7dRNzfbdCm
	1Y1C586oCIClxaj8YwsbIW0jPfRcZdt2EE0sbgbox/ztL68o13YvTsv8hNBZZS0SisBaysEHXtL
	meUZTYMUEtqCmDSlAicDWKrM1RMGMYhP5u
X-Received: by 2002:a05:600c:3f1b:b0:490:4175:4bf4 with SMTP id 5b1f17b1804b1-490a2997abfmr129013035e9.8.1780373943479;
        Mon, 01 Jun 2026 21:19:03 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36dd91aec9csm1166430a91.6.2026.06.01.21.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 21:19:02 -0700 (PDT)
Date: Tue, 2 Jun 2026 12:18:59 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Ginger <ginger.jzllee@gmail.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix race between ocfs2_control_install_private()
 and ocfs2_control_release()
Message-ID: <ah5ZMguK4Pzh1DfX@p15>
References: <20260601121618.1263346-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601121618.1263346-1-joseph.qi@linux.alibaba.com>

On Mon, Jun 01, 2026 at 08:16:18PM +0800, Joseph Qi wrote:
> Move atomic_inc(&ocfs2_control_opened) and the handshake state update
> inside ocfs2_control_lock to close a race window where
> ocfs2_control_release() can observe ocfs2_control_opened dropping to
> zero (resetting ocfs2_control_this_node and running_proto) while
> ocfs2_control_install_private() is about to bump the counter and mark
> the connection valid.
> 
> Fixes: 3cfd4ab6b6b4 ("ocfs2: Add the local node id to the handshake.")
> Reported-by: Ginger <ginger@gmail.com>

The code looks good to me, but above email address is not valid.
The correct should be: <ginger.jzllee@gmail.com>

- Heming

> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/stack_user.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 5803f1dee679..91e19d33847c 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -327,18 +327,14 @@ static int ocfs2_control_install_private(struct file *file)
>  		ocfs2_control_this_node = p->op_this_node;
>  		running_proto.pv_major = p->op_proto.pv_major;
>  		running_proto.pv_minor = p->op_proto.pv_minor;
> -	}
> -
> -out_unlock:
> -	mutex_unlock(&ocfs2_control_lock);
> -
> -	if (!rc && set_p) {
> -		/* We set the global values successfully */
>  		atomic_inc(&ocfs2_control_opened);
>  		ocfs2_control_set_handshake_state(file,
>  					OCFS2_CONTROL_HANDSHAKE_VALID);
>  	}
>  
> +out_unlock:
> +	mutex_unlock(&ocfs2_control_lock);
> +
>  	return rc;
>  }
>  
> -- 
> 2.39.3
> 
