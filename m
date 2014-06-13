From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 13 Jun 2014 14:18:06 -0700
Subject: [Ocfs2-devel] [PATCH V2] ocfs2/dlm: fix misuse
	of	list_move_tail() in dlm_run_purge_list()
In-Reply-To: <539AAB47.8050705@huawei.com>
References: <539AAB47.8050705@huawei.com>
Message-ID: <20140613211805.GJ5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 13, 2014 at 03:41:59PM +0800, Xue jiufei wrote:
> When a lockres in purge list but is still in use, it should be moved to
> the tail of purge list. dlm_thread will continue to check next lockres
> in purge list. However, code list_move_tail(&dlm->purge_list,
> &lockres->purge) will do *no* movements, so dlm_thread will purge the
> same lockres in this loop again and again. If it is in use for a long
> time, other lockres will not be processed.
> 
> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Signed-off-by: joyce.xue <xuejiufei@huawei.com>

Oh didn't realize, this must be the fixed version of the patch? It might've
been nice to label it V2 or something. Anyway, thanks for this. Please
ignore my previous mail.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
