Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5627D191
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 06:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781592388; cv=none; b=j1m+yHA4vHyOz2dQVxCfr3VKoUDuIfXVgnWXDYqqPNY3KZjlafGY/c7vVbOt1kZun/vL+AlevQ/e7dfwnY6TZ19HSVgxKONcUzoCoccbWNVqY0hUjAasO/bMTYdvMwRGpY4XK2ZyYMcwn8MnqYnJavc4vlnnIKJDWzPW3w0Qmh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781592388; c=relaxed/simple;
	bh=lrn8KaCupiRYmN9pF+E3IYMb5Eab9aLIOJu4eF0AnpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ITWPVjPG9JkaTr+A87SmOxEes+90+3ZJjLLUzt5sGa8PbnO6XHqmUOeArdleiu3Aw16T7nKNBjWGlwnNgN/sY38KR7bjZnOoxaH3VuS5oZ1J65WLb5vXf7VHljqNKqtX+CrRz0convSi+1uCf00AEnPyozdBkplK6DahFasosRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fX0D/EDL; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fX0D/EDL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781592378; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CCyY4ncR7cHAZ27kalPakkanYpuVYVTnWpk556rQuKE=;
	b=fX0D/EDLdoBzMxlOxK3IBgQPkRpioC0aguUW1mwOh/3ZFDTcOdc5E5Z/QhX2x3zYwgKhLlYBdMpOlYwcpEc4NEmant2n5NRQqPIk4eS+/DxP5ZjFz+9WThAJCX9/TBs4RVZL4wzib5+Z/Gh9naMhsgkEuIbQiisZBdhGIlhirMM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X5-Wjpz_1781592377;
Received: from 30.221.145.41(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X5-Wjpz_1781592377 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Jun 2026 14:46:17 +0800
Message-ID: <92497bd5-028b-4966-8224-f2878120da00@linux.alibaba.com>
Date: Tue, 16 Jun 2026 14:46:16 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] ocfs2: validate xattr metadata bounds
To: Zhang Cen <rollkingzzc@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com,
 2045gemini@gmail.com, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Heming Zhao <heming.zhao@suse.com>
References: <20260526034040.3602377-1-rollkingzzc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260526034040.3602377-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/26/26 11:40 AM, Zhang Cen wrote:
> Hi,
> 
> This small series rejects corrupted OCFS2 xattr metadata before the
> getxattr and listxattr paths walk filesystem-controlled inline, external
> block, or indexed bucket storage.
> 
> Patch 1 validates the inline xattr header placement and entry count
> before ocfs2_xattr_ibody_get() parses it. Patch 2 builds on that helper
> and validates listxattr entry counts and name ranges against the storage
> that backs each walk.

Wny not consider move the validation into ocfs2_validate_inode_block() and
ocfs2_validate_xattr_block()?

Thanks,
Joseph

> 
> Both issues were reproduced with crafted OCFS2 images under KASAN.
> 
> v2:
> - Resend as a proper two-patch series. The previous send was malformed
>   by the transport and appeared as a single combined email.
> 
> Zhang Cen (2):
>   ocfs2: validate inline xattr metadata in ocfs2_xattr_ibody_get
>   ocfs2: validate listxattr entry bounds
> 
>  fs/ocfs2/xattr.c | 122 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 101 insertions(+), 21 deletions(-)
> 

