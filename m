Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E305EEA6
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Sep 2024 02:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725848856; cv=none; b=nON6GYStdnqkJyN/pvS7sytI26ykZ+dvvEvUExnpPFc3/HRtrNSLovKZ5UZvWKzbYzQnjgNOU5aSiv/7/+MuOV7iQqK+XxURYeyTQLNAWZxZ5Jv8I0i03Ywbz+D8bmykpVOzcMi/mr4mu7WhbgPVWN0ItxbP17lxZxITow1GxFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725848856; c=relaxed/simple;
	bh=j0CAdSqLtsFEGDKYXCx2Nlytm8QHptatcfCF55g1Rmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e03NPW7klaPSfnMmmpnLHWpi/elgMERdbNHUM84d2yQWU46+f+ZNeomzNgGdpXgAT+S5o0ZbfuA+XqXaHxLFH2Do1UVJThl1TriCV5pxnprQAB00fMr7+Oy9jsAT3LAVLkjJ3fHl8TWPUpAxEq5WQUzq21y435uJG8LgXABK+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=E6PFsWjE; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="E6PFsWjE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725848846; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dsSKiP4wQ7iUhn9nl4tqPadBgTvfs1BkOXJhjTRxYSc=;
	b=E6PFsWjETQ+sdSK19D8eiasHDnlDDT/LirQMvzNI44qOkEB5X9WLge0mUkuA1+YecG29u1PpHYQGBWd+UkFChg7A1m4/cB5/eXYahovwa1pXlFezvXofCe1lDx4oW/oaQPAjdAs/RwoXv377wOeHHLAhkSUSkHSjvN+v1VlXM08=
Received: from 30.221.132.42(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WEVqlx0_1725848844)
          by smtp.aliyun-inc.com;
          Mon, 09 Sep 2024 10:27:25 +0800
Message-ID: <4ec6bf01-b031-49c9-a9c7-10e210e14042@linux.alibaba.com>
Date: Mon, 9 Sep 2024 10:27:23 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: bug fix when bh is null
To: Su Yue <l@damenly.org>, Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 syzbot+adfd64e93c46b99c957e@syzkaller.appspotmail.com
References: <20240906221208.136692-1-ghanshyam1898@gmail.com>
 <ikv5ob7f.fsf@damenly.org>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ikv5ob7f.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/9/24 9:39 AM, Su Yue wrote:
> 
> On Sat 07 Sep 2024 at 03:42, Ghanshyam Agrawal <ghanshyam1898@gmail.com> wrote:
> 
> Commit message please even it's simple in one line.
> 
>> Reported-by: syzbot+adfd64e93c46b99c957e@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=adfd64e93c46b99c957e
>>
> I think it's fixed by https://lore.kernel.org/ocfs2-devel/20240902023636.1843422-1-joseph.qi@linux.alibaba.com/T/#t .
> 
Yes, Lizhi Xu has sent the fixes before and now it's in mm-tree.

Thanks,
Joseph
