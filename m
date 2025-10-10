Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E09E285CB3
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 10:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760093872; cv=none; b=CMZRpH2c+nxRwjvB6KTfqX+DsgTqLka/7JnOsTCtqZPor70UXjL77xp6H27WtNC32MlbZcDg4WwCJOqA6O5xHQ6GxVRChWFy/WMDy0qwuJmRmuO8HqOI33Y9HtyQgqnMvYt2cTxy5eI2dySrkLJup2KqAbkqhM9NR7DSgtRMVD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760093872; c=relaxed/simple;
	bh=Wj6gIulUnWvXeom/CwN9VPxLwwy0g/kXOyBAVF6Z6E4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zly36Eei/szNnpW91+UXHmekXUK5E2wTjHCE6lR0HZvwLIXQgMx0if7EhD7WuZchupcEiCVQOeVOIXUzn14Y+iq8Tc86rX/+knn/F5zbQU6JIvEiS9W5q3x6e1qp7VtX1LqyophljXGbs6pr6d1AiBRsaM8grXD95ZAi264ODTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A+udyNQk; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A+udyNQk"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-40d0c517f90so94306f8f.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 03:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760093868; x=1760698668; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lkJYMaS4IIIM0NFGrC+10wt100uN/dM/19JwM1lNjto=;
        b=A+udyNQkyTwEPsbwPHty/ZyyvbWnI1FUnx2d+3RzeBRYg7JU20qpq81YZp/rfjSZym
         BMThcIDVoVxSXp0FN6ewQrpfydLH/DxPUQZmwlB/+tljAYaJRMpCu308spYj5nHtCKJt
         8GCDc+v48BKkD3Ve6Wf+HVuhnlz2QqCKRyeoTwi0eph50ffAyQhbUJtMmp8ouPbtfFRS
         myQvOqwODpUOh62vf3dFiMp32J6dG6MFVYqtJMvjOPoXsduUnJ/ei6ybnQWUvF72qXOP
         lb/kEiNnRRv7dbhfF8uaWUyu//8QdhmYFCDpCsx/lnxGwhZVUdYZIGHuxlRJNu3s087P
         qhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760093868; x=1760698668;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkJYMaS4IIIM0NFGrC+10wt100uN/dM/19JwM1lNjto=;
        b=fQAMCtuUiTomP6uGFBkz629W9pFJiYBGCy/E2WiC811CzyGiPUzQmc09Etny7CGyWo
         465lc/U687KWKNHxhwEq3pRPC8kYa2XPcRVLQLM9oMFMu98osNM/YFKSqJih+0luIx+O
         J9DzMtsx8/oWfv4FoetjNTkww/ojrcRm8HxpTEPtX2DXvTdUma0Ac8brc/RGourr6100
         Avy0MUIPK5IcJKmAU5ez1L1gtQxFoVfnMBSDAcxakHW+yENb5PRImvbD8y93gR3LE4m1
         5BL+jBoxdQuzvKEsbtMxMFXEM1hIHU1gnrxGNcU0TJ5qfiqgWW9AQ8ML9EVr4wnQOo0Y
         9nmg==
X-Gm-Message-State: AOJu0YzPgmQnEVYHhg7XGzGLdkGNbxPeR02x3uURaFPdwsz2R6Hwem6W
	M/FrWTivf1pSpBXW1Y+BqstcCpSKej4Z5fl4l8UWk885ESvKS5wo9H2dFMvp9pVf2Bc=
X-Gm-Gg: ASbGncuvBmr84xnfnHKy3aJXamK7NQcfrExGmNGNmWigOGS0cilA/u0Cp6ge1drtJBM
	HQMN5cjMKI0p8LK91XAq9lQE+OhiYdALxqc+W7pmchomGyGVQ0Ej3tRAFxVVI4OqBrvJXwydc29
	wlpBTMm7Y+URgv1EPnO/26119athctE5ofO8g/9st//GPTix+r1r7BoQL3ZrNjxO1DyeLbP/EnV
	l4XHKsR6jRp7YPCBd8oR7obfp/IfFsIloFd7Lm6PM0s30qiudpd04maShzWYtXE5D4AKNb6C7PG
	9ofFEoUhlr620ekMuIOrzkThVnroCh6agGL5NBQFQ5wjQjCqXa4Mn62ru1pzmcLD1MrLQBQWOVJ
	WWelqbioR1tAXOx0Uil6Al1Cj2/7h4nlqDuoA+f76wKqF3IwN
X-Google-Smtp-Source: AGHT+IGqkBLD+8rpTBVVL+GOA5QHMWCFwHRplTKp+D8cB11p1dvYIurUXeXdCg1cZRbObyX60Cpv3w==
X-Received: by 2002:a05:6000:4012:b0:425:6794:77fd with SMTP id ffacd0b85a97d-42666ab5d64mr4389518f8f.1.1760093868476;
        Fri, 10 Oct 2025 03:57:48 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678df4cb51sm2038530a12.30.2025.10.10.03.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 03:57:47 -0700 (PDT)
Message-ID: <a2e3cbfd-3121-43c6-ad2f-7faa30236278@suse.com>
Date: Fri, 10 Oct 2025 18:57:43 +0800
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
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
References: <8af5355e-5a05-46c5-bee6-c7ed3de71c0b@suse.com>
 <20251007094626.196143-1-dmantipov@yandex.ru>
 <60ee8e1a-3e06-4b9a-8e2f-bd3f81331732@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <60ee8e1a-3e06-4b9a-8e2f-bd3f81331732@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 14:54, Joseph Qi wrote:
> 
> 
> On 2025/10/7 17:46, Dmitry Antipov wrote:
>> In 'ocfs2_dx_dir_lookup_rec()', check whether an extent list length
>> of the directory indexing block matches the one configured via the
>> superblock parameters established at mount, thus preventing an
>> out-of-bounds accesses while iterating over the extent records below.
>>
>> Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> 
> Looks fine.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Looks good to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>> 
>> ---
>> v2: move sanity check to ocfs2_dx_dir_lookup_rec() (Heming Zhao)
>>      and rely on the convenient ocfs2_error() to handle error
>> ---
>>   fs/ocfs2/dir.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index 8c9c4825f984..ece0462a5d26 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -778,6 +778,14 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>>   	struct ocfs2_extent_block *eb;
>>   	struct ocfs2_extent_rec *rec = NULL;
>>   
>> +	if (le16_to_cpu(el->l_count) !=
>> +	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
>> +		ret = ocfs2_error(inode->i_sb,
>> +				  "Inode %lu has invalid extent list length %u\n",
>> +				  inode->i_ino, le16_to_cpu(el->l_count));
>> +		goto out;
>> +	}
>> +
>>   	if (el->l_tree_depth) {
>>   		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
>>   				      &eb_bh);
> 

