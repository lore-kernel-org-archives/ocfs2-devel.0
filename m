From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sat Jul 31 02:24:42 2004
Subject: [Ocfs2-devel] System hang issue when access the same dir/file
	from 2 different nodes at the same time
In-Reply-To: <B44D37711ED29844BEA67908EAF36F037131E5@pdsmsx401.ccr.corp.intel.com>
References: <B44D37711ED29844BEA67908EAF36F037131E5@pdsmsx401.ccr.corp.intel.com>
Message-ID: <20040731072437.GE8008@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 30, 2004 at 11:17:25PM +0800, Chen, Yukun wrote:
> Hi All
> 
>          I met a bug on kernel 2.4.24, rev 1303,bi-node system. Steps to
> duplicate(a bug #111 has been reported to the bugzilla of oss.oracle.com)
<snip>

> Then, the system will hang with following error messages
> 
> ...
> 
> (5461) ERROR at vote.c, 921: inode 67643, vote_status=0, vote_state=1, lockid=
> 34633216, flags = 0x8000, asked type = 5 master = 1, state = 0x0, type = 5
> 
> Jul 27 16:31:06 westvile2 kernel: (2035) ERROR at vote.c, 921: inode 67661,
> vote_status=0, vote_state=1, lockid=34642432, flags = 0x40000004, asked type =
> 5 master = 1, state = 0x0, type = 5
> 
> Jul 27 16:31:36 westvile2 kernel: (5461) ERROR at vote.c, 921: inode 67643,
> vote_status=0, vote_state=1, lockid=34633216, flags = 0x8000, asked type = 5
> master = 1, state = 0x0, type = 5

<snip> 
> I have tried net vote and disk vote but get the same error message on screen.
> 
>  
> 
> Any ideas on it ?

yes, this last week we were seeing something similar where one node is
failing to respond to another one because it's own process_vote thread is
deadlocked with whichever process is in acquire_lock on that same node --
we've been seeing this problem and are trying various things to get around
it. What revision of svn are you running? Would you mind trying the latest
and seeing if it happens (some code to fix these cases has been committed)
	--Mark


--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
