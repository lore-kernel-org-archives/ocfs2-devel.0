From: Russell Mosemann <rmosemann@futurefoam.com>
Date: Thu, 18 May 2017 07:07:47 -0500 (CDT)
Subject: [Ocfs2-devel] kernel BUG at ocfs2/alloc.c:1514
In-Reply-To: <591DB99E020000F900076BEB@prv-mh.provo.novell.com>
References: <1495044743.629431015@webmail.futurefoam.com> 
	<591DB99E020000F900076BEB@prv-mh.provo.novell.com>
Message-ID: <1495109267.980727417@webmail.futurefoam.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is no need for testing. The bug is documented. Someone made the decision to crash the code rather than handle the condition. See the git commit below.

    BUG_ON(meta_ac == NULL);

Some information is in a January posting to this list from Ben Hutchings.
https://oss.oracle.com/pipermail/ocfs2-devel/2017-January/012701.html

++++++?
meta_ac is passed down from ocfs2_dio_end_io_write(), which allocates
it using ocfs2_lock_allocators()... but the latter only allocates it conditionally.  It seems like the condition is wrong somehow.
++++++

Additional insight was provided by Ian Campbell in March. It was sent this list, but I do not see it in the archive.

++++++
This still seems to be happening for this user with 4.9.13, looking at
"git log -p v4.9.13..origin/master -- fs/ocfs2" I wonder if
https://git.kernel.org/torvalds/c/3e10b793fc40dfdbe51762e0d084bd6f2c8acaaa
might be relevant?

The commit message mentions meta_ac not getting allocated and an extent
split vs refcount split differentiation and we have ocfs2_split_extent
in the trace. Slim reasoning I know, maybe someone who knows the code
could make a better determination.
++++++

--
Russell Mosemann
IT Manager | Future Foam, Inc.
1610 Avenue N | Council Bluffs, IA 51501-1071
O: (712) 323-9122 Ext 228
F: (712) 323-0158


-----Original Message-----
From: "Gang He" <ghe@suse.com>
Sent: Thursday, May 18, 2017 2:11am
To: rmosemann at futurefoam.com, ocfs2-devel at oss.oracle.com
Subject: Re: [Ocfs2-devel] kernel BUG at ocfs2/alloc.c:1514



Hello Russell,

I just went through the bug description from the link below, 
Could you always meet this issue in your testing environment? since it looks like a simple direct write.
Second, could you describe the whole reproduce steps in details or provide a testing script which can make this bug happen?
Because, in our normal environment, I believe we can not meet this bug easily since the kernel version v4.9 is very new.


Thanks
Gang


>>> 

> Copious stack traces available at
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=841144 
> 
> 
> --
> Russell Mosemann
> IT Manager | Future Foam, Inc.
> 1610 Avenue N | Council Bluffs, IA 51501-1071
> O: (712) 323-9122 Ext 228
> F: (712) 323-0158
