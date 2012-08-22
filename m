From: srinivas eeda <srinivas.eeda@oracle.com>
Date: Wed, 22 Aug 2012 10:13:00 -0700
Subject: [Ocfs2-devel] RFC: OCFS2 heartbeat improvements
In-Reply-To: <5034EA17.107@oracle.com>
References: <5034EA17.107@oracle.com>
Message-ID: <5035131C.1010207@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 8/22/2012 7:17 AM, Jie Liu wrote:
> Hi All,
>
> These days, I am investigating an issue regarding OCFS2 unexpected 
> reboot in some real world use cases.
> This problem occurred when the network status goes south, when the 
> disk IO load is too high, etc...
> I suspect it might caused by ocfs2 fencing if it's BIO reading/writing 
> can not be scheduled and processed quickly, or
> something like this happened in the network IO heartbeat thread.
>
> Now am trying to reproduce this problem locally.  In the meantime, I'd 
> like to ping you guys with some rough ideas
> to improve the disk IO heartbeat to see if they are sounds reasonable 
> or not.
>
> Firstly, if an OCFS2 node is suffer from heavy disk IO, how about to 
> fix the bio read/write to make this IO request can not
> be preempted by other requests? e.g,  for o2hb_issue_node_write(), 
> currently, it do bio submission with WRITE only,
> 'submit_bio(WRITE, bio)'.   If we change the flag to WRITE_SYNC, or 
> even submit the request combine with REQ_FUA,
> maybe could get highest priority for disk IO request.
This was submitted before by Noboru Iwamatsu and acked by sunil and tao 
but some how didn't get merged

https://oss.oracle.com/pipermail/ocfs2-devel/2011-December/008438.html
>
> Secondly, the comments for bio allocation at o2hb_setup_one_bio() 
> indicates that we can pre-allocate bio instead of
> acquire for each time.  But I have not saw any code snippet doing such 
> things in kernel. :(
> how about creating a private bio set for each o2hb_region, so that we 
> can do allocation out of it?
> maybe it's faster than do allocation from global bio sets.  Also, does 
> it make sense if creating a memory pool
> on each o2hb_region, so that we can have continuous pages bind to 
> those bios?
>
>
> Any comments are appreciated!
>
> Thanks,
> -Jeff
>
>
>
>
>
>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120822/7967b991/attachment-0001.html 
