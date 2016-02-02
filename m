From: Ryan Ding <ryan.ding@oracle.com>
Date: Tue, 02 Feb 2016 16:01:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix build warning
In-Reply-To: <1454395613-3428-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1454395613-3428-1-git-send-email-sudipm.mukherjee@gmail.com>
Message-ID: <56B06252.5080504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com


On 02/02/2016 02:46 PM, Sudip Mukherjee wrote:
> We were getting build warning about:
> /fs/ocfs2/file.c: In function ?ocfs2_file_write_iter?:
> fs/ocfs2/file.c:2198:1: warning: label ?relock? defined but not used
>
> The previous commit has cleaned up the code for direct io and removed
> the jump instruction to relock, but missed removing the label which is
> unused now.
>
> Fixes: 1a46f12e5071 ("ocfs2: code clean up for direct io")
> Cc: Ryan Ding <ryan.ding@oracle.com>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Reviewed-by: Ryan Ding<ryan.ding@oracle.com>

> ---
>   fs/ocfs2/file.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 41c506e..c18ab45 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2195,7 +2195,6 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>   
>   	inode_lock(inode);
>   
> -relock:
>   	/*
>   	 * Concurrent O_DIRECT writes are allowed with
>   	 * mount_option "coherency=buffered".
