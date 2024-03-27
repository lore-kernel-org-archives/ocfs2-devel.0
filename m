Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9902C694
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 07:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711526003; cv=none; b=mIdglAKeP5UGIuBwTAO313jFvWXwyrtgyxwLjh34nIKGAiqRvQ+yieAJB6TrxJCJ5TnSRF9Nb5nZMLkLkYlpzEF0JMdFSmPYFpBbKKufBnUTPtB1m1XA9Cp8YSwPjZB76682lZkonqpbLr9pT6El82mt+cT7jCUccjXfaJUfAS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711526003; c=relaxed/simple;
	bh=o9k8mO5GpHEjKD7MWG7aTNmfRGPPLknO4K9i6ZWC+8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dG6zt5F5xRoMa1HG9YOH55doOoOiEiRwXM7Rc2ob+ip4fFNfSwmY+53LwBQkSHZNQiG6QtLC39Ih6vDFGiEdJDs9hmTZdqCJ1E4ciDW80guWUuqXJ5TsSYGU82/ZfEMDCwZ+NPlcij2DD79ekeX0ng7t64rO3zYyGcmQuv5clK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cXmoPQEq; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cXmoPQEq"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d109e82bd0so87463571fa.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 00:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711525999; x=1712130799; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rgg5Q9TMZQqmm+slezW4AJgQ427CGEA9AmSSNUyijnM=;
        b=cXmoPQEq6DsFPDRskahPG9qRYTOySt5IHerM1b/7M1gxumRrcYY3PcpJS160ADgyPz
         lEnIu52MaTGkxLgjRMEw4A1dxhQeXu+ct9kZgUTD+N8D+35EOdI76g/wAIcd9KuaFwGA
         xVHlwLRJOvDSGVN6qdr5wjB+mJ5BfazavFNtqAHbR6MkRQZ/DgZPr8IfI/LzYv9WRL1z
         /uZP+xLt1BlqJusqB+O8/G27DwtsI0jPeB/eJHS8nQvQF5CkCAWNOzGRKtjC0mAd41/G
         VFRWN9d9jiBAuUNJrhsDdpJsUQAPdKaREEMCSV8lD5d5YKHvBXnook8PdoqG0f5vSTOs
         KTrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711525999; x=1712130799;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rgg5Q9TMZQqmm+slezW4AJgQ427CGEA9AmSSNUyijnM=;
        b=MrW5hBblAhqlGEzMn672yqPNzJvla4XkGngWr8GhcuEr0eOnR9rDJFrcGYxRuGucuB
         cl0KkTUBollJcTVtbooVOAWEvgTcKpoups3w6msUetLWP/psqVmr97MycvvheGboFkmL
         TotAK/V4RdJQoet0fDAxmw47q4FYY4CIbX8TNRGhMgxfj+6LlYVxQU6tEbZ3abqSVK1b
         szZFSTy5tohxpXD+WyMf7cuRPWDFBgleAVELQj7JRPZjjrYZqR5I4gHTe8Z89qwyl60p
         P2DrygkfPXPloeU9a3SliHkrO+dQkjOg9UJpaNxRdU2pBdta5TsuwNIONj9mGYA4WUXz
         +q0w==
X-Gm-Message-State: AOJu0YwbY1DrrevS6JOpsSU1Pf5soUCNw3aDTIOxzSIcBkIYvUSKPcK8
	pRB+BGk/n9NTagxqmwOJxjhzjGNd34Pmovx9eyOAJrCwP34wz6PLSmAXs1WFomU=
X-Google-Smtp-Source: AGHT+IHsAiT40tlRIV9gL8hvhdILJKT4m3E/B+f/6eci0xnBdygSGnlDTkQ4zdcI1xBlCvq7hdKdeA==
X-Received: by 2002:a05:651c:502:b0:2d2:cb43:bc86 with SMTP id o2-20020a05651c050200b002d2cb43bc86mr379353ljp.45.1711525998876;
        Wed, 27 Mar 2024 00:53:18 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902900a00b001dca3a65200sm8268109plp.228.2024.03.27.00.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 00:53:18 -0700 (PDT)
Message-ID: <7f06066a-3b3a-467e-b6c7-a8cd0b7ab277@suse.com>
Date: Wed, 27 Mar 2024 15:53:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] improve write IO performance when fragmentation is
 high
Content-Language: en-US
To: joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240327060914.2583-1-heming.zhao@suse.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240327060914.2583-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sorry, I forgot add v4 tag and there is a mistake in patch.
I will re-send the v4 patch.

-Heming

On 3/27/24 14:09, Heming Zhao wrote:
> In v4 coding, I found new issues and split 3 patch files for easy reviewing:
> - (1/3, existing) improve write IO performance when fragmentation is high
> - (2/3, new) adjust enabling place for la-window
> - (3/3, new) speed up chain-list searching
> 
> Heming Zhao (3):
>    ocfs2: improve write IO performance when fragmentation is high
>    ocfs2: adjust enabling place for la window
>    ocfs2: speed up chain-list searching
> 
>   fs/ocfs2/localalloc.c   |  17 ++++---
>   fs/ocfs2/move_extents.c |   2 +-
>   fs/ocfs2/ocfs2_fs.h     |   3 +-
>   fs/ocfs2/resize.c       |   8 +++
>   fs/ocfs2/suballoc.c     | 110 ++++++++++++++++++++++++++++++++++------
>   fs/ocfs2/suballoc.h     |   6 ++-
>   6 files changed, 119 insertions(+), 27 deletions(-)
> 

