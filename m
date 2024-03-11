Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D748B17561;
	Mon, 11 Mar 2024 09:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710149273; cv=none; b=jhvULMN1/B+QdkN8YHyHX+zsVQ+LVaV9aFVExroKh2uDNDtsJQOBy6Wbn1brcsFY6ESvNAWktY06ey1pfIAYiKphOYLuoVuKdH0YbGcLmvcXcAKMAp81CAZaUs/100fC78HuJD1unVnkVVKvoRF9Cn5xSZYLUnYXivDGgeJaQgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710149273; c=relaxed/simple;
	bh=zo50emVo+yAS+xyCxhzK/JticZSFs9rq9yU7KC6O2DU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gM+S1QEjn4ZreRwX01FZxOZ/EDE0WGFgcxDM7yznYuHIkzJT/OKj8IZd6jH90o2P3QW8R44+TBda+DN5iH1AB370KH6o269dbOtQPahmWTbu8jF+M6SAvMwj1zJhRD0lF2/91yWv7IwxC+mMLh3ri5BMrfiZ9nn3O1FOOam8AdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=breSe7D+; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="breSe7D+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710149267; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=l2AbEBfS717sEFsVW37uRE+Hz8tZTWhFDavtXMq++CQ=;
	b=breSe7D+dh8NZJlnC9+B6Eu6m+Pd6IOItQ1LJhTX50gZo9xHqfTaTHy9EybvqnFlhK+m1hcR+GYkKiaJ2U+AA57SxUmNolyzbLrqb0150AYZNzg4skXgcmUfN2EDOr8SFZwcYCYbH6RUUVDhssizu1TPJvmB3LLRFQXsphjxdAs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W2EpOdM_1710149266;
Received: from 30.221.129.84(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W2EpOdM_1710149266)
          by smtp.aliyun-inc.com;
          Mon, 11 Mar 2024 17:27:46 +0800
Message-ID: <d3aea09b-3ad2-4f48-b86e-db46d3018bbd@linux.alibaba.com>
Date: Mon, 11 Mar 2024 17:27:46 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ocfs2 mount error
Content-Language: en-US
To: =?UTF-8?Q?Valentin_Vidi=C4=87?= <vvidic@valentin-vidic.from.hr>
Cc: Alexander Aring <aahringo@redhat.com>,
 David Teigland <teigland@redhat.com>, gfs2@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>
References: <Ze4qSvzGJDt5yxC3@valentin-vidic.from.hr>
 <49396145-712d-44eb-884e-58eb19b1f4f2@linux.alibaba.com>
 <Ze7IiZmlhRaOgdhm@valentin-vidic.from.hr>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <Ze7IiZmlhRaOgdhm@valentin-vidic.from.hr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/11/24 5:02 PM, Valentin Vidić wrote:
> On Mon, Mar 11, 2024 at 04:37:39PM +0800, Joseph Qi wrote:
>> It seems that you are using fsdlm.
>> But from your running commands, I don't see how fsdlm get involved.
>> Could you please give more detail on how to reproduce it?
> 
> Sure, this is the original Pacemaker test script that failed:
> 
> https://salsa.debian.org/ha-team/ocfs2-tools/-/blob/master/debian/tests/pcmk?ref_type=heads
> 
> Basically it starts Corosync and DLM services and than calls:
> 
> mkfs.ocfs2
> fsck.ocfs2
> mount.ocfs2
> 

Thanks for quick reply.
Now it confirms that it is using fsdlm.

Joseph


