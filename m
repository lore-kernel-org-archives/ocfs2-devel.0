Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3243C22A4F1
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 06:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760078597; cv=none; b=FH1Cd/qWldWgm1DPMOyWOFtb1IRO1NSBX33r5EYV1zvpLWwQpiGclBnRF7PI/2a/1w/3UsYzlaeK+KkEv55A8WN1XvyvoTs80lob1b5sJar9LDrR5yS/YFd7gFkJCVrU74wECgg5ONc0yUS5wQqpDkttdLsq2noAwiXwQ0A1rMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760078597; c=relaxed/simple;
	bh=B7SoXFrD9L7+Zmm9R0gizI3MFxfyS9dKilEpIsgLzD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g4WN2kE95KXkVvzm9NMtLpU9JhAZgfatPLaKfAFe/rpXN13xMfNxaAWITKjPYWbBBK/xg/arxDRHLjpdJjge0qa/ZceGAqh6rJxrM977fGFnA1cd7OdveBpSrEEBVRx7QE3KavvHj66bcmujY0J+Ew1IeC7UMxD+nOqe8w/nxm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fQHUxBxl; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fQHUxBxl"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e38c21fafso3124305e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Oct 2025 23:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760078591; x=1760683391; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ocWnJFzR+tmvOpUsLEWZEP7yhcUcuubFz4MWAWlyuYY=;
        b=fQHUxBxlqDKjoQ3xNzP4UPkPX5KqkhaN/5c7PP+nmJPmj5+Ov5hvWeciITEfedNAWF
         gpVUKCTuqifMFvdmMSTyNYUlxJBYXpvCy0xx2YWd9diuXZ11dLHsBt92tMYIdiALmZ/d
         Kuyh+1/yyRqU/x+FqBqUbjNZ70gGTV6XFQj0/4C5dDWuAg286MBhOKmr10Uh4hn2TF1F
         sAJbg8s+jP3UybnOrjD3znt4r2FRAlU8+uVJ7YxFdZVF9DlyJYRVxvQSNqvZoXqg4Awx
         LOy/bm85DPOtKPIGZbT40S9g3Fkho8Aa8XU43bg5EQE4oe0YYd6lH6FVvNknIxtwX8hz
         WUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760078591; x=1760683391;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ocWnJFzR+tmvOpUsLEWZEP7yhcUcuubFz4MWAWlyuYY=;
        b=qPkNKynjDqSHaPVYOSVUqvAAzK1zEKziSNfUo8tEewa0uWY6jgwe3FNoYkybhmWHBJ
         T3d0SQ4hFDVPm3W+LoYTtBkm3eOaNNIiLAQMTIZoGKkeAjCbAaQiYEy9dK2Wi/Cs0m79
         HF9ODsGBHdHfndVPckQx6BT4OJHOARubqUJErHmf4zGAUFJDC9ffC6JOzD1wlUOROkt2
         nqUZLyiunDXicBvBhEUnvZVHtrbryJAc4ktcoVa3x0+AldCWsf4gKmZs+Loz/aQUtnBp
         +DXfRfygX16LTv/XiVKY2CVCUOkzQ+vGMVLbjKh2uQcphIdjtNt7EjG7pIzRCkkDQWnm
         gU2Q==
X-Gm-Message-State: AOJu0YyCZ1GtZclvb/ycw87nd6EmRsGw+3zCDSWG8VgmoWrIuPw3Jyeq
	KX6FgjnTst0EnGcK3ojN+p+BUr10wUMtvzhzoibIBP8Qus/bk25ToVVkViorhRPLTbI=
X-Gm-Gg: ASbGncuhXlQJQBvN8KTGy38TB8ZCsX7y+MVBnwzwO4fpdm4llPFixVLBipsOA9D6jZY
	oXNMGDDyJG2yyLglwUZ5A15l7Aj5+z6FatL0Ynjm0LhONZmYsvcjO2RrzQxKKNtNvD79ousvy6c
	b7O8V8Y47D7SPEUWaiex3W5QTlDnJXBuRUlkztmLjq9pX0l+qBknQ/47Et5D9ItCKlh1NU114vr
	FawYNHFq5UqC8ZtQk6YHG1OU92eSDwuBwXpsqhnS5cJUcRgXwbhXEnObovokMZ4Xye2qyqg5cEm
	ml46n6+ZzWoMYjhSl8O5myMNQIW0k8CzvlUb11lIxoq3GS/1NJZOeK2LQid3AWXGCl5KjGfNnaN
	Gjq34x1Ere/tiuMWO7e4ECt6y5xaTWmuTJHfbHkHW13mihE0t
X-Google-Smtp-Source: AGHT+IEtqDr4A1Hq1BhNAC7x1TNDcSDLtY2xVdIWNrksPd597pl0P0a3TBaMJkw6NR221PrreHchoQ==
X-Received: by 2002:a5d:5f83:0:b0:3e5:5261:7ffa with SMTP id ffacd0b85a97d-4266e7e2ddemr3790800f8f.9.1760078591375;
        Thu, 09 Oct 2025 23:43:11 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de658bsm47593555ad.22.2025.10.09.23.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 23:43:10 -0700 (PDT)
Message-ID: <7398fad7-3727-411b-a648-bfd0ca915f82@suse.com>
Date: Fri, 10 Oct 2025 14:43:07 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add extra consistency check to
 ocfs2_dx_dir_lookup_rec()
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
References: <8af5355e-5a05-46c5-bee6-c7ed3de71c0b@suse.com>
 <20251007094626.196143-1-dmantipov@yandex.ru>
 <93f3ef3c-0363-430b-acf8-db70bd4a4b16@suse.com>
 <35fdecc4-39f3-4f3b-b1fa-95c9a8134f18@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <35fdecc4-39f3-4f3b-b1fa-95c9a8134f18@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/10/25 14:36, Joseph Qi wrote:
> 
> 
> On 2025/10/10 13:53, Heming Zhao wrote:
>> Hi Joseph,
>>
>> Do you have time to check my following comment?
>>
>> On 10/7/25 17:46, Dmitry Antipov wrote:
>>> In 'ocfs2_dx_dir_lookup_rec()', check whether an extent list length
>>> of the directory indexing block matches the one configured via the
>>> superblock parameters established at mount, thus preventing an
>>> out-of-bounds accesses while iterating over the extent records below.
>>>
>>> Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
>>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
>>> ---
>>> v2: move sanity check to ocfs2_dx_dir_lookup_rec() (Heming Zhao)
>>>       and rely on the convenient ocfs2_error() to handle error
>>> ---
>>>    fs/ocfs2/dir.c | 8 ++++++++
>>>    1 file changed, 8 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>> index 8c9c4825f984..ece0462a5d26 100644
>>> --- a/fs/ocfs2/dir.c
>>> +++ b/fs/ocfs2/dir.c
>>> @@ -778,6 +778,14 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>>>        struct ocfs2_extent_block *eb;
>>>        struct ocfs2_extent_rec *rec = NULL;
>>>    +    if (le16_to_cpu(el->l_count) !=
>>> +        ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
>>
>> el->l_count represents the length of the array l_recs[], the max value is
>> ocfs2_extent_recs_per_dx_root(sb). Therefore, we should use "<=" instead of "!=".
>>
> 
> In ocfs2_dx_dir_attach_index():
>    dx_root->dr_list.l_count = cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb))
> 
> And the above path is non-inline case, so it seems '!=' is correct.
> 
> Thanks,
> Joseph
> 
> 

Totally understand, thanks for the explanation.
And this patch looks good to me.

- Heming
