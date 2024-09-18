Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9161BC5C
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 01:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726624673; cv=none; b=YKWvE2TOzEm4l3UIWo4BFWJ48ETAdPNO9c59f2673kpyUSjn9ZT6/d6vZ1JpBRq5RZ4gUfx5u2WpumKpgqS0V8GFoubV9V25bObARTFqg2H5/lpaRktVsBeeXe3PliqVLktLEza4LTCouS3P4VgExZA1eiV9LKc7Bxa2X7AChyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726624673; c=relaxed/simple;
	bh=ngMcbxZMUXpWu5YlhxeBD71LAx00cXhF6oX0y0lq8+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wws7j97YlqTSsX+NUdVxwpcAK0wn1tgE9GD0mt/ydP0nNOgrlw0Cs4jyZxopBbGQlwhHEvYEGY6eViJNbrDyYmFPyyccQ5irYGMQ+HttgMmhi36x5Jb3QJzC0KnG/J7yS8VNIJSEMMcwxxuTzgSpTFtcr16Nxvq5RJ0uS/1Pt4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FhDrV9dR; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FhDrV9dR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1726624668; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=A4jqe7pWtQ64X7iNYqSy/jnDxqkRdn0IU1n4pvDIMqY=;
	b=FhDrV9dRGtCuY7wOg7IQ0AoLxMdn/HXm6qT0PL6g/AHEsaRVJj+/OhaQtYb1WYCssk3KKFeJ4+uJbqotFcIvYKNEBeEeqX933dM/9FIyq2IqpVLigHmi9azkhXL1eeMR5wEFup8M10FFkaENJ57cT0qOjrZFZaYhaWWLjzgeYgE=
Received: from 30.221.131.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WFC9GlY_1726624666)
          by smtp.aliyun-inc.com;
          Wed, 18 Sep 2024 09:57:47 +0800
Message-ID: <19ba4042-b7b8-4b8a-933d-f62eab8c684f@linux.alibaba.com>
Date: Wed, 18 Sep 2024 09:57:46 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Fix typo in comment
To: Mohammed Anees <pvmohammedanees2003@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240917185156.10580-1-pvmohammedanees2003@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240917185156.10580-1-pvmohammedanees2003@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/18/24 2:51 AM, Mohammed Anees wrote:
> Fix "Allcate" -> "Allocate"
> 
> Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index ea9127ba3..395e23920 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -4767,7 +4767,7 @@ int ocfs2_insert_extent(handle_t *handle,
>  }
>  
>  /*
> - * Allcate and add clusters into the extent b-tree.
> + * Allocate and add clusters into the extent b-tree.
>   * The new clusters(clusters_to_add) will be inserted at logical_offset.
>   * The extent b-tree's root is specified by et, and
>   * it is not limited to the file storage. Any extent tree can use this

