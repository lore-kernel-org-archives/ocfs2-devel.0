Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6111A1AB53A
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Dec 2024 12:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733313637; cv=none; b=KZ4s+towzc/gPxYuW2Qx3EgjHe05ESoYl6+rGtv/A1XQ3IaoaIsHpf0hWwPjTc8emD+Sp0Ad1AgFtX2F6X88vWxWkPqneFhAWeEpUAHPJKCuXK0OEjh46XzwipJ/LmOfABpPuuu1GU8mKWVVItsY8VdHRhWPa8hRCNA3vVezCLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733313637; c=relaxed/simple;
	bh=zxPwnU9lIjUuQfCrz9BIDl96M1ZkxGh9ww2g9qzhclU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IWMgWDj0HIoT7LHCgKTsrARfgLqVJ5fgabMeVO8yTqLIxx+szxjMSCHSYpX7JMDQ+G3qCwpM2aRqUG9DQfTRYGL7OX/8Jxkeqm5eUC90fNFiRAIGfU3sT3l+SHKouz5XTgTjxt2u/bhXz9p/+RFsKtlQY8XDf0d6fkrJUotY7ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=swKlrPQV; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="swKlrPQV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733313632; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ng/hTn+b3RrgUNeWcSce9zno82+k1afjip+5Wjr2OhM=;
	b=swKlrPQVYlT4msfIOlNtQARI7F/xz4tBfAOr0kqbQ3qx64qB+370Vw/9yYYjK8EFiJuOjGI8rE20c9RkAbDcHwmIOulGxfwoDi44xQiekfJ4M8G11eqehKfZZt2Hjy16VERewpXMqIZFl4D4ZK3O40P8LK98p58S4+UhXLCeYkg=
Received: from 30.221.128.184(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WKq5934_1733313630 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Dec 2024 20:00:31 +0800
Message-ID: <7571e8a8-f8d6-43e4-ac8d-aea1df8a6e35@linux.alibaba.com>
Date: Wed, 4 Dec 2024 20:00:30 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] ocfs2, dlmfs: convert to the new mount API
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, Eric Sandeen <sandeen@redhat.com>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, brauner@kernel.org
References: <20241028144443.609151-1-sandeen@redhat.com>
 <z5krqu5typmeyi4vbwyinc5pcaeodk4zicjjkrmdsbq4vg6w57@vn5oyugodxks>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <z5krqu5typmeyi4vbwyinc5pcaeodk4zicjjkrmdsbq4vg6w57@vn5oyugodxks>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/4/24 12:45 AM, Goldwyn Rodrigues wrote:
> On  9:41 28/10, Eric Sandeen wrote:
>> This has been tested to some degree with a local ocfs2 mount, but I am
>> not able to do a proper testing in a clustered environment. I have
>> confirmed that AFAICT, random combinations of valid and/or invalid mount
>> options on the local mount behave the same before and after these
>> changes.
>>
>> (Just a side note: I had to omit "ro" mount testing, because simply
>> mounting a local ocfs2 filesystem as ro, then unmounting, panics the
>> kernel with or without these changes. I haven't looked into why.)
>>
>> Any feedback greatly appreciated, thanks!
>>
> 
> I have tested these patches in a clustered environment with pacemaker
> (pcmk) and can confirm these patches work fine.
> 
> Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 

It seems that I've overlooked this series before.
Simply test with o2cb stack and it passes.

Thanks,
Joseph
