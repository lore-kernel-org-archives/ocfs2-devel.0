From: Manish Singh <manish.singh@oracle.com>
Date: Thu Feb 12 14:30:04 2004
Subject: [Ocfs2-devel] Request to remove -Wfno-format
In-Reply-To: <200402121839.i1CIdRaY027264@penguin.co.intel.com>
References: <200402121839.i1CIdRaY027264@penguin.co.intel.com>
Message-ID: <20040212202959.GA23932@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 12, 2004 at 10:39:27AM -0800, Rusty Lynch wrote:
> While porting to 2.6 I am just using the 2.6 build system and putting off 
> the autoconfig stuff till later. As a result of this I am seeing a ton of 
> additional warning messages due to the fact that the ocfs2 build system is 
> including "-Wno-format".
> 
> Is there a good reason for adding the "-Wno-format" option to the build?

No good reason. Fixing the LOG messages for proper formats was deemed less
important than fixing real functionality bugs, so -Wno-format is used to cut
down on the warning noise.

> The kind of mistakes that are being ignored are ==>
> 
> LOG_TRACE_ARGS("found some data to free (%u.%u)\n", 
>                HI(cur_extent->this_ext), LO(cur_extent->this_ext));
> alloc.c: In function `ocfs_kill_this_tree':
> alloc.c:1620: warning: unsigned int format, long unsigned int arg (arg 2)
> alloc.c:1620: warning: unsigned int format, long unsigned int arg (arg 3)
> alloc.c:1638: warning: unsigned int format, long unsigned int arg (arg 2)
> alloc.c:1638: warning: unsigned int format, long unsigned int arg (arg 3)
> 
> 
> and ==> 
> LOG_TRACE_ARGS("Popping this header (%u.%u)\n",
>                HI(AllocExtent->this_ext), 
>                LO(AllocExtent->this_ext), 
>                AllocExtent->next_free_ext);
> alloc.c:2079: warning: unsigned int format, long unsigned int arg (arg 2)
> alloc.c:2079: warning: unsigned int format, long unsigned int arg (arg 3)
> alloc.c:2079: warning: too many arguments for format
> alloc.c:2099: warning: unsigned int format, long unsigned int arg (arg 2)
> alloc.c:2099: warning: unsigned int format, long unsigned int arg (arg 3)
> 
> 
> If it is ok, I would like to make the build more strict, and treat each of
> the warnings as bugs.

Go for it, the cleanup is welcome. While you're at it, getting rid of
the HI()/LO() nonsense would be good too.

-Manish
