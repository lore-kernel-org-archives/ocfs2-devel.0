From: tristan <tristan.ye@oracle.com>
Date: Mon, 04 Jan 2010 10:36:15 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add stuffs associated with
 ocfs2_info_request ioctls to ioctl.h
In-Reply-To: <20091231201059.GB3301@mail.oracle.com>
References: <1262247524-26824-1-git-send-email-tristan.ye@oracle.com>
	<20091231201059.GB3301@mail.oracle.com>
Message-ID: <4B41541F.8030704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Dec 31, 2009 at 04:18:43PM +0800, Tristan Ye wrote:
>   
>> Currently we were adding ioctl cmds/structures for ocfs2 into ocfs2_fs.h
>> which was used for define ocfs2 on-disk layout. That sounds a little bit
>> confusing, and it can be quickly polluted espcially when growing the
>> ocfs2_info_request ioctls afterwards. The appropriate place to kept in-memory
>> ioctl structures is ioctl.h I guess.
>>     
>
> 	We want a separate ocfs2_ioctl.h.  The definitions of the ioctl
> and its structures are things a userspace program would want to use.
> ioctl.h, on the other hand, is an internal header for libocfs2.
>   

Oh, I may misunderstand your words, Joel. Did you mean we only split the on-disk layout and ioctls into two parts(ocfs2_fs.h and ocfs2_ioctl.h) in ocfs2-tools for userspace,
while kernel part still maintains one ocfs2_fs.h to cover both definitions for on-disk and ioctl strutures?

If so, why don't we keep a unification in ocfs2-tools and kernel part?

If not, why we need maintain two ioctl headers in kernel part(ioctl.h and ocfs2_ioctl.h)?


Tristan.



> Joel
>
>   
