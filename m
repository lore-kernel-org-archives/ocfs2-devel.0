Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E1E3E63AE
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 May 2026 23:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778889388; cv=none; b=HVHmFve1/5kB2SufG/8GT1/xWTKLv+WRo5gRm5ms29Sgq/myTvbED/kOxJFYy8V2MoEVSOYdkh8JS+tj74kqmXhb/nQrm0NMKKkS6mDICP+7jOMS8TSVB+tPVEvHvmGeQqw65hpk/algZc3HwK6Q9DGQ3Aelnax0nv2VP0+te6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778889388; c=relaxed/simple;
	bh=TczwYFvezC+cxAVsXFLJSZa6yKhWgXpLxIGr4mPEKJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pG0b+XQUtDt7jN70Ye4Ab1JyDHO8UOYco5Hym/uU8N3pXutDF/4gZ4wyuVzfaOcdfPXhAdfgQCUGmeLjzSXgZ+UM14fa3SrKWCKsfjrwu8HgVZJQGUC+FCbauXMsz4xLgF149VjdrY5/6YdOkjg546hmQ31b8Bjcu+Wnl8MnZpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=hBmxf75K; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="hBmxf75K"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-44c44af71f8so35897f8f.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 15 May 2026 16:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778889386; x=1779494186; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7l0XJ9rj+fjB2S5mDM2d3xOJnuO0et6lV2GrlUYJVSw=;
        b=hBmxf75Kr8G2voN35SMTVNRivnqcww6ztIX7/1ducUaoq5jrJPqcS496kPABbNSwGN
         u5xoC4LTn19F8kxCWHjYL+/fxK3+9FSOdSEcBml1RRkF50LDj+CxltxAPkrTMgkEmOWq
         1Njud5nHsyQtX2CIcxKE6/JOlN6MUKMCsazUx3OYDvugz96T6SoyN27AXxbeYmIKgRW9
         AIEJZFM1QxnX7qM3ppICj6O3wkW0CpKcsO8ncwW2kf6VOAyZifXOBJo4+UNbMBCsY2ns
         lHVLTfp/0UTqqKPLDyzmQzHc21eNugw9BCdNec1T8HaLq8rBThJNEe/KaYhq2bz+xzzQ
         JGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778889386; x=1779494186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7l0XJ9rj+fjB2S5mDM2d3xOJnuO0et6lV2GrlUYJVSw=;
        b=XqDJOUJKA9fHafJtBTUhkT3lWcXf/Jro/3f1UGBMYYNCjFkRrRpPpiWihIj0jvZd1N
         Oo2hqH18GIgDcFZxhCyIoTgg8c2LdlUr5PEMuHXth1Z2xXX12p3B2BqzjRrXkoOU2ZxM
         cDAErgUr3LKafZxwh2F+NLRCqejYuZuNEqslVk+yuXSB6J2tU07mELyfsSi1EA7r1zl9
         0tjLnd/HrRN4c/EEwZ6Y7/r8p6avaa9N8cPI4VSidUJ5w1OViWhurOT8Mc7J3hB0x7kT
         NHkBgOFELDdDoDQtxC1Nk5Wv2nFrGLt/IA4yN/bkeurI1jsKUbHpWxDBhzcJSbClYvP8
         J8hw==
X-Forwarded-Encrypted: i=1; AFNElJ9uHsLca0r8vgZvUJfT8dwPBWfe99/13ZoRvydFk/IhXnxewRVoghiIl3np14rXqLWfJrEmasuyUX4ZqQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwBwnCQpE/8l5RIWExV2B3/P6kPNIOnqUPHa3rNi+imAs7jX5Al
	U+ur7K3XT7EdtFDhNtuN0xxrQPIlnJXwk75n31AsgKILhOkd6e750DcwsIBZPsKgml8=
X-Gm-Gg: Acq92OFt5tLvSrr6KXSmHcoNWGAlDInOznQIN9Om7tf+d6/2lR57m7P86UaKKBVAbWv
	5zpTDTuP+NRKm8b+wMkZAFy8AMAWCdxCKYxILfXo+CLL1z7D1B5J5hUyz2Z13GsLLUGvcU/PS1r
	xG2w9Qowc0ryorXmS7NJIWgtfV74cnIt9cfIiuT+JN2R4XjEqpRpXDBt/OrCOGkkzNgx//If08j
	Fu29QDu2hFdG0GCIKm2xw9AvXAqc91hHhqStrih1IlASeyOY20Tfo3ref+JjGClMAUj5A5YnbYu
	P6f5tdH+dpb30X2UNP2GjdupfuJMVk/18R8AYC3mC4iD9Y7TwOkH2xDI9SWN1GzAIRTg0jio03M
	ds3nTQHPeTXlh1ME+s+EkPRYLzzSWyOMcMjpyRMaQYGbp3FVXKFHUS5qoYvYVo98S1P8+9iQmo1
	/5LGbtbcRPZZDQeoqmIJ0ZkA==
X-Received: by 2002:a05:600c:45d0:b0:488:a797:f099 with SMTP id 5b1f17b1804b1-48fe61f0787mr42703265e9.3.1778889385760;
        Fri, 15 May 2026 16:56:25 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm6596384a12.30.2026.05.15.16.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 16:56:24 -0700 (PDT)
Date: Sat, 16 May 2026 07:56:21 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, jiangyiwen <jiangyiwen@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
Message-ID: <ageyiQPdXbsnyikV@c73>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73>
 <b0e9c4c2-9ea1-4d41-b8b2-5f2f6c15b80a@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0e9c4c2-9ea1-4d41-b8b2-5f2f6c15b80a@I-love.SAKURA.ne.jp>

On Sat, May 16, 2026 at 12:51:32AM +0900, Tetsuo Handa wrote:
> On 2026/05/16 0:35, Heming Zhao wrote:
> > Hi,
> > 
> > The logic here is incorrect. The purpose of the refcount is to track how many
> > consumers are using the inode.
> 
> The igrab(inode) for the first time is for getting a refcount for the slot, isn't it?
> The igrab(inode) for the subsequent times is for getting a refcount which is supposed to be dropped by the caller, isn't it?
> _ocfs2_get_system_file_inode() always gets a refcount which is supposed to be dropped by the caller when it succeeds, doesn't it?
> 
> So why do you want one more refcount?
> 

Hi,

Could you please reply inline? your current reply style makes it very hard for
others to follow. I made a mistake in the previous email, and wrote the analysis
to continue my previous email.

- Heming
