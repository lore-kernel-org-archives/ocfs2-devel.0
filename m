From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Nov 2009 14:57:07 -0800
Subject: [Ocfs2-devel] [PATCH 02/10] ocfs2: Handle missing dlmconstants.h
In-Reply-To: <4AFB1024.3050707@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
	<1257818413-32014-3-git-send-email-sunil.mushran@oracle.com>
	<20091111025956.GC17774@mail.oracle.com>
	<4AFB1024.3050707@oracle.com>
Message-ID: <20091111225707.GG17774@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 11, 2009 at 11:27:32AM -0800, Sunil Mushran wrote:
> Joel Becker wrote:
> > Then maybe change this to
> >
> > #ifndef DLM_LOCK_NL
> > # include <linux/dlmconstants.h>
> > #endif
> >   
> 
> Not sure why we need to do this.

	Because if we are against mainline, we will not include the
kapi-compat header.  Then we have to include linux/dlmconstants.h.  Or
are you asking why do this instead of checking the NO_DLMCONSTANTS
define?  That works too.  -EDONTCARE

Joel

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
