From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 27 Feb 2010 20:06:29 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Use a separate masklog for AST
	and BASTs
In-Reply-To: <1267242165-30474-1-git-send-email-sunil.mushran@oracle.com>
References: <1267242165-30474-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100228040629.GC20343@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 26, 2010 at 07:42:44PM -0800, Sunil Mushran wrote:
> This patch adds a new masklog and uses it allow tracing ASTs and BASTs
> in the dlmglue layer. This has been found to be very useful in debugging
> cluster locking issues.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

These patches are now in the 'merge-window' branch of ocfs2.git.

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
