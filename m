Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B165D42042
	for <ocfs2-devel@lists.linux.dev>; Sun, 21 Jul 2024 10:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721559280; cv=none; b=QZ19HbTALK3CV0iyBC/Gvp0zXJwmaiK/2kKHI+NHMmyCn5mzN/1aXwfyO88wqdrwhBxwRPviUrwerWFKGYTH1YLaAx59m3qM0wVlijNHGb84ykbRF3ltXIhe6fZ0OT2XfXtysMyF6TtUTLBkTzpJN2r3SlU5HEvQq0s39ScJsTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721559280; c=relaxed/simple;
	bh=PQpB1buz7ZoBN+s99abVQJHQ9aFtvnAFeFq6oMQP0Q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BnK4wPdhoM71j/bbiVrS4Xo3QwMab+dsS6j7q/LXA5BVAPgKi7g5Nca8XVBBFscyft1JaPtGqUDIMUCRlXr0gLNRfncB4sHIzQTKrlKVPAaOpr/hNC6jb/sSewY+DV613WOeoh1tFXzVZiisaPeuBliUCaHPSFlWRUMxYbOiw7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QP8hLFek; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QP8hLFek"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4266fcb311cso24722915e9.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 21 Jul 2024 03:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721559276; x=1722164076; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gjVW/g/E++u1jpx0UHxUlnU5KnPaBSjt4CRMRZ8X3Z4=;
        b=QP8hLFek2kviMOMwtG1qWTqaMBWlT8Mfx5XgeR8pBx+KWJ5r4t8kQyvYM8x8ZmL2Eg
         GTUBF5CmrgxCPbtw2lpdw/rqBbJShl44J/b9jCTZY3DlIeKn0eDFeD6PVSMokTWt1oEI
         GeolQwHGncOlki/q9igSvcbNZjW/ubKK9Jh7/FSPi8NZynVF+qdhJd28lb6d08pQgYL6
         /89v4iQblrNWHxZf/CvK4P16AjepdROUuyTN6yomNFUmCK/hgcuTJtxTUZsdcOpkuYVT
         daBnldvee0hE/mj+fqRhAAqx5k9c7qsY59yQ+XQZ/ejP91dW/z3x6OG4AN0XfPvvLqOy
         Pfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721559276; x=1722164076;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjVW/g/E++u1jpx0UHxUlnU5KnPaBSjt4CRMRZ8X3Z4=;
        b=aTgXJVcJWUcwcawHz1/bfoO6F9/myhCfc80SNfWTL4O6JyfeAlby5JWNh9Ixg4rAOy
         otRdGbdGJyFu184dy7NHALDyzvqcnxsn61PtyUUTJNMV9j8NhY31YE06mLAat7BuMCOX
         oUqOSgOdhPy4iuQJeFnxXvSgGs9XXhqCZm6xPAKqKsJxp49sUg1AJWhPviauT19pd812
         BpXyBivR42GZ4UbRhcyBNRGoEjhXzSzy/KsS3XKpsMe8hZlSwSemF3x3ivAtTXtUwiiQ
         ZMn7XlENGdqnPkJXbR8y7TInUbnjn5togb/i6Vnd+ZzOUGjoH53rfkM4LpKJfdV7sGj1
         8D1w==
X-Gm-Message-State: AOJu0YxmfmTwruTLrxP23y9sM8MY7hZTajXjLOxjpYdcV8TcmVv6mNE5
	5OWjzAlkfj0lvii9HkVTVfSzFmgLoh327SANAgVWKlsy9KJKCDkpTiVyUEnduvM=
X-Google-Smtp-Source: AGHT+IGCo9JW86zOlp/4KQRQxS/CbYD7l630E726eoBR1R0X4WKMXTszOdOC1KqcwY+i1VES/WOOOQ==
X-Received: by 2002:a5d:6981:0:b0:368:3b1f:fe40 with SMTP id ffacd0b85a97d-369bbbbdd59mr2258579f8f.20.1721559275861;
        Sun, 21 Jul 2024 03:54:35 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f31586esm34653585ad.141.2024.07.21.03.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jul 2024 03:54:35 -0700 (PDT)
Message-ID: <bed695b9-81f0-4907-becd-ebc11941349d@suse.com>
Date: Sun, 21 Jul 2024 18:54:32 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ocfs2: give ocfs2 the ability to reclaim suballoc free
 bg
To: joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, glass.su@suse.com
References: <20240721104626.19419-1-heming.zhao@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240721104626.19419-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/24 18:46, Heming Zhao wrote:
> The current ocfs2 code can't reclaim suballocator block group space.
> This cause ocfs2 to hold onto a lot of space in some cases. for example,
> when creating lots of small files, the space is held/managed by
> '//inode_alloc'. After the user deletes all the small files, the space
> never returns to '//global_bitmap'. This issue prevents ocfs2 from
> providing the needed space even when there is enough free space in a
> small ocfs2 volume.
> This patch gives ocfs2 the ability to reclaim suballoc free space when
> the block group is free. For performance reasons, ocfs2 doesn't release
> the first suballocator block group.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   fs/ocfs2/suballoc.c | 195 +++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 192 insertions(+), 3 deletions(-)
> 

This patch can pass the test cases below.

ocfs2-test:

single_run-WIP.sh -f 1 -k /home/ocfs2test/linux-2.6.39.tar.gz -l /home/ocfs2test/log    -m /mnt/ocfs2 -d /dev/vdc -b 2048 -c 4096 -s pcmk -n ocfs2tst -t create_and_open,directaio,fillverifyholes,renamewriterace,aiostress,    filesizelimits,mmaptruncate,buildkernel,splice,sendfile,reserve_space,mmap,inline,    xattr,reflink,mkfs,tunefs,backup_super

multiple_run.sh -f 1 -k /home/ocfs2test/linux-2.6.39.tar.gz -n tw-iomap1,tw-iomap2 -d /dev/vdc -b 2048  -c 4096 -s pcmk -C ocfs2tst -t xattr,inline,reflink,write_append_truncate,multi_mmap,  create_racer,flock_unit,cross_delete,open_delete /mnt/ocfs2 /mnt/ocfs2

discontig_runner.sh -f 1 -d /dev/vdc -b 2048 -c 4096 -s pcmk -n ocfs2tst /mnt/ocfs2

discontig_runner.sh -m tw-iomap1,tw-iomap2 -f 1 -d /dev/vdc -b 2048 -c 4096 -s pcmk -n ocfs2tst /mnt/ocfs2

xfstest:

The exclude cases are not related with this patch.

./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 -e generic/081 -e generic/266 -e generic/272 -e generic/281 -e generic/331 -e generic/347 -e generic/361  -e generic/628 -e generic/629 -e generic/648 -e generic/650

Thanks,
Heming
