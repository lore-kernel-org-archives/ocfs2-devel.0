From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 08 Nov 2013 01:21:50 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not write error flag to user
 structure we cannot copy from/to
In-Reply-To: <20131107112243.GG24799@localhost>
References: <1382905082.2994.32.camel@deadeye.wl.decadent.org.uk>
	<20131107112243.GG24799@localhost>
Message-ID: <1383873710.8136.25.camel@deadeye.wl.decadent.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 2013-11-07 at 03:22 -0800, Joel Becker wrote:
> On Sun, Oct 27, 2013 at 08:18:02PM +0000, Ben Hutchings wrote:
> > If we failed to copy from the structure, writing back the flags leaks
> > 31 bits of kernel memory (the rest of the ir_flags field).
> > 
> > In any case, if we cannot copy from/to the structure, why should we
> > expect putting just the flags to work?
> 
> The first issue could be fixed; we could clear the flags.  The second
> issue is what matters.  If we're getting EFAULT, we're not going to be
> moving any flags around.  We should just return the EFAULT and be done
> with it.
>  
> > Also make sure ocfs2_info_handle_freeinode() returns the right error
> > code if the copy_to_user() fails.
> > 
> > Compile-tested only.
> > 
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Cc: stable at vger.kernel.org
> > Fixes: ddee5cdb70e6 ('Ocfs2: Add new OCFS2_IOC_INFO ioctl for ocfs2 v8.')
> 
> I can't recommend this for stable if it hasn't actually been tested.

I wouldn't expect you to apply it without testing!  But if it is
correct, then it should go to stable.

> There is no exposure; as you point out, the put_user() will fail if the
> get_user() is failing.

This is true for a program that accidentally used an invalid pointer.
But a malicious program can have one thread manipulating memory mappings
while the other thread runs the ioctl(), so that only the put_user()
succeeds.

> Send me a version without stable and I'll Ack it.
[...]

I believe this meets the criteria for stable.  It is your perogative as
maintainer to remove the cc if you disagree.

Ben.

-- 
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case.
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 828 bytes
Desc: This is a digitally signed message part
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20131108/ef5097f7/attachment.bin 
