Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133F61E3DCC
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Jan 2025 11:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249938; cv=none; b=FrM9z9BZ4HEUl0C5zSwr85JRlXviDEf/ab94rO1YNQN5fpgPPw3r5gpuWECLY8DyWZSs1ftJflGd5ST0B+S+3gNNk4efohPe0ieNpqtgk+l7qkaj74aFwSFH+TXFTtmlz2rHLXICB6sdtikjI/j8uUvbDLFcaRexCzt7Vmy0tko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249938; c=relaxed/simple;
	bh=PrB3Fr4s7FDtwbweDg17cRAzzQYBQLQFf9cCFMCGveA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YiqTmyjPJhcdZMdbJlwcKFJ2vx16rBcKm+xWFO99CBfN2bih6GPtxUwjZwn0nt+3qSnqcSmCWfGUd3FmknP5cr5ZLGoKm+O+iJsyNV8E4a0KMtLTaQ09yeia/W7+YalGsMi48l1XO5fRuuqkDIJdpjzxIq2W99Kp4jWat9FI8W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sJiVD3x7; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sJiVD3x7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736249931; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=McX/q3p/SAm7qC/JWTu4ugEzfTM3XFkHG1Eid3ybb6k=;
	b=sJiVD3x73Yb9AlqCjPdOXQhFNrFFj51mc7gXPg4jMd9BAgUP13iozGT+MCrKy4nKp1+Ms2WplKUKssR1XRO5arz/sFjXyPyY6kpPFe9mxaoQAKxrtaF/nOBrs9cl+bJUbh8574o8eEj9pTNWsu5P+lEEDesj7lEgJc+NuPgOdOU=
Received: from 30.221.129.26(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WNATcYC_1736249927 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jan 2025 19:38:47 +0800
Message-ID: <88b41e58-2878-4719-8efe-446c58b1f5e1@linux.alibaba.com>
Date: Tue, 7 Jan 2025 19:38:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic/620: add '-J block64' mkfs option for ocfs2
To: Glass Su <glass.su@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Mark Fasheh <mark@fasheh.com>
Cc: fstests@vger.kernel.org, ocfs2-devel@lists.linux.dev
References: <20250106140104.91880-1-glass.su@suse.com>
 <20250107021254.GP6160@frogsfrogsfrogs>
 <6B45499F-7306-478A-A860-73E02D47FCF3@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <6B45499F-7306-478A-A860-73E02D47FCF3@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/1/7 10:42, Glass Su wrote:
> 
> 
>> On Jan 7, 2025, at 10:12, Darrick J. Wong <djwong@kernel.org> wrote:
>>
>> On Mon, Jan 06, 2025 at 10:01:04PM +0800, Su Yue wrote:
>>> mkfs.ocfs2 is using 32bit journal as default.
>>> For 16T size device support, '-J block64' should be used.
>>>
>>> Signed-off-by: Su Yue <glass.su@suse.com>
>>> ---
>>> tests/generic/620 | 3 +++
>>> 1 file changed, 3 insertions(+)
>>>
>>> diff --git a/tests/generic/620 b/tests/generic/620
>>> index 3f1ce45a55fd..60e5a2cacdda 100755
>>> --- a/tests/generic/620
>>> +++ b/tests/generic/620
>>> @@ -41,6 +41,9 @@ sectors=$((2*1024*1024*1024*17))
>>> chunk_size=128
>>>
>>> _dmhugedisk_init $sectors $chunk_size
>>> +
>>> +[ "$FSTYP" = "ocfs2"  ] && MKFS_OPTIONS="$MKFS_OPTIONS -J block64"
>>
>> Won't mkfs.ocfs2 turn on block64 on a > 16T volume without prompting?
>>
> It won’t. Only error will be printed:
> 
> ERROR: jbd can only store block numbers in 32 bits. /dev/mapper/huge-test.620 can hold 4563402752 blocks
> which overflows this limit. If you have a new enough Ocfs2 with JBD2 support, you can try formatting with the "-Jblock64" option to turn on support for this size block device.
> 
> It’s 2025 now. Maybe it’s time to make mkfs.ocfs2  turn on block64 if device size > 16T.
> 
> Maintainers may know some stories.  Joseph?
> 

AFAIK, standard 32-bit journal is the default journal format for ocfs2
since the beginning.
