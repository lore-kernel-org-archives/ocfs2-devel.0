From: Daniel Phillips <phillips@google.com>
Date: Thu, 04 May 2006 20:05:16 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <20060504223037.GB21588@ca-server1.us.oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<445936FE.90401@google.com> <44594AE2.9080802@oracle.com>
	<44594EC9.3040407@google.com> <445A6A61.2090009@oracle.com>
	<445A7EF3.2000701@google.com>
	<20060504223037.GB21588@ca-server1.us.oracle.com>
Message-ID: <445AC0EC.2000601@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> Out of curiousity, are we talking about a single journal device (all slot 
 > journals on one disk) or one device per journal?

Hi Mark,

For me, all journals on one disk, but that is just what I want for my one
particular project.  The user should be able to specify slot by slot which
device the journal is on, if it is not on the main volume.  This is just
the logical extension of the Ext3 scheme.

I don't see that there is anything to be gained by requiring the user to
specify a different device for each journal since the user tools already
have to handle the case where all the journals are on the same device.

The configuration I am most interested at the moment has two nodes, each
of which exports one NVRAM disk and one normal disk to the other.  The
NVRAM disks form a mirror with two journals on it.  The normal disks
likewise form a mirror with the OCFS2 fs proper on it.  The latter
volume needs to be snapshotted and its mirror needs a dirty map.  The
dirty map will live on the (NVRAM) journal volume.  See how big a deal
it is to be able to factor out the journals like that?  As I mentioned
earlier, the journals don't need to be snapshotted and the mirror
doesn't need a dirty map, which is a really big help considering that
typical write latency is determined by the journal, and the latency of
a snapshoted, mirrored device with a persistent dirty map can get really
high.

A picture:

                Node0  <---- GigE cable  ---->  Node1
   NVRAM:   Slot0 Journal               Mirror of Slot0 Journal
            Slot1 Journal               Mirror of Slot1 Journal
            HDISK Dirty Map             Mirror of HDISK Dirty Map

   HDISK:   OCFS2 FS proper             Mirror of OCFS2 FS proper
            OCFS2 FS Snapshot Store     Mirror of OCFS2 FS Snapshot Store

As a side note, separate journals will allow the user to be much less
conservative about setting the number of slots.

Regards,

Daniel
