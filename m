From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Dec 2015 13:41:11 -0800
Subject: [Ocfs2-devel] [PATCH v3 0/4] Add online file check feature
In-Reply-To: <1451027779-6849-1-git-send-email-ghe@suse.com>
References: <1451027779-6849-1-git-send-email-ghe@suse.com>
Message-ID: <20151229134111.6e0817e4b540c1fdf42d0475@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: mfasheh@suse.com, rgoldwyn@suse.de, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, 25 Dec 2015 15:16:15 +0800 Gang He <ghe@suse.com> wrote:

> When there are errors in the ocfs2 filesystem,
> they are usually accompanied by the inode number which caused the error.
> This inode number would be the input to fixing the file.
> One of these options could be considered:
> A file in the sys filesytem which would accept inode numbers.
> This could be used to communication back what has to be fixed or is fixed.
> You could write:
> $# echo "<inode>" > /sys/fs/ocfs2/devname/filecheck/check
> or
> $# echo "<inode>" > /sys/fs/ocfs2/devname/filecheck/fix
> 
> Compare with second version, I re-design filecheck sysfs interfaces, there
> are three sysfs files(check, fix and set) under filecheck directory(see above),
> sysfs will accept only one argument <inode>. Second, I adjust some code in 
> ocfs2_filecheck_repair_inode_block() function according to upstream feedback,
> we cannot just add VALID_FL flag back as a inode block fix, then we will not 
> fix this field corruption currently until having a complete solution.
> Compare with first version, I use strncasecmp instead of double strncmp
> functions. Second, update the source file contribution vendor.

This feature should be documented, please.  That means all pseudo-file
locations, all inputs, all outputs, expected behaviour etc etc.  Enough
info so that our users can usefully and fully use this feature in the
minimum time.  Documentation/filesystems/ocfs2.txt is the place for that.
