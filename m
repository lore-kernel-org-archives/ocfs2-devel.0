Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE4B7E1
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Jun 2023 02:35:56 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Vm7rHK8_1687919435;
Received: from 30.221.133.165(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Vm7rHK8_1687919435)
          by smtp.aliyun-inc.com;
          Wed, 28 Jun 2023 10:30:36 +0800
Message-ID: <6d59ab08-070f-1562-2eaa-16b083f1a732@linux.alibaba.com>
Date: Wed, 28 Jun 2023 10:30:33 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH 0/2] update ocfs2-devel mailing list addresses
Content-Language: en-US
To: Anthony Iliopoulos <ailiop@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20230628013437.47030-1-ailiop@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20230628013437.47030-1-ailiop@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks for this work.

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

On 6/28/23 9:34 AM, Anthony Iliopoulos wrote:
> The ocfs2-devel mailing list has been migrated to kernel.org, update all
> related kernel documentation pointers to reflect the change.
> 
> Anthony Iliopoulos (2):
>   MAINTAINERS: Update ocfs2-devel mailing list address
>   docs: update ocfs2-devel mailing list address
> 
>  Documentation/ABI/obsolete/o2cb       |  4 ++--
>  Documentation/ABI/removed/o2cb        |  4 ++--
>  Documentation/ABI/stable/o2cb         |  4 ++--
>  Documentation/ABI/testing/sysfs-ocfs2 | 12 ++++++------
>  Documentation/filesystems/dlmfs.rst   |  2 +-
>  Documentation/filesystems/ocfs2.rst   |  2 +-
>  MAINTAINERS                           |  2 +-
>  fs/ocfs2/Kconfig                      |  6 +++---
>  8 files changed, 18 insertions(+), 18 deletions(-)
> 
