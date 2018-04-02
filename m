From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 2 Apr 2018 17:31:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: wait for dlm recovery done
 when migrating all lock resources
In-Reply-To: <5AAA6E25.7090303@huawei.com>
References: <5AAA6E25.7090303@huawei.com>
Message-ID: <62de800e-5068-97b7-1483-7aab370500ae@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 18/3/15 20:59, piaojun wrote:
> Wait for dlm recovery done when migrating all lock resources in case that
> new lock resource left after leaving dlm domain. And the left lock
> resource will cause other nodes BUG.
> 
>       NodeA                       NodeB                NodeC
> 
> umount:
>   dlm_unregister_domain()
>     dlm_migrate_all_locks()
> 
>                                  NodeB down
> 
> do recovery for NodeB
> and collect a new lockres
> form other live nodes:
> 
>   dlm_do_recovery
>     dlm_remaster_locks
>       dlm_request_all_locks:
> 
>   dlm_mig_lockres_handler
>     dlm_new_lockres
>       __dlm_insert_lockres
> 
> at last NodeA become the
> master of the new lockres
> and leave domain:
>   dlm_leave_domain()
> 
>                                                   mount:
>                                                     dlm_join_domain()
> 
>                                                   touch file and request
>                                                   for the owner of the new
>                                                   lockres, but all the
>                                                   other nodes said 'NO',
>                                                   so NodeC decide to be
>                                                   the owner, and send do
>                                                   assert msg to other
>                                                   nodes:
>                                                   dlmlock()
>                                                     dlm_get_lock_resource()
>                                                       dlm_do_assert_master()
> 
>                                                   other nodes receive the msg
>                                                   and found two masters exist.
>                                                   at last cause BUG in
>                                                   dlm_assert_master_handler()
>                                                   -->BUG();
> 
> Fixes: bc9838c4d44a ("dlm: allow dlm do recovery during shutdown")
> 
Redundant blank line here.
But I've found Andrew has already fix this when adding to -mm tree.

Acked-by: Joseph Qi <jiangqi903@gmail.com>

> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
