From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 26 Nov 2015 09:34:46 +0800
Subject: [Ocfs2-devel] Long io response time doubt
In-Reply-To: <56543674.6060809@suse.com>
References: <56440208.7070809@huawei.com> <56443E60.9060103@suse.com>
	<56444708.2050207@huawei.com> <56446068.8010502@suse.com>
	<5645598F.7010304@huawei.com> <20151114052333.GA5173@laptop.ha>
	<564933F1.80906@huawei.com> <565435C6.4050601@suse.com>
	<56543674.6060809@suse.com>
Message-ID: <565661B6.7000902@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,
convert has two types, upconvert and downconvert. And please note that,
PR and EX is not compatible.
Assume read node has gotten PR first, then write node wants to get EX,
it requires read node to downconvert PR to NL. Then read node want's to
get PR again, write node should downconvert EX to PR (highest
compatible) and then read node can upconvert NL to PR. And so forth.
So both the read/write nodes will do upconvert and downconvert.
The code you paste is calling into fs/dlm which I am not familiar with:(
I think you can list your questions and send to cluster-devel.

Thanks,
Joseph

On 2015/11/24 18:05, Eric Ren wrote:
> Sorry, forget to add the pieces of code flow...
> 
> On reading node:
> 
>  3)  dlm_ast-4278  =>  ocfs2dc-4277 
>  ------------------------------------------
> 
>  3)               |  ocfs2_process_blocked_lock() {
>  3)               |    ocfs2_unblock_lock() {
>  3)   0.116 us    |      ocfs2_prepare_cancel_convert();
>  3)               |      ocfs2_cancel_convert() {
>  3)               |        user_dlm_unlock() {
>  3)               |          dlm_unlock() {
>  3)   0.120 us    |            dlm_find_lockspace_local();
>  3)   0.158 us    |            find_lkb();
>  3)               |            cancel_lock() {
>  3)               |              validate_unlock_args() {
>  3)   0.093 us    |                del_timeout();
>  3)   0.782 us    |              }
>  3)               |              _cancel_lock() {
>  3)               |                send_common() {
>  3)   0.189 us    |                  add_to_waiters();
>  3)               |                  create_message() {
>  3)               |                    _create_message() {
>  3)               |                      dlm_lowcomms_get_buffer() {
>  3)   0.156 us    |                        nodeid2con();
>  3)   1.680 us    |                      }
>  3)   0.108 us    |                      dlm_our_nodeid();
>  3)   2.821 us    |                    }
>  3)   3.319 us    |                  }
>  3)   0.094 us    |                  send_args();
>  3)               |                  send_message() {
>  3)   0.070 us    |                    dlm_message_out();
>  3)   9.485 us    |                    dlm_lowcomms_commit_buffer();
>  3) + 10.609 us   |                  }
>  3) + 16.054 us   |                }
>  3) + 16.632 us   |              }
>  3)   0.156 us    |              put_rsb();
>  3) + 19.044 us   |            }
>  3)               |            dlm_put_lkb() {
>  3)   0.094 us    |              __put_lkb();
>  3)   0.632 us    |            }
>  3)   0.074 us    |            dlm_put_lockspace();
>  3) + 22.513 us   |          }
>  3) + 23.028 us   |        }
>  3) + 23.727 us   |      }
>  3) + 25.004 us   |    }
>  3)               |    ocfs2_schedule_blocked_lock() {
>  3)   0.073 us    |      lockres_set_flags();
>  3)   0.592 us    |    }
>  3) + 26.852 us   |  }
>  ------------------------------------------
>  3)  ocfs2dc-4277  =>  dlm_ast-4278 
>  ------------------------------------------
> 
>  3)               |  process_asts() {
>  3)   0.202 us    |    dlm_rem_lkb_callback();
>  3)   0.081 us    |    dlm_rem_lkb_callback();
>  3)               |    fsdlm_lock_ast_wrapper() {
>  3)               |      ocfs2_unlock_ast() {
>  3)   0.099 us    |        ocfs2_get_inode_osb();
>  3)   1.290 us    |        ocfs2_wake_downconvert_thread();
>  3)               |        lockres_clear_flags() {
>  3)   8.539 us    |          lockres_set_flags();
>  3)   9.096 us    |        }
>  3) + 12.055 us   |      }
>  3) + 12.673 us   |    }
>  3)               |    dlm_put_lkb() {
>  3)   0.161 us    |      __put_lkb();
>  3)   0.718 us    |    }
>  3) + 16.133 us   |  }
> 
> 
> On writing node:
> 
>  3)  kworker-443   =>  ocfs2dc-4456 
>  ------------------------------------------
> 
>  3)               |  ocfs2_process_blocked_lock() {
>  3)               |    ocfs2_unblock_lock() {
>  3)   0.269 us    |      ocfs2_prepare_cancel_convert();
>  3)               |      ocfs2_cancel_convert() {
>  3)               |        user_dlm_unlock() {
>  3)               |          dlm_unlock() {
>  3)   0.321 us    |            dlm_find_lockspace_local();
>  3)   0.286 us    |            find_lkb();
>  3)               |            cancel_lock() {
>  3)               |              validate_unlock_args() {
>  3)   0.122 us    |                del_timeout();
>  3)   0.901 us    |              }
>  3)               |              _cancel_lock() {
>  3)               |                do_cancel() {
>  3)               |                  revert_lock() {
>  3)               |                    move_lkb() {
>  3)   0.155 us    |                      del_lkb();
>  3)   0.243 us    |                      add_lkb();
>  3)   1.778 us    |                    }
>  3)   2.577 us    |                  }
>  3)               |                  queue_cast() {
>  3)   0.102 us    |                    del_timeout();
>  3)               |                    dlm_add_ast() {
>  3)   0.165 us    |                      dlm_add_lkb_callback();
>  3) + 14.492 us   |                    }
>  3) + 16.381 us   |                  }
>  3) + 20.384 us   |                }
>  3)               |                grant_pending_locks() {
>  3)               |                  grant_pending_convert() {
>  3)               |                    can_be_granted() {
>  3)   0.143 us    |                      _can_be_granted();
>  3)   0.906 us    |                    }
>  3)   1.900 us    |                  }
>  3)   2.738 us    |                }
>  3) + 24.670 us   |              }
>  3)   0.154 us    |              put_rsb();
>  3) + 28.068 us   |            }
>  3)               |            dlm_put_lkb() {
>  3)   0.163 us    |              __put_lkb();
>  3)   1.029 us    |            }
>  3)   0.195 us    |            dlm_put_lockspace();
>  3) + 34.035 us   |          }
>  3) + 34.914 us   |        }
>  3) + 35.919 us   |      }
>  3) + 37.864 us   |    }
>  3)               |    ocfs2_schedule_blocked_lock() {
>  3)   0.210 us    |      lockres_set_flags();
>  0)               |  process_asts() {
>  3)   0.998 us    |    }
>  0)   0.215 us    |    dlm_rem_lkb_callback();
>  3) + 40.671 us   |  }
>  0)   0.084 us    |    dlm_rem_lkb_callback();
>  0)               |    fsdlm_lock_ast_wrapper() {
>  0)               |      ocfs2_unlock_ast() {
>  0)   0.088 us    |        ocfs2_get_inode_osb();
>  0)   9.498 us    |        ocfs2_wake_downconvert_thread();
>  0)               |        lockres_clear_flags() {
>  0)   1.272 us    |          lockres_set_flags();
>  0)   1.757 us    |        }
>  0) + 13.396 us   |      }
>  0) + 13.983 us   |    }
>  0)               |    dlm_put_lkb() {
>  0)   0.136 us    |      __put_lkb();
>  0)   0.641 us    |    }
>  0) + 17.224 us   |  }
> 
> 
> Thank,
> Eric
> On 11/24/15 18:02, Eric Ren wrote:
>> Hi Joseph,
>>
>> I use ftrace's function tracer to record some code flow. There's a question that makes me confused -
>> why does ocfs2_cancel_convert() be called here in ocfs2dc thread? In other words, what do we expect it
>> to do here?
>>
>> ocfs2_unblock_lock(){
>>      ...
>>      if(lockres->l_flags & OCFS2_LOCK_BUSY){
>>         ...
>>         ocfs2_cancel_convert()
>>        ...
>>     }
>> }
>>
>> From what I understand, ocfs2_cancel_convert()->ocfs2_dlm_unlock()->user_dlm_unlock()->dlm_unlock(DLM_LKF_CANCEL) puts
>> the lock back on the the grand queue at its old grant mode.  In my case, you know, read/write the same shared file from two nodes,
>> I think the up-conversion can only happen on the writing node - (PR->EX), while on the reading node, no up-conversion  is need, right?
>>
>> But, the following output from writing and reading nodes, shows that ocfs2_cancel_convert() has been called on both nodes. why could
>> this happen in this scenario?
>>
>> On 11/16/15 09:40, Joseph Qi wrote:
>>>> Sorry, I'm confused about b). You mean b) is also part of ocfs2cmt's
>>>> work? Does b) have something to do with a)? And what's the meaning of "evict inode"?
>>>> Actually, I can hardly understand the idea of b).
>>> You can go through the code flow:
>>> iput->iput_final->evict->evict_inode->ocfs2_evict_inode
>>> ->ocfs2_clear_inode->ocfs2_checkpoint_inode->ocfs2_start_checkpoint
>>>
>>> It happens that one node do not use the inode any longer (but not
>>> delete), and will free its related lockres.
>> OK, thanks~
>>
>> Eric
> 
