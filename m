From: Jeff Mahoney <jeffm@suse.com>
Date: Thu, 11 May 2006 16:04:35 -0400
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <20060425183553.GB10524@ca-server1.us.oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
Message-ID: <446398D3.7010508@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Mark Fasheh wrote:
> The OCFS2 team is in the preliminary stages of planning major features for
> our next cycle of development. The goal of this e-mail then is to stimulate
> some discussion as to how features should be prioritized going forward. Some
> disclaimers apply:
> 
> * The following list is very preliminary and is sure to change.
> 
> * I've probably missed some things.
> 
> * Development priorities within Oracle can be influenced but are ultimately
>   up to management. That's not stopping anyone from contributing though, and
>   patches are always welcome.
> 

While performance enhancements are always welcome, the two big features
we'd like to see in future OCFS2 releases are features that will make
using OCFS2 more transparent and more like a "local" file system. The
features we want are cluster wide lockf/flock and shared writable mmap.

- From a data integrity perspective, it shouldn't make a difference to an
application whether competing reader/writers are on the same node or a
different node. If standard locking primitives are already in use by the
application, they should "just work" if the competing process is on
another node.

> So I'll start with changes that can be completely contained within the file
> system (no cluster stack changes needed):
> 
> -Sparse file support: Self explanatory. We need this for various reasons
>  including performance, correctness and space usage.

I think we all want this one. Once apon a time, ReiserFS didn't support
sparse files and it made doing things that expected sparse files an
exercise in torture.

> -Htree support

Hashed directories in some form, but I think the comments against ext3
style h-trees are valid.

> Now on to file system features which require cluster stack changes. I'll
> have alot more to say about the cluster stack in a bit, but it's worth
> listing these out here for completeness.

> -Online file system resize

This would be nice, and I think easily done in the same manner ext3
does. Anything outside the file system's current view of the block
device can be initialized in userspace, and the last block group,
bitmaps, and superblock would be adjusted by an ioctl in kernelspace.

> -Allow the file system to go "hard read only" when it loses it's connection
>  to the disk, rather than the kernel panic we have today. This allows
>  applications using the file system to gracefully shut down. Other
>  applications on the system continue unharmed. "Hard read only" in the OCFS2
>  context means that the RO node does not look mounted to the other nodes on
>  that file system. Absolutely no disk writes are allowed.  File data and
>  meta data can be stale or otherwise invalid. We never want to return
>  invalid data to userspace, so file reads return -EIO.

This is a big one as well. If a node knows to fence itself, it can put
itself in an error state as well. fence={panic,ro} would be a decent start.

> As far as the existing cluster stack goes, currently most of the OCFS2 team
> feels that the code has gone as far as it can and should go. It would
> therefore be prudent to allow pluggable cluster stacks. Jeff Mahoney at
> Novell has already done some integration work implementing a userspace
> clustering interface. We probably want to do more in that area though.
> 
> There are several good reasons why we might want to integrate with external
> cluster stacks. The most obvious is code reuse. The list of cluster stack
> features we require for our next phase of development is very large (some
> are listed below). There is no reason to implement those features unless
> we're certain existing software doesn't provide them and can't be extended.
> This will also allow a greater amount of choice for the end user. What stack
> works well for one environment might not work as well for another. There's
> also the fact that current resources are limited. It's enough work designing
> and implementing a file system. If we can get out of the business of
> maintaining a cluster stack, we should do so.
> 
> So the question then becomes, "What is it that we require of our cluster
> stack going forward?"
> 
> - We'd like as much of it to be user space code as is possible and
>   practical.

The heartbeat project does a pretty good job on the userspace end, but
as Andi pointed out, it has the usual shortcomings of anything in
userspace involved with writing data inside the kernel. It is prone to
deadlocks and we could miss node topology events.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFEY5jTLPWxlyuTD7IRAmsMAKCTZpN5rb+6jr6K0TvMJVq6LxNrwgCggFvT
uLovIf8rbp1GhF2LVg1i6Cw=
=SkZi
-----END PGP SIGNATURE-----
