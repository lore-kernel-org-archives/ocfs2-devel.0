From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Dec 2008 09:32:45 +0800
Subject: [Ocfs2-devel] [PATCH 02/18] ocfs2: Add the on-disk structures
 for metadata checksums.
In-Reply-To: <1228871395-10273-3-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
	<1228871395-10273-3-git-send-email-joel.becker@oracle.com>
Message-ID: <493F1C3D.3030700@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> Define struct ocfs2_block_check, an 8-byte structure containing a 32bit
> crc32_le and a 16bit hamming code ecc.  This will be used for metadata
> checksums.  Add the structure to free spaces in the various metadata
> structures.
> 
> Add the OCFS2_FEATURE_INCOMPAT_META_ECC bit.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/ocfs2_fs.h |   55 ++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 4ae3984..4e20f50 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -148,6 +148,9 @@
>  /* Support for extended attributes */
>  #define OCFS2_FEATURE_INCOMPAT_XATTR		0x0200
>  
> +/* Metadata checksum and error correction */
> +#define OCFS2_FEATURE_INCOMPAT_META_ECC		0x0800
> +
Is there any reason why we don't use 0x0400?

Regards,
Tao
