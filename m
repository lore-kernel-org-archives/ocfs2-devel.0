Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C843A380C
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Jul 2026 04:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785212729; cv=none; b=FB9nwoUc+zR/NfkrGm5VTKV6+Yro7SsS7qnmPwQUyMHsAJau6eoPfnV/B6HW2zB2VdzrE7PRcci8K+7O99pyVsa02VSoV0uJF967kSddwOShZDWPXXdhEy1u8/NsuwyHtdbd0u4A9BoB7cqqlyXshnIfuSUomsCXxTyjcIUnmII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785212729; c=relaxed/simple;
	bh=smF/jlOvM7wPwXlWu11iBt96K3uXF0jJskRG/Fr1rAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bp36paGfkYrugxXTdTsBcfmvd2l0SzL5NZsQtPLNxmzSk5/t1Gcg8O4DeEBqi4ao7JejW3BXXHZlM77Io0FsMguLv1LuKGYQSYAVTP7Max2o2L7G59rW060Vshyv9LCVBfklqMdv/B0NcYuD9J8a3JK6niR21qW9XvQmtWEJj+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dI9iUqSY; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dI9iUqSY"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-698ae9da373so611531a12.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Jul 2026 21:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785212726; x=1785817526; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g1Xp4I8PU6Tfz4i0WqvYDB+1NTZauzkB12T4ndMxR2w=;
        b=dI9iUqSYIdDGF9Q5EESuO3peu2I3lSXKK9oDrxMJ7JexsIW1tQbAbVr+ijawRDqKNu
         HZlj5aUpaRbVbBf1Zmfja0xWKKRQnfuD7Sm7yctx5/0k4LuQdrLYYLWlFXghiYwa2VIN
         HX59jOwy7S/fEoIPRMbmciLC6zxZNaZrBbWZo2b3PmPYcWXhgxsUYDSOc0OuZsBa1WLI
         K/tv9B6wQQ//6DKJNf52x7ji+l+01ocScPwS0lTtDRhD4B/mb+5Ct30J2mMjK0mBMJbf
         wxmWGsnV3AVXxpVfXmOFHoiMplBMtGzzwBlXC8tkeN/8KDk9uLyS6i0DkpQrgYhiGXHR
         d8fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785212726; x=1785817526;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g1Xp4I8PU6Tfz4i0WqvYDB+1NTZauzkB12T4ndMxR2w=;
        b=JKN5f8kLy3k8xQorQpUAJd81/K7hdyzkFCn2f0SdI9kwI61WeNWROaD348IwQtHCbV
         LltR3N0YJglMRJ3MJ69LvqA9SfZB8SMrAv7pBEgDZD/sLausAKgPv/ELY7kfmVkI3TBW
         zxdQLkq1l3gL1o5RUh269ju4Asi7T+X2wRvmD7/QYal9ZXMmNSR8eW468eOt8MxYor/Z
         4lkeHv1YBH080K4KaG0zGuirV98D/975Ph809foSsobFdjjaEpTagQ9crzLXoXGuZBmy
         jzFb4UoAsUT6O6EOdLO4ZJFLeZQrc5gT/m1uVkYtrZAkjSpTFUY5ASdeG7bSuB3ttrnl
         LhSg==
X-Forwarded-Encrypted: i=1; AHgh+Rqn1+gc7UMtxNT6FOrCyc/yHRit7PdLqZf/wP/oNiOynidlQfgipSc2O0HEJ5eYP9ZLjkoFeEqwJXxsWA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwLZvZGfiFuIhArzb9D0oqbBy4t3AtN4I560VRBayEJ/G4q9UlD
	z7vLhVH5Pb5oJOQSTJPnYnqbrv1ue66wzNRfJgok+FiYUYk7inhb8I8v3dY6oWhOBdw=
X-Gm-Gg: AR+sD12GZob7AF5yqqWniKckfCbwYulyq/rNEcZkzdJI38dIpC2KuOEirffvYdENYJi
	zrVVNlRwxsuBYVI2ANRJi0hWk6llevwAfgEyCnTQApIb4wrTZJ0Y4ht9ho9Kko3WlIg2ws8Ewu3
	89y/IBZoBBD0CNeLMqnH3uC7nNi9Zj/eFehisjkhaHAQFRk+bZBag6HvmSGSZJx5AAH/bSHk0S0
	lG2LGb0J7ApcFxsXGhGBNVeaAA02B2uFyWMOpfdLbX1PJihFq3hxpau9u0CSwqKdC9CmtXrEx5z
	kn/gFBYT2bc49Mxmafp5/a/Cu+rLOdDccKf6Tx5uJdAKg3oJw6Olc05LRPC2dFicI5Aq6uteRsT
	YslEtqdAb4KCEjDuqW0UfgixdQceD6kdeJsZnHuo2TevZxaiq4/wxkdwGa8pT9amGZcZ2L9pSw2
	ejZDYxbzHIOc06WePWpsQ=
X-Received: by 2002:a05:6402:4301:b0:68e:4c0:f59a with SMTP id 4fb4d7f45d1cf-6a034a08197mr161223a12.2.1785212726202;
        Mon, 27 Jul 2026 21:25:26 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cffa9243fcsm22533725ad.64.2026.07.27.21.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 21:25:25 -0700 (PDT)
Message-ID: <1dea0a61-364d-4476-8582-7280e5cc2220@suse.com>
Date: Tue, 28 Jul 2026 12:25:20 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 4/4] ocfs2: remove legacy blockdev direct-IO path
 APIs
To: Christoph Hellwig <hch@lst.de>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260727061802.18485-1-heming.zhao@suse.com>
 <20260727061802.18485-5-heming.zhao@suse.com> <20260728041956.GD19573@lst.de>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20260728041956.GD19573@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/26 12:19, Christoph Hellwig wrote:
> After this __blockdev_direct_IO is unused except to implement
> blockdev_direct_IO.  So please fold blockdev_direct_IO into
> __blockdev_direct_IO and remove all the code that is now unused


Thanks for all your kind review comments.
I will carefully revise the patch set before sending v3.

- Heming
