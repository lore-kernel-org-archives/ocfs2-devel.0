From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Jan 26 11:47:19 2007
Subject: [Ocfs2-devel] Re: [2.6 patch] fix OCFS2 compile error
In-Reply-To: <20070126184942.GP17836@stusta.de>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<45B89008.9000809@eyal.emu.id.au> <45B965EA.20106@eyal.emu.id.au>
	<20070126184942.GP17836@stusta.de>
Message-ID: <20070126194713.GB8176@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com

On Fri, Jan 26, 2007 at 07:49:42PM +0100, Adrian Bunk wrote:
> I don't know why gcc 3.3 generates this now since ocfs2_backup_super_blkno()
> seems to be unused, but there is a bug for 32 bit systems that should be 
> fixed:
> 
> Commit 50af94b14c98f5769860a282a397c6f3b135c8a8 adds:
>   offset /= sb->s_blocksize;
> 
> That is:
>   u64 = u64 / long
> 
> Not a problem on 64bit architectures, but obviously a problem on 32 bit 
> architectures.
> 
> This patch fixes it by using sb->s_blocksize_bits instead of sb->s_blocksize.

Thanks Adrian... I think we both hit upon this at about the same time :) My
patch made it into ocfs2.git first (for obvious reasons)...
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
