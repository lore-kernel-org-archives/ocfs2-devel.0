From: tristan <tristan.ye@oracle.com>
Date: Tue, 09 Feb 2010 09:12:07 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Optimize truncting codes for
 ocfs2 to use ocfs2_remove_btree_range instead.
In-Reply-To: <20100209004756.GF1832@mail.oracle.com>
References: <1265366732-15895-1-git-send-email-tristan.ye@oracle.com>
	<20100209004756.GF1832@mail.oracle.com>
Message-ID: <4B70B667.6070103@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, Feb 05, 2010 at 06:45:31PM +0800, Tristan Ye wrote:
>   
>> I merge the following steps into one patch since they may be logically doing one thing,
>> Though I knew it looks a little bit fat to review.
>>
>> 1). Remove redundant codes used by ocfs2_commit_truncate before, since we're moving to
>>     ocfs2_remove_btree_range anyway.
>>
>> 2). Add a new func ocfs2_reserve_blocks_for_rec_trunc() for purpose of accepting  some
>>     extra blocks to reserve.
>>
>> 3). Change ocfs2_prepare_refcount_change_for_del() a bit to fit our needs, it's safe to
>>     do this since it's only being called by truncating codes.
>>
>> 4). Change ocfs2_remove_btree_range() a bit to take refcount case into account.
>>
>> 5). Finally, we change ocfs2_commit_truncate() to call ocfs2_remove_btree_range() in
>>     a proper way.
>>     
>
> 	I was going to be mad that these 5 things weren't five patches,
> but actually it reads pretty well as a patch.  I'm OK with it being one
> patch.
>   

Joel,

Yes, it actually was doing one thing logically, the reason why I listed 
the steps is try to make things straightforward.

To separate the patch into five smaller ones was really a bad idea, 
which turns the code into a inconsistent state after applying each.

Thanks,
Tristan.

> 	Mark, can I get an Ack?
>
> Joel
>
>   
