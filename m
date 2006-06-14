From: Daniel Phillips <phillips@google.com>
Date: Wed, 14 Jun 2006 12:08:06 -0700
Subject: [Ocfs2-devel] ext2 attributes for OCFS2
In-Reply-To: <20060614185431.GE3082@ca-server1.us.oracle.com>
References: <20060610123253.GA23924@MAIL.13thfloor.at>	<20060611174510.GW3082@ca-server1.us.oracle.com>	<20060612214116.GA13582@MAIL.13thfloor.at>	<20060613235625.GD3082@ca-server1.us.oracle.com>	<20060614104400.GA19984@MAIL.13thfloor.at>
	<20060614185431.GE3082@ca-server1.us.oracle.com>
Message-ID: <44905E96.9040002@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Wed, Jun 14, 2006 at 12:44:00PM +0200, Herbert Poetzl wrote:
>>>Yeah, it should mostly work just fine, but I'm betting there are some
>>>paths which will need a manual re-check as things may have changed out
>>>from under the VFS while we weren't holding a cluster lock. It should
>>>be easy enough to check things like the immutable flag in those places
>>>though.
>>
>>might be, I already wondered why things like
>>mark_inode_dirty() do not work with ocfs2,
>>IMHO the vfs/ocfs2 synchronization is broken
>>(to some degree) but maybe that is intentional
> 
> Yeah, it's difficult to get the VFS to "cluster lock" without affecting the
> runtime of other file systems, so we have to work within that constraint :/

Please don't be shy about asking.  Can you describe the mark_inode_dirty
issue?

Regards,

Daniel
