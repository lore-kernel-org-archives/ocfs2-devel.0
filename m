From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 17 Jul 2008 15:06:48 -0700
Subject: [Ocfs2-devel] ocfs2_jbd2.patch for linux-2.6.26
In-Reply-To: <e64671580807170207ob041c82qaaed5009996c4dda@mail.gmail.com>
References: <e64671580807170207ob041c82qaaed5009996c4dda@mail.gmail.com>
Message-ID: <20080717220648.GM28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sabuj!

On Thu, Jul 17, 2008 at 04:07:26AM -0500, Sabuj Pattanayek wrote:
> Hi all,
> 
> Here's a patch to make OCFS2 work with JBD2, i.e. so we can create
> volumes greater than 16T. Patch and compile against the 2.6.26
> mainline kernel sources:

Thanks for this patch - it's been on the Ocfs2 todo list for some time now.
We all appreciate you sending this along.

A couple of thoughts:

 - We can't drop JBD completely as your patch does - some users might not
   want to upgrade to JBD2 for various reasons, one of which is that it
   isn't as tested as JBD.

 - We need to avoid creating new inodes above the 32 bit boundary, unless
   explicitly told that it's ok via a mount option. This is so that we
   don't return duplicate inode numbers on systems which only have a 32 bit
   st_ino value (see stat(2)).

 - An incompat bit for file systems with JBD2 journals might be a good idea.


So, to fix things up so that we can use either JBD or JBD2 (only one, chosen
at compile time), I think we should just add a file 'jbd_compat.h' to
fs/ocfs2 which contains a set of wrapper functions. The set of wrappers
chosen of course, depends on whether JBD2 support is picked at config time.


Regarding the 32 bit inode issue, we can use the "inode64" mount option as
implemented by XFS. From "man mount":

       inode64
              Indicates  that  XFS is allowed to create inodes at any location
              in the filesystem, including those which will  result  in inode
              numbers  occupying  more  than 32 bits of significance.  This is
              provided for backwards compatibility, but  causes  problems for
              backup applications that cannot handle large inode numbers.

Handling this properly just means we don't create new inode groups above the
32 bit boundary. The easiest way to do this would be to add a single value
to struct ocfs2_alloc_context, 'ac_alloc_32bit'. ocfs2_reserve_new_inode()
could set it if the 'inode64' mount option wasn't specified.

Internally, ocfs2_reserve_local_alloc_bits() would return -ENOSPC if the it
sees the bit and the local alloc starts past the boundary. Similarly,
ocfs2_cluster_group_search() could be updated to return -ENOSPC if the
cluster group ends beyond that same boundary.


So, making JBD2 optional and the inode64 mount option are the two things I'd
like to see before accepting such a patch upstream. If you have the time and
inclination to follow this through, I and the other Ocfs2 developers will
gladly assist you at every step in the process.

Thanks,
	--Mark

--
Mark Fasheh
