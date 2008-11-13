From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 12 Nov 2008 19:59:02 -0800
Subject: [Ocfs2-devel] [RFC][PATCH 0/4] ocfs2: Directory indexing support
In-Reply-To: <1226543048-911-1-git-send-email-mfasheh@suse.com>
References: <1226543048-911-1-git-send-email-mfasheh@suse.com>
Message-ID: <20081113035902.GG27602@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 12, 2008 at 06:24:04PM -0800, Mark Fasheh wrote:
> The following patches implement indexed directory support in Ocfs2, mostly
> according to the design doc I wrote up a while ago:

<snip>

> Very basic ocfs2-tools patches will also follow in the next couple days or
> so. This will mostly be mkfs and debugfs support. I think it might be best
> to build the libocfs2 support on top of whatever patches we have for
> extended attributes as the tree code will have to change for that.

	I agree.  I hope we see those soon.  We have a lot of stuff now
that isn't fully tools supported.

> Open questions:
> 
> Should we just drop the signature in ocfs2_dir_block_trailer? I can't help
> but feel that it might have limited usefulness as it's not at the front of
> the block (like the rest of our signatures) and that the nature of a dirent
> block might be that we can't trust the existence of the signature to
> actually mean there's a valid ocfs2_dir_block_trailer there. The answer is
> probably still to keep the signature, but I thought I'd throw this out
> there.

	I like having it, because it sticks right out in bvi/hexdump.
With any of our metadata structures, we generally have to figure out if
they are "really" a such-and-such by hand after validating the
signature.  But if we start from the knowledge "block N is or is not
supposed to be of type X", the signature is a quick way to see if
something is wrong.

> Is it worth storing index (ocfs2_dx_entry) records inline inside of
> ocfs2_dx_root_block and only growing out to a tree when we exhaust the
> available space? Running the math, we could store between 18 (512 byte
> blocks) and 242 (4k blocksize) records in the space occupied by the extent
> list.

	I'd say we should do _something_.  Many (most?) directories have
less than 242 entries, and this saves us a sync read on any cold-cache
lookup.  What about a way we could readahead the first index leaf
instead?  I suppose we could store "first leaf" on the inode right next
to the dx root, and then fire of readahead for the first leaf right
before we sync-read the dx_root.  If the directory fits in one index
leaf, that first leaf is already in our cache.  If not, we just ignore
it.  For 4k/4k, this is a single block.  Then the dx_root doesn't have
to have special logic for inline-entries.

> In order to keep the code simple, I've gone with a single linked-list for
> the free dirent block search. There might be situations though, where this
> performs poorly. My plan is to version the free dirent block list so that we
> can 'upgrade' it (maybe to multiple lists) at a later point. Old versions
> would fall back to the less optimized unindexed leaf search. That way the
> upgrade would be seamless to the user.

	I always liked this.  Wouldn't this mean that old versions might
leave 'full' dirblocks on the free list?

Joel

-- 

"There are some experiences in life which should not be demanded
 twice from any man, and one of them is listening to the Brahms Requiem."
        - George Bernard Shaw

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
