From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 13 Nov 2009 15:54:29 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Trivial cleanup of jbd
 compatibility layer removal
In-Reply-To: <1257547822-4246-1-git-send-email-sunil.mushran@oracle.com>
References: <1257547822-4246-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091113235429.GD9739@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 06, 2009 at 02:50:22PM -0800, Sunil Mushran wrote:
> Mainline commit 53ef99cad9878f02f27bb30bc304fc42af8bdd6e removed the
> JBD compatibility layer from OCFS2. This patch removes the last remaining
> remnants of that.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This patch is now in the "fixes" branch of ocfs2.git.

Joel

-- 

"I don't know anything about music. In my line you don't have
 to."
        - Elvis Presley

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
