From: Pavel Machek <pavel@ucw.cz>
Date: Fri, 4 Dec 2015 10:20:35 +0100
Subject: [Ocfs2-devel] [PATCH v2 0/4] Add online file check feature
In-Reply-To: <5661C105020000F9000210FA@relay2.provo.novell.com>
References: <1446013561-22121-1-git-send-email-ghe@suse.com>
	<20151202182012.GA21249@amd>
	<566013E7020000F900020CA2@relay2.provo.novell.com>
	<20151203051721.GA5241@kroah.com>
	<5661C105020000F9000210FA@relay2.provo.novell.com>
Message-ID: <20151204092035.GA21799@amd>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: greg@kroah.com, akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <MFasheh@suse.com>, rgoldwyn@suse.de, linux-kernel@vger.kernel.org

On Fri 2015-12-04 01:36:21, Gang He wrote:
> Hi Greg,
> 
> 
> >>> 
> > On Wed, Dec 02, 2015 at 07:05:27PM -0700, Gang He wrote:
> >> Hello Pavel,
> >> 
> >> 
> >> 
> >> >>> 
> >> > On Wed 2015-10-28 14:25:57, Gang He wrote:
> >> >> When there are errors in the ocfs2 filesystem,
> >> >> they are usually accompanied by the inode number which caused the error.
> >> >> This inode number would be the input to fixing the file.
> >> >> One of these options could be considered:
> >> >> A file in the sys filesytem which would accept inode numbers.
> >> >> This could be used to communication back what has to be fixed or is fixed.
> >> >> You could write:
> >> >> $# echo "CHECK <inode>" > /sys/fs/ocfs2/devname/filecheck
> >> >> or
> >> >> $# echo "FIX <inode>" > /sys/fs/ocfs2/devname/filecheck
> >> >> 
> >> > 
> >> > Are you sure this is reasonable interface? I mean.... sysfs is
> >> > supposed to be one value per file. And I don't think its suitable for
> >> > running commands.
> >> Usually, the corrupted file (inode) should be rarely encountered for OCFS2 
> > file system, then
> >> lots of commands are executed via this interface with high performance is 
> > not expected by us.
> >> Second, after online file check is added, we also plan to add a mount option 
> > "error=fix", that means
> >> the file system can fix these errors automatically without a manual command 
> > triggering.
> > 
> > It's not a "performance" issue, it's a "sysfs files only have one value"
> > type thing.  Have two files, "inode_fix" and "inode_check" and then just
> > write the inode into them, no need to have a "verb <inode>" type parser.
> Current, we have three functional items "check, fix and set", in the future, maybe we can add more item.
> Then, for each functional item, we need to create a sys file and add related code (actual some code is duplicated),
> I prefer to one sys file to handle multiple sub-commands.

And we prefer not to have your code in tree.

Please design some reasonable interface. Abusing sysfs for this is not
right.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
