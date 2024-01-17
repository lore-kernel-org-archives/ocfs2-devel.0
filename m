Received: from mail.nfschina.com (unknown [42.101.60.195])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 01CFE17E9;
	Wed, 17 Jan 2024 01:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705454618; cv=none; b=hBl6Z2W9IiVbyZeDMWihV1jNh6WRK1mA+GjpW7x7q0rGlh86Onjf0nQXNvr2cAwBYSDGtKb+0apPU0bixCdLXcdOEzkjYiNDQvKL0AB6z1fxqFq29yn0ewHKJmcUgE6ttmdK+pAs6Hf9F8+BMGvZx8jPii0aiA4qeuHpSdHjp6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705454618; c=relaxed/simple;
	bh=Vmx397rnKN9dTE4JxoTDlJ1QfqShVG2owgUaAVsdmhs=;
	h=Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 Content-Language:To:Cc:X-MD-Sfrom:X-MD-SrcIP:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding; b=dfhTzbu2ed7Xi2Me9OzS7pLxYLO72Zk6Ljz3G7x6gDVUre9XAffgPrUyVbK2M/6r7SPpAsNKD8BpEM11kw6iAYyGbmg8E13Jo1tRyk4On6QCNYlKUIlzQVLBb0air8jy5lslC9hDpoRWa5GtGzFqdvVDJtrD/orEK4AmPq+v6fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from [172.30.11.106] (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPSA id CA73D607F2347;
	Wed, 17 Jan 2024 09:23:02 +0800 (CST)
Message-ID: <1847a959-b8a1-29e9-c87e-036709586d1a@nfschina.com>
Date: Wed, 17 Jan 2024 09:23:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] ocfs2: remove useless code in ocfs2_try_to_merge_extent
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
 justinstitt@google.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 kernel-janitors@vger.kernel.org
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
In-Reply-To: <20240116120926.3bfa87253bf5af5090bd78bd@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/1/17 04:09, Andrew Morton wrote:
> On Fri, 12 Jan 2024 12:26:40 +0800 Su Hui <suhui@nfschina.com> wrote:
>
>> Clang static checker warning: Value stored to 'rec' is never read.
>> Remove this useless code to silent this warning.
>>
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -3743,8 +3743,6 @@ static int ocfs2_try_to_merge_extent(handle_t *handle,
>>   			goto out;
>>   		}
>>   
>> -		rec = &el->l_recs[split_index];
>> -
>>   		/*
>>   		 * Note that we don't pass split_rec here on purpose -
>>   		 * we've merged it into the rec already.
> Then:
>
> 		ret = ocfs2_merge_rec_left(path, handle, et, rec,
> 					   dealloc, split_index);
>
> and ocfs2_merge_rec_left() almost immediately dereferences `rec'.
>
> So this looks quite wrong to me.
>
Oh, really sorry for the noise.
This patch is wrong.

Su Hui

