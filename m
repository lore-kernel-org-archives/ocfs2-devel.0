From: Daniel Phillips <phillips@google.com>
Date: Fri, 05 May 2006 20:09:24 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <20060505182500.GC21588@ca-server1.us.oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<445936FE.90401@google.com> <44594AE2.9080802@oracle.com>
	<44594EC9.3040407@google.com> <445A6A61.2090009@oracle.com>
	<445A7EF3.2000701@google.com>
	<20060504223037.GB21588@ca-server1.us.oracle.com>
	<445AC0EC.2000601@google.com>
	<20060505182500.GC21588@ca-server1.us.oracle.com>
Message-ID: <445C1364.2020208@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> Hi Daniel,
> On Thu, May 04, 2006 at 08:05:16PM -0700, Daniel Phillips wrote:
>>The user should be able to specify slot by slot which
>>device the journal is on, if it is not on the main volume.  This is just
>>the logical extension of the Ext3 scheme.
> 
> To be honest, that sounds a little bit like overkill to me.
> 
> For example, I was imagining that the user could create a seperate, rootless
> file system on the journal device - similar to how we do heartbeat only file
> systems. The normal file system would have the journal file system UUID
> stored in it's superblock. This way mount.ocfs2 could find the proper disk
> on the system and pass it along to the file system. If we had multiple
> possible journal devices, it would at least mean a much larget set of UUID's
> to store, necessitating a seperate area on disk for them. I'm sure there are
> other implications as well.

Hi Mark,

Why do you want to wrap the separate journals in a filesystem instead of just
being devices?

> Thanks for explaining your proposed setup. What are you using to mirror the
> devices?

DDRaid over NBD or iSCSI, probably NBD (which leads the performance race at
the moment).

Regards,

Daniel
