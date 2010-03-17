From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 16 Mar 2010 23:59:09 -0700
Subject: [Ocfs2-devel] [PATCH 0/5] Ocfs2 allocation reservations
Message-ID: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Changes from the last patch set:
- added a check for overlapping reservations in ocfs2_resv_insert()
- cleaned up the comments in ocfs2_cannibalize_resv()
- the check for reservation past bitmap end in ocfs2_check_resmap() is more
  strict now.
- removed the unused m_search_start member of ocfs2_reservation_map
- optimized __ocfs2_resv_find_window() to ignore regions that are too small
  for the current alloc
- major cleanup of ocfs2_resmap_claimed_bits()
- added a set of BUG_ON's to in ocfs2_resmap_claimed_bits() to check that
  the passed allocation range is within the window.
- fixed ocfs2_local_alloc_find_clear_bits() to return actual bits allocated
- add a check for a null data_ac in ocfs2_write_begin_nolock()

I also added a fifth patch, "ocfs2: remove ocfs2_local_alloc_in_range()".
I could spin this as it's own patch to go upstream earlier if we want.

Finally, thanks to Tao for an excellent review that helped me catch most of
those issues.


Original introduction message follows:

The following patches comprise my latest work on enabling larger contiguous
allocations in Ocfs2 in the presence of multiple threads. The patches have
been through much more testing since my last round. At this point, I'd say
they're ready for wider consumption and of course, more review :)

Similarly to the last series, reservations only operate on the local alloc
bitmap. The code knows nothing of inodes and allocators however, so we can
extend it to the global bitmap (should the need arise) at a future date.

Changes from the last series are numerous. The biggest one however, is that
reservations (when enabled) are no longer 'advisory' and represent an actual
region of free bits in the local alloc file. The local alloc code obeys
reservations unconditionally.

The reason I made this change is because I saw a breakdown in allocation
(back to worst-case) on longer running tests, or those with many threads. 
Those tests it turned out, were exposing "corner cases" in the code where
reservations could no longer be honored due to bits having been set in the
local alloc bitmap. Better window replacement (and tracking) policy became
quite convoluted when the state of the local alloc bitmap wasn't quite
known. It is far simpler to just consult the bitmap for windows, and my
testing results showed that it worked better too.

This differs from file systems like ext4 (which I used for inspiration), but
our allocation strategy differs greatly.  Whereas ext4 may have many
different block groups in play during a multi-threaded write we only have
the single (and relatively smaller) local alloc window.  Reservations can
afford to be advisory for ext4, in Ocfs2 however we need them to be honored.


As for results, I provide one of my recent test runs on a 4k/4k file
system:

dd if=/dev/urandom of=/ocfs2/1 bs=4096 count=10000 & dd if=/dev/urandom
of=/ocfs2/2 bs=4096 count=10000 & dd if=/dev/urandom of=/ocfs2/3 bs=4096
count=10000 &


resv_level=0
Inode: 16920    % fragmented: 93.48     clusters: 10000 extents: 9348 score: 23931
Inode: 16921    % fragmented: 84.75     clusters: 10000 extents: 8475 score: 21696
Inode: 16922    % fragmented: 95.50     clusters: 10000 extents: 9550 score: 24448

resv_level=5 (defaults changed a bit, this means '128 blocks per reservation'):
Inode: 16916    % fragmented: 1.66      clusters: 10000 extents: 166 score: 425
Inode: 16917    % fragmented: 1.71      clusters: 10000 extents: 171 score: 438
Inode: 16918    % fragmented: 1.58      clusters: 10000 extents: 158 score: 404

Thanks in advance,
	--Mark
