From: Adrian Bunk <bunk@stusta.de>
Date: Fri Jan 26 10:49:38 2007
Subject: [Ocfs2-devel] [2.6 patch] fix OCFS2 compile error
In-Reply-To: <45B965EA.20106@eyal.emu.id.au>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<45B89008.9000809@eyal.emu.id.au> <45B965EA.20106@eyal.emu.id.au>
Message-ID: <20070126184942.GP17836@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Mark Fasheh <mark.fasheh@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com

On Fri, Jan 26, 2007 at 01:22:34PM +1100, Eyal Lebedinsky wrote:
> I should have added that this is on Debian stable:
> 	$ gcc --version
> 	gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)
> 
> Eyal Lebedinsky wrote:
> > i386
> > Practically all modules selected.
> > 
> >   Building modules, stage 2.
> >   MODPOST 1931 modules
>...
> > WARNING: "__udivdi3" [fs/ocfs2/ocfs2.ko] undefined!
> > make[1]: *** [__modpost] Error 1

Thanks for your report.

I don't know why gcc 3.3 generates this now since ocfs2_backup_super_blkno()
seems to be unused, but there is a bug for 32 bit systems that should be 
fixed:

Commit 50af94b14c98f5769860a282a397c6f3b135c8a8 adds:
  offset /= sb->s_blocksize;

That is:
  u64 = u64 / long

Not a problem on 64bit architectures, but obviously a problem on 32 bit 
architectures.

This patch fixes it by using sb->s_blocksize_bits instead of sb->s_blocksize.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -587,7 +587,7 @@ static inline u64 ocfs2_backup_super_blkno(struct super_block *sb, int index)
 
 	if (index >= 0 && index < OCFS2_MAX_BACKUP_SUPERBLOCKS) {
 		offset <<= (2 * index);
-		offset /= sb->s_blocksize;
+		offset >>= sb->s_blocksize_bits;
 		return offset;
 	}
 
