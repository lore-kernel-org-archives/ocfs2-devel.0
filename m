Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192A4134AB
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 11:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761045178; cv=none; b=jnRHj5x2AYY3cp02CZhnPed8qYjcRIL5Hi4tXl2qGajj3xd1ev18TB1qCJ2RPdNE4O8Kz1IiXdHHz/I5lXxbHKk3d8mBHs1mDpey6zcYztHln/GmpTSmVepO2G5O09zxTy9R6uRnS7L4M/ySe5rkpTN1PAqBwYZMOubyJFAKRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761045178; c=relaxed/simple;
	bh=kfpy0fP5ZVwcVWbbW6j8M+HGke2Ms8OPeYuV7YPtDaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VZo4Ywl6l20CaiZrtyO3hSYKG05/gsAmJ6iDIBYhD9FIU9YP4/t0dFcdVLPcBkXfI7DMMrC0vlVghVQ3jmg01Ni1mJ9RAvnRYOHVWV8SWpnDolo53yiG+JraCnxxiGl2hr0I0jEGyk2Relks47zhtPvxw3baVXfiVsHOpbuakk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LdabE4dn; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LdabE4dn"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-426ff579fbeso663520f8f.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 04:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761045174; x=1761649974; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qJVobrAwhPq+w8HOxKovKYpgiDkC8oThtEd167Yqc2A=;
        b=LdabE4dnkkzC+cmsIgdq73BKs0ArH4nSAZq+NnatrjvQAPuOfnjYE7izvtLcHgmQNn
         Omj8VgznkiUAkb8dNQ+EPyuXrkrG6q+Jk1CKu8+f5DRrMa5Emot5s9Y0ZESR7+mOjWQR
         DoVdkowvbEtAfxBvUUQtHnF4EKE29Z7W+JeVqtbxWD667HzWM3tTx5eFZ0W2niyl0w8k
         9Vz23bavp0lS862FAdBXhoY/NZYaSCh1thI2lSvv3QkurypYD4Y5+Gs+N5cPgb8ue2Er
         Nbk/vEhxScmv1UjvYxqJ5jazRxjF47law36M24s/WUNILueg5lTdgP1I+SzMDigSndwa
         lqbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761045174; x=1761649974;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJVobrAwhPq+w8HOxKovKYpgiDkC8oThtEd167Yqc2A=;
        b=Fbn8JOgsR+EKybOxDWXhfQz9JYU55mWNSjRYRyVDh7BuvGcnB5khtQpC6NXOoKAXMZ
         Xv/cB9b2JgOT+5qvSEuGD77JJT4uMVH6I3853kPUaFHSwhoUk/nwktTJsxMBS3gZ4h4c
         ZVRJWErNFB8e6LpIqanaPhCy1dOM2Nx6oa5/3Hy11KkITjm9drDTjNIH7nxcwg5dI2cA
         LXOxQK4ypPHlH1de+NSz6EoKz86mUykwZl/PjunPvU1WNhx5u28N9OJ+upxwpr3gYNjL
         k0Gmte/GqvW5R6SE1ll5LTUkB5BEVOiYPh4Hnqf4efVrGUUylmUHtwcGtZuQdg7735Zw
         o2mg==
X-Gm-Message-State: AOJu0Yzck6Xv1dfNThdKJNdfa6EeH3ek0gZl/ZLQEJsYGo3J8YECEf4n
	M36EQsvG2MnV/RwdY7beb4Efa62Y4kpa0mCCM/n3C1D+2ATuqVIS5uIaB4zIv2r3nNs=
X-Gm-Gg: ASbGncvhKn8BtmJ0QUqKti2I2TdMf4aL3+tJdVsGFT38uXbFPSpkbL7tPrcC3R3g6RF
	89QM/Gnp2kLG9W067G1QKj+Rj93K3hJcL7b8qG6HT1XHNillewYxgw5r/+a416osVG+OPoP+LBY
	cTKddhbpa3zCyG1svYbRs9mTBsGkAkqDJtH/sCWXz0/WziXZhLodMQOV5vwyHx7zlXdAgV4zoC8
	hT+efneFUtr8AN9ATv/Ky7QhcjXtmZRPYEhu+YuMcIEwyrrwcFYDTPYBT/XKVeNhrnnYsqOR+Tk
	XFklfAFmBIOm06QxhmPwX4qEkhJCguIQ0CZmTgToIgbddIYU7uYm6v3b3YesbIUW/3CiNolpxwa
	10xcXUlvtYwPC1O2t5klcO20LA1Jp0h+0weA/0sYyT8MLvHm6e3FJEd6CKKQ7LxOEqUZm9Q4Cbz
	KF8TLEL28=
X-Google-Smtp-Source: AGHT+IED9u+D9+7hzEwGTyYVyeg9qSOSFM8DO7X/rwdlO7Kb3lhlGG1mAhAERy02Q11OzKvudp9rlA==
X-Received: by 2002:a05:6000:2385:b0:425:6794:f19b with SMTP id ffacd0b85a97d-4284e542d8bmr1258958f8f.2.1761045174270;
        Tue, 21 Oct 2025 04:12:54 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fde15sm106477425ad.84.2025.10.21.04.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 04:12:53 -0700 (PDT)
Message-ID: <c68325fe-2d41-4db5-8567-4e91871a33e9@suse.com>
Date: Tue, 21 Oct 2025 19:12:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add extra consistency check to
 ocfs2_replay_truncate_records()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
References: <18c4bf1b-5860-46ff-9e55-71e715fafdf2@suse.com>
 <20251020150227.210267-1-dmantipov@yandex.ru>
 <5d5f0edc-1251-4c15-8d3c-dc3c8023a871@suse.com>
 <607750b2-c3a3-4316-8e4d-0cfd0f04e245@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <607750b2-c3a3-4316-8e4d-0cfd0f04e245@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/21/25 16:01, Dmitry Antipov wrote:
> On 10/21/25 4:32 AM, Heming Zhao wrote:
> 
>> On 10/20/25 23:02, Dmitry Antipov wrote:
>>> In 'ocfs2_replay_truncate_records()', check whether truncate log
>>> length matches the one comes from the superblock parameters defined
>>> when making a filesystem and current record index is within the valid
>>> range, thus preventing an out-of-bounds accesses while iterating over
>>> the log records below.
>>>
>>> Reported-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=4d55dad3a9e8e9f7d2b5
>>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
>>
>> LGTM.
>> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
>>
>>> ---
>>> v2: adjust commit message (Heming Zhao)
>>> ---
>>>   fs/ocfs2/alloc.c | 10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>>> index 162711cc5b20..143ce8ba6071 100644
>>> --- a/fs/ocfs2/alloc.c
>>> +++ b/fs/ocfs2/alloc.c
>>> @@ -5941,6 +5941,16 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>>>       di = (struct ocfs2_dinode *) tl_bh->b_data;
>>>       tl = &di->id2.i_dealloc;
>>> +    if (le16_to_cpu(tl->tl_count) != ocfs2_truncate_recs_per_inode(osb->sb)) {
>>> +        status = -EINVAL;
>>> +        mlog_errno(status);
>>> +        goto bail;
>>> +    }
>>> +    if (le16_to_cpu(tl->tl_used) >= le16_to_cpu(tl->tl_count)) {
> 
> Ugh, there should be le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count) since
> array indexing always uses tl->tl_used - 1.

Good catch. the code logic is same as that of verify_truncate_log() from ocfs2-tools.

- Heming

> 
> Dmitry
