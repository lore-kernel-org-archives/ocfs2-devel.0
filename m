Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ECE2DC789
	for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 05:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791781844; cv=none; b=pnvm154FAZhfE9Ly+YugXBVFPeFZzOqMX3OqMx0kxOye7LZ/YFgcAU+y5QA7zrYZepiIStYmqEVy+y47+P3p+DP1BVFfSUsNq/ntmpHGVTI5GoOIK5fUcPjcpOMQGhS/hNoWDnPZJGdCtZYKZAiaNqgjPs9aKBTkGNEN4ESrwHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791781844; c=relaxed/simple;
	bh=IFPb0ic/DyH6R9oVq533iIXYk6oVXp9P9CoDqHkInqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SHWi6tEJandhoHWZLB2XR0t6F+/uMwHov1A89r1eGUd4PKj+PkxFoQLYQjvIIxtMRG7Pl4k0701IIPxkJcq3lrtfu3SFXHvgii0jOKpwUzVfykC6l9jovlbdUUFMec0GQhmJbr+XzCEBm0Ln0Ru3ipYKTlkcAzdduQJ0fhZg8tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vpt+Xprw; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vpt+Xprw"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49e6b771d06so4082425e9.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 11 Oct 2026 22:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791781841; x=1792386641; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0Ek6Y6WHWyZvWPK4rY8L2n9MgGRmcFjVIrlMTJWJp3A=;
        b=Vpt+Xprwg/2DqxmoaTUbX/tWCBtUxC6rt6PR+KAbRD3Ar0WVA4zjxqxnu3H8ygNxoS
         feeQuyw9rnW8pMDZKhUiqkxa7nFkQLeV+fPfMhJqk3owBoAZsqyCNlLBUEp5Y7YsJYdw
         +ImdB3IWE9CRRQoEznZMnKprAAdxK9KM8DTk7wy8pkF7SRmA3JrXyQqIct6CE4ipWpkn
         8TxPqgAMPwoJB8PYkv3TF0cKUSsAsZnK6hMsOqXhu8s1gEwSpJT9aSfYBuIvFAdbumgA
         za4nJTGvhERFWHWHvI+wf1gTMMfegFObzk/Avdux8TjJn1n+vtwasc7bRdCjnqziLru3
         J/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791781841; x=1792386641;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Ek6Y6WHWyZvWPK4rY8L2n9MgGRmcFjVIrlMTJWJp3A=;
        b=muamiMvvGhsbl8b/h18nwTrVjruERV3cqUN64cTkcBtjNgQo3dq+X77H4LPZY1jHBj
         iELNPdkoxt3dEOnP7irHcPHAseTxDvQkznlawu/gO2TeDye9qdcm5qzFxoq/JsTcpoOp
         lJETS5bvOAf2tQp/xVW1tRdfj/VoQng887JA5FgBrOfvPqt+X1PSJo826bI+NjQXQZwH
         43jTM+3lRHRJBK+enTghsrq5OQERoQ/ex1leAN2hWnNue+sfaNn9ntYGsTvLbcn57h21
         2ayELJx07ltYx8B3IiQLUNtcmp3J11nkxSBHP8ay2DB5Klfj9JzadUP+uyFEtIqYkQF8
         3kKw==
X-Forwarded-Encrypted: i=1; AKwUvBxJr7VUQDVjiMHLHwt+Wvp5gH9MFgc5t7ccuSIg8tZ3O3TEz7SXCaknHmHn7X4k4FQk+/D02kENTf4S9Q==@lists.linux.dev
X-Gm-Message-State: AFq9FYKQP0oHqSm/cvjFoO1a9sdeD5hrml0XrN3oLiUcORbY3sPRn16P
	aHgqKzXDDeYPsywsAx6DGJB3yg8lHNic6E1fTi5wSQlOnyklKXh82q+3R6romTSPwds=
X-Gm-Gg: AYBFou1UuM/y+rv2SMxAKAD4PyNq5u9dya7y8JpcKkIKqoqe29oAEONm+BWjgy02ddK
	B46nWWnSnPq4LLnyAYe1wGjBJSvrGIMA5lDfCIftfBFW6b1CigD8tV+bdba8r5iZBOdUucc6/14
	GD9AI8+9pjw9w/z8G7ewzBwOoDUN8dFtsn19J1qi8AKKncFrWbCkw+aUfvYOsn2ki51NER+I3YQ
	lMtJhHAfVjMwGTUAHwKh8T42M8dQiM0V+7X3TThxymgzzPvAM83FmEiV7iCsuJXYjWNTAFUkxld
	EEqYH5hoMRfetTc5g2PTivpiLZv3o4g8O9OGIyJyxGvgmVCpgbH+sMuyHZ1HcTuwtEqt++O6Inn
	x3Hg5TDbygznkSayY0xAwhFkI/Tpe9nLSburLoZBSAlD6TbvdzfXkcZiFah9jDYvLRcHvjsx5Cd
	gw76Etd+5yZQsA8zBzchl7NntgacL9OmPRPwhCx5kPHOhx74FHp3JFdEdDKJF8nIc2xSAMwdoXc
	F2q
X-Received: by 2002:a05:6000:29c6:b0:488:85c9:120b with SMTP id ffacd0b85a97d-48dbaae251fmr9042329f8f.3.1791781841105;
        Sun, 11 Oct 2026 22:10:41 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab393efd88sm8990476a91.3.2026.10.11.22.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 22:10:40 -0700 (PDT)
Message-ID: <af295d6f-ed18-406d-adeb-f179ae3d0e74@suse.com>
Date: Mon, 12 Oct 2026 13:10:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Publish the filecheck owner before adding sysfs
 attributes
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 akpm@linux-foundation.org, ghe@suse.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0086-v2-646731c4254a02823b4d@gmail.com>
 <asnqJTe50D-EuhTb@p15>
 <CAFRLqsVqawLcZK60Wt2GKszXCeeJj6WNEO09zwybxO+mkOUBaw@mail.gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <CAFRLqsVqawLcZK60Wt2GKszXCeeJj6WNEO09zwybxO+mkOUBaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/11/26 23:40, Cen Zhang wrote:
> Hi Heming,
> 
> Heming Zhao <heming.zhao@suse.com> 于2026年10月10日周六 15:38写道：
>>
>> setting to NULL is unnecessary, it becomes a harmless dangling pointer here.
>> Other code looks good to me.
>>
>> Thanks,
>> Heming
> 
> Thanks for reviewing this.
> 
> I checked the failure path again with the help of LLM, and I think clearing
> fs_fcheck is still needed on this baseline. If kobject_init_and_add()
> fails, the
> function puts the kobject and frees fcheck. Its caller in
> ocfs2_fill_super() then
> jumps to out_dismount, which calls ocfs2_dismount_volume() and, in turn,
> ocfs2_filecheck_remove_sysfs().
> 
> That last function returns early only when fs_fcheck is NULL. Leaving
> the dangling pointer would make it operate on the already-put kobject
> and access the freed fcheck in ocfs2_filecheck_sysfs_free().
> 
> I may still be missing something, but based on this path it seems the NULL
> assignment is still needed. Would you agree, or did I overlook a case where
> it is safe to leave it?
> 
> Thanks again for taking a look.
> 
> Best regards,
> Cen Zhang


Thanks for the info, I will add my reviewed-by tag.

- Heming
