Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F099278753
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 06:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570278; cv=none; b=Tb19Z+GXk3FWsjc0KAxpt8JjLL2d+5iZBHHLPzcUJLoqgf+5wXCkWfiIuU1CXNCdsyKhroJjZEfom6zsBZ7HrKIS78pira4kjLtJJqWR+AzmaXj1BYzILWjRh3fUWmJy53fDFVvTRcvBPMjGGTzXTJRL8RjnB7P90xfMfnATfAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570278; c=relaxed/simple;
	bh=2io+coGsPXy7Rc27r/JqPO/Zr9vIFhBw2CPH38P9x0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejX8nLiiBeVAGku7co7qmdbcL5MhaG+zi5C7X7oKxCjYAVV3mEk2H255ha1M2j1SVRcjcRytlg05KBa9jouAG/PEmHcd1ApiHuJzS6CeiPd4Ktk9uxzGOIf0oWUDvF6m06aRI5aQh8i+7liv+dQMXMI5YoxRgtZIRofyKrl5xrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AHORUXbe; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHORUXbe"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3418ad69672so2376439a91.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 22:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764570276; x=1765175076; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=peAT0TtJ+zmGu6HEzqEiByNE29w1TbiVx2+7wH8lyF8=;
        b=AHORUXbe82ZSY0coQu7vt58t/G113W9/C6fX9T8vo4/2RVE60cMQv5p4oDDrA8IguF
         XpknfKq/xlg1KiVs0UjfbTHZbJU3cpRj4W2FCSNExPC5vXysCF/nwbKJqlk7j1l7Py7m
         XKMCmgh196GpfEhiOM3Hhuan55VKx2xGjjdpDj0scNvyI9yBRaKKM7UQFBLrtAOTwkzI
         TFbyj29ITLySsGWh4pC/K1zN3ciyzIKsyi5dukmdnsImSBrqOa+KQmYNAC12pv0KC2es
         EJ2KBYxvaIpG205zqwME1HArQEotQncupX1IEfo8n0JIxVV5oQ+Fm4TxW+zB24i08yec
         9mrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764570276; x=1765175076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=peAT0TtJ+zmGu6HEzqEiByNE29w1TbiVx2+7wH8lyF8=;
        b=Iq/3i1RmbmSCbO2DUQK96FYb1cB3RdbBbxgOYkqyRW8U+VvS0K+KWnhd4JDnZdBAzT
         Xi1JCJ6W2+N6WmABdvneqmUB5K6Cirk9gYfKd4XlQQy26UuZxuPUvllmzajs4es/qig5
         o9ivHbDKqHQpXKqkAI44PYDFyAtx6f1P+Hbs6sQg+nT+QFytdX/cF0lZaGay+2T9gM1i
         mNQhOdl/En+qNqt5OPPJtUxqBHgrfll2Cs7jgqw+Q7lkNMdrI02a61o95dkbz9LdLCMA
         NY3CGopUwTdUfL5gyrXim1SQwbhsRdpl6VyMF8ABim1Fem0Zkf0eqHNqX/lBTtN2XVFU
         Wvvg==
X-Forwarded-Encrypted: i=1; AJvYcCVBGCTUQrkSRYbnEnWZlb0mHPp0t2VsPHUAeRdCkKDGMYDS7uvDbTBeFnn5fODkw0tGBW9+zPTN12i6pw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxKReLF8suBA6vlaIrwJdVxKBZzgftY0ERL6OYiHUaH5K//iMWX
	DDFR2X0+dI2KxXXRNjx3t5RPYylUxcDskGf+vy/knbATbM9UHVSA96Z9
X-Gm-Gg: ASbGnctfLoJYz42F2XFgKZnAEY875Mj7Ubf/wn1TuVWU/GjiDL/LdHxDEKcUtTmEyul
	bGX+DlUxlhahXmnHW7cUv3UzLJCwOJGmd+M+jXpwDTF7Eu3w1ffVKwlEP3yxenpfVNiny66zPmu
	Pv/+88Q8fVWN+kIoQnwqhY0OzNQfujhXOpIonTn9vtu0+2w3D5mZjR8/oKJQ7Bj4w4tQ9SsCXtn
	bTjxIHmZuoj9srVR84WrgHtzWQ6rBMaUW2hcSSpbgSt4FlZpZWK3lXt4Ch83125GJXMyscLFyu0
	M6LuzZmItKND+qlGMoeSuo+RWo5imf12pqkpRoyvXL8zPYqkvjy6BkGDh6qpp2mX08fR81/uafa
	Qs21JAH8dJw1Roy+98Lkbii28O0tIuPpilXkJDeOpRw+6iHtgP8/vCN7lbXfjwt5imLQfM384dd
	pjom8C2gc2HQ==
X-Google-Smtp-Source: AGHT+IGNMBL8zDhRobd+qHrdQkwX8FWvtMRKN8hXCxfnIN+ugTut4kAT7vSMmoOejqWih8bkdISh2A==
X-Received: by 2002:a17:90b:4a08:b0:336:b60f:3936 with SMTP id 98e67ed59e1d1-34733e72342mr39442424a91.12.1764570276389;
        Sun, 30 Nov 2025 22:24:36 -0800 (PST)
Received: from inspiron ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm11828072a91.11.2025.11.30.22.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 22:24:36 -0800 (PST)
Date: Mon, 1 Dec 2025 11:54:28 +0530
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Subject: Re: [PATCH] fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Message-ID: <aS00nMK1juomYZkN@inspiron>
References: <20251130104637.264258-1-activprithvi@gmail.com>
 <6d27a5aa-1e32-4dd3-997c-ddc015be88a3@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6d27a5aa-1e32-4dd3-997c-ddc015be88a3@linux.alibaba.com>

On Mon, Dec 01, 2025 at 10:51:49AM +0800, Joseph Qi wrote:
>
>
>On 2025/11/30 18:46, Prithvi Tambewagh wrote:
>> syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
>> `cl_next_free_rec` field of the allocation chain list is 0, triggring the
>> BUG_ON(!cl->cl_next_free_rec) condition and panicking the kernel.
>>
>> To fix this, `cl_next_free_rec` is checked inside the caller of
>> ocfs2_find_victim_chain() i.e. ocfs2_claim_suballoc_bits() and if it is
>> equal to 0, ocfs2_error() is called, to log the corruption and force the
>> filesystem into read-only mode, to prevent further damage.
>>
>> Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
>> Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
>> ---
>>  fs/ocfs2/suballoc.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index 6ac4dcd54588..84bb2d11c2aa 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -1993,6 +1993,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>>
>>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
>>
>
>This blank line can be eliminated.
>
>> +	if (le16_to_cpu(cl->cl_next_free_rec) == 0) {
>
>Better to add the upper limit check as well. e.g.
>
>!le16_to_cpu(cl->cl_next_free_rec) ||
>le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)

Hello Joseph,

I went through the code in fs/ocfs2/suballoc.c, like this function 

static inline u16 ocfs2_find_smallest_chain(struct ocfs2_chain_list *cl)
{
	u16 curr, best;

	best = curr = 0;
	while (curr < le16_to_cpu(cl->cl_count)) {
		if (le32_to_cpu(cl->cl_recs[best].c_total) >
		    le32_to_cpu(cl->cl_recs[curr].c_total))
			best = curr;
		curr++;
	}
	return best;
}

and in function ocfs2_block_group_alloc() these lines 

if (le16_to_cpu(cl->cl_next_free_rec) < le16_to_cpu(cl->cl_count))
	le16_add_cpu(&cl->cl_next_free_rec, 1);

and observed that according to the architecture of ocfs2, the chain list is 
in the form of 0-indexed array. In that case, the change you suggested for 
upper limit, could be re-written as 

le16_to_cpu(cl->cl_next_free_rec) >= le16_to_cpu(cl->cl_count)

since value of cl->cl_next_free_rec greater than or equal to cl->cl_count 
will indicate that there are no available chains. Can you please review this?

Thank you,
Prithvi

>
>Thanks,
>Joseph
>
>> +		status = ocfs2_error(ac->ac_inode->i_sb,
>> +				     "Chain allocator dinode %llu has 0 chains\n",
>> +				     (unsigned long long)le64_to_cpu(fe->i_blkno));
>> +		goto bail;
>> +	}
>> +
>>  	victim = ocfs2_find_victim_chain(cl);
>>  	ac->ac_chain = victim;
>>
>>
>> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
>
