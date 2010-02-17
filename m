From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 16 Feb 2010 22:10:10 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions
 from ocfs2_fs.h to new added ocfs2_ioctl.h.
In-Reply-To: <1265620919-7970-1-git-send-email-tristan.ye@oracle.com>
References: <1265620919-7970-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100217061009.GJ13798@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 08, 2010 at 05:21:58PM +0800, Tristan Ye wrote:
> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
> index d66cf4f..eb891db 100644
> --- a/fs/ocfs2/file.h
> +++ b/fs/ocfs2/file.h
> @@ -26,6 +26,8 @@
>  #ifndef OCFS2_FILE_H
>  #define OCFS2_FILE_H
>  
> +#include "ocfs2_ioctl.h"
> +

	Why are you adding this header to file.h?  It makes no sense.

Joel

-- 

Life's Little Instruction Book #173

	"Be kinder than necessary."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
