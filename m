From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 16 May 2006 18:44:20 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <446398D3.7010508@suse.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<446398D3.7010508@suse.com>
Message-ID: <20060517014419.GS21588@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeff,

On Thu, May 11, 2006 at 04:04:35PM -0400, Jeff Mahoney wrote:
> While performance enhancements are always welcome, the two big features
> we'd like to see in future OCFS2 releases are features that will make
> using OCFS2 more transparent and more like a "local" file system. The
> features we want are cluster wide lockf/flock and shared writable mmap.
I'm trying to do more research on the user locking stuff right now actually.
My aim is twofold. The first is to nail down exactly what each type of
locking entails, and secondly I want to know what impact a lack of
cluster-aware locking has on at least one existing application.

Just to break it down, lockf() seems to be a (POSIX compliant?) library
wrapper around fcntl() locking, which is range based, optionally mandatory,
and provides deadlock detection. Ranges can encompass any part of the file,
with a special case that allows to lock all possible (present and future)
bytes from a given offset. Along with the usual blocking / nonblocking
variants on read / exclusive locks, fcntl supports the F_GETLK operation
which allows userspace to query information about a range, including the
pids of processes holding incompatible locks.

flock() on the other hand is always advisory and does not support ranges. No
explicit deadlock detection seems to be done, though deadlocks can be broken
by the user sending a signal (including kill -9) to one of the waiting
processes. It also supports shared, exclusive and trylock type operations.

And finally, quoting from the fcntl() man page: "Since kernel 2.0, there is
no interaction between the types of lock placed by flock(2) and fcntl(2)."

Now, to get to an actual example of application usage, I took a look at the
apache 2.2.2 source. It seems that they do file locking in the apr functions
apr_file_lock() / apr_file_unlock() (located in
srclib/apr/file_io/unix/flock.c). On Linux, these use fcntl().

The only consumer of those functions I could find in the httpd tarball are
the "sdbm" routines in and around srclib/apr-util/dbm/sdbm/

And that's about where my apache expertise ends :/

There's many more apps to look at for information though - sendmail
immediately comes to mind. An strace on my machine here reveals that rpm
uses fcntl() locking.

So the question for the current OCFS2 code base is what impact the lack of
cluster-aware fcntl() locking has on the particular set of software which
we're going to worry about right now. Whenever we chose to do it (and we
_will_ do it), it will take a long time to develop - fcntl() locking alone
encompasses about two thirds of our non-trivial dlm feature wishlist.

> - From a data integrity perspective, it shouldn't make a difference to an
> application whether competing reader/writers are on the same node or a
> different node. If standard locking primitives are already in use by the
> application, they should "just work" if the competing process is on
> another node.
I agree 100%.

> > -Online file system resize
> 
> This would be nice, and I think easily done in the same manner ext3
> does. Anything outside the file system's current view of the block
> device can be initialized in userspace, and the last block group,
> bitmaps, and superblock would be adjusted by an ioctl in kernelspace.
Yep, that's basically how we plan to approach it.

> > - We'd like as much of it to be user space code as is possible and
> >   practical.
> 
> The heartbeat project does a pretty good job on the userspace end, but
> as Andi pointed out, it has the usual shortcomings of anything in
> userspace involved with writing data inside the kernel. It is prone to
> deadlocks and we could miss node topology events.
Ahh ok, so that explains how heartbeat handles it (aka, it doesn't right
now). It really seems to me that we're going to need to find a solution to
this sort of problem sooner or later (why do I get the feeling that I'm
being naive?). Speaking from experience, having cluster stack components in
kernel means a much longer development time. Even small focused ones like
the OCFS2 stack.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
