From: tristan <tristan.ye@oracle.com>
Date: Sat, 20 Mar 2010 09:35:39 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Journaling i_flags and
 i_orphaned_slot when adding inode to orphan dir.
In-Reply-To: <20100320012748.GJ15539@mail.oracle.com>
References: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
	<20100320012748.GJ15539@mail.oracle.com>
Message-ID: <4BA4266B.3080001@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, Mar 19, 2010 at 09:21:09AM +0800, Tristan Ye wrote:
>   
>> Currently, some callers were missing to journal the dirty inode after
>> adding it to orphan dir.
>>
>> Now we're going to journal such modifications within the ocfs2_orphan_add()
>> itself, It's safe to do so, though some existing caller may duplicate this,
>> and it makes the logic look more straightforward anyway.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>>     
>
> 	This patch has been added to the 'fixes' branch of ocfs2.git.
> Can you go over the callers of ocfs2_orphan_add() to see if there is any
> cleanup you can do?  Redundant dirty calls where nothing else is
> dirtied, etc.  That cleanup will be a separate patch that I push to the
> merge window when done.
>   

Sure, you're right, redundant dirty calls doesn't make any sense, and 
even makes the logic confused.

I'll handle this.

Thanks,
Tristan.

> Joel
>
>   
