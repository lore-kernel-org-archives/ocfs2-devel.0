From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Wed Aug 11 11:16:53 2004
Subject: [Ocfs2-devel] fstat cause process blocked on bi-node enviornment
In-Reply-To: <B44D37711ED29844BEA67908EAF36F038AD052@pdsmsx401.ccr.corp.intel.com>
References: <B44D37711ED29844BEA67908EAF36F038AD052@pdsmsx401.ccr.corp.intel.com>
Message-ID: <20040811161456.GA2312@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Aaron,

We're working on this issue right now.  There is definitely a deadlock that 
occurs with concurrent opens on different nodes.  Should have a fix soon.

Thanks!
-kurt

On Wed, Aug 11, 2004 at 05:49:36PM +0800, Chen, Yukun wrote:
> Hi all
> 
>   For beta 4 release, on kernel 2.4.x.
> 
>   Steps to duplicate:
> 
>   1. on node a, large the size of file1
> 
>   2. on node b, in the meanwhile, fstat to get the attributes of the
> same file
> 
>   then the process is blocked with error message:
> 
> ############
> (2336) ERROR at vote.c, 921: inode 8770, vote_status=0, vote_state=1,
> lockid=35921920, flags = 0x40000004, asked type = 5 master = 1, state =
> 0x0, type = 5
> (2336) ERROR at dlm.c, 1000: Timed out acquiring lock for inode 8770,
> (lockid = 35921920) retrying...
> (2) ocfs_process_vote: ACQUIRE request for lockid: 12288, action: (11)
> READONLY, type: net vote, num_ident = 1
> (2) vote: lockid=12288, node=0, seqnum=17, response=1, open_handle=no
> ###########
> 
> simultaneously, error message can be found on the first node( node a)
> below:
> 
> ####################
> (5626) ERROR at vote.c, 921: inode 3, vote_status=0, vote_state=1,
> lockid=12288, flags = 0x60001000, asked type = 5 master = 1, state =
> 0x0, type = 5
> (5626) ERROR at dlm.c, 1000: Timed out acquiring lock for inode 3,
> (lockid = 12288) retrying...
> 
> ####################
> 
> It seems sth. wrong with the lock. Any comments are welcome.
> 
> Thanx.
> 
> BTW, a bug #125 has been reported to oss.oracle.com to descripe this
> issue.
> 
> Aaron
> 
> Intel China Software Lab
> 
> Tel:  8621-52574545 Ext.1587
> 
> E_mail:yukun.chen@intel.com
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
