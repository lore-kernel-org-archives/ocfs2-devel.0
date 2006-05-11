From: Daniel Phillips <phillips@google.com>
Date: Thu, 11 May 2006 14:16:20 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <446398D3.7010508@suse.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<446398D3.7010508@suse.com>
Message-ID: <4463A9A4.6030204@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jeff Mahoney wrote:
> While performance enhancements are always welcome, the two big features
> we'd like to see in future OCFS2 releases are features that will make
> using OCFS2 more transparent and more like a "local" file system. The
> features we want are cluster wide lockf/flock and shared writable mmap.

These are both already on the list, so I suppose you are just voting for
priority?  I agree re priority: these two items stand in the way of full
local Posix semantics.  They should be number one and two on the list.

> Hashed directories in some form, but I think the comments against ext3
> style h-trees are valid.

I do not know which "comments against" you are refering to.  I only saw
an unsupported, non-technical assertion from Christoph.  Perhaps
Christoph would be kind enough to share with us the technical details
of how XFS deals with the 31 bit telldir cookie problem.

Hash directories or btrees of any form all have the same telldir issue
as Htree, so if you advocate hashed directories, you also advocate
coming up with some scheme to try to reduce the severity of the telldir
problem.

The only schemes that make the telldir problem actually go away are ones
that stick with a directory scheme modelled on UFS.  I only know of one
of those, the FSF hashing scheme, which has a major problem: the hash
index is not persistent.  It has to be recreated on initial access to
the directory and kept around in memory, competing with other hashed
objects.  This does not scale well.  Another problem is, since the holes
in this scheme are so obvious there is not a lot of incentive to put
time into it, knowing it will eventually be tossed out in favor of
something else.  But feel free :-)

The reason people like HTree is, it is really, really fast and minimizes
disk accesses.  It is also mostly debugged, though we still tend to see
a new issue every now and then.  It's been more than a year since I saw
the last one, and that was an outright bug.

One thing that we tried to do with HTree is work within a 31 bit cookie
limitation to accomodate NFSv2.  I am thinking that maybe we should have
just made NFSv2 fall back to not using the index, which is easy to do
with HTree, and thereby give ourselves the 62 bits of cookie we really
need.  I will float this idea on ext2-devel.

Regards,

Daniel
