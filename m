From: tristan <tristan.ye@oracle.com>
Date: Thu, 06 May 2010 09:50:24 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Make
 ocfs2_find_cpos_for_left_leaf() public.
In-Reply-To: <20100506011135.GB9955@mail.oracle.com>
References: <1271059887-12640-1-git-send-email-tristan.ye@oracle.com>
	<20100506011135.GB9955@mail.oracle.com>
Message-ID: <4BE22060.7040405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Mon, Apr 12, 2010 at 04:11:26PM +0800, Tristan Ye wrote:
>   
>> The original idea to pull ocfs2_find_cpos_for_left_leaf() out of
>> alloc.c is to benefit punching-holes optimization patch, it however,
>> can also be referred by other funcs in the future who want to do the
>> same job.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>>     
>
> Tristan,
> 	Don't these patches sit atop another truncate cleanup?  Can you
> send me an entire series with everything required for cleanup and
> optimization of truncate and hole clearing.
>   

Sure,

I'm going to generate a new series of all truncate cleanup and 
punch-hole optimization atop your latest fixes branch.




> Thanks,
> Joel
>
>   
