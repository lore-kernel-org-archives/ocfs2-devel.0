Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337623D54B
	for <ocfs2-devel@lists.linux.dev>; Mon, 11 Mar 2024 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710160135; cv=none; b=nPhyIbfmjXDL7FFOfu6ChKgAQciKGKr3IdE7muFRjqoVZydcHl3aoyuJbzlH80gTEJbaiZZU3WJkFTaEZbllCRNQ05GxGPzMvrhMTZB2O9bEDCpCdeTWLjMRf3l2LrLLk/mYnVv8GvGIRRNrhlLCJjs/dU9Zud4Gmn5DUdvNXmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710160135; c=relaxed/simple;
	bh=ODlnPstan8hbHEsuXsHYsVZaMdTjPJ/S4Z9uQ2H9FBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dYlByj/bsGWzCm2cy/C/iMRcDpjpzvCHKulsPh0OlLCPVstprSK039r5UXQQZxiv4nVw6uzOwWHk8A0tVLsilg1EEcKY9aiDDV4JrVmxpKOrE6iWoz3RLlpf0/3dkLztw7vGvWK2ZFyxY5t0Hw+Bc3VaAJoCA4cKppKDMmslXck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C0kKqYBq; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C0kKqYBq"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2d220e39907so70212221fa.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 11 Mar 2024 05:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710160131; x=1710764931; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A3jXmX0aR/8qTYqY4uAuHbYzCmB+WsMmuvgqWFxiTUM=;
        b=C0kKqYBqlmtGgRjzC4t46Gzdc4ymh0SUIobNhBm0TSyfphIPcSQaGIffxf7mtqx4gt
         3hQ95CydEdlamuOAnTbYtLvDd3FRooSVozk6h5E4I2vRo8LFmLuWTclTlWvAn4qUlI7p
         QukN6OnyssKwaOWMSFSodWw+OZ+xrKPz2bTY9oZ0e4AIUsaqPAYvDAmzMm9EK8cZE0Ki
         f/TMQX2iclapiwLdToIeCkczq4xYzUYFoQaKvCJR/bnMiVTX0qp5qoYaYRzFBbiQmguX
         yQIgGJwcgxAuh94/VR2IPULzeQe7ylmsq++tcHuvzU/LNhPMjIssNhye3XVNpPE/jtpZ
         tsJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710160131; x=1710764931;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3jXmX0aR/8qTYqY4uAuHbYzCmB+WsMmuvgqWFxiTUM=;
        b=sS6+NQVMGXSWTyp/FGiBO12pyt9rqAxbkE7J+EAmducc17s/y27TN3FQ13dqj8G6JQ
         NPhdwq84KiTx0AIyWSHlW6gkgWmmuRpRjbygayU+PlUUv7851gCiEPJUZ43iNfq1eLMX
         h7WndlpkLkVdRBXMKRlkU11W/RjmqqkQK0AvM2pSMoALVlSSmHLEriUEQMv+ZKHlpeGn
         F//rqv3JuV+x6yLEJboxMfKrJC82Q6MgHyqP5RI+MgvMZFoVe0cXXw1KMyXWj4f6yM3K
         KvmXflaxMZtcInB87L++q6x+3XgUPj0AwO2OLtUjmzxiyoJn2NlEqgzfcvF23ahQtjw6
         287A==
X-Forwarded-Encrypted: i=1; AJvYcCWGp+pSnl/bk5EKsgz3EmzuDWjbGSedtQV0zZzjf5jDWsyWXD1aKfA5yqjuLfHJZQ421BfNKj0PO5uEGjXwxIcRmyLwkXDhjO1O0vM=
X-Gm-Message-State: AOJu0YwmfNPsoMH3rpv93nxIiiz+k9uKnv1W5fQHKCVP1RamLXYU/VfI
	5XQHATh8BoOd0vL8aGxyEghc2wMdeIK4j+FjcrzdNy1WlsGilOpxNdAkjsf3IJ0=
X-Google-Smtp-Source: AGHT+IE4ffnSpXppO5SDLeI96FfkRyrqofJB19IM1oDEva9YaAGXchbrd+kZVCR8jMTy68j1XL1Gyg==
X-Received: by 2002:a2e:8708:0:b0:2d4:3dbc:16ec with SMTP id m8-20020a2e8708000000b002d43dbc16ecmr234211lji.20.1710160131281;
        Mon, 11 Mar 2024 05:28:51 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id w33-20020a17090a6ba400b0029bb5dc7c77sm4506395pjj.23.2024.03.11.05.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 05:28:50 -0700 (PDT)
Message-ID: <a94a7b6b-2d4d-497e-8f53-f2e1ee280591@suse.com>
Date: Mon, 11 Mar 2024 20:28:46 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ocfs2 mount error
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 =?UTF-8?Q?Valentin_Vidi=C4=87?= <vvidic@valentin-vidic.from.hr>
Cc: Alexander Aring <aahringo@redhat.com>,
 David Teigland <teigland@redhat.com>, gfs2@lists.linux.dev,
 ocfs2-devel@lists.linux.dev
References: <Ze4qSvzGJDt5yxC3@valentin-vidic.from.hr>
 <49396145-712d-44eb-884e-58eb19b1f4f2@linux.alibaba.com>
 <Ze7IiZmlhRaOgdhm@valentin-vidic.from.hr>
 <d3aea09b-3ad2-4f48-b86e-db46d3018bbd@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <d3aea09b-3ad2-4f48-b86e-db46d3018bbd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/11/24 17:27, Joseph Qi wrote:
> 
> 
> On 3/11/24 5:02 PM, Valentin Vidić wrote:
>> On Mon, Mar 11, 2024 at 04:37:39PM +0800, Joseph Qi wrote:
>>> It seems that you are using fsdlm.
>>> But from your running commands, I don't see how fsdlm get involved.
>>> Could you please give more detail on how to reproduce it?
>>
>> Sure, this is the original Pacemaker test script that failed:
>>
>> https://salsa.debian.org/ha-team/ocfs2-tools/-/blob/master/debian/tests/pcmk?ref_type=heads
>>
>> Basically it starts Corosync and DLM services and than calls:
>>
>> mkfs.ocfs2
>> fsck.ocfs2
>> mount.ocfs2
>>
> 
> Thanks for quick reply.
> Now it confirms that it is using fsdlm.
> 
> Joseph
> 
> 

It looks like I met the same issue one year ago.
check [1] and search for "error 17." in this mail.

[1]: https://lore.kernel.org/ocfs2-devel/20230626150916.je3egonzb3crvbl5@p15/

If my memory is still right, this root cause of this issue is that
fsck forgets to clear the lockspace before exiting. I will investigate
the debian's issue and provide a fix.

Thanks,
Heming
