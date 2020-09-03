From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 3 Sep 2020 15:27:24 +0100
Subject: [Ocfs2-devel] Broken O_{D,}SYNC behavior with FICLONE*?
In-Reply-To: <20200903035225.GJ6090@magnolia>
References: <20200903035225.GJ6090@magnolia>
Message-ID: <20200903142724.GA18478@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, ocfs2 list <ocfs2-devel@oss.oracle.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>

On Wed, Sep 02, 2020 at 08:52:25PM -0700, Darrick J. Wong wrote:
> Hi,
> 
> I have a question for everyone-- do FICLONE and FICLONERANGE count as a
> "write operation" for the purposes of reasoning about O_SYNC and
> O_DSYNC?

They aren't really write operations in the traditional sense as they
only change metadata.  Then again the metadata is all about the file
content, so we'd probaby err on the safe side by including them in the
write operations umbrella term.
