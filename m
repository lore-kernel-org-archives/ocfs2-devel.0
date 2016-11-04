From: Jan Kara <jack@suse.cz>
Date: Fri,  4 Nov 2016 18:08:10 +0100
Subject: [Ocfs2-devel] [PATCH 0/6 v2] fs: Provide function to unmap metadata
	for a range of blocks
Message-ID: <1478279296-6575-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>, linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>

Hello,

I've noticed that in several places we need to unmap metadata in buffer cache
for a range of blocks and we do it by iterating over all blocks in given range.
Let's provide a helper function for that and implement it in a way more
efficient for larger ranges of blocks. Also cleanup other uses of
unmap_unerlying_metadata().  The patches passed xfstests for ext2 and ext4.

Jens, can you merge these patches if they look fine to you?

Changes since v1:
* Improved comment describing what the function does
* Renamed function
* Added wrapper for single block users and use it

								Honza
