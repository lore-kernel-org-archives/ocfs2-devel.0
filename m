From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 10 Nov 2009 18:59:57 -0800
Subject: [Ocfs2-devel] [PATCH 02/10] ocfs2: Handle missing dlmconstants.h
In-Reply-To: <1257818413-32014-3-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
	<1257818413-32014-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091111025956.GC17774@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 09, 2009 at 06:00:05PM -0800, Sunil Mushran wrote:
> Mainline commit d69a3ad6a0e47b2aa9b2b2ddfd385752132a4d34 split
> lock mode and flag constants from dlm.h into a sharable header,
> dlmconstants.h.
> 
> This patch adds a header with the same name that merely includes
> dlm.h.

	Again you're including the kapi-compat header unconditionally.
Only include it when it is necessary.

> +#ifdef NO_DLMCONSTANTS_HEADER
> +#include <linux/types.h>
> +#include <linux/dlm.h>

Then maybe change this to

#ifndef DLM_LOCK_NL
# include <linux/dlmconstants.h>
#endif

Joel

-- 

"In the arms of the angel, fly away from here,
 From this dark, cold hotel room and the endlessness that you fear.
 You are pulled from the wreckage of your silent reverie.
 In the arms of the angel, may you find some comfort here."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
