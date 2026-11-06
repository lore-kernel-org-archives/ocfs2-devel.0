Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975124;
	b=KTCjBdoU3DoOQRehxNZNrvhO0uxOHAj+BSu9ARrfEvIHv6uZh75alTyhpeL1RdHFnshq
	 8FtwsCW/CU9OwPAIjzUKEfdp5ppmdE+KNZXePM6Bs4pyPGGZM0SRg5T0Pl5nzwWDQLzUc
	 3KDuzpRsF8ag1wUJxpD/g1ZTH/7RMdDYjh8DIRB+0iQa8+BwX37Gubv+nGCf81Exo2aSt
	 9tnUatZqifssLxjwQ4YzampTgZfy8Kup3kdvUHBvkgdq6r8c/kZ4L741XZe90hvVUO45B
	 ccXUJcM5BStWCCvSaD0knN0Ndr6Z56pTokQG7MfN+v14vOVxLkzTAtsEPzyfLmMzCwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975124;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=8GouyKlMnx2BsF94DlpxLAYRdV88m16A/IUWMHdfZhQ=;
	b=hCf0g59Mjnu60XWgzZ+9Zotpn2b6nSspXWw2b5iiwUmhCPucotA1sr/l6r7HCyJN8BWJ
	 1ijOX5XuRw+uwssBZn7bz7FcPeYArCGZYC+K05kdrDy6qY2EUECrh3yQzIUVt6xCTAadu
	 r6vgZYF5CLlzsIKtZWAtI78bX2JEV9E+WTNgJ4dF1RAevWZ1zz9RmFpNUfixbf2Ofo0Yk
	 Xeg3unGn8XrIMV6woH53EchBGMzXpD5L0qui+lq4AtnOZosUgfSeMLlzyo9efhjgL4z4a
	 0m0E+ZIISQBXLJ1/tM92Ykz9NlBLFBdcpczyAYZs52uNLDznQEnJnHtZPA8JV38UmSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=gfPhPcBi;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D809606A333
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 14:25:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D809606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=gfPhPcBi
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4af520023fdso1692005e9.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 06 Nov 2026 06:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793975122; x=1794579922; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8GouyKlMnx2BsF94DlpxLAYRdV88m16A/IUWMHdfZhQ=;
        b=gfPhPcBiX975Svk0b6jczXyWZrFhkNjAkE/kfL1GxErN8WEPIbPKKwP+no22+cEGUs
         IMoP7cQ/rPEbc3y4v+c94zWAOFP4sbd9qrFh80gZjibKW5pQt5zpk3eeCeKkDGpWRLZI
         C5ulhsWLJqTBQr9xgxv8AlrBV39K49Hxxgnzwy5KQKZ17LkCh5TIMCxH5YGK2dvpU5WY
         IA9hvACGAs6U3eZ1EB0VHh1bo21rkvfQvhuGlMW7t176AE9Cnap/agKRi/GMawV9d9g2
         fzeKDzdckxIzbCw4FKlNQuW+SxeO1mmRsCbeLbB3bO0QePLzFtjzo/7WGjCatQfUQEPH
         6h+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793975122; x=1794579922;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8GouyKlMnx2BsF94DlpxLAYRdV88m16A/IUWMHdfZhQ=;
        b=WU0j4jXeqhSlEilQqa0ZQKdMkmNbeOYnb2puCx5EI4uT8cLlBuL5m9xcx9+bqeAbwa
         xs7vQPVWqybuJbPHmcL313EYpSONjIn3OVOf3OnJaoFldNJy6/3VcXTMuyf54sEpVQ9h
         KxDWEiQ58Bb5Wli3+oKaUEXPEER9ykHspJaY2xe/3F9dkNOxBUBGfqX8394BQPuf3jQq
         BxoCIFETcyefqaxGk51oyTKAXLdX9VVj+UldSbOJFzzoka3kjPgeG+VvxvZ6m8UDe7Y1
         14fjHDqUnEm72hAi7suZgpUsdWqR6HR7a6jySmWurrS1U0PmEj9917hNou/cy79r/tJ5
         QLhA==
X-Forwarded-Encrypted: i=1; AKwUvByIMK2TSTYntot5i1YAYttcZMpiNzbP9bQv6WjPg0WMo92urxJDikpnjZbiWU/5UW6UfmrDK+BnxabyWw==@lists.linux.dev
X-Gm-Message-State: APuU4Z8Z50xRVvszNkQHY26KaAu65iqmMaTYpv0QbJm3qnTfpvE6m6gv
	yHD4tQowyaoPVtdR8nBdxSVWIY/BZPNAoglZnSmKXzw81LwZCJ0S0tHP6rfE+6Ih+qc=
X-Gm-Gg: AYBFou1sxVzWSZvZsdu6bDy/GFGKzpTH0UPrOsz7ucHBh6S3NfBepQCnBY/hC2fFfKk
	OL52MkLwtnTGrhjikOHsOxGIVfOvC4p8ENke9ngL0ufQUOKkrDC20aaUIxLTkIS2cin3bNLBo4d
	IyXpyXzGJXpHFqgR+5Hgm7R3CQLZoEYZ9fR91ETVL7Vi0ec5x/IUSCNKKGX9YtPAVER6dEL/ABw
	i5+vHv+m9xDs8vkLFq7c+cTw8MbIFNCkY/5IspNe966ZtBRO7+7RhjRrQno1332AGwXJJPblV4o
	sikWquUSnzF/+ekghPnXMc2zZzRG3id2m/sbFoy034RcZGg9zSV78Mlwtm1BQbR5VZLqV6hgu+n
	pmsTfAZ/uoFki3tVFQLJsFTPFWG/jFO+xBS9yoBIvOrgryr8BiFgYWx6Jzyztqa+mY5eibSpLGj
	UJdrVJYS6sZmn2e3hfb5fY54Pm6WD/ivfQMJ6k89H8k7V0y8DmFbZEaQRF+EyEdhJqm58U27WzH
	F1DDKPFmvX5gsXcj5nm/BcLFw9giSnWA69NkH861biiD6BToKeIqIRUXQsazvs1KMHjXOuDARkA
	7mD+65oDPZEJhxam1M0=
X-Received: by 2002:a7b:c013:0:b0:4b2:3c81:103 with SMTP id 5b1f17b1804b1-4b6dd268bfemr35458095e9.2.1793975122127;
        Fri, 06 Nov 2026 06:25:22 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4c41eesm10090608c88.15.2026.11.06.06.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 06:25:20 -0800 (PST)
Message-ID: <f6960191-2490-46ec-b44f-b5f92c2cade3@suse.com>
Date: Fri, 6 Nov 2026 22:25:13 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 3/4] ocfs2: switch dio write path from buffer_head
 to iomap
To: Christoph Hellwig <hch@lst.de>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261105071930.16399-1-heming.zhao@suse.com>
 <20261105071930.16399-4-heming.zhao@suse.com> <20261106105212.GC5746@lst.de>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20261106105212.GC5746@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/26 18:52, Christoph Hellwig wrote:
> On Thu, Nov 05, 2026 at 03:19:27PM +0800, Heming Zhao wrote:
>> Converts OCFS2's DIO write path from the legacy buffer_head
>> infrastructure to the modern iomap framework.
>>
>> Key modifications and designs are as follows:
> 
> That's a not very useful style of usually AI generated text.
> 
> If a change is not key it should not be mentioned here.
> 
> As should "modifications" in general - what is changed is pretty
> obvious in the diff itself (and if it isn't it should be made more
> clear in the code/comments).  So what should go into the commit
> log really is the high-level considerations, pitfals and not quite
> clear bits.  The rest is just unhelpful noise.
> 

got your meaning, will revise the commit log.

> 
>> +static int ocfs2_lock_map_blocks(struct inode *inode,
>> +				 struct ocfs2_map_block *map, int flags)
>> +{
>> +	int ret = 0;
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> +
>> +	down_read(&oi->ip_alloc_sem);
>> +	ret = ocfs2_map_blocks(inode, map, flags);
>> +	up_read(&oi->ip_alloc_sem);
>> +
>> +	return ret;
>> +}
> 
> This pattern already showed up in the previous patch, why isn't the
> helper added there and used for reads as well?
> 
> Also this and the next one have a very similar diffstat.  It would
> help reviewers a lot if you merged the two patches and did any pure
> code movements in a separate patch, so that the actual changes stick
> out instead of just adding a wall of new code here, and removing
> lots of old code in the next one.
> 

I'll take your suggestions into account.

My intention with this layout was to let reviewers side-by-side compare what
has actually changed between the new (iomap) and old (buffer_head) paths.
Since ocfs2 involves cluster locking, and the buffer_head path has been
running stably in production for over 20 years, my current approach is to
preserve the existing buffer_head flow and logic as much as possible,
introducing only the minimal changes strictly necessary for iomap.

I plan to leverage advanced iomap features to boost DIO performance in
future work.

-Heming
