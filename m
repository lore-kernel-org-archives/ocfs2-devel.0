From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 1 Mar 2010 17:21:21 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions
 from ocfs2_fs.h to new added ocfs2_ioctl.h.
In-Reply-To: <1266997872-17091-1-git-send-email-tiger.yang@oracle.com>
References: <1266997872-17091-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20100302012121.GC447@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 24, 2010 at 03:51:11PM +0800, Tiger Yang wrote:
> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
> index d66cf4f..eb891db 100644
> --- a/fs/ocfs2/file.h
> +++ b/fs/ocfs2/file.h
> @@ -26,6 +26,8 @@
>  #ifndef OCFS2_FILE_H
>  #define OCFS2_FILE_H
>  
> +#include "ocfs2_ioctl.h"

	I wanted to grab this for the merge window, but I see that
file.h is still including the new header.  The header should be included
in the appropriate C file, not here.  Please clean this up.

Joel

-- 

"It is not the function of our government to keep the citizen from
 falling into error; it is the function of the citizen to keep the
 government from falling into error."
	- Robert H. Jackson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
