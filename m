From: Robert Wipfel <rawipfel@novell.com>
Date: Fri Oct 21 09:29:01 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051021090937.GA30904@lst.de>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
	<20051020102358.GB11726@marowsky-bree.de>
	<20051020150341.GC11488@ca-server1.us.oracle.com>
	<20051020152606.GB16745@redhat.com>
	<20051020154244.GD11488@ca-server1.us.oracle.com>
	<20051021090937.GA30904@lst.de>
Message-ID: <4358A6C1.C5C7.00CF.0@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>>> On Fri, Oct 21, 2005 at  3:09 am, in message
<20051021090937.GA30904@lst.de>,
Christoph Hellwig <hch@lst.de> wrote: 
> On Thu, Oct 20, 2005 at 08:42:44AM - 0700, Joel Becker wrote:
>> On Thu, Oct 20, 2005 at 10:26:06AM - 0500, David Teigland wrote:
>> > For some reason we've never used a mount.gfs so it didn't even
cross my
>> > mind --  it sounds like the obvious way to go.  That description I
sent of
>> > how gfs mount interacts with the cluster bits may be changing
now...
>> 
>> 	Hehe, when you said "mount process..." in your description, I
>> assumed mount.gfs :- )  You might want to rip off the
>> generic- mount- option- parsing code from mount.ocfs2 (which we
ripped off
>> from mount.smb).
> 
> Heh.  Maybe you would be kind enough to rip it out from all of them
> and submit a patch to create a libmount or similar to the util-
linux
> maintainer? ;- )

That would be nice - presumably it might also help solve the problem
of protecting non-cluster aware file systems too, that are today
protected
against conflicting mounts by userspace conventions, that don't always
guard against an admin manually mounting a file system on one node
that
might've been mounted by a cluster resource on some other node. When
the mount is issued, it would be nice to have some way to determine 
whether to apply the extra cluster checks; for the case of a file
system on
shared disk, versus do a normal mount for a file system on local disk.
For the cluster case, of a non-cluster aware file system, the mount
could
take a per-fs global lock, and on conflicting nodes the lock would
prevent
a mount (and maybe fsck too). Otoh, assuming a file system that's
really
awesome at single-node operations, with latent potential to expand into
a
cluster, hopefully this kind of protection would be built-in and with
all the
tools aware of the need to respect concurrent (cluster) access. Can the
disk
volume manager help - by protecting the file system's block
devices....
