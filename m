From: Eric Ren <zren@suse.com>
Date: Tue, 24 Nov 2015 18:02:46 +0800
Subject: [Ocfs2-devel] Long io response time doubt
In-Reply-To: <564933F1.80906@huawei.com>
References: <56440208.7070809@huawei.com> <56443E60.9060103@suse.com>
	<56444708.2050207@huawei.com> <56446068.8010502@suse.com>
	<5645598F.7010304@huawei.com> <20151114052333.GA5173@laptop.ha>
	<564933F1.80906@huawei.com>
Message-ID: <565435C6.4050601@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

I use ftrace's function tracer to record some code flow. There's a 
question that makes me confused -
why does ocfs2_cancel_convert() be called here in ocfs2dc thread? In 
other words, what do we expect it
to do here?

ocfs2_unblock_lock(){
      ...
      if(lockres->l_flags & OCFS2_LOCK_BUSY){
         ...
         ocfs2_cancel_convert()
        ...
     }
}

 From what I understand, 
ocfs2_cancel_convert()->ocfs2_dlm_unlock()->user_dlm_unlock()->dlm_unlock(DLM_LKF_CANCEL) 
puts
the lock back on the the grand queue at its old grant mode.  In my case, 
you know, read/write the same shared file from two nodes,
I think the up-conversion can only happen on the writing node - 
(PR->EX), while on the reading node, no up-conversion  is need, right?

But, the following output from writing and reading nodes, shows that 
ocfs2_cancel_convert() has been called on both nodes. why could
this happen in this scenario?

On 11/16/15 09:40, Joseph Qi wrote:
>> Sorry, I'm confused about b). You mean b) is also part of ocfs2cmt's
>> work? Does b) have something to do with a)? And what's the meaning of "evict inode"?
>> Actually, I can hardly understand the idea of b).
> You can go through the code flow:
> iput->iput_final->evict->evict_inode->ocfs2_evict_inode
> ->ocfs2_clear_inode->ocfs2_checkpoint_inode->ocfs2_start_checkpoint
>
> It happens that one node do not use the inode any longer (but not
> delete), and will free its related lockres.
OK, thanks~

Eric
