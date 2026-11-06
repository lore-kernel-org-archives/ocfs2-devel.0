Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974196;
	b=Y2pZjNYdPpg8yCFlips9v8/OnoGyB2ZjSYHzi/I7AYPLkADFPmlS5mc2/iaKDZm3nzIR
	 rL0+Soy7/F33tjCkjgLMjVzLbqU9aqVQ55k5eS+GPslsmb9MOGXjjEn86BB8DoQa1SKA1
	 zPqnDwRctHvv85NfLu3+KcSnuhX5PlFPztUyuoIQcldzYRoZ/hVG227HZpJAjMwtPQxN2
	 dlbacbJ6jYXHbmBS+JZEedUErLoyBCm2zZOn58pxvC+P8QckH3Nd5XvYP7PxDtod1Rm6A
	 aCqG8NDYQQQAfx619jr4WwGv48lgIzRTrMOFlFsXFsI2ikmzg3BPurSkwzPuETU7zGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974196;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LoxS/LnZX03KsQjK2OutNjRXX+iWailJTk3FM6xlJwg=;
	b=eF4v6GcIP2adP79SGjFG2NVbp7kkpt57aOVkip3MsU/W0c6NELY4ACPE8ga18OZUOKyM
	 sVPo5h4PAvDKVz+GYdfinf7gmeTK/0Mi4ByjiSPDuRU4e9L34Q1fhrxtEgdm2BkgcplDO
	 HN5xdNah3/AoaYqRd7PR12xram+cg79BSRITf/uaZ1Dqq9ZJpkLF5KTFOmzLrm4QuKwu/
	 W5d9sjffhghSHi/adi8zTSQk8bOYe8Ezwhq3t4IlJoWNnrr3IRKakfZwx6LM33URedu5i
	 37g9sS2yX84bdpJrgwiA5qq44P8QFy/glITfDAu926C3RrSqUPjQLoKMT4Vy7LZXEEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=eSclBk9d;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D84606A33C
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 14:09:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69D84606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=eSclBk9d
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1bc97805eso711525e9.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 06 Nov 2026 06:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793974195; x=1794578995; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LoxS/LnZX03KsQjK2OutNjRXX+iWailJTk3FM6xlJwg=;
        b=eSclBk9doS7TIY5SPxIPQABvVdfrxBcX8trZZTZ7Ugijedc8FCr++/5zVG5cvG4BK8
         BxL8SQRfbX/5T1H6b4aus53VCLZkI7ipuf9GmJ9N/BCBCGscM8Jfej7r+ivdxyGFSX4b
         KLiehvF6rRQZK53FamwbSFbkNfdU6elxhikwSGN+3ohCsEsnA2GyMaTWpTtB2uxw54Dh
         ECJLao1mJ1TX12SeWMf0wtDEvdFr2O9w9RvrJhXsdoL/miVHsY3X71IogTEmM88Gkd22
         ZxjvaubMPkqnV6TznSS5+2TxRvFMSsCvkNwOzrndeZo6pvbuUDybwb/W08z9wPrnwc26
         8obg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793974195; x=1794578995;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LoxS/LnZX03KsQjK2OutNjRXX+iWailJTk3FM6xlJwg=;
        b=0zffDNs8JXu3Ubah7YxS/l2jcqXRI+EogeNT4pu12mjv3eQmF0irOt5qfAFX7RMevh
         9Njw5+qoxV91d0rsiqEc/ofGgaKRBqaub7t6Sm7fDrP/j+K22inv/xxGWP7SdG6CmiCj
         QYEizQlJjvhulgF4jOmjvwAy2EZYSGN86byXdx0VorlGZ+ML0gpb9N2/kGnSjLOoLKkv
         Uz62MGz7gqchXTbFRChV5O0jTzGJDM9gPmmLjejO2VNEQ0MPWIqSvn9cgc8AdOLhFTzT
         EBFVKRJdpD+337/r0QqtQXRUgGY4DP7qsW4XwRVowDOjFljojN7ZhlYLtLEP9SIUKN/W
         qGWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwmeYuzsxW5/gZpkzWgRokARZZ+hKor4rYBLX6nzswFPgr0PKiQ8SLXBIO+x1+UHC0XIzkBHJbaFaL6YQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9C9A41f+fVRBet0lZhOrrxquud0KA+a9OmUa0Q2EI+aTSYWaMC
	ZTcakwnJ/WvpsGM1W8zxURBHqqOEOgJXKjOwwfacGztXoTa/MH/LNnuLJtTQGAAJCL8=
X-Gm-Gg: AYBFou1jlxo7tMtMCc6POdv3Lr4xMAy4ArbOteRaolHdwoFcghuFz19x78qG+5UYM0m
	iBC95IBgfPBADiO6Dhes1KIMwpOAvXG/yBJDbO89HPboyiDJ1Oik3LGKuVi+/riDfs59gjoUZQ1
	Hpcl8TdlqaJibfHrU/iGYEhL32JT4Y7ZPpnJtr9AZtn5MU80VZKj4GpWkeMY71kaZb06wlxiq20
	go6sdONCtRVXrBo4gCxtLYRhhtQF4MrS2bR0K9JYCJ6jY0OCasMvsucCHtcBwiJ6lHOe7IVkRRh
	3Ud0FmPVXk30o+Ejg4kRueSHcYHm5ZsY8loY508Y6YlWHo3tuvGXEFnmmpIKYAHrFoW2q4aAXrC
	CxazQ/bfrRNqKpb/YObHgXaWXl4X5qUmhHVR3Rl65K3z021S2sdQZrrAcAzg281BLxkPMMX314c
	e6VWFWZs7shkB4zeegys4V96vdvtdNtCl3YjYL2S730yiFu1xPljLBjM53NyefUGlvxtlamZPSq
	8Yz8uPSTSFUe0w3xYvJ5zlIUvBy0Lm+qNJygXQkOF4+aASkrHIU/kwNNmvq+yKSrqo1ns3ne2y6
	O2W/k5uI8vAheyMQKyQZHre8GkMUbgohww==
X-Received: by 2002:a05:600c:6d8f:b0:4b6:2242:d0be with SMTP id 5b1f17b1804b1-4b6d82b2c85mr35660945e9.0.1793974194725;
        Fri, 06 Nov 2026 06:09:54 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4e079esm7002021c88.19.2026.11.06.06.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 06:09:53 -0800 (PST)
Message-ID: <3f975e52-ae09-4f5c-96a5-10629577ce04@suse.com>
Date: Fri, 6 Nov 2026 22:09:47 +0800
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
Subject: Re: [RFC PATCH v5 0/4] migrates ocfs2 DIO from buffer_head to iomap
To: Christoph Hellwig <hch@lst.de>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261105071930.16399-1-heming.zhao@suse.com>
 <20261106104617.GA5746@lst.de>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20261106104617.GA5746@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/26 18:46, Christoph Hellwig wrote:
> s/migrates/migrate/ I think.
> 
> On Thu, Nov 05, 2026 at 03:19:24PM +0800, Heming Zhao wrote:
>> To simplify iomap development, we currently adopt the simplest approach:
>> retaining the buffer_head style, where only one cluster is allocated
>> per iomap_begin() call.
> 
> Do you mean you'd otherwise need changes to the core iomap code?
> Or do I misunderstand the sentence.
> 

Apologies for my English.
"To simplify iomap development" should be "To simplify ocfs2 iomap development".

Because the ocfs2 buffer_head path uses "struct ocfs2_dio_write_ctxt *dwc"
to pass dio unwritten info from the dio get_block phase (ocfs2_dio_wr_get_block())
to the end_io phase (ocfs2_dio_end_io_write()).

However, iomap clears iocb->private before the iomap_dio_ops end_io callback,
which makes it impossible to reuse the current ocfs2 buffer_head end_io function.

- Heming
