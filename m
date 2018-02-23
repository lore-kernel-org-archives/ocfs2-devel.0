From: Joseph Qi <jiangqi903@gmail.com>
Date: Fri, 23 Feb 2018 18:16:29 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clean unrelated comment
In-Reply-To: <1519371054-4648-1-git-send-email-ge.changwei@h3c.com>
References: <1519371054-4648-1-git-send-email-ge.changwei@h3c.com>
Message-ID: <61fea229-531f-0051-9174-63eb14f8cdad@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 18/2/23 15:30, ge.changwei at h3c.com wrote:
> From: Changwei Ge <ge.changwei@h3c.com>
> 
> Obviously, the comment before dlm_do_local_recovery_cleanup() has
> nothing to do with it. So remove it.
> 
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>

It seems to say we can no longer trust the lvb in this case. Maybe it
should be placed somewhere to call dlm_revalidate_lvb()?

Anyway, this cleanup looks good to me.
Acked-by: Joseph Qi <jiangqi903@gmail.com>
