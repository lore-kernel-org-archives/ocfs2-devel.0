From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Tue Aug  3 14:14:42 2004
Subject: [Ocfs2-devel] Calculating volume size from superblock
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B01864F52@orsmsx410>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

joel.becker@oracle.com wrote:
> On Mon, Aug 02, 2004 at 03:00:44PM -0700, Villalovos, John L wrote:
>> Just wondering.  As a possible RFE.  Is there any reason the size of
>> the global bitmap could not be in the superblock?  It seems strange
>> that in order to find out how big the filesystem is I have to
>> actually traverse the filesystem.
> 
> 	Well, the global bitmap is what the global bitmap represents, if
> you'll allow circular logic.  Why should the superblock need to be
> updated if global bitmap information changes?  This actually matters
> in a cluster.

So the global bitmap size changes on a regular basis?

I guess I thought that once you formatted the file system the size of
the global bitmap would be a constant size for the life of the
filesystem.  (Until you added a resize capability).

Is that not true?  If so I guess that explains it better why I need to
traverse through the file system in order to figure out the size of it.

I'm just trying to make my life easier by not needing to traverse the
file system.  Of course I haven't gone through every function in making
the EVMS plugin so I may need to anyway :(

John
