From: Theodore Tso <tytso@mit.edu>
Date: Sun, 28 Sep 2008 21:25:27 -0400
Subject: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
In-Reply-To: <20080917232629.GB20752@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com>
Message-ID: <20080929012527.GI8711@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org

On Wed, Sep 17, 2008 at 04:26:30PM -0700, Joel Becker wrote:
> Filesystems often to do compute intensive operation on some
> metadata.  If this operation is repeated many times, it can be very
> expensive.  It would be much nicer if the operation could be performed
> once before a buffer goes to disk.

Sorry for the delay in reviewing this patch, but I've got a question.
Right now you are calling the commit trigger *after* doing the escape
data copying.  This means that if the commit trigger is going to
modify the buffer (in the case of the checksum being stored in-line in
the block, which I gather is the case in OCFS2, right?), if you get
unlucky and the block begins with the four bytes JBD2_MAGIC_NUMBER,
then the checksum will be in the value which gets written out to the
log, but *not* to the value in the buffer head that will ultimately
get written to the final location on disk.  In the normal case where
the journal wraps and then truncated, it means the checksum will never
get written to the disk.  That seems bad.  :-)

I believe the correct location to fire the per-buffer commit trigger
is right after the first kmap_atomic, right before the comment "Check
for escaping".  This also fixes the bug where if the checksum is
stored in the first four bytes of the block, in the case where you
have bad luck and the checksum == JBD2_MAGIC_NUMBER, you won't end up
with a corrupted journal.

Do you agree?  If so, please let me know and I can fix up the patch,
or just submit to me an updated patch.

Thanks,

						- Ted
