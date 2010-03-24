From: tristan <tristan.ye@oracle.com>
Date: Wed, 24 Mar 2010 10:51:24 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach truncating and
 punching-hole codes to handle fastsymlink.
In-Reply-To: <20100324023246.GI31783@mail.oracle.com>
References: <1269331484-21262-1-git-send-email-tristan.ye@oracle.com>
	<20100323195224.GA31783@mail.oracle.com>
	<4BA96675.80506@oracle.com>
	<20100324021306.GH31783@mail.oracle.com>
	<4BA97745.8040009@oracle.com>
	<20100324023246.GI31783@mail.oracle.com>
Message-ID: <4BA97E2C.8030700@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, Mar 24, 2010 at 10:21:57AM +0800, tristan wrote:
>> Joel Becker wrote:
>>> 	The difference is that we never call the truncate code for fast
>>> symlinks or inline data in the kernel.  We do in libocfs2.
>> Really?
>>
>> Truncating for inline data is common I guess, for symlink, we may lack 
>> of method to truncate it from userspace via ftruncate(2).
>>
>> But it's ok to be there, right?
>
> 	It's not OK to be there.  The truncate system call will error if
> it is not a regular file.  Same with OCFS2_IOC_UNRESVP.  Thus no symlink
> can get there.  ocfs2_truncate_for_delete() checks i_clusters before
> calling the real truncate code.  Thus it avoids fast symlinks and inline
> data.

Joel,

I agreed with your point on the fact that truncating for fast symlink 
may be meaningless, since sys_truncate() will block all none-regular 
files. while it does make sense for inline data, see 
ocfs2_truncate_inline(), which was used to deal with inline file 
separately. that's the way we're treating inline file when doing 
truncating, how did you say we avoid this? that makes me confused.


Tristan.

>
> Joel
>
