Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F404772A6
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Sep 2026 08:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788856363; cv=none; b=dkSdd/TLjKnMqggZowwugIqbREfF5ZsndJR1v5bPfGMPN9H8x8Q+jFGKsaw7oJuoPgyFYNGO2/azCZ+x67iCRcDWxI/m/5CeH6DZ8fzcxgrx4rQC1MmUw/QwAQ3sPaYmm9l96zVPhcxJ94vUNpvSvVCsqYYDRwdayVZ3PINKnYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788856363; c=relaxed/simple;
	bh=E7eYuLoZleOAMi5aybzFXUMotlL4x/aHsP+MlHsKC0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hYIbYlfYTongp2DTp+PyC3HkJp0mjaQIVPiSOx0tMy32K0hDw7ySqQp8SSDeXiNUxikA6oMgY1cj5ZIIV+40airOcZJgrrk9/pf+v8O1R4Mt03rQKxxEwuDazHwCaWSleMRfoMHeS4ZVwDSzT8gOC+4sWI/UpxULnLDDf1EHPl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OtnmpG7V; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OtnmpG7V"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-484362f5c4aso5469381f8f.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 08 Sep 2026 01:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788856359; x=1789461159; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vRu051t1h1A6nzfqSoDX3YwLGwKiY0jwf7brkaReOLM=;
        b=OtnmpG7VxnebYbLZubFbushTRpq8A2Dv3M9aSjoR3fhEHg1NwK81/GIjuIguNK1uUp
         C9JDigzyVXKjUet4z9StV+IC7JYgygPj9H7cv8A70uOhfeJIjQKWMfS5F1DH7THzkyDb
         /OtCVOV3rdqONvaEZE3GbBykIqpItmVVJKu8PLX7hRDJwoBreJAHXnNYTfR4ZSGTP9M9
         4oPLWQM7D2vao4XZPsDUw8CBTKCLQm1zwKnKdNDwseD0TXuBYhxXCYLuny+ixIGL0Lwa
         4c9mMhcD4Fuj2UFJhPn0Apjff3vF3ObighP6GKqrx9RQKktL4mCPck//lPQrpLm+DS0T
         1zyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788856359; x=1789461159;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vRu051t1h1A6nzfqSoDX3YwLGwKiY0jwf7brkaReOLM=;
        b=be1eCbdnYEkPrJJSSlBrks5zfAUBfet9METX/B6G1dH+14DFhKj4dYTt1CQ63rUX5+
         JaJSz5NBRnnPsVdgh6j02w5TE87OV0ZLfV/inq6pu4kz/4nqywTOXUuLQld3aG/ShC2R
         BCF6QQW6SrdxH9IjpUMPl6AdO5J85+GN06cR8CMBUqCLcsowIDdY6ecBTeF3LIBnfM+Z
         aaPGiFysXg2T2nFRvvXgkVLsUoE7ooEi/sVOZzzSAsCdYr4rdbFyl6b3+NMSufMNZKBS
         c58ZvIQbXWZG8nzhiJsQK8djhAA+VlYp6huNzRCNKFN38PJitaNAoRrJ3TeVUOLzkntB
         M5FA==
X-Forwarded-Encrypted: i=1; AKwUvBwaQNSTUBakXOdBMEtzaTHDNrqxtMUJI2Xvqp2AFRPEJS43MeiTkJ1VtZ72fumTgKD9j9RJKwA2AZaYgg==@lists.linux.dev
X-Gm-Message-State: AFuF++l4qbrIGAeHpd9PVMjsgjZAQjp8E0vWgyZZpHnXBupW86asRfVu
	/zsFVvCQopBXlcjbnJdmwxe6+eWDktgu3ZmNHlg5LSAitSg4QDWrCPzl
X-Gm-Gg: AYBFou28W2TnkhxI/+aIoXrtjC6Lnej0Zx1M9TYuR2ZjKzVH0CzuSP3PIbYLy+Jvwt5
	TRM1lIZA++oFOCoghodI7GUF9824wYHgQkHnWtETovCYod+RoiBcqi/ggjGnp3TQKi0/t+ldmhd
	NWjjZegOZrJeHdIqesu55XEjoY4T3xHhN83inAjZyMgjQmHAeJfuf/OIqYRK8P9amxFMmkG5lGm
	7NXL2nhNApRm1cBHUwJnCFuLtH0mQMV7ebdCg+XSFPA7PteZxGoTRI560ku4gqSrY0o8Fe1pDhT
	TOMDgm/3ADUOcf2ih4vBu2x4Y6VPzjJoxPmOLijF3Pw9lZlKq7H56UdcQJ9BSngVFtkerSnOrhy
	i0Tly0xo3zHYaXDbx7aRbvM/im8eMwn+4ksFcYFP9/GwBUklVWUUqf+B823zXrPHN8xx5WN1VKO
	RmKT2KLG4eU20RZLfhYTCgJttYsIecStYByPsVmTIgA8aJEoY2ULQmS8/dLP+lXvv4rtofjGg4U
	08awzL6ma7d/1c7HE7tNFtwl89xFr2QG2jcPJ4545qu3dXM0w936I081h748fA5gZWTLl1Ve51x
	qdgrkwyUr4KMuXsgmUDJIwNt7EX576aTVpAySEZrzOcoGAYYQsTbSiuKx25m76c9hW5dJITVD7h
	fAG9tt+HDR6vdiuvJGJI3BD+TIV8V0+K+Dg==
X-Received: by 2002:a5d:588f:0:b0:485:847f:fd9b with SMTP id ffacd0b85a97d-48586e4a62bmr48379038f8f.6.1788856359104;
        Tue, 08 Sep 2026 01:32:39 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d312ca0sm35535684f8f.4.2026.09.08.01.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 01:32:38 -0700 (PDT)
Message-ID: <9fd0ed6b-e732-4485-a7b5-0380b07d3fc4@gmail.com>
Date: Tue, 8 Sep 2026 10:32:36 +0200
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove unnecessary ret variable in
 ocfs2_calc_xattr_init()
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Andrew Morton <akpm@linux-foundation.org>, kernel test robot
 <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202609040247.8B3lmoqX-lkp@intel.com>
 <20260907132202.48834-1-krystianmkaniewski@gmail.com>
 <b63bd2bd-229f-4636-9c89-8f1686ab087d@linux.alibaba.com>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <b63bd2bd-229f-4636-9c89-8f1686ab087d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hey Joseph,

Thanks for letting me know and let's drop this patch then. I've just 
received an email a few days ago after my patch was applied to upstream 
Linux and there was this finding, however I didn't expect it's already 
addressed.

On 9/8/2026 3:23 AM, Joseph Qi wrote:
> Hi,
> This has already been addressed by:
> ed57836ff300 ocfs2: make ocfs2_calc_xattr_init() return void
>
> Thanks,
> Joseph
>
> On 9/7/26 9:22 PM, Krystian Kaniewski wrote:
>> Commit bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
>> ocfs2_init_acl()") removed the only code that could change ret in
>> ocfs2_calc_xattr_init(). The variable is now always zero, so remove it
>> and return zero directly.
>>
>> This fixes the reported Coccinelle warning without changing behavior.
>>
>> Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
>> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
>> ---
>>   fs/ocfs2/xattr.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 35bcbb0ff607..ab3b645983c9 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -640,7 +640,6 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>>   			  int *want_clusters, int *xattr_credits,
>>   			  int *want_meta, struct ocfs2_acl_state *acl_state)
>>   {
>> -	int ret = 0;
>>   	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>>   	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
>>   
>> @@ -662,7 +661,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>>   	}
>>   
>>   	if (!(s_size + a_size))
>> -		return ret;
>> +		return 0;
>>   
>>   	/*
>>   	 * The max space of security xattr taken inline is
>> @@ -729,7 +728,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>>   		}
>>   	}
>>   
>> -	return ret;
>> +	return 0;
>>   }
>>   
>>   static int ocfs2_xattr_extend_allocation(struct inode *inode,
>>
>> base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d
