Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C36FB8
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Mar 2024 02:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710469543; cv=none; b=YDe3TOnXM61AQHuiY6TOVhxRfR+oJeZa4Vg7EO31H1weQcAk8J3OtFxzj8uE5KzTe9wYcUWOy8heT4DtO5xD7stlMAfbaJM2NUrv+GABXevONIPO2Vr22onmA84n5PYg0AgeKCdnQdJ2bouZmILkWaNDx7Qcq+e88UZcAEJl07Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710469543; c=relaxed/simple;
	bh=ijauEB2Mw7/cSJvMKxpqNNa/u76n0C0z0miA7zZrKIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KMU1GVm0oK9DAJ/tjA5kVhyaoUrAV5goDoLeoysvIHpkB2TjfSQOtvXWXt23Q0IVQ7f4fq/NorhEfXpiWZKDM6c1/xEujNBa3C9vF/VWHFNu1E+/m94CuWu3lB4mBIX4ExM6mOSdsJZ4pvwgzO2LqTnqkNi06lxB3yjt861aoEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JRIbTHiJ; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JRIbTHiJ"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d46dd5f222so17149501fa.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 14 Mar 2024 19:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710469539; x=1711074339; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fx8WRKEqE3B238z20fBiFAB+X/UnLpVj0EzWsx73EUg=;
        b=JRIbTHiJE10XQnzs3SS/BR3Njpp2jsyNiaTm5QTVld+Yy24oXE0NtsDeS0BEYWRWl8
         8k8vasC1DQUsjYjEoTS5iz4VVqd9M3sSd+6o17C752n/Pt5lrwtvdkuwgu06+Ho6CFA+
         6jNtJkgk4eOpHQmiFNC/DOlQXY0mdwgBxEWm5sgCJStBFHUk8DmdH5XcNLoeqbU7wrlD
         HAtlV9XkcsqQOkSQESAKt0phtvUk6q+A6WFX2eOHj4vV+k6iCKLNEYH9o16D1u0IbExl
         s270+mbQMfAHSfBuRSTWsXBb53BtaUw60Usoi7H91IVBm2ouvOwIXyUhVRqj+4dBmAAc
         5Rhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710469539; x=1711074339;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fx8WRKEqE3B238z20fBiFAB+X/UnLpVj0EzWsx73EUg=;
        b=tnAsOffojETnzL8Ct0pK+JPnIb6+4ToZwM7sUCKvOO+s0j3SIwhEYLUdCu+rqukFNZ
         9i/Ze7A2YGR3lMan54MYY2znLepthxVgl7JRvdLdltebaGzzhZYtmiURqYv9p7y4iN2v
         q4+4UYLscpB7ECWj+d83qicgMPCqRadlMz4FBq9hwwCMPnc3GRcwiJTUuhBiDRK6Cw9i
         qx1Qn/gjbXQLHkWGuIV5tUGyhAv4h5i1N9cJv9szDSuv/SKZw2xIWkeHDDrLpDVoLddi
         iKx5GCUYGZ8CwYWvxkgkEKv9n25uop3e2BvKtxlxVY3l1R7nhKMK8QgZHbnP7ldMT48w
         MHYg==
X-Gm-Message-State: AOJu0Yxm9FpSWTjqhlp5dIfDWNMaAjMCB1PxPFsOe6lfl5hf8dlGehhZ
	5JxqLwfU/0OkrTABzdWVGU7SksyRsZIfYY6swQTE2DGG4TtAFx2hE3HVmPR7CX4=
X-Google-Smtp-Source: AGHT+IHZbO3AeN8SpLur3It/n5+NSTx/tOfA7f746N1AuOruxPA/tjm2r2Xnw23sulZXnpJl0zHnTg==
X-Received: by 2002:a2e:8645:0:b0:2d4:51f4:dbee with SMTP id i5-20020a2e8645000000b002d451f4dbeemr2275622ljj.53.1710469538653;
        Thu, 14 Mar 2024 19:25:38 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d1-20020aa78141000000b006e631af9cefsm2249804pfn.62.2024.03.14.19.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Mar 2024 19:25:38 -0700 (PDT)
Message-ID: <306d79c8-f327-4c34-b103-a59d8ca87567@suse.com>
Date: Fri, 15 Mar 2024 10:25:35 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix journal protection issues
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20240314073353.11489-1-heming.zhao@suse.com>
 <1e0cd8fb-ca1e-4937-bdfe-333284569425@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <1e0cd8fb-ca1e-4937-bdfe-333284569425@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 09:09, Joseph Qi wrote:
> Hi,
> 
> On 3/14/24 3:33 PM, Heming Zhao wrote:
>> This patch resolves 3 journal-related issues:
>> 1. ocfs2_rollback_alloc_dinode_counts() forgets to provide journal
>>     protection for modifying dinode.
>> 2. ocfs2_block_group_alloc() & ocfs2_group_add() forget to provide
>>     journal protection for writing fe->i_size.
>> 3. adjusted journal_dirty scope for ocfs2_update_last_group_and_inode().
>>     This adjustment ensures that only content requiring protection is
>>     included in the journal.
>>
> 
> Any real issue you've found for above cases?

No. I just found these issues when I was reading code.
> 
> Take ocfs2_rollback_alloc_dinode_counts() for example, it will always be
> pair used with ocfs2_alloc_dinode_update_counts(), more precisely, in
> the error case of ocfs2_block_group_set_bits(). And the 'di_bh' is
> already dirtied before. Since they are in the same transaction, I don't
> see any problem here.

Yes, they share the same transaction.
However:
In ocfs2_alloc_dinode_update_counts(), there already uses a jbd2 access/dirty
pair to protect metadata. In my view, jbd2_journal_access starts the
protection stage, jbd2_journal_dirty closes the protection stage. the rollback
function should start a new access/dirty pair to info jbd2 the di_bh had been
modified again.

-Heming

