From: Gang He <ghe@suse.com>
Date: Wed, 02 Dec 2015 19:05:27 -0700
Subject: [Ocfs2-devel] [PATCH v2 0/4] Add online file check feature
In-Reply-To: <20151202182012.GA21249@amd>
References: <1446013561-22121-1-git-send-email-ghe@suse.com>
	<20151202182012.GA21249@amd>
Message-ID: <566013E7020000F900020CA2@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: pavel@ucw.cz
Cc: greg@kroah.com, akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <MFasheh@suse.com>, rgoldwyn@suse.de, linux-kernel@vger.kernel.org

Hello Pavel,



>>> 
> On Wed 2015-10-28 14:25:57, Gang He wrote:
>> When there are errors in the ocfs2 filesystem,
>> they are usually accompanied by the inode number which caused the error.
>> This inode number would be the input to fixing the file.
>> One of these options could be considered:
>> A file in the sys filesytem which would accept inode numbers.
>> This could be used to communication back what has to be fixed or is fixed.
>> You could write:
>> $# echo "CHECK <inode>" > /sys/fs/ocfs2/devname/filecheck
>> or
>> $# echo "FIX <inode>" > /sys/fs/ocfs2/devname/filecheck
>> 
> 
> Are you sure this is reasonable interface? I mean.... sysfs is
> supposed to be one value per file. And I don't think its suitable for
> running commands.
Usually, the corrupted file (inode) should be rarely encountered for OCFS2 file system, then
lots of commands are executed via this interface with high performance is not expected by us.
Second, after online file check is added, we also plan to add a mount option "error=fix", that means
the file system can fix these errors automatically without a manual command triggering.

Thanks
Gang

> 
> ...or returning back results.
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek 
> (cesky, pictures) 
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html 
> .
