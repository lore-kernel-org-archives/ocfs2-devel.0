From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 16 Feb 2010 20:29:09 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add current->comm in trace output
In-Reply-To: <1266012546-13865-1-git-send-email-sunil.mushran@oracle.com>
References: <1266012546-13865-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100217042908.GA13798@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 12, 2010 at 02:09:06PM -0800, Sunil Mushran wrote:
> Add current->comm to the standard mlog() output to help with debugging.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	Do you have sample output?  This could get long, no?

Joel

-- 

"And yet I fight,
 And yet I fight this battle all alone.
 No one to cry to;
 No place to call home."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
