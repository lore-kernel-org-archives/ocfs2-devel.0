From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 20 Jun 2019 20:54:20 -0400
Subject: [Ocfs2-devel] [PATCH 1/6] mm/fs: don't allow writes to
	immutable files
In-Reply-To: <20190620221306.GD5375@magnolia>
References: <156022836912.3227213.13598042497272336695.stgit@magnolia>
	<156022837711.3227213.11787906519006016743.stgit@magnolia>
	<20190620215212.GG4650@mit.edu> <20190620221306.GD5375@magnolia>
Message-ID: <20190621005420.GH4650@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: matthew.garrett@nebula.com, yuchao0@huawei.com, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org, reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Jun 20, 2019 at 03:13:06PM -0700, Darrick J. Wong wrote:
> > I note that this patch doesn't allow writes to swap files.  So Amir's
> > generic/554 test will still fail for those file systems that don't use
> > copy_file_range.
> 
> I didn't add any IS_SWAPFILE checks here, so I'm not sure to what you're
> referring?

Sorry, my bad; I mistyped.  What I should have said is this patch
doesn't *prohibit* writes to swap files....

(And so Amir's generic/554 test, even modified so it allow reads from
swapfiles, but not writes, when using copy_file_range, is still
failing for ext4.  I was looking to see if I could remove it from my
exclude list, but not yet.  :-)

> > I'm indifferent as to whether you add a new patch, or include that
> > change in this patch, but perhaps we should fix this while we're
> > making changes in these code paths?
> 
> The swapfile patches should be in a separate patch, which I was planning
> to work on but hadn't really gotten around to it.

Ok, great, thanks!!

				- Ted
