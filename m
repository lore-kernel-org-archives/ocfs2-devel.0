From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Thu, 2 Aug 2012 14:08:17 -0700
Subject: [Ocfs2-devel] kernel BUG at fs/buffer.c:2886! Linux 3.5.0
In-Reply-To: <501AD4D2.80007@vetienne.net>
References: <501313B6.70801@aprogsys.com>
	<20120730063000.GA4025@dhcp-172-17-9-228.mtv.corp.google.com>
	<50163B8A.7060509@aprogsys.com>
	<20120730075333.GC4025@dhcp-172-17-9-228.mtv.corp.google.com>
	<5016D2C0.6090708@vetienne.net> <501994E8.9070100@aprogsys.com>
	<501995B7.2030405@vetienne.net> <501A2A7E.10702@aprogsys.com>
	<501AD4D2.80007@vetienne.net>
Message-ID: <CAEeiSHWM2j3rFSGHtd06QRxT2NaL1gF8k5zPYKn6AYp=06dy1g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent ETIENNE <ve@vetienne.net>
Cc: linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, ocfs2-devel@oss.oracle.com

On Thu, Aug 2, 2012 at 12:28 PM, Vincent ETIENNE <ve@vetienne.net> wrote:

> Hi
>
> based on current git ( commit 1a9b4993b70fb1884716902774dc9025b457760d )
> and  reverting commit  ea022dfb3c2a4680483b00eb2fecc9fc4f6091d1
>
> commit ea022dfb3c2a4680483b00eb2fecc9fc4f6091d1
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Thu May 3 10:14:29 2012 -0400
>
>     ocfs: simplify symlink handling
>
>  and  adding the correction from
>
>
> https://oss.oracle.com/git/?p=smushran/linux-2.6.git;a=commit;h=a2118b301104a24381b414bc93371d666fe8d43a
>
> suppres the fallocate bug
>
> and lead to no oops. At least immediatly. Will let it run some times
>


Apply this change and re-run:

diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index f1fbb4b..66edce7 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -57,7 +57,7 @@
 static int ocfs2_fast_symlink_readpage(struct file *unused, struct page
*page)
 {
        struct inode *inode = page->mapping->host;
-       struct buffer_head *bh;
+       struct buffer_head *bh = NULL;
        int status = ocfs2_read_inode_block(inode, &bh);
        struct ocfs2_dinode *fe;
        const char *link;
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120802/9596de8c/attachment.html 
