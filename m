Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD442069
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Mar 2025 06:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743058408; cv=none; b=fj3fGsT3+D722GTrajvzyiQ5eqcso3G7B0XmEmeWUkxYfiJqiArQYdiAsmr7UENIeAk1NN+rbP7rWAHV018i2CY83k4c1XNVwbGbsA6nXgmXzU2GODNln0qEM1zahUx28zUbOulIcfAApUk3PtOHbkU0DJp2Gk4Gc/cSn7I42NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743058408; c=relaxed/simple;
	bh=gmjJJW9kLnwVf4ojgXk72+SIvB4JBqU2VPR6QGUBIts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DMY9fX4vcYvdx242G23N0RJdHmRGIw0zQiYrrDnna/vt2w2KMuM9Wah/9mUz9AQXwyfZhy4MBr3IKToIIo0l8Hbv3PYaEvN52l3RG9ta+3dCqbvLKzX2+F8CMzAC7bklRue42PTiRKOj77zSjLFWeKaf4zfEwTpFK68GzhEhtBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DU7FJCMi; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DU7FJCMi"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cf861f936so1048545e9.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Mar 2025 23:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743058404; x=1743663204; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t1PDL49wsR8t3oK5tOwSBTXVuxib+JRofPTqoaO+MbY=;
        b=DU7FJCMiiMYW2ptHGbOnT+e24IUeFdEmoa+5PNUgxwKm4uSFCTuJURZZT839lr6ZuT
         S4PVwH7YEjXL5icoJ5P9/B2QqXUOO1IYgC3YyhYz0pAq8g2ZX+f/4mujLr/vEPikzcdB
         TPHgH2hUH2ncpRLcY+pu23Ah4u9ldSzZr5R6QNopVkJyrtw+8OlZ6ujwuIAZ1ytH3PHA
         GqPiGo++3esKqvi8Ycx+1KH4H7dNhUXH53KzZX8gFM/s6+gwtZldlGkpn2YgKAwftPYe
         EHrVf6+lKan7a9ddALHG5YyBxI4eb2NIW/v7QxT4NslySiaaEWHx7H/XwUEC7yrVqjv+
         4Yzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743058404; x=1743663204;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t1PDL49wsR8t3oK5tOwSBTXVuxib+JRofPTqoaO+MbY=;
        b=qnc0WpmuwHH8bmdyxYXBSWcwcDxtEMn48ZGXjiaB+y31KZyhCq4yRIuWWSc6Oqs3F5
         dDS1FUo64IModDHB46VJRPSkLk9UiIqGT9ByKkuJXlFa9AXmOpmY3gtb95L9v2Qy2cdN
         GwJl+PSbNiymaJwkEFZFd0IeFN+TljsMvFMUlWCJS6hU8gk7Hrq2OEk4jkWGPqyNcYW+
         ZOLSQuKebgAb7q5K6XGHe2JLVTOawbn8mNCkplbVOHX1aljgAzrNPfP2KVCWS8QfZmv8
         IDak38g3AA/6WS/k3kCu9hhXOSNtfbB80T1+xNlFb3Aphgj8VCEwwCZnxXUD8GTIXagT
         Ddbg==
X-Forwarded-Encrypted: i=1; AJvYcCV8EBByBvHRotqQh61Iylo+cCO9S8GL63Dyxy9dC3djnzPSIzdiHWjic4ZhMbZxQobVnE6SjwupIacrYA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwLeQ7O+UMchFFO6L3TypwYz57W80WvT8h/hvIlju/ZmWBTzneU
	Xgd0QUtCi1NPA/quq+RXeBFMNA6Isn1lmalicLeyaN+sUihEgDd4mG9MBbjPVu4=
X-Gm-Gg: ASbGnctiqt3sfG3nsyv04BBpjPvOGNWmJ5/i4hpDJJq3FX8l5GJDpyEMqJlnEGx49EU
	5qJoJ3bw2EjFyxoMtZ+CRxNszCrITFf819HyP4DesY2F9u/e/1FZussFOkyTPo7Zq/ruM55oJSP
	ls/4sQ+TG2JeRscBD3le9a7NT6pRjHGHHu/IZpMynnAfBnZKbGva5R3Gyea4fXm4j9G5wJxo8va
	vNxE6xgHMAHXof53NJT0BpCt6tOLTo9KQSn0IV2zyucB0nvyGdiTKjpY9ggu++6+5Xk0QOM76T9
	i5iJqkEk6+IOOKbRk5oqWL1Vv9a8WakpSiSZil3ohZBYDfmgNhY=
X-Google-Smtp-Source: AGHT+IEdkz6q64rsYV3VZmc/ZfV6ChqPaq/S6W1mt38Hq+RVFgHVVbpHCU3NX5s/6fNrItFngbvoXQ==
X-Received: by 2002:a5d:47c7:0:b0:38d:be5e:b2a7 with SMTP id ffacd0b85a97d-39ad2b19b7fmr398048f8f.10.1743058403991;
        Wed, 26 Mar 2025 23:53:23 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f45e9esm121332185ad.88.2025.03.26.23.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 23:53:23 -0700 (PDT)
Message-ID: <bcce4e5c-d739-4b1c-86bd-d165ec0780be@suse.com>
Date: Thu, 27 Mar 2025 14:53:20 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/1] ocfs2: fix write IO performance improvement for
 high fragmentation
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
 "joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>,
 Junxiao Bi <junxiao.bi@oracle.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <20250324054851.2509325-1-gautham.ananthakrishna@oracle.com>
 <199205d8-20fb-463d-9065-8021b3cf7cb8@suse.com>
 <DS7PR10MB48784AA2A065605733B79499F7A12@DS7PR10MB4878.namprd10.prod.outlook.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <DS7PR10MB48784AA2A065605733B79499F7A12@DS7PR10MB4878.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/27/25 14:21, Gautham Ananthakrishna wrote:
> HI Heming,
> 
> Sharing the test suite may not be practical (it has shell scripts, python and C binaries). However, I can take a look into your patch and run a quick test.
> 
> Thanks,
> Gautham.
> 

Thank you for your quick reply and willingness to help.

- Heming
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> *From:* Heming Zhao <heming.zhao@suse.com>
> *Sent:* Thursday, March 27, 2025 11:39 AM
> *To:* Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>; joseph.qi@linux.alibaba.com <joseph.qi@linux.alibaba.com>
> *Cc:* linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; ocfs2-devel@lists.linux.dev <ocfs2-devel@lists.linux.dev>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>; Junxiao Bi <junxiao.bi@oracle.com>; akpm@linux-foundation.org <akpm@linux-foundation.org>
> *Subject:* Re: [PATCH RFC 1/1] ocfs2: fix write IO performance improvement for high fragmentation
> Hello Gautham,
> 
> Thanks for locating the issue and submitting a patch.
> Is it possible to share your test case for this bug?
> 
> The key of this bug is ocfs2_cluster_group_search() comparing with wrong
> bits size. I have another fix for this bug and will send it to this mailing
> list later.
> 
> Thanks,
> Heming
> 
> On 3/24/25 13:48, Gautham Ananthakrishna wrote:
>> The commit 4eb7b93e03101fd3f35e69affe566e4b1e3e3dca caused a regression
>> in our test suite in discontig extent tests. Upon troubleshooting I found
>> The following issues.
>> 
>> 1. The function ocfs2_cluster_group_search() was called for discontig allocations
>> as well. But it checks only the contiguous bits 'bg_contig_free_bits'.
>> It hit the ENOSPC in the following case in one of the tests.
>> 
>> ocfs2_mkdir()
>>   ocfs2_reserve_new_inode()
>>    ocfs2_reserve_suballoc_bits()
>>     ocfs2_block_group_alloc()
>>      ocfs2_block_group_alloc_discontig()
>>       __ocfs2_claim_clusters()
>>        ocfs2_claim_suballoc_bits()
>>         ocfs2_search_chain()
>>          ocfs2_cluster_group_search()
>> 
>> Looked like the commit did not consider discontig searches. To fix this,
>> I have split ocfs2_cluster_group_search() into *_common(), *_contig() and
>> *_discontig()
>> 
>> 2. That commit enforced ocfs2_cluster_group_search() to search only the
>> 'bits_wanted' number of bits whereas ocfs2_block_group_find_clear_bits()
>> fills the best available size and the function ocfs2_cluster_group_search()
>> itself is supposed to search 'min_bits' at the minimum and need not be
>> 'bits_wanted' always.
>> 
>> Fixed the above issues in this patch.
>> This patch fixes 4eb7b93e03101fd3f35e69affe566e4b1e3e3dca
>> 
>> Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
>> ---
>>   fs/ocfs2/suballoc.c | 146 ++++++++++++++++++++++++++++----------------
>>   1 file changed, 95 insertions(+), 51 deletions(-)
>> 

