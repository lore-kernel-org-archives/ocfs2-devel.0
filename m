From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 20 Apr 2010 15:32:23 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add macro
 OCFS2_VOL_UUIDSTR_LEN in ocfs2_fs.h
In-Reply-To: <1271746743-17653-1-git-send-email-tristan.ye@oracle.com>
References: <1271746743-17653-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100420223223.GB9423@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 20, 2010 at 02:59:02PM +0800, Tristan Ye wrote:
> Since we've been using uuid_str in most of ocfs2 codes, adding
> such a macro would be helpful.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/ocfs2_fs.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index bb37218..b313c83 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -274,6 +274,7 @@
>  
>  #define OCFS2_VOL_UUID_LEN		16
>  #define OCFS2_MAX_VOL_LABEL_LEN		64
> +#define OCFS2_VOL_UUIDSTR_LEN		(OCFS2_VOL_UUID_LEN * 2 + 1)

	Also, why is this in ocfs2_fs.h?  It's not a structural
feature.

Joel

-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
