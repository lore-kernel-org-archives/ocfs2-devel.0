From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Wed, 10 Jul 2013 01:26:34 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/refcounttree: add the missing NULL
 check of the return value of find_or_create_page()
In-Reply-To: <20130709221117.GB25976@localhost>
References: <51DA6FD5.8050300@cn.fujitsu.com>
	<20130709221117.GB25976@localhost>
Message-ID: <51DCB77D.5030902@cn.fujitsu.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel <linux-kernel@vger.kernel.org>

On 07/10/2013 06:11 AM, Joel Becker wrote:

> On Mon, Jul 08, 2013 at 03:52:53PM +0800, Gu Zheng wrote:
>> Add the missing NULL check of the return value of find_or_create_page() in
>> function ocfs2_duplicate_clusters_by_page().
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/ocfs2/refcounttree.c |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>> index 998b17e..456d0e4 100644
>> --- a/fs/ocfs2/refcounttree.c
>> +++ b/fs/ocfs2/refcounttree.c
>> @@ -2965,7 +2965,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>>  			to = map_end & (PAGE_CACHE_SIZE - 1);
>>
>>  		page = find_or_create_page(mapping, page_index, GFP_NOFS);
>> -
>> +		if (!page) {
>> +			ret = -ENOMEM;
>> +			mlog_errno(ret);
>> +			break;
>> +		}
>>  		/*
>>  		 * In case PAGE_CACHE_SIZE <= CLUSTER_SIZE, This page
>>  		 * can't be dirtied before we CoW it out.
> 
> Put a blank line between the closing brace and the comment.  Otherwise,

Got it.:)

> Acked-by: Joel Becker <jlbec@evilplan.org>

Thanks~

Regards,
Gu

> 
> Joel
>> -- 
>> 1.7.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo at vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
