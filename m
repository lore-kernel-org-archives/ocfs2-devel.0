From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri, 5 May 2006 11:25:00 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <445AC0EC.2000601@google.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<445936FE.90401@google.com> <44594AE2.9080802@oracle.com>
	<44594EC9.3040407@google.com> <445A6A61.2090009@oracle.com>
	<445A7EF3.2000701@google.com>
	<20060504223037.GB21588@ca-server1.us.oracle.com>
	<445AC0EC.2000601@google.com>
Message-ID: <20060505182500.GC21588@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Daniel,

On Thu, May 04, 2006 at 08:05:16PM -0700, Daniel Phillips wrote:
> The user should be able to specify slot by slot which
> device the journal is on, if it is not on the main volume.  This is just
> the logical extension of the Ext3 scheme.
To be honest, that sounds a little bit like overkill to me.

For example, I was imagining that the user could create a seperate, rootless
file system on the journal device - similar to how we do heartbeat only file
systems. The normal file system would have the journal file system UUID
stored in it's superblock. This way mount.ocfs2 could find the proper disk
on the system and pass it along to the file system. If we had multiple
possible journal devices, it would at least mean a much larget set of UUID's
to store, necessitating a seperate area on disk for them. I'm sure there are
other implications as well.

> The configuration I am most interested at the moment has two nodes, each
> of which exports one NVRAM disk and one normal disk to the other.  The
> NVRAM disks form a mirror with two journals on it.  The normal disks
> likewise form a mirror with the OCFS2 fs proper on it.  The latter
> volume needs to be snapshotted and its mirror needs a dirty map.  The
> dirty map will live on the (NVRAM) journal volume.  See how big a deal
> it is to be able to factor out the journals like that?  As I mentioned
> earlier, the journals don't need to be snapshotted and the mirror
> doesn't need a dirty map, which is a really big help considering that
> typical write latency is determined by the journal, and the latency of
> a snapshoted, mirrored device with a persistent dirty map can get really
> high.
Thanks for explaining your proposed setup. What are you using to mirror the
devices?
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
