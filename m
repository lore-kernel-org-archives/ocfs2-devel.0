From: Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 29 May 2019 10:52:42 -0700
Subject: [Ocfs2-devel] [PATCH v4] fs/ocfs2: fix race in
	ocfs2_dentry_attach_lock
In-Reply-To: <20190529174636.22364-1-wen.gang.wang@oracle.com>
References: <20190529174636.22364-1-wen.gang.wang@oracle.com>
Message-ID: <20190529175242.GA4431@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, gechangwei@live.cn, daniel.sobe@nxp.com, akpm@linux-foundation.org, stable@vger.kernel.org, jiangqi903@gmail.com

On Wed, May 29, 2019 at 10:46:36AM -0700, Wengang Wang wrote:
> ocfs2_dentry_attach_lock() can be executed in parallel threads against the
> same dentry. Make that race safe.
> The race is like this:
> 
>             thread A                               thread B
> 
> (A1) enter ocfs2_dentry_attach_lock,
> seeing dentry->d_fsdata is NULL,
> and no alias found by
> ocfs2_find_local_alias, so kmalloc
> a new ocfs2_dentry_lock structure
> to local variable "dl", dl1
> 
>                .....
> 
>                                     (B1) enter ocfs2_dentry_attach_lock,
>                                     seeing dentry->d_fsdata is NULL,
>                                     and no alias found by
>                                     ocfs2_find_local_alias so kmalloc
>                                     a new ocfs2_dentry_lock structure
>                                     to local variable "dl", dl2.
> 
>                                                    ......
> 
> (A2) set dentry->d_fsdata with dl1,
> call ocfs2_dentry_lock() and increase
> dl1->dl_lockres.l_ro_holders to 1 on
> success.
>               ......
> 
>                                     (B2) set dentry->d_fsdata with dl2
>                                     call ocfs2_dentry_lock() and increase
> 				    dl2->dl_lockres.l_ro_holders to 1 on
> 				    success.
> 
>                                                   ......
> 
> (A3) call ocfs2_dentry_unlock()
> and decrease
> dl2->dl_lockres.l_ro_holders to 0
> on success.
>              ....
> 
>                                     (B3) call ocfs2_dentry_unlock(),
>                                     decreasing
> 				    dl2->dl_lockres.l_ro_holders, but
> 				    see it's zero now, panic
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> Reported-by: Daniel Sobe <daniel.sobe@nxp.com>
> Tested-by: Daniel Sobe <daniel.sobe@nxp.com>
> Reviewed-by: Changwei Ge <gechangwei@live.cn>
> ---
> v4: return in place on race detection.
> 
> v3: add Reviewed-by, Reported-by and Tested-by only
> 
> v2: 1) removed lock on dentry_attach_lock at the first access of
>        dentry->d_fsdata since it helps very little.
>     2) do cleanups before freeing the duplicated dl
>     3) return after freeing the duplicated dl found.
> ---
> 
>  fs/ocfs2/dcache.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://urldefense.proofpoint.com/v2/url?u=https-3A__www.kernel.org_doc_html_latest_process_stable-2Dkernel-2Drules.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=k2_veS6gfouGEyAl_KYtO3stkXp1T-mThycjG-C3nVQ&s=qEdFSVeGJPPVIB9XpFnnu7fibsroE5YUT5oujKq10b8&e=
for how to do this properly.

</formletter>
