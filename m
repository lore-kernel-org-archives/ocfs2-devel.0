From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 26 Feb 2010 15:11:44 -0800
Subject: [Ocfs2-devel] [PATCH] dlm: allow dlm do recovery during shutdown
In-Reply-To: <1267217631-18593-1-git-send-email-srinivas.eeda@oracle.com>
References: <1267217631-18593-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100226231143.GD23730@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 26, 2010 at 12:53:51PM -0800, Srinivas Eeda wrote:
> If a node down event happens while dlm shutdown in progress, dlm recovery
> should be done before dlm is shutdown. But dlm_reco_thread only does recovery
> if the dlm_state is in DLM_CTXT_JOINED.
> 
> dlm_reco_thread should do recovery if dlm_state is in DLM_CTXT_JOINED or
> DLM_CTXT_IN_SHUTDOWN.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>

This patch is now in the 'merge-window' branch of ocfs2.git.

Joel

-- 

"Nobody loves me,
 Nobody seems to care.
 Troubles and worries, people,
 You know I've had my share."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
