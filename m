Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287547F6
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 May 2024 01:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716946434; cv=none; b=KIk77QLppT3Lsuw5UhbDVNguI3T/ZAPX8S1i05GXgYxqPqfGUIy8jbYjTOwQFde4c0OpB9N2iIQcUcgPL8Hc2jbN6RB1/3HaOIFOpSphNNXYt6Ounvcay0Dqxb+sid8f8oeSJB5ieU+syr9k8/VMarvIls72938m9r19t5BLpgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716946434; c=relaxed/simple;
	bh=L1pVllcGBCVxVqyy33QAbOccnHewRIK1xHzMJfXTlI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nz5hZbSDonRWgQXyyS+RAcgeWIq8iZuAvaYjVpcKo8vI3Pcfp+yZyoan/NlFHHiatXYUoai/q69dGM1l2/PMvyyoYYilOfMYIwkSJBpRWj+uRaq9WaiiJcprRth9je/+bvoDA4+IwXSiiIN9LGJc6AMUuIu6/ETBK/wDNhPBruI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=amv36OF9; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="amv36OF9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716946428; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=L36qkI/8lyHZcLS3URVOzgkjR6SjgInaH97K+pkuAXg=;
	b=amv36OF9jeTzVj1Kbo5g07EBjEHpfy4BdGWZ2kViu6pOBT+D56ntfA9PyhgzjGo14WFomrnjeM2spy5c3exjjm9rGOXLQLNamklCTBGGYDUhfZJTPyS0bGs3izKzJ7tHSs94L5mJZWP8m1eIBzymh5GFhNrbF8qoZB0+cqh6tyg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032014031;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W7Qtmnn_1716946427;
Received: from 30.221.129.43(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W7Qtmnn_1716946427)
          by smtp.aliyun-inc.com;
          Wed, 29 May 2024 09:33:48 +0800
Message-ID: <22f06d3c-5781-43d8-8169-678ef2299ddb@linux.alibaba.com>
Date: Wed, 29 May 2024 09:33:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add bounds checking to ocfs2_search_dirblock()
To: lei lu <llfamsec@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev
References: <20240528120140.15550-1-llfamsec@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240528120140.15550-1-llfamsec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/28/24 8:01 PM, lei lu wrote:
> Add a check to make sure all members of the ocfs2_dir_entry
> don't stray beyond valid memory region.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>  fs/ocfs2/dir.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index d620d4c53c6f..56e2f8c62106 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -352,19 +352,20 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>  	de_buf = first_de;
>  	dlimit = de_buf + bytes;
>  
> -	while (de_buf < dlimit) {
> +	while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>  		/* this code is executed quadratically often */
>  		/* do minimal checking `by hand' */
>  
>  		de = (struct ocfs2_dir_entry *) de_buf;
>  
> -		if (de_buf + namelen <= dlimit &&
> +		/* do a full check */
> +		if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> +			ret = -1;
> +			goto bail;
> +		}

What's the difference by moving full check above?
As I commented in v1, we may add a more check in ocfs2_check_dir_entry().

> +
> +		if (de->name + namelen <= dlimit &&

As discussed in v1, this change looks reasonable.

Thanks,
Joseph

>  		    ocfs2_match(namelen, name, de)) {
> -			/* found a match - just to be sure, do a full check */
> -			if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> -				ret = -1;
> -				goto bail;
> -			}
>  			*res_dir = de;
>  			ret = 1;
>  			goto bail;
