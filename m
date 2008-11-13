From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 12 Nov 2008 18:24:04 -0800
Subject: [Ocfs2-devel] [RFC][PATCH 0/4] ocfs2: Directory indexing support
Message-ID: <1226543048-911-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patches implement indexed directory support in Ocfs2, mostly
according to the design doc I wrote up a while ago:

http://oss.oracle.com/osswiki/OCFS2/DesignDocs/IndexedDirectories

The patches have been rebased on top of the current merge_window branch in
Ocfs2. 

Testing so far has mostly been kernel tree builds and unit tests from
the ocfs2-test project. Everything seems pretty stable, but I'm sure we
could pound on it some more. I have yet to test this particular set of
patches - rebasing took longer than I thought it would, and I wanted to get
these out to the list for early review :)  I will report back on testing
results, as well as performance numbers in the next couple days.


Very basic ocfs2-tools patches will also follow in the next couple days or
so. This will mostly be mkfs and debugfs support. I think it might be best
to build the libocfs2 support on top of whatever patches we have for
extended attributes as the tree code will have to change for that.


Future Improvements:

We can optimize away the index reads for "medium" sized directories, if the
number of blocks in the unindexed tree is less than the minimum number of
reads required to read the index. Taking contiguousness into account might
yield even better results.


Open questions:

Should we just drop the signature in ocfs2_dir_block_trailer? I can't help
but feel that it might have limited usefulness as it's not at the front of
the block (like the rest of our signatures) and that the nature of a dirent
block might be that we can't trust the existence of the signature to
actually mean there's a valid ocfs2_dir_block_trailer there. The answer is
probably still to keep the signature, but I thought I'd throw this out
there.


Is it worth storing index (ocfs2_dx_entry) records inline inside of
ocfs2_dx_root_block and only growing out to a tree when we exhaust the
available space? Running the math, we could store between 18 (512 byte
blocks) and 242 (4k blocksize) records in the space occupied by the extent
list.


In order to keep the code simple, I've gone with a single linked-list for
the free dirent block search. There might be situations though, where this
performs poorly. My plan is to version the free dirent block list so that we
can 'upgrade' it (maybe to multiple lists) at a later point. Old versions
would fall back to the less optimized unindexed leaf search. That way the
upgrade would be seamless to the user.
	--Mark

--
Mark Fasheh
