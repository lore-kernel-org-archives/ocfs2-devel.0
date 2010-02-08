From: tristan <tristan.ye@oracle.com>
Date: Mon, 08 Feb 2010 09:45:53 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Journaling i_flags and
 i_orphaned_slot when adding inode to orphan dir.
In-Reply-To: <20100205232121.GE3416@mail.oracle.com>
References: <1265270565-15883-1-git-send-email-tristan.ye@oracle.com>
	<20100205232121.GE3416@mail.oracle.com>
Message-ID: <4B6F6CD1.2080100@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Feb 04, 2010 at 04:02:45PM +0800, Tristan Ye wrote:
>   
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index f010b22..a24caca 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -84,7 +84,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
>>  static int ocfs2_orphan_add(struct ocfs2_super *osb,
>>  			    handle_t *handle,
>>  			    struct inode *inode,
>> -			    struct ocfs2_dinode *fe,
>> +			    struct buffer_head *fe_bh,
>>     
>
> 	When you're changing these things, can you call them 'di' for
> ocfs2_dinode instead of 'fe'?  The same for 'di_bh' instead of 'fe_bh'.
> specially when adding variables to new functions.  The 'fe' terminology
> is ancient and makes no sense to anyone that hasn't seen ocfs.  
>   

Thank you joel,

Got it.



> Joel
>
>   
