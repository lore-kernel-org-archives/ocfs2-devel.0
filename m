From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 7 Nov 2012 15:52:07 -0800
Subject: [Ocfs2-devel] [PATCH] fs/ocfs2: change %8s to %s for mlog of
	ocfs2_sb_probe
In-Reply-To: <5099FE6C.3040406@asianux.com>
References: <5099FE6C.3040406@asianux.com>
Message-ID: <20121107235207.GG21780@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 07, 2012 at 02:23:40PM +0800, Chen Gang wrote:
> 
>    at least, the hdr->signature len is 9 (OCFS1_VOLUME_SIGNATURE)
> 	at ocfs1_fs_compat.h:39:
> 	#define OCFS1_VOLUME_SIGNATURE		 "OracleCFS"
>    so change %8s to %s

Ok, good catch - OCFS1_VOLUME_SIGNATURE is 9 bytes wide. And yes, the
->signature field in ocfs1_vol_disk_hdr is 64 bytes wide so we would always
hit a NULL byte in a valid ocfs1 disk header.


>   additional information:
> 
>     %8s  limit the width, not for the original string output length
>          if name length is more than 8, it still can be fully displayed.
>          if name length is less than 8, the ' ' will be filled before name.
> 
>     %.8s truly limit the original string output length (precision)

However, we can't guarantee that the block will always contain a valid
ocfs1 disk header, with a valid signature field. So we have to still limit
the print, otherwise we could go off the end of our struct if the data read
is garbage (which is exacly what this check is supposed to catch).

I think that instead we should simply change the %8s to %9s.
	--Mark

--
Mark Fasheh
