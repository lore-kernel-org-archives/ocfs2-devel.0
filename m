From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 4 Mar 2015 15:57:19 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] BUG_ON(lockres->l_level
	!=	DLM_LOCK_EX && !checkpointed) tripped in ocfs2_ci_checkpointed
In-Reply-To: <1425333797-26082-1-git-send-email-tariq.x.saeed@oracle.com>
References: <1425333797-26082-1-git-send-email-tariq.x.saeed@oracle.com>
Message-ID: <20150304235719.GW21790@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tariq,

	Thanks for the patch, btw if you want your patches to go upstream you'll have a much
better chance if you CC Me and Andrew (along with the mailing list).

Comments inline:

On Mon, Mar 02, 2015 at 02:03:17PM -0800, Tariq Saeed wrote:
> Orabug: 20189959
> 
> PID: 614    TASK: ffff882a739da580  CPU: 3   COMMAND: "ocfs2dc"
>  #0 [ffff882ecc3759b0] machine_kexec at ffffffff8103b35d
>  #1 [ffff882ecc375a20] crash_kexec at ffffffff810b95b5
>  #2 [ffff882ecc375af0] oops_end at ffffffff815091d8
>  #3 [ffff882ecc375b20] die at ffffffff8101868b
>  #4 [ffff882ecc375b50] do_trap at ffffffff81508bb0
>  #5 [ffff882ecc375ba0] do_invalid_op at ffffffff810165e5
>  #6 [ffff882ecc375c40] invalid_op at ffffffff815116fb
>     [exception RIP: ocfs2_ci_checkpointed+208]
>     RIP: ffffffffa0a7e940  RSP: ffff882ecc375cf0  RFLAGS: 00010002
>     RAX: 0000000000000001  RBX: 000000000000654b  RCX: ffff8812dc83f1f8
>     RDX: 00000000000017d9  RSI: ffff8812dc83f1f8  RDI: ffffffffa0b2c318
>     RBP: ffff882ecc375d20   R8: ffff882ef6ecfa60   R9: ffff88301f272200
>     R10: 0000000000000000  R11: 0000000000000000  R12: ffffffffffffffff
>     R13: ffff8812dc83f4f0  R14: 0000000000000000  R15: ffff8812dc83f1f8
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffff882ecc375d28] ocfs2_check_meta_downconvert at ffffffffa0a7edbd [ocfs2]
>  #8 [ffff882ecc375d38] ocfs2_unblock_lock at ffffffffa0a84af8 [ocfs2]
>  #9 [ffff882ecc375dc8] ocfs2_process_blocked_lock at ffffffffa0a85285 [ocfs2]
> #10 [ffff882ecc375e18] ocfs2_downconvert_thread_do_work at ffffffffa0a85445 [ocfs2]
> #11 [ffff882ecc375e68] ocfs2_downconvert_thread at ffffffffa0a854de [ocfs2]
> #12 [ffff882ecc375ee8] kthread at ffffffff81090da7
> #13 [ffff882ecc375f48] kernel_thread_helper at ffffffff81511884
> 
> assert is tripped because the tran is not checkpointed and the lock level is PR.
> Following call could leave the lock in PR state, latter on causing the assert.
> ocfs2_setattr -> ocfs2_acl_chmod -> ocfs2_set_acl -> ocfs2_acl_set_mode
> Here is how.
> 
> 1116 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
> 1117 {
> 1261         ocfs2_inode_unlock(inode, 1); <<<
> ..
> 1272         if (!status && attr->ia_valid & ATTR_MODE) {
> 1273                 status = ocfs2_acl_chmod(inode);

You're looking at an old kernel, that's now a call to posix_acl_chmod().
You'll want to send patches against a recent kernnel too.

 
> 330 int ocfs2_acl_chmod(struct inode *inode)
> 351                 ret = ocfs2_set_acl(NULL, inode, NULL, ACL_TYPE_ACCESS,
> 
> 230 static int ocfs2_set_acl(handle_t *handle,
> 231                          struct inode *inode,
> 232                          struct buffer_head *di_bh,
> 233                          int type,
> 258                                 ret = ocfs2_acl_set_mode(inode, di_bh,
> 
> 175 static int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
> 176                               handle_t *handle, umode_t new_mode)
> 177 {
> 178         int ret, commit_handle = 0;
> 179         struct ocfs2_dinode *di;
> 180
> 181         if (di_bh == NULL) {
> 182                 ret = ocfs2_read_inode_block(inode, &di_bh);
> 183                 if (ret) {
> 184                         mlog_errno(ret);
> 185                         goto out;
> 186                 }
> 187         } else
> 188                 get_bh(di_bh);
> 189
> 190         if (handle == NULL) {
>                     >> BUG: inode lock not held in ex at this point <<
> 191                 handle = ocfs2_start_trans(OCFS2_SB(inode->i_sb),
> 
> ocfs2_setattr.#1261 we unlock and at #1273 call ocfs2_acl_chmod. When we reach
> ocfs2_acl_set_mode.#191 and do trans, the inode cluster lock is not held in EX
> mode (it should be). How this could have happended?

Ok, so the problem is that we're not holding a cluster lock across acl
operations. This actually affects calls from the VFS as well. You have the
right idea here - make sure we do this under lock :)

We want to do the locking in ocfs2_iop_set_acl() and ocfs2_iop_get_acl()
though. Those both get called from the VFS and the path from
posix_acl_chmod() will hit that too, so we can kill two birds with one
stone.

Thanks,
	--Mark

--
Mark Fasheh
