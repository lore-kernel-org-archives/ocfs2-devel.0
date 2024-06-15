Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173FF19D890
	for <ocfs2-devel@lists.linux.dev>; Sat, 15 Jun 2024 03:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718421107; cv=none; b=ecqKOJkdFZ0iwo3URy2nt0WBMRbs02u7CHKBtLlcqHefaUjqkClAC1D7Y0Hmba6l9HJwX4sGjZS74dq1qwlOrUK02cmtX5RvAPXPiMgehm+niR08J+hLlFU2zYXTROjha+S8vzrF0q1MT/ydDlmqdXi9kUVqa/oKSKzypbVKScc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718421107; c=relaxed/simple;
	bh=LAi/Nlv9lMqL99c0d28Ckdm96I/n7HgGgAfr/UNgXVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZU9W8JUb1acnPafyEfZt/gELUojA5j1ZBqYVwzCi4YBrkhOK3gRzEaSZQFmT0vLtxplhPLLZVvqRmbgpuCOr/Lm29/BWnZDrBR9q+wZJ36OKVFxWIg4Dbm1EY70GlhbtWappQkEUse+xG5MQURxOwT0td6C6aK4/3B4H4Fd20dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WjfZ5xrW; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WjfZ5xrW"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-35f223e7691so1759065f8f.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 14 Jun 2024 20:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718421103; x=1719025903; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i+KHPuf0pRo9rfSxli4/S/yswQBCYXA0AirjX/km0wE=;
        b=WjfZ5xrWtl1QhlnaDDIDjuYdGewzFCfS2vRlS6gKvuffNbvxX7Agni9lVAXM6dog8d
         oldxztXEFZ95Es+QNpgjZFCThmYfTZozvLEQ7nK1gIbW7NLgjXYuU2d/CVvVuNoChPNZ
         3VnPfnPsQ3UGxpahWWZ5MMy2IOktkEhSnkV6+2uPAD742E0a+lfE+EqDOEyfue4bKLZu
         shq2i41okLMkD3TMIidN5M6O7ctjkmaP6N0O/BRswE43ptZwdD8iS9ulXRh58qfBw5Aa
         k9jHzZpLVIkUlYMbs1GIATI9TEi69N36P5GqrlQ7t22l9pEjSDqmKNKSLD/TooojY+IR
         8Aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718421103; x=1719025903;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i+KHPuf0pRo9rfSxli4/S/yswQBCYXA0AirjX/km0wE=;
        b=CelaFHwG0GeeH6151OXTznSwoO5Ussy9d3tAouZxtQAobqolMQ2bi+rBmXBdc6OCNN
         oaT5EA7ZpIYKKTmx2/WNfOQ5b1F5SdWdffeUZ4LWwP67bJ/GlCeLOO/+7qGtYIBn1Dl/
         yhJhEcvvbMX8T8zXdipFiWn5fJZptB2nuwQyuuyFlsVQ7gL8nK0Xt5dHCY9h6MIKmEJq
         X5rwRLL3v7fGYK7r618u0oGbOGtzLm5ZE39HpSKTGR1vC+knfZFZQDWs/63/JZqDrf5C
         B9ABGTRyRJ3HVwZDI1RJ8oqw0p3yX0hbGV6SSjiiauY/9HM8xPJmIKdJQc6xdPc8UIqq
         YzTg==
X-Forwarded-Encrypted: i=1; AJvYcCVwjZVoUQ4f0m5mORYWVY3pexW7ex9n4/yISgNzzWsb0I53JAZwW4NgqgENGBZoDDvXhEAZUUa4YyDl1G5Sh0BXP56/GYgpbDCcxSs=
X-Gm-Message-State: AOJu0Yxp6COy/7GIbUfwidzReqShxvkscKdJu656K4RKvuZ6gHafUDp5
	wglb3t7kXM65JoMhHpgOKcl/B+wuivxGXwrSfRoBCfNbzXwH6kUBO45LdC5VnBw=
X-Google-Smtp-Source: AGHT+IFvbXZhtVaxofIV+nAPf0wCM2J/RcvY2PF5p5nlbBp8FR6epq/0Hey1qYkFAeIX26yjx3eJtQ==
X-Received: by 2002:a5d:550c:0:b0:35e:60e6:c8a6 with SMTP id ffacd0b85a97d-360718c9d80mr7303007f8f.6.1718421103224;
        Fri, 14 Jun 2024 20:11:43 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc96752fsm3762320b3a.50.2024.06.14.20.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 20:11:42 -0700 (PDT)
Message-ID: <2ad4610c-0b4d-478d-9819-83d87b145789@suse.com>
Date: Sat, 15 Jun 2024 11:11:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Fix DIO failure due to insufficient transaction
 credits
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 ocfs2-devel@lists.linux.dev, Joel Becker <jlbec@evilplan.org>,
 Mark Fasheh <mark@fasheh.com>
References: <20240614145243.8837-1-jack@suse.cz>
 <2ec660c6-6f5d-448c-8488-3924552e261f@suse.com>
 <20240614195427.5bec08e823d3398b0f28216a@linux-foundation.org>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240614195427.5bec08e823d3398b0f28216a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/24 10:54, Andrew Morton wrote:
> On Sat, 15 Jun 2024 09:21:51 +0800 Heming Zhao <heming.zhao@suse.com> wrote:
> 
>> On 6/14/24 22:52, Jan Kara wrote:
>>> The code in ocfs2_dio_end_io_write() estimates number of necessary
>>> transaction credits using ocfs2_calc_extend_credits(). This however does
>>> not take into account that the IO could be arbitrarily large and can
>>> contain arbitrary number of extents. Extent tree manipulations do often
>>> extend the current transaction but not in all of the cases. For example
>>> if we have only single block extents in the tree,
>>> ocfs2_mark_extent_written() will end up calling
>>> ocfs2_replace_extent_rec() all the time and we will never extend the
>>> current transaction and eventually exhaust all the transaction credits
>>> if the IO contains many single block extents. Make sure the transaction
>>> always has enough credits for one extent insert before each call of
>>> ocfs2_mark_extent_written().
>>>
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>
>> Thanks for Jan's patch, it was used to fix a SUSE customer issue.
> 
> That's useful info.  Could we please have, for the changelog, a
> description of that issue?  Amongst other reasons, so that someone else
> who is dealing with a customer issue can figure out whether this patch
> will address it.
> 

See blow crash call stack, I removed the customer-related information.

------
PANIC: "Kernel panic - not syncing: OCFS2: (device dm-1): panic forced after error"

PID: xxx  TASK: xxxx  CPU: 5  COMMAND: "SubmitThread-CA"
  #0 machine_kexec at ffffffff8c069932
  #1 __crash_kexec at ffffffff8c1338fa
  #2 panic at ffffffff8c1d69b9
  #3 ocfs2_handle_error at ffffffffc0c86c0c [ocfs2]
  #4 __ocfs2_abort at ffffffffc0c88387 [ocfs2]
  #5 ocfs2_journal_dirty at ffffffffc0c51e98 [ocfs2]
  #6 ocfs2_split_extent at ffffffffc0c27ea3 [ocfs2]
  #7 ocfs2_change_extent_flag at ffffffffc0c28053 [ocfs2]
  #8 ocfs2_mark_extent_written at ffffffffc0c28347 [ocfs2]
  #9 ocfs2_dio_end_io_write at ffffffffc0c2bef9 [ocfs2]
#10 ocfs2_dio_end_io at ffffffffc0c2c0f5 [ocfs2]
#11 dio_complete at ffffffff8c2b9fa7
#12 do_blockdev_direct_IO at ffffffff8c2bc09f
#13 ocfs2_direct_IO at ffffffffc0c2b653 [ocfs2]
#14 generic_file_direct_write at ffffffff8c1dcf14
#15 __generic_file_write_iter at ffffffff8c1dd07b
#16 ocfs2_file_write_iter at ffffffffc0c49f1f [ocfs2]
#17 aio_write at ffffffff8c2cc72e
#18 kmem_cache_alloc at ffffffff8c248dde
#19 do_io_submit at ffffffff8c2ccada
#20 do_syscall_64 at ffffffff8c004984
#21 entry_SYSCALL_64_after_hwframe at ffffffff8c8000ba

Thanks,
