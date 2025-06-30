Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455C924501B
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751291749; cv=none; b=nBguypBkBjUWqCpfhO8YS2XANEhpXmWbDh/o86DF7skHjyGZcVFyehnz8uvuKHmOY/eA27z9whSJcksJCbxUQMMIa6qCH/HBgTw/caui+sG4QfPa+QS0oW4Qz7ggfKB8AeP5+byGgJNKQjlYmD6OAzQZP5Y+zGKMIhAjzqAzb20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751291749; c=relaxed/simple;
	bh=Gu9OKf8rQBmrExSPd1d0qTtLcNZrMzJ2i8I87FDAePU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kCi6k4QitvFqclcCjxf+ZWYP/KYi3tKEmRe8eZwtmGPdwEftVZO45I3Q2o+eeHzANlL94RKrU1uHpk0rEaL5PVhc/HVMe0NEajDfEU/jHgVZMGNbTt1hXq2ZjPl4TFH47dVw97VBgh77D43R1yWnD9yNBuPFAvN2dSQyb8vOq/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CR30YWI5; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CR30YWI5"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-453079c1e2eso5354675e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 06:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1751291744; x=1751896544; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fdj3pqe8ZDsSy0zFVlQn+uagXU2FmydKl9tMhyBgJnQ=;
        b=CR30YWI532orZRjKUm28hzsx9AT7rhZc68Tcq6OXM09ssiet13+BXL9pIIz3lAWiqm
         1NMRtgUqS60smJCJr3HYGoGjG+GrK/d9NqjkbDiZQkfE+WmN4+Cmje+2Tz/Hj3nQtvtY
         mIVOIpAoHz1zmhtPRNDlTfps7V59rvb80OgDK6YDlEYkeaZcGk+7JfeEcuNURjqHAgo4
         KxQrd19/vGg0tT9yS4PJv1fnASItp1kpkQtnAx4tz/kb+tXftL5m475mu9cqoAmSzW7C
         Osuojb3ZxD2ZRmdzluh0ymMbuMx9b3sRZ0toJmBh1pPGmb0vQjmXgjK8OXclUJ/q0/yB
         pjpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751291744; x=1751896544;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fdj3pqe8ZDsSy0zFVlQn+uagXU2FmydKl9tMhyBgJnQ=;
        b=BNLPz+VPRaDEoPYJScKqk+cwLymPEGSiZCOaSNFJENRzZZe6ys2WHQCoO41x0hXGRt
         39v3rehEeOMb3MDyxCfn1EjTDW8Un4KCar8zUpmTbqSsBKvWC/xC8DGSzF+1qtJPcccE
         PWSmlEEm14I+KatIgTzTQ/89SmvHis85fPrtDFGDkODrY0BAWa6ABWzn3W+eKYYanSn7
         cShiAxg6ds6MklqmamNWEEE7Jvg32BNzKPi4ZYhV+L2b3XcHdBDRQgIIbZ/EhN3Q+wQL
         9PgpsGG4fBL9Ndf/vZP29ZP4FslAcSUAQizraVHpivph7wFP70lmriVE3xkA0D6o2GQm
         43BQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2is4Nn6lMJZrMC3dHl4rRKgEAymU/Aj7ZxEPX+eOh495SeqzJkyIHF3Xx+DEGqwLfm2eJAQp+c0ovYw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyZoZx0j+MYsEcELiaZ7CPEOiUg7a1o2PyO5MuR+hYwK5Sm6Kp7
	mHMDLsckf4ZeyA1FEA0AI+tpQ/VUe13LWPWminJ3TSJkLjXaGjZmmc4LOuo2FeStXxA=
X-Gm-Gg: ASbGncsaQIzBaQoNSqJFCxLJ3CxT/cu4gNJ2IfzSNStDuuNuAv0giFHY7qGaxzKm8mr
	Yju8UzhiJg6C2CRlYXEMSsakxHDTD/Dq+YulgImtjsJDUl4ByEETLjwrXPiKboCk++7T15KUeN0
	z2TnByNjGjwDtyvNqtlYkUkTRejpaBgbzH9Ky3wDM2nUeZJi9hiqo+vJMJ+rilw4geUDpvm2GwB
	bCbCW/fOP2RQYHjuVymV7cKOwfEVdpV2h8LxyRatlzcElbRlzz2CcAbncHnt6hnoyMTMiwGI5S7
	EadUD3W/GoJQoFY3l7BE99/5N71WwfNRC2a3vTgmQKafGfqyUwNOsDnYS4N12zrNFpO9
X-Google-Smtp-Source: AGHT+IH1bo27fCLOgntXw5DxakwPIbKEfqHW5HovLZYLeRzABQNkd8wTWMAMfFy+4a0iMGjJkkJEJw==
X-Received: by 2002:a05:6000:2f85:b0:3a5:3399:51b1 with SMTP id ffacd0b85a97d-3aaf36423ffmr2915205f8f.6.1751291744314;
        Mon, 30 Jun 2025 06:55:44 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557445csm9747580b3a.91.2025.06.30.06.55.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 06:55:43 -0700 (PDT)
Message-ID: <6ef3bcf7-4c49-47b4-a750-4e1a3a15bb52@suse.com>
Date: Mon, 30 Jun 2025 21:55:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: embed actual values into ocfs2_sysfile_lock_key
 names
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <29348724-639c-443d-bbce-65c3a0a13a38@I-love.SAKURA.ne.jp>
 <d490a3ad-6309-42f3-9774-91871fbf7330@linux.alibaba.com>
 <d76672e5-0d69-42b1-a9d3-b70439c194b5@suse.com>
 <d54a0eb8-5899-4ea7-bc86-7a0d56c190d2@I-love.SAKURA.ne.jp>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <d54a0eb8-5899-4ea7-bc86-7a0d56c190d2@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/30/25 18:39, Tetsuo Handa wrote:
> On 2025/06/30 11:42, Heming Zhao wrote:
>> I am not familiar with lockdep, and just have two questions regarding
>> the lockdep in ocfs2.
>>
>> 1>
>> there are three global "static struct lock_class_key" definitions:
>> - fs/ocfs2/inode.c  : ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES]
>> - fs/ocfs2/dlmglue.c: lockdep_keys[OCFS2_NUM_LOCK_TYPES]
>> - fs/ocfs2/sysfile.c: ocfs2_sysfile_cluster_lock_key[NUM_SYSTEM_INODES]
>>
>> why did you env only trigger the ocfs2_sysfile_lock_key[] warning?
> 
> Because syzbot is reporting lockdep warning on ocfs2_sysfile_lock_key
> at https://syzkaller.appspot.com/bug?extid=68c788938ba0326046a9 and
> I couldn't find which lock_class_key syzbot is reporting.
> 
> Unless you want me to update all keys within this patch, you can submit
> similar changes on lockdep_keys and ocfs2_sysfile_cluster_lock_key as
> separate patches.
> 
>>
>> 2>
>> It seems the existing CONFIG_DEBUG_LOCK_ALLOC is incorrect, it should be
>> replaced with CONFIG_LOCKDEP.
> 
> I couldn't catch what you mean. There are many modules which declare
> "struct lock_class_key" under CONFIG_DEBUG_LOCK_ALLOC=y.
> 

I mean OCFS2 should use unified kernel configuration option.

- Heming
